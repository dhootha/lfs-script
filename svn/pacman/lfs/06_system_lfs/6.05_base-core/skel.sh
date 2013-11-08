#!/bin/bash

install -d ${1}/etc/skel

cat > ${1}/etc/skel/.bash_profile << "EOF"
# Begin ~/.bash_profile
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# updated by Bruce Dubbs <bdubbs@linuxfromscratch.org>

# Personal environment variables and startup programs.

# Personal aliases and functions should go in ~/.bashrc.  System wide
# environment variables and startup programs are in /etc/profile.
# System wide aliases and functions are in /etc/bashrc.

append () {
	# First remove the directory
	local IFS=':'
	local NEWPATH
	for DIR in $PATH; do
		if [ "$DIR" != "$1" ]; then
			NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
		fi
	done

	# Then append the directory
	export PATH=$NEWPATH:$1
}

if [ -f "$HOME/.bashrc" ] ; then
	source $HOME/.bashrc
fi

if [ -d "$HOME/bin" ] ; then
	append $HOME/bin
fi

unset append

# End ~/.bash_profile
EOF

# ~/.bashrc
cat > ${1}/etc/skel/.bashrc << "EOF"
# Begin ~/.bashrc
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>

# Personal aliases and functions.

# Personal environment variables and startup programs should go in
# ~/.bash_profile.  System wide environment variables and startup
# programs are in /etc/profile.  System wide aliases and functions are
# in /etc/bashrc.

if [ -f "/etc/bashrc" ] ; then
	source /etc/bashrc
fi

# End ~/.bashrc
EOF

# ~/.bash_logout
cat > ${1}/etc/skel/.bash_logout << "EOF"
# Begin ~/.bash_logout
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>

# Personal items to perform on logout.

# End ~/.bash_logout
EOF
