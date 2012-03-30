# .zshrc -- Alex Jurkiewicz
# http://www.bluebottle.net.au/.zshrc
# alex@bluebottle.net.au

# This is a very heavy RC file. If you're logging into a heavily loaded
# system, consider using a simpler shell until you fix it: ssh -t host /bin/sh

[[ -r ~/.zshrc.local.before ]] && . ~/.zshrc.local.before

#####
# Environment Setup
#####

# Some global zlogout files (RHEL...) clear the screen. This sucks, so disable all global RCs
unset GLOBAL_RCS

if [[ -n "$(locale -a | egrep -i "en_(AU|US)\.utf-?8" | head -1)" ]] ; then
	# Linux: en_AU.utf8
	# FreeBSD / OSX: en_AU.UTF-8
	# Locale can take a while on slow systems
	# This will use UTF-8 en_AU if it exists, else UTF-8 en_US if it exists, else C
	export LANG=$(locale -a | egrep -i "en_(AU|US)\.utf-?8" | head -1)
else
	export LANG=C
fi
export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

# Initial colours setup -- required by a few things further in
[[ -x /usr/bin/dircolors ]] && eval `dircolors`
autoload colors && colors

autoload -U tcp_open
zmodload zsh/stat
echo ${^fpath}/url-quote-magic(N) | grep -q url-quote-magic && autoload -U url-quote-magic && zle -N self-insert url-quote-magic
autoload -U zed
autoload -U zargs
autoload -U zcalc
autoload -U zmv

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>' #Removed '/'

HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
setopt nobeep interactivecomments kshglob autocd histfindnodups noflowcontrol extendedglob extendedhistory
setopt autolist nolistambiguous # On first tab, complete as much as you can and list the choices
setopt histnostore              # Don't put 'history' into the history list
setopt histignoredups           # Don't add identical events in a row (ok in different parts of the file)
setopt incappendhistory         # Add to history as we go
unsetopt autoremoveslash	# Don't remove slashes at the end of completions (maybe irrelevant with ZLE_*_SUFFIX options below...)
setopt nocheckjobs nohup longlistjobs

stty -ixon #no XON/XOFF
bindkey -e
bindkey '\e[3~' delete-char
bindkey '^[[3;5~' kill-word
bindkey '^Q' kill-word
bindkey ' ' magic-space

# gnome terminal, konsole, terminator
        bindkey '^[[1;5D' emacs-backward-word   # FreeBSD
        bindkey '^[[1;5C' emacs-forward-word    # FreeBSD
        bindkey '^A' beginning-of-line          # FreeBSD
        bindkey '^E' end-of-line                # FreeBSD
        bindkey '^[OH' beginning-of-line
        bindkey '^[OF' end-of-line
        bindkey '^[5D' emacs-backward-word
        bindkey '^[5C' emacs-forward-word
# PuTTY
        bindkey '^[[1~' beginning-of-line
        bindkey '^[[4~' end-of-line
        bindkey '^[OD' emacs-backward-word
        bindkey '^[OC' emacs-forward-word

# Autocomplete setup
autoload -U compinit && compinit
autoload -U promptinit && promptinit
zmodload -i zsh/complist && zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# [[ -f ~/.ssh/known_hosts ]] && ( _myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} ) ; zstyle ':completion:*' hosts $_myhosts )
zstyle ':completion:*:*:*:users' ignored-patterns _dhcp _pflogd adm apache avahi avahi-autoipd backup bin bind clamav cupsys cyrusdaemon daemon Debian-exim dictd dovecot games gnats gdm ftp halt haldaemon hplip ident identd irc junkbust klog kmem libuuid list lp mail mailnull man messagebus mysql munin named news nfsnobody nobody nscd ntp ntpd operator pcap polkituser pop postfix postgres proftpd proxy pulse radvd rpc rpcuser rpm saned shutdown smmsp spamd squid sshd statd stunnel sync sys syslog toor tty uucp vcsa varnish vmail vde2-net www www-data xfs couchdb kernoops libvirt-qemu rtkit speech-dispatcher usbmux dbus gopher
zstyle ':completion:*:*:*:hosts' ignored-patterns ip6-localhost ip6-loopback localhost.localdomain
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?~'  # Ignore files ending in ~ for all commands but rm
zstyle ':completion:*:processes' command 'ps -aux'              # Complete with all available processes
zstyle ':completion:*:kill:*' force-list always                 # Always show results for kill, even if there's only one result
zstyle ':completion:*:*:-command-:*' ignored-patterns '*.cmd'	# Ignore *.cmd in $PATH
# Don't modify completions after printing them
export ZLE_REMOVE_SUFFIX_CHARS='' && export ZLE_SPACE_SUFFIX_CHARS=''

#####
# Basic Information
#####

# What are we?
export FULLHOST=$(hostname -f 2>/dev/null || hostname)
export SHORTHOST=$(echo $FULLHOST | cut -d. -f1-2)
export TINYHOST=$(hostname -s)

