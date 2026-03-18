# ~/.bash_aliases — managed by dotfiles

# --- Navigation ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
mkcd() { mkdir -p "$1" && cd "$1"; }

# --- ls ---
alias ls='ls --color=auto'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

# If eza is installed, use it
if command -v eza &>/dev/null; then
    alias ls='eza --color=auto --group-directories-first'
    alias ll='eza -alF --group-directories-first --git'
    alias la='eza -a --group-directories-first'
    alias tree='eza --tree'
fi

# --- grep ---
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# --- Safety nets ---
alias rm='rm -I'
alias mv='mv -i'
alias cp='cp -i'

# --- Git ---
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias gco='git checkout'
alias gb='git branch'
alias gst='git stash'
alias gstp='git stash pop'

# --- Docker ---
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'

# --- Utilities ---
alias cls='clear'
alias h='history'
alias j='jobs -l'
alias ports='ss -tulnp'
alias myip='curl -s ifconfig.me'
alias reload='source ~/.bashrc'

# If bat is installed, use it for cat
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
fi

# --- Extract anything ---
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *.rar)     unrar x "$1" ;;
            *)         echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
