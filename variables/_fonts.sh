#!/bin/bash
# Robson Rissato - robsonwr@gmail.com
# Variables to be used for font styling.

# color
readonly RED="\033[1;31m"
readonly GREEN="\033[1;32m"
readonly BLUE="\033[1;32m"
readonly WHITE="\033[1;37m"
readonly YELLOW="\033[1;33m"
readonly GRAY_LIGHT="\033[0;37m"
readonly CYAN_LIGHT="\033[1;36m"

# thickness
readonly BOLD=$(tput bold)
readonly NORMAL=$(tput sgr0)

#
#echo -e " \033[0;30m Preto  \033[0m             --> 0;30 "
#echo -e " \033[0;31m Vermelho  \033[0m          --> 0;31 "
#echo -e " \033[0;32m Verde  \033[0m             --> 0;32 "
#echo -e " \033[0;33m Marrom  \033[0m            --> 0;33 "
#echo -e " \033[0;34m Azul  \033[0m              --> 0;34 "
#echo -e " \033[0;35m Purple  \033[0m            --> 0;35 "
#echo -e " \033[0;36m Cyan  \033[0m              --> 0;36 "
#echo -e " \033[0;37m Cinza Claro  \033[0m       --> 0;37 "
#echo -e " \033[1;30m Preto Acinzentado \033[0m  --> 1;30 "
#echo -e " \033[1;31m Vermelho Claro  \033[0m    --> 1;31 "
#echo -e " \033[1;32m Verde Claro  \033[0m       --> 1;32 "
#echo -e " \033[1;33m Amarelo \033[0m            --> 1;33 "
#echo -e " \033[1;34m Azul  Claro \033[0m        --> 1;34 "
#echo -e " \033[1;35m Purple Claro  \033[0m      --> 1;35 "
#echo -e " \033[1;36m Cyan  Claro \033[0m        --> 1;36 "
#echo -e " \033[1;37m Branco  \033[0m            --> 1;37 "

#echo -e " \033[40;1;37m Fundo Preto    \033[0m     --> 40;?;? "
#echo -e " \033[41;1;37m Fundo Vermelho \033[0m     --> 41;?;? "
#echo -e " \033[42;1;37m Fundo Verde    \033[0m     --> 42;?;? "
#echo -e " \033[43;1;37m Fundo Marrom   \033[0m     --> 43;?;? "
#echo -e " \033[44;1;37m Fundo Azul     \033[0m     --> 44;?;? "
#echo -e " \033[45;1;37m Fundo Purple   \033[0m     --> 45;?;? "
#echo -e " \033[46;1;37m Fundo Cyan     \033[0m     --> 46;?;? "
#echo -e " \033[47;1;37m Fundo Cinza    \033[0m     --> 47;?;? "

#echo -e " \033[4;30m Sublinhado  \033[0m        --> 4;? "
#echo -e " \033[5;30m Piscando    \033[0m        --> 5;? "
#echo -e " \033[7;30m Invertido   \033[0m        --> 7;? "
#echo -e " \033[8;30m Concealed   \033[0m        --> 8;? "

