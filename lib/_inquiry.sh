#!/bin/bash
# Robson Rissato - robsonwr@gmail.com
get_mysql_root_password() {
  
  print_banner
  printf "${WHITE} 💻 Insira senha padrão para o sistema:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " mysql_root_password
}

get_instancia_add() {
  
  print_banner
  printf "${WHITE} 💻 Digite o nome da empresa a ser configurada (Utilizar Letras minusculas):${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " instancia_add
}

get_instancia_update() {
  
  print_banner
  printf "${WHITE} 💻 Digite o nome da empresa que quer atualizar (Utilizar Letras minusculas):${GRAY_LIGHT}"
  printf "\n\n"
  printf "* Por favor verifique nome antes para não ocorrer erros no update da instancia "
  printf "\n\n"
  printf "* Abaixo Listagem das instancia "
  printf "\n\n"
  sleep 2  
  ls /home/${user_system}/
  printf "\n\n"
  read -p "> " instancia_add
}

get_max_whats() {
  
  print_banner
  printf "${WHITE} 💻 Digite o numero maximo de conexões que a empresa ( ${instancia_add} ) poderá cadastrar:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " max_whats
}

get_max_user() {
  
  print_banner
  printf "${WHITE} 💻 Digite o numero maximo de atendentes que a empresa ( ${instancia_add} ) poderá cadastrar:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " max_user
}

get_frontend_url() {
  
  print_banner
  printf "${WHITE} 💻 Digite o domínio do FRONTEND/PAINEL para a ( ${instancia_add} ):${GRAY_LIGHT}"
  printf "\n\n"
  printf "  Ex: front.seudominio.com.br "
  printf "\n\n"
  read -p "> " frontend_url
}

get_backend_url() {
  
  print_banner
  printf "${WHITE} 💻 Digite o domínio do BACKEND/API para a ( ${instancia_add}):${GRAY_LIGHT}"
  printf "\n\n"
  printf "  Ex: back.seudominio.com.br "
  printf "\n\n"
  read -p "> " backend_url
}

get_frontend_port() {
  
  print_banner
  printf "${WHITE} 💻 Digite a porta do FRONTEND para a ( ${instancia_add} ); Ex: 3000 A 3999 ${GRAY_LIGHT}"
  printf "\n\n"
  printf "  Não use uma porta que ja esta sendo ultilizada em outras aplicações ou instancias. "
  printf "\n\n"
  read -p "> " frontend_port
}

get_backend_port() {
  
  print_banner
  printf "${WHITE} 💻 Digite a porta do BACKEND para esta instancia; Ex: 4000 A 4999 ${GRAY_LIGHT}"
  printf "\n\n"
  printf "  Não use uma porta que ja esta sendo ultilizada em outras aplicações ou instancias. "
  printf "\n\n"
  read -p "> " backend_port
}

get_phpmyadmin_port() {
  
  print_banner
  printf "${WHITE} 💻 Digite a porta do PHPMYADMIN  para a ( ${instancia_add} ); Ex: 8080 ${GRAY_LIGHT}"
  printf "\n\n"
  printf "  Não use uma porta que ja esta sendo ultilizada em outras aplicações ou instancias. "
  printf "\n\n"
  read -p "> " phpmyadmin_port
}

get_urls() {
  get_mysql_root_password
  get_instancia_add
  get_max_whats
  get_max_user
  get_frontend_url
  get_backend_url
  get_frontend_port
  get_backend_port
  get_phpmyadmin_port
}

software_update() {
  get_instancia_update
  frontend_update
  backend_update
}

inquiry_options() {
  
  print_banner
  printf "${WHITE} 💻 Bem vindo(a) ao instalador Press-Ticket, Selecione abaixo a proxima ação!${GRAY_LIGHT}"
  printf "\n\n"
  printf "   [1] Instalar o Press-Ticket\n"
  printf "   [2] Atualizar o Press-Ticket\n"
  printf "   [*] Sair sem fazer nada\n"
  printf "\n"
  read -p ">>> " option

  case "${option}" in
    1) get_urls ;;

    2) 
      software_update 
      exit
      ;;

    *) exit ;;
  esac
}