# Basic distro detection
if [[ `uname` = Linux ]] ; then
        # Basic distro detection
        if [[ -f /etc/debian_version ]] ; then
                if grep -q Ubuntu /etc/issue.net ; then
                        DISTRO=ubuntu
                elif grep -q Debian /etc/issue.net ; then
                        DISTRO=debian
                else
                        DISTRO=unknown
                fi
        elif grep -q CentOS /etc/issue ; then
                        DISTRO=centos
        else
                DISTRO=unknown
        fi
        [[ -f /usr/lib/command-not-found ]] && commandnotfound=/usr/lib/command-not-found
        [[ -f /usr/share/command-not-found/command-not-found ]] && commandnotfound=/usr/share/command-not-found/command-not-found
fi

# Where are we?
case $FULLHOST in
*.bluebottle.net.au|*.home|ajlaptop*|ajvm*)
        ourloc=home
        ucolor=$fg_bold[green]
        ;;
*.websend.com.au|*.local|ws*)
        ourloc=work
        ucolor=$fg_bold[cyan]
        ;;
*)
        ourloc=unknown
        ucolor=$fg_bold[white] ;;
esac

#####
# Alias, Default Programs, Program Options Setup
#####
if [[ -x $(which vim) ]]                                                                                                         then export EDITOR=vim ; export VISUAL=vim ; alias vi=vim
else                                                                                                                            export EDITOR=vi ; export VISUAL=vi
fi
[[ -x $(which python) ]] && export PYTHON=`which python`

# Colours
if ls -F --color=auto >&/dev/null; then
  alias ls="ls --color=auto -F"
else
  alias ls="ls -F"
fi
export GREP_OPTIONS='--color=auto'
export CLICOLOR=1 # FreeBSD
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Pager
[[ -x $(which less) ]] && export PAGER=less
export LESS=-i

# New commands
alias l='command ls'
alias s=screen
alias tmux="tmux -2" # 256colour support
alias t="tmux -2"
alias sl=ls
alias hist='builtin history'
alias history='history 1' # Show all events
alias j=jobs
alias sidp=sudo
dstat --list &>/dev/null && alias dstat="dstat -tpcmdgn --top-cpu --top-bio" || alias dstat="dstat -tpcmdgn" # a little hacky, but I believe --top-cpu and --top-bio have always been core dstat plugins so just check if this dstat version has the plugin system
setenv() { export $1=$2 } # Woohoo csh
sudo() { [[ $1 == (vi|vim) ]] && ( shift && sudoedit "$@" ) || command sudo "$@"; } # sudo vi/vim => sudoedit
excuse() { nc bofh.jeffballard.us 666 | tail -1 }
#[[ -x `locate macros/less.sh | egrep \^/usr.\*vim | head -1` ]] && alias vess=`locate macros/less.sh | egrep \^/usr.\*vim | head -1` # This can be in a lot of places # warning: this line is SLOW
[[ -f /usr/share/pyshared/bzrlib/patiencediff.py ]] && alias pdiff="python /usr/share/pyshared/bzrlib/patiencediff.py"
alias portsnap-update='sudo portsnap fetch && sudo portsnap update' # FreeBSD
whence motd &>/dev/null || alias motd="cat /etc/motd"

# Create (minimal) copies of other config files if they aren't there, AND we aren't root, AND we're in ~
if [[ $USER != root ]] && [[ -x $(which wget) ]] && [[ $PWD = $HOME ]] ; then
        screenrc=~/.screenrc    && [[ ! -f $screenrc ]] && wget -qO $screenrc http://bluebottle.net.au/.screenrc && sed -e "s/046/0$(( 19 + $#FULLHOST ))/" $screenrc > $screenrc.temp && mv $screenrc.temp $screenrc &|
        tmuxconf=~/.tmux.conf	&& [[ ! -f $tmuxconf ]] && wget -qO $tmuxconf http://bluebottle.net.au/.tmux.conf &|
        vimrc=~/.vimrc          && [[ ! -f $vimrc ]] && wget -qO $vimrc http://bluebottle.net.au/.vimrc &|
        htoprc=~/.htoprc        && [[ `uname` = Linux ]] && [[ ! -f $htoprc ]] && wget -qO $htoprc http://bluebottle.net.au/.htoprc &|
        terminatorconfig=~/.config/terminator/config && [[ `uname` = Linux ]] && [[ ! -f $terminatorconfig ]] && mkdir -p ~/.config/terminator && wget -qO $terminatorconfig http://bluebottle.net.au/.terminatorconfig &|
        inkpot=~/.vim/colors/inkpot.vim && [[ ! -f $inkpot ]] && mkdir -p ~/.vim/colors && wget -qO $inkpot 'http://www.vim.org/scripts/download_script.php?src_id=5747' &|
fi

# Experimental!
#####
#sess=$$
#tcp_open -qz www.bluebottle.net.au 80 $sess
#tcp_send -qs $sess -- 'GET /.vimrc HTTP/1.1'
#tcp_send -qs $sess -- 'Host: www.bluebottle.net.au'
#tcp_send -qs $sess -- ''
#tcp_read -qbds $sess > file
#tcp_close -q $sess 2> /dev/null

# Prompt Setup
#####

