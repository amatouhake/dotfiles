################################################################
#### Powerlevel10k
################################################################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

zinit ice depth=1; zinit light romkatv/powerlevel10k 


################################################################
#### Completion
################################################################

zinit light-mode for \
    zsh-users/zsh-syntax-highlighting \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    zsh-users/zsh-history-substring-search

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

function history-substring-select() {
    BUFFER=$(fc -l -n 1 | tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle redisplay
}

zle -N history-substring-select
bindkey '^R' history-substring-select

export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt share_history

### Z Shell オプション
autoload -Uz compinit
compinit

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt correct

# 補完に関するオプション
# http://voidy21.hatenablog.jp/entry/20090902/1251918174
setopt auto_param_slash  # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt mark_dirs  # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt list_types  # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt auto_menu  # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_keys  # カッコの対応などを自動的に補完
setopt interactive_comments  # コマンドラインでも # 以降をコメントと見なす
setopt magic_equal_subst  # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる

setopt complete_in_word  # 語の途中でもカーソル位置で補完
setopt always_last_prompt    # カーソル位置は保持したままファイル名一覧を順次その場で表示

setopt print_eight_bit  #日本語ファイル名等8ビットを通す
setopt extended_glob  # 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
setopt globdots  # 明確なドットの指定なしで.から始まるファイルをマッチ

bindkey "^I" menu-complete   # 展開する前に補完候補を出させる(Ctrl-iで補完するようにする)

zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*' use-cache true

zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history _expand_alias
zstyle ':completion:*:messages' format $YELLOW'%d'$DEFAULT
zstyle ':completion:*:warnings' format $RED'No matches for:'$YELLOW' %d'$DEFAULT
zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:corrections' format $YELLOW'%B%d '$RED'(errors: %e)%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'

### HOME and END
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line


################################################################
#### Functions
################################################################

extract() {
  case $1 in
    *.tar|*.tar.gz|*.tgz|*.tar.xz|*.tar.bz2|*.tbz|*.tar.Z) tar xvf $1;;
    *.gz) gzip -d $1;;
    *.bz2) bzip2 -d $1;;
    *.Z) uncompress $1;;
    *.zip) unzip $1;;
  esac
}

runcpp() { g++ -O2 $1 && shift && ./a.out $@ }


################################################################
#### Alias
################################################################

expand-alias() {
    zle _expand_alias
    zle redisplay
    zle accept-line
}

zle -N expand-alias
bindkey "^M" expand-alias

alias la='ls -A'
alias g='cd $(ghq root)/$(ghq list | peco --prompt "GIT REPOSITORY>")'
alias gh='hub browse $(ghq list | peco --prompt "GIT REPOSITORY>" | cut -d "/" -f 2,3)'

alias -s {tar,gz,tgz,xz,bz2,tbz,Z,zip}=extract
alias -s {c,cpp}=runcpp
alias -s js='node'
alias -s py='python'


################################################################
#### Abbreviations
################################################################

typeset -A abbreviations
typeset -A abbreviations_no_prefix
typeset -A abbreviations_git
typeset -A abbreviations_npm
typeset -A abbreviations_yarn
typeset -A abbreviations_pnpm

abbreviations=(
  a 'apt'
  g 'git'
  m 'mkdir'
  n 'npm'
  p 'pnpm'
  y 'yarn'
)

abbreviations_no_prefix=(
  gb '$(git branch | peco --prompt "GIT BRANCH>" | sed -e "s/^\*\s*//g")'
  A '| awk'
  G '| grep'
  P '| peco'
  S '| sed'
  X '| xargs'
)

abbreviations_git=(
  a 'add'
  b 'branch'
  c 'commit -m'
  ch 'checkout'
  d 'diff'
  f 'fetch'
  p 'push'
  s 'status'
)

abbreviations_npm=(
  i 'init'
  r 'run'
  s 'search'
)

abbreviations_yarn=(
  a 'add'
  i 'init'
  r 'remove'
  s 'search'
)

abbreviations_pnpm=(
  i 'init'
  r 'run'
  s 'search'
)

expand-abbreviation() {
    local MATCH
    
    LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    
    if echo $LBUFFER | grep -q -E "\S+\s"; then
        LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
        LBUFFER+=${abbreviations_no_prefix[$MATCH]:-$MATCH}
    fi
    
    if echo $LBUFFER | grep -q -E "git\s\S+$"; then
        LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
        LBUFFER+=${abbreviations_git[$MATCH]:-$MATCH}
    fi
    
    if echo $LBUFFER | grep -q -E "npm\s\S+$"; then
        LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
        LBUFFER+=${abbreviations_npm[$MATCH]:-$MATCH}
    fi
    
    if echo $LBUFFER | grep -q -E "yarn\s\S+$"; then
        LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
        LBUFFER+=${abbreviations_yarn[$MATCH]:-$MATCH}
    fi
    
    if echo $LBUFFER | grep -q -E "pnpm\s\S+$"; then
        LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
        LBUFFER+=${abbreviations_pnpm[$MATCH]:-$MATCH}
    fi
    
    zle self-insert
}

no-expand-abbreviation() {
    LBUFFER+=" "
}

zle -N expand-abbreviation
zle -N no-expand-abbreviation

bindkey " " expand-abbreviation
bindkey "^x " no-expand-abbreviation
