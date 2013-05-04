#!/bin/bash

install -d ${1}/etc

cat > ${1}/etc/profile << "EOF"
# Begin /etc/profile
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# modifications by Dagmar d'Surreal <rivyqntzne@pbzpnfg.arg>

# System wide environment variables and startup programs.

# System wide aliases and functions should go in /etc/bashrc.  Personal
# environment variables and startup programs should go into
# ~/.bash_profile.  Personal aliases and functions should go into
# ~/.bashrc.

# Functions to help us manage paths.  Second argument is the name of the
# path variable to be modified (default: PATH)
pathremove () {
	local IFS=':'
	local NEWPATH
	local DIR
	local PATHVARIABLE=${2:-PATH}
	for DIR in ${!PATHVARIABLE} ; do
		if [ "$DIR" != "$1" ] ; then
			NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
		fi
	done
	export $PATHVARIABLE="$NEWPATH"
}

pathprepend () {
	pathremove $1 $2
	local PATHVARIABLE=${2:-PATH}
	export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

pathappend () {
	pathremove $1 $2
	local PATHVARIABLE=${2:-PATH}
	export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}


# Set the initial path
export PATH=/bin:/usr/bin

if [ $EUID -eq 0 ] ; then
	pathappend /sbin:/usr/sbin
	unset HISTFILE
fi

# Setup some environment variables.
export HISTSIZE=1000
export HISTIGNORE="&:[bf]g:exit"

# Setup a red prompt for root and a green one for users.
NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
if [[ $EUID == 0 ]] ; then
        PS1="$RED\u [ $NORMAL\w$RED ]# $NORMAL"
else
        PS1="$GREEN\u [ $NORMAL\w$GREEN ]\$ $NORMAL"
fi

for script in /etc/profile.d/*.sh ; do
	if [ -r $script ] ; then
		. $script
	fi
done

# Now to clean up
unset pathremove pathprepend pathappend

# End /etc/profile
EOF

install -d --mode=0755 ${1}/etc/profile.d

# /etc/profile.d/dircolors.sh
cat > ${1}/etc/profile.d/dircolors.sh << "EOF"
# Setup for /bin/ls to support color, the alias is in /etc/bashrc.
if [ -f "/etc/dircolors" ] ; then
	eval $(dircolors -b /etc/dircolors)

	if [ -f "$HOME/.dircolors" ] ; then
		eval $(dircolors -b $HOME/.dircolors)
	fi
fi
alias ls='ls --color=auto'
EOF

# /etc/profile.d/extrapaths.sh
cat > ${1}/etc/profile.d/extrapaths.sh << "EOF"
if [ -d /usr/local/lib/pkgconfig ] ; then
	pathappend /usr/local/lib/pkgconfig PKG_CONFIG_PATH
fi
if [ -d /usr/local/bin ]; then
	pathprepend /usr/local/bin
fi
if [ -d /usr/local/sbin -a $EUID -eq 0 ]; then
	pathprepend /usr/local/sbin
fi

if [ -d ~/bin ]; then
	pathprepend ~/bin
fi
#if [ $EUID -gt 99 ]; then
#	pathappend .
#fi
EOF

# /etc/profile.d/umask.sh
cat > ${1}/etc/profile.d/umask.sh << "EOF"
# By default, the umask should be set.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
	umask 002
else
	umask 022
fi
EOF

# /etc/profile.d/i18n.sh
cat > ${1}/etc/profile.d/i18n.sh << "EOF"
# Set up i18n variables
export LANG=ru_RU.UTF-8
EOF
