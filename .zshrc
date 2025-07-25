export HOME=/home/hyunsoo

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=af-magic

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
git
zsh-syntax-highlighting
zsh-autosuggestions
tmux
z
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# fuzzy-finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# autojump
[[ -s ~/.autojump/etc/profile.d/autojump.sh  ]] && source ~/.autojump/etc/profile.d/autojump.sh


# go env
export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin:/opt/openenclave/bin"
export PKG_CONFIG_PATH="/opt/openenclave/share/pkgconfig"
export RUST_SRC_PATH=$HOME/rust/library # for rust racer

# Cargo command alias
alias cgr="cargo run"
alias cgt="cargo test"
alias cgc="cargo check"
alias cgb="cargo build"
alias cgf="cargo fuzz run"
alias cge="cargo expand"
alias cgi="cargo install"

# Cabal command alias
alias cbb="cabal build ."
alias cbr="cabal run ."
alias cbp="cabal repl"

# Stack command alias
alias sb="stack build"
alias sr="stack run"
alias st="stack test"

# Nix command alias
alias ns="nix-shell"
alias nsz="nix-shell --run zsh"

# Docker command alias
alias dc="docker compose" # Compose V2

# Hardhat command alias
alias hh="npx hardhat"

alias ls="eza"
alias cat="bat"

# Git command alias
alias gc="git clone"

export BAT_THEME="Coldark-Dark"

alias vi="nvim"

alias k="kubectl"

alias cursor="/opt/cursor.appimage --no-sandbox"

# justfile
alias jb="just build"
alias jt="just test"
alias jr="just run"

alias gk='ginkgo'

# tmux setting
DISABLE_AUTO_TITLE="true" # By setting 'true', it doesn't allow to set the pane title automatically

# utility functions
dus () {
    du -h -d 1 $* | sort -h --reverse
}

count() {
    ls -l | wc -ll
}

# tmux utils
tmw () { # tmux move window
    tmux move-window -t $1
}

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

# For starship
export STARSHIP_CONFIG=$HOME/.dotfiles/starship.toml
eval "$(starship init zsh)"

# For direnv
eval "$(direnv hook zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# walk (terminal nevigator)
export EDITOR=nvim
function lk {
  cd "$(walk "$@")"
}

[ -f "/home/hyunsoo/.ghcup/env" ] && . "/home/hyunsoo/.ghcup/env" # ghcup-env


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/home/hyunsoo/.opam/opam-init/init.zsh' ]] || source '/home/hyunsoo/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

export PATH="$PATH:/home/hyunsoo/.huff/bin"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

[[ -s "/home/hyunsoo/.gvm/scripts/gvm" ]] && source "/home/hyunsoo/.gvm/scripts/gvm"

alias psqlh="psql --host=localhost"

alias rm="trash-put"
