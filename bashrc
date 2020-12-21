#!/usr/bin/env bash

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob

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
alias td='tmux kill-session -t '
alias vi='vim'

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

# Ctags
alias ctags='/usr/local/bin/ctags'

# Autocomplete
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# PATH
export PATH=$PATH:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$JAVA_HOME/bin:$HOME/go/bin
