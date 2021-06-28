export SHELL=/bin/zsh

bindkey -v
export KEYTIMEOUT=1

# ZSH highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Dircolors for Dracula theme
if [ -f ~/.dir_colors ]; then
    eval "$(dircolors -b ~/.dir_colors)"
fi


# PATH
PATH=$PATH:$HOME/.local/bin

# Aliases
alias la='ls -Alh' # show hidden files
alias ls='ls -aFh --color=always' # add colors and file type extensions
alias lx='ls -lXBh' # sort by extension
alias lk='ls -lSrh' # sort by size
alias lc='ls -lcrh' # sort by change time
alias lu='ls -lurh' # sort by access time
alias lr='ls -lRh' # recursive ls
alias lt='ls -ltrh' # sort by date
alias lm='ls -alh |more' # pipe through 'more'
alias lw='ls -xAh' # wide listing format
alias ll='ls -Fl' # long listing format
alias labc='ls -lap' #alphabetical sort
alias lf="ls -l | egrep -v '^d'" # files only
alias ldir="ls -l | egrep '^d'" # directories only

alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime='now'
alias nowdate='date +"%d-%m-%Y"'

alias vi='nvim'
alias vim='nvim'
alias svi='sudo vi'
alias vir='nvim -R'
alias vimr='nvim -R'

alias rm='rm -I --preserve-root'


# powerline-go config
function powerline_precmd() {
    PS1="$($HOME/bin/powerline-go \
	    -mode flat \
	    -error $? \
	    -max-width 95 \
	    -modules 'user,venv,cwd,perms,git,jobs,exit,root,wsl,terraform-workspace,shenv,kube,dotenv' \
	    -jobs ${${(%):%j}:-0})"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ] && [ -f "$HOME/bin/powerline-go" ]; then
    install_powerline_precmd
fi
