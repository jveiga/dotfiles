# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# to debug, uncomment this
# zmodload zsh/zprof
source ~/.antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh
# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle ruby
antigen bundle homebrew
antigen bundle docker-compose
antigen bundle ripgrep
# antigen bundle command-not-found

# Syntax highlighting bundle.
# antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
# antigen theme lambda

# Tell Antigen that you're done.
antigen apply
# autoload -Uz compinit && compinit
. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export AWS_REGION=eu-west-1
export AWS_PROFILE=fishbrain
export PATH=$PATH:/Users/jveiga/.bin/:/Users/jveiga/Library/Python/3.7/bin/:/Users/jveiga/Library/Python/2.7/bin:~/go/bin/:/Users/jveiga/.local/bin/:/Users/jveiga/Library/Android/sdk/tools/bin/:~/.nimble/bin/:$(go env GOPATH)/bin
alias vim=nvim
alias grep=rg
alias ls=exa
alias gaws='docker run -it --rm  -v ~/.aws:/root/.aws cevoaustralia/aws-google-auth --profile fishbrain'
export ERL_AFLAGS="-kernel shell_history enabled"

# export GOPATH=/Users/jveiga/go
alias gf='git fetch --prune'
alias gfm='gf --prune && gm'
alias tree='tree-rs'
alias dc='docker-compose'


# Wasmer
export WASMER_DIR="/Users/jveiga/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"
source ~/.skim/key-bindings.zsh

# to debug, uncomment this
# zprof

. ~/.asdf/plugins/java/set-java-home.zsh

export GO111MODULE=on
export GOROOT=$(go env GOROOT)

_z_cd() {
    cd "$@" || return "$?"

    if [ "$_ZO_ECHO" = "1" ]; then
        echo "$PWD"
    fi
}

z() {
    if [ "$#" -eq 0 ]; then
        _z_cd ~ || return "$?"
    elif [ "$#" -eq 1 ] && [ "$1" = '-' ]; then
        if [ -n "$OLDPWD" ]; then
            _z_cd "$OLDPWD" || return "$?"
        else
            echo 'zoxide: $OLDPWD is not set'
            return 1
        fi
    else
        result="$(zoxide query "$@")" || return "$?"
        if [ -d "$result" ]; then
            _z_cd "$result" || return "$?"
        elif [ -n "$result" ]; then
            echo "$result"
        fi
    fi
}


alias zi='z -i'

alias za='zoxide add'

alias zq='zoxide query'
alias zqi='zoxide query -i'

alias zr='zoxide remove'
alias zri='zoxide remove -i'


_zoxide_hook() {
    zoxide add
}

chpwd_functions=(${chpwd_functions[@]} "_zoxide_hook")


eval "$(starship init zsh)"
SCCACHE_CACHE_SIZE="1G"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
