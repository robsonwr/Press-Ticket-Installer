#!/bin/bash
# Robson Rissato - robsonwr@gmail.com
# functions for setting up app backend
#######################################
# sets environment variable for backend.
# Arguments:
#   None
#######################################
backend_set_env() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (backend)...${GRAY_LIGHT}"
  printf "\n\n"
  printf "Url escolhida : $backend_url"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

  # ensure idempotency
  frontend_url=$(echo "${frontend_url/https:\/\/}")
  frontend_url=${frontend_url%%/*}
  frontend_url=https://$frontend_url

su - ${user_system} << EOF
  cat <<[-]EOF > /home/${user_system}/${instancia_add}/backend/.env
NODE_ENV=
BACKEND_URL=${backend_url}
FRONTEND_URL=${frontend_url}
PROXY_PORT=443
PORT=${backend_port}

DB_HOST=localhost
DB_DIALECT=mysql
DB_USER=${instancia_add}
DB_PASS=${mysql_root_password}
DB_NAME=${instancia_add}

JWT_SECRET=${jwt_secret}
JWT_REFRESH_SECRET=${jwt_refresh_secret}

REDIS_URI=redis://:${mysql_root_password}@127.0.0.1:${redis_port}
REDIS_OPT_LIMITER_MAX=1
REGIS_OPT_LIMITER_DURATION=3000

PMA_PORT=${phpmyadmin_port}
REDE=${instancia_add}

USER_LIMIT=${max_user}
CONNECTIONS_LIMIT=${max_whats}
[-]EOF
EOF

  sleep 2
}

#######################################
# sets environment variable for backend.
# Arguments:
#   None
#######################################

backend_mariadb_create() {
  print_banner
  printf "${WHITE} 💻 Criando banco e phpmyadmin via Docker...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  su - root <<EOF
  usermod -a docker ${user_system}
  docker run --name mariadb-server \
                -e MYSQL_ROOT_PASSWORD=${mysql_root_password} \
                -e MYSQL_DATABASE=${instancia_add} \
                -e MYSQL_USER=${instancia_add} \
                -e MYSQL_PASSWORD=${mysql_root_password} \
             --restart always \
                -p 3306:3306 \
                -d mariadb:latest \
             --character-set-server=utf8mb4 \
             --collation-server=utf8mb4_bin
  sleep 2
  
  docker run --name phpmyadmin-server \
                -d --link mariadb-server:db \
                -p ${phpmyadmin_port}:80 phpmyadmin/phpmyadmin
EOF
sleep 2

}

#######################################
# installs node.js dependencies
# Arguments:
#   None
#######################################
backend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  su - ${user_system} <<EOF
  cd /home/${user_system}/${instancia_add}/backend
  npm install
EOF

  sleep 2
}

#######################################
# compiles backend code
# Arguments:
#   None
#######################################
backend_node_build() {
  print_banner
  printf "${WHITE} 💻 Compilando o código do backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  su - ${user_system} <<EOF
  cd /home/${user_system}/${instancia_add}/backend
  npm install
  npm run build  
EOF

  sleep 2
}

#######################################
# runs db migrate
# Arguments:
#   None
#######################################
backend_db_migrate() {
  print_banner
  printf "${WHITE} 💻 Executando db:migrate...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  su - ${user_system} <<EOF
  cd /home/${user_system}/${instancia_add}/backend
  npx sequelize db:migrate
EOF

  sleep 2
}

#######################################
# runs db seed
# Arguments:
#   None
#######################################
backend_db_seed() {
  print_banner
  printf "${WHITE} 💻 Executando db:seed...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  su - ${user_system} <<EOF
  cd /home/${user_system}/${instancia_add}/backend
  npx sequelize db:seed:all
EOF

  sleep 2
}

#######################################
# starts backend using pm2 in 
# production mode.
# Arguments:
#   None
#######################################
backend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  su - ${user_system} <<EOF
  cd /home/${user_system}/${instancia_add}/backend
  pm2 start dist/server.js --name ${instancia_add}-backend
EOF

  sleep 2
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
backend_nginx_setup() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  backend_hostname=$(echo "${backend_url/https:\/\/}")

su - root << EOF
cat > /etc/nginx/sites-available/${instancia_add}-backend << 'END'
server {
  server_name $backend_hostname;
  location / {
    proxy_pass http://127.0.0.1:${backend_port};
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_cache_bypass \$http_upgrade;
  }
}
END
ln -s /etc/nginx/sites-available/${instancia_add}-backend /etc/nginx/sites-enabled
EOF

  sleep 2
}

# Usado para outras instancias

#######################################
# sets environment variable for backend.
# Arguments:
#   None
#######################################
backend_mariadb_create_instancia() {
  print_banner
  printf "${WHITE} 💻 Criando banco via Docker...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  su - root <<EOF
  usermod -a docker ${user_system}
  docker exec mariadb-server \
                  mysql \
                  -u root \
                  -p${mysql_root_password} \
                  -e "create database ${instancia_add} character set utf8mb4 collate utf8mb4_bin;"
 
 echo "Criou Banco de dados - ${instancia_add}"
 sleep 2

  docker exec mariadb-server \
                  mysql \
                  -u root \
                  -p${mysql_root_password} \
                  -e "create user '${instancia_add}'@'%' identified by '${mysql_root_password}'; grant usage on *.* to '${instancia_add}'@'%'; flush privileges;"             

echo "Criou Usuário - ${instancia_add}"
sleep 2

  docker exec mariadb-server \
                  mysql  \
                  -u root  \
                  -p${mysql_root_password} \
                  -e "grant all privileges on ${instancia_add}.* to '${instancia_add}'@'%' with grant option;"

echo "Aplicou Privilégios Usuário - ${instancia_add}"
sleep 2
EOF
sleep 2

}

# Usado para update

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
backend_update() {
  print_banner
  printf "${WHITE} 💻 Atualizando o backend da instancia ( ${instancia_add} )...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  su - ${user_system} <<EOF
  cd /home/${user_system}/${instancia_add}
  pm2 stop ${instancia_add}-backend
  git pull
  cd /home/${user_system}/${instancia_add}/backend
  npm install
  npm update -f
  npm install @types/fs-extra
  rm -rf dist  
  npm run build
  sleep 2
  npx sequelize db:migrate
  sleep 2
  npx sequelize db:seed
  sleep 2
  pm2 start ${instancia_add}-backend
  pm2 save 
EOF

  sleep 2
}