# Called in preexec() and precmd() to set the window title and screen title (if in screen)
function title() {
        # escape '%' chars in $1, make nonprintables visible
        a=${(V)1//\%/\%\%}
        # Truncate command, and join lines.
        a=$(print -Pn "$a" | tr -d "\n")
        # Remove 'sudo ' from the start of the command if it's there
        a=${a#sudo }

        case $TERM in
        screen*)
                # Screen/tmux tab title
                [[ $a = zsh ]] && print -Pn "\ek$2\e\\" # show the path if no program is running
                [[ $a != zsh ]] && print -Pn "\ek$a\e\\" # if a program is running show that

                # Terminal title
                if [[ -n $STY ]] ; then # after the final dot can be user OR hostname (depending on unix flavour)
                        # Screen session has a meaningless name, don't include it in xterm title
                        [[ $a = zsh ]] && print -Pn "\e]2;$SHORTHOST:S\[$WINDOW\]:$2\a"
                        [[ $a != zsh ]] && print -Pn "\e]2;$SHORTHOST:S\[$WINDOW\]:${a//\%/\%\%}\a"
                elif [[ -n $TMUX ]] ; then
                        # We're running in tmux, not screen
                        [[ $a = zsh ]] && print -Pn "\e]2;$SHORTHOST:$2\a"
                        [[ $a != zsh ]] && print -Pn "\e]2;$SHORTHOST:${a//\%/\%\%}\a"
                fi
                ;;
        xterm*|rxvt*)
                [[ $a = zsh ]] && print -Pn "\e]2;$SHORTHOST:$2\a"
                # extra processing here so you don't bork commandlines with % in them
                [[ $a != zsh ]] && print -Pn "\e]2;$SHORTHOST:${a//\%/\%\%}\a"
                ;;
        esac
}

#Choose the character (and colour) at the end of the prompt
if [[ `whoami` = root ]] ; then
        echo $fg_bold[white] "* NOTE: This is zsh, not the normal root shell" $reset_color
fi

# grey, aka #3E3E3E
#grey=''
if [[ `uname` != Darwin ]] ; then
	# OSX Terminal interprets this as a flashing colour
	grey='[38;5;248m'
fi

# Show a simple B&W prompt if we dont have colour support or we're on a physical console
if [[ -z $fg ]] || ( [[ `uname` == Linux ]] && [[ $TTY == /dev/tty* ]] ) || ( [[ `uname` == FreeBSD ]] && [[ $TTY == /dev/ttyv* ]] ) ; then
        PS1="%D{%H:%M:%S} %m %~ $ "
else
        PS1="%{$reset_color$grey%}%D{%H:%M:%S} %{%(#.$fg_bold[red].${ucolor})%}$SHORTHOST %{$reset_color$fg[yellow]%}%~%{%(?.${ucolor}.$fg[red])%} $%{$reset_color%} "
fi

# Runs before printing the prompt
precmd() {
        # See https://launchpad.net/command-not-found
        #(($?)) && [[ -f $commandnotfound ]] && [[ -x $PYTHON ]] && [[ -n $_command ]] && { whence -- "$_command" >& /dev/null || $PYTHON $commandnotfound -- "$_command" ; unset command }
        title "zsh" "%15<...<%~"
        }
# Runs before executing an input command
preexec() {
        _command="${1%% *}"
        title "$1" "%15<...<%~"
        }

#####
# Misc
#####

# See if there's an update available -- Note! Clobbers .zshrc.new
updatezshrc() { [[ -f ~/.zshrc.new ]] && ( mv -v ~/.zshrc ~/.zshrc.old ; mv -v ~/.zshrc.new ~/.zshrc ) || echo "Uh-Oh" }
# Need the PWD=HOME check because wget can't be told to output the file anywhere but '.' when using -N. Stupid app.
[[ $USER != root ]] && ( [[ -x $(which wget) ]] && [[ $PWD = $HOME ]] && wget -N --quiet http://bluebottle.net.au/.zshrc.new ; [[ ~/.zshrc.new -nt ~/.zshrc ]] && echo $fg_bold[white] "\n* Downloaded newer .zshrc as .zshrc.new" $reset_color ) &|
# fetch -m http://www.bluebottle.net.au/.zshrc

# If this is a login shell do a basic fingerprint on the system
# tmux by defualt creates login shells. Boo hiss!
if [[ $- == *l* ]] && [[ -z "$TMUX" ]] ; then
	echo
	hostname
	if [[ -f /etc/issue.net ]] ; then
		cat /etc/issue.net | head -1
	elif [[ -f /etc/issue ]] ; then
		cat /etc/issue | head -1
	elif [[ `uname` = Darwin ]] ; then
		sw_vers -productName | tr '\n' ' ' ; sw_vers -productVersion
	fi
	uname -srm
	if [[ -n "$SSH_CLIENT" ]] ; then
		echo -n "Connected to: " && netstat -tn | grep $(echo $SSH_CLIENT | cut -d\  -f1) | grep $(echo $SSH_CLIENT | cut -d\  -f2) | awk '{print $4}'
	fi

	echo
fi

# Run the local override file if it's there
[[ -r ~/.zshrc.local.after ]] && . ~/.zshrc.local.after

echo -n # Prime $?

