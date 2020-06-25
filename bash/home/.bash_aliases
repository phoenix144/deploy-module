# Some useful aliases.
alias texclean='rm -f *.toc *.aux *.log *.cp *.fn *.tp *.vr *.pg *.ky'
alias uncmt="grep -Ev '^(#|$|;)'"
alias pgcc='gcc -Wall -Werror -std=c99'
alias oc='sudo -u www-data /var/www/owncloud/occ'

# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# "repeat" command.  Like: repeat 10 echo foo
repeat ()
{ 
    local count="$1" i;
    shift;
    for i in $(_seq 1 "$count");
    do
        eval "$@";
    done
}

# Subfunction needed by `repeat'.
_seq ()
{ 
    local lower upper output;
    lower=$1 upper=$2;

    if [ $lower -ge $upper ]; then return; fi
    while [ $lower -lt $upper ];
    do
	echo -n "$lower "
        lower=$(($lower + 1))
    done
    echo "$lower"
}
