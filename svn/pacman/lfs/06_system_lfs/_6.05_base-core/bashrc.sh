#!/bin/bash

install -d ${1}/etc

cat > ${1}/etc/bashrc << "EOF"
# Begin /etc/bashrc
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# updated by Bruce Dubbs <bdubbs@linuxfromscratch.org>

# System wide aliases and functions.

# System wide environment variables and startup programs should go into
# /etc/profile.  Personal environment variables and startup programs
# should go into ~/.bash_profile.  Personal aliases and functions should
# go into ~/.bashrc

# Provides a colored /bin/ls command.  Used in conjunction with code in
# /etc/profile.

alias ls='ls --color=auto'

# Provides prompt for non-login shells, specifically shells started
# in the X environment. [Review the LFS archive thread titled
# PS1 Environment Variable for a great case study behind this script
# addendum.]

NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
if [[ $EUID == 0 ]] ; then
	PS1="$RED\u [ $NORMAL\w$RED ]# $NORMAL"
else
	PS1="$GREEN\u [ $NORMAL\w$GREEN ]\$ $NORMAL"
fi

# Setup a red prompt for root and a green one for users.
NORMAL="\[\033[0m\]"
RED="\[\033[1;31m\]"
GREEN="\[\033[1;32m\]"
BLUE="\[\033[1;34m\]"
WHITE="\[\033[1;37m\]"
# http://maketecheasier.com/8-useful-and-interesting-bash-prompts/2009/09/04
PS1="\n${WHITE}\342\224\214(\
$(if [[ ${EUID} == 0 ]]; \
then echo ${RED}\\h; \
else echo ${BLUE}\\u@\\h; \
fi)${WHITE})\342\224\200(\
\$(if [[ \$? == 0 ]]; \
then echo \"${GREEN}\$?\"; \
else echo \"${RED}\$?\"; \
fi)\
${WHITE})\342\224\200(${BLUE}\@ \d${WHITE})\342\224\200(${GREEN}\w${WHITE})\342\224\200(${GREEN}\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -lah | head -n 1 | cut -d' ' -f2)b${WHITE})\n\342\224\224\342\224\200> ${NORMAL}"

# End /etc/bashrc
EOF
