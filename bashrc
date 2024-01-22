# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
shopt -s histappend
shopt -s extglob

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Prompt colors ######################################################################

export PROMPT_COMMAND=__prompt_command

function __prompt_command() {
    local exit="$?"
    
    local current_shell_pid="$$"
    local prompt='>$ '

    local yellow='\[\033[0;33m\]'
    local light_blue_bold='\[\033[1;36m\]'
    local pale_blue_bold='\[\033[1;34m\]'
    local bright_blue='\[\033[0;34m\]'
    local red_bold='\[\033[1;31m\]'
    local green='\[\e[0;32m\]'
    local no_color='\[\033[0;00m\]'

    local git_branch
    git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    local working_directory
    working_directory=$(pwd)

    PS1="${green}${current_shell_pid}"

    [[ ! -z "${git_branch}" ]] && PS1+="${light_blue_bold}:${yellow}${git_branch}"

    PS1+="${light_blue_bold}:${pale_blue_bold}${working_directory}${light_blue_bold}:${bright_blue}["
    if [ "$exit" != 0 ]; then
        PS1+="${red_bold}${exit}"
    else
        PS1+="${green}${exit}"
    fi
    PS1+="${bright_blue}]\n${green}${prompt}${no_color}"

}

# Aliases #####################################################################
# General
alias mkdir='mkdir -v'
alias grep='grep --color=auto'
alias ls='ls -hFG'
alias ta='tmux a -t'
alias tl='tmux ls'
alias tn='tmux new -s '
alias tk='tmux kill-session -t '
alias vi='vim'
alias copy="xclip -selection c"
alias copy2="xclip -sel clip"
alias paste="xclip -selection c -o"

# Safety
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ln='ln -i'

bind '"[A":history-search-backward'
bind '"[B":history-search-forward'

# Git
alias gs='git status'
alias gb='git branch'
alias gco='git checkout'
alias gc='git commit'
alias gpl='git pull'
alias gps='git push'
alias ga='git add'
alias ga.='git add .'
alias gl='git log'

alias ns='nix-shell'
alias cleanup-vim-backups="find . -name '.*.sw*' | xargs -L 1 rm -f"
alias repeat-until-fail="
BACKEND_TEST=notebooks make backend-cluster-test
while [ \$? -eq 0  ]; do
	    BACKEND_TEST=notebooks make backend-cluster-test
done"

alias helios-verify='helios-lint && make backend-go-tools && make backend-graphql-check && make backend-check-go-deps && helios-init && helios-test'
alias helios-clean-test='helios-init && helios-test'
alias helios-test='make backend-test && make postgres-test-reset postgres-test-go && make postgres-test-reset backend-integration-test'
alias helios-lint='make backend-lint'
alias helios-reload='make kube-reload-go-services && deploy/kube/util/reload-svlcontroller-img.sh'
alias helios-db-reset='make kube-reset-postgres'
alias helios-db-connect='psql -h 127.0.0.1 -U postgres freya'
alias helios-test-db-connect='psql -h 127.0.0.1 -U postgres test'
alias helios-restart='make kube-stop && make kube-start'
alias helios-build='make backend-debug'
alias helios-init='make kube-init'
alias helios-init-fe='helios-init && make frontend-start'
alias helios-bastion-login="ssh bastion1b-useast.cloud.memcompute.com"
alias helios-get-k3d-node-ip='kubectl get node "${KUBE_NODE_NAME}" -o jsonpath="{.status.addresses[0].address}"'
alias helios-integration-test='FREYA_RUN_DIR=go/src/freya REALM_SECRETS_PATH=$(pwd)/test/realm-secrets.json REVOPS_CONFIG_PATH=$(pwd)/test/revops-config.json FREYA_DB_HOST=127.0.0.1 ./run.sh go test -p=1 -count=1 -tags=integration '
alias helios-clean-k8s-clusters="kubectl delete memsqlcluster --all && kubectl get deployments | grep operator | awk '{print \$1}' | xargs kubectl delete deployment"

# Exports
export EDITOR=vim
export PATH=$PATH:/usr/local/go/bin:~/go/bin
export KUBECONFIG=/home/ymolinar/Repos/helios/test/kubeconfig.yml

# Set nix env variables
. ${HOME}/.nix-profile/etc/profile.d/nix.sh
# Added by Nix installer
if [ -e ${HOME}/.nix-profile/etc/profile.d/nix.sh ]; then . ${HOME}/.nix-profile/etc/profile.d/nix.sh; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Direnv
eval "$(direnv hook bash)"
