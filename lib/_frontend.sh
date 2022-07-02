#!/bin/bash
# Robson Rissato - robsonwr@gmail.com
# functions for setting up app frontend
#######################################
# sets frontend environment variables
# Arguments:
#   None
#######################################
frontend_set_env() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (frontend)...${GRAY_LIGHT}"
  printf "\n\n"
  printf "Url escolhida : $frontend_url"
  printf "\n\n"

  sleep 5

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

su - ${user_system} << EOF
  cat <<[-]EOF > /home/${user_system}/${instancia_add}/frontend/.env
REACT_APP_BACKEND_URL=${backend_url}
REACT_APP_HOURS_CLOSE_TICKETS_AUTO = 24
SERVER_PORT = ${frontend_port}
[-]EOF
EOF

  sleep 2

su - ${user_system} << EOF
  cat <<[-]EOF > /home/${user_system}/${instancia_add}/frontend/server.js
//simple express server to run frontend production build;
const express = require("express");
const path = require("path");
const app = express();
require('dotenv').config();
app.use(express.static(path.join(__dirname, "build")));
app.get("/*", function (req, res) {
	res.sendFile(path.join(__dirname, "build", "index.html"));
});
app.listen(process.env.SERVER_PORT || 3333);

[-]EOF
EOF

  sleep 2
}

#######################################
# installed node packages
# Arguments:
#   None
#######################################
frontend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  su - ${user_system} <<EOF
  cd /home/${user_system}/${instancia_add}/frontend
  npm install
EOF

  sleep 2
}

#######################################
# compiles frontend code
# Arguments:
#   None
#######################################
frontend_node_build() {
  print_banner
  printf "${WHITE} 💻 Compilando o código do frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  su - ${user_system} <<EOF
  cd /home/${user_system}/${instancia_add}/frontend
  npm install
  npm run build
EOF

  sleep 2
}

#######################################
# starts pm2 for frontend
# Arguments:
#   None
#######################################
frontend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  su - ${user_system} <<EOF
  cd /home/${user_system}/${instancia_add}/frontend
  pm2 start server.js --name ${instancia_add}-frontend
  pm2 save
EOF

  sleep 2
}

#######################################
# sets up nginx for frontend
# Arguments:
#   None
#######################################
frontend_nginx_setup() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  frontend_hostname=$(echo "${frontend_url/https:\/\/}")

su - root << EOF

cat > /etc/nginx/sites-available/${instancia_add}-frontend << 'END'
server {
  server_name $frontend_hostname;

  location / {
    proxy_pass http://127.0.0.1:${frontend_port};
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

ln -s /etc/nginx/sites-available/${instancia_add}-frontend /etc/nginx/sites-enabled
EOF

  sleep 2
}

# Usado para update

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
frontend_update() {
  print_banner
  printf "${WHITE} 💻 Atualizando o frontend da instancia ( ${instancia_add} )...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  su - ${user_system} <<EOF
  cd /home/${user_system}/${instancia_add}
  pm2 stop ${instancia_add}-frontend
  git pull
  cd /home/${user_system}/${instancia_add}/frontend
  npm install
  rm -rf build
  npm run build
  pm2 start ${instancia_add}-frontend
  pm2 save
EOF

  sleep 2
}
