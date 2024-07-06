# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Source zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit load asdf-vm/asdf

# Theme
GEOMETRY_COLOR_DIR=152
zinit ice wait"0" lucid atload"geometry::prompt"
zinit light geometry-zsh/geometry

zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

zinit light mafredri/zsh-async  # dependency
zinit ice svn silent atload'prompt sorin'
zinit snippet PZT::modules/prompt

zinit ice atload"fpath+=( \$PWD );"
zinit light chauncey-garrett/zsh-prompt-garrett
zinit ice svn atload"prompt garrett" silent
zinit snippet PZT::modules/prompt

zinit ice wait'!' lucid nocompletions \
         compile"{zinc_functions/*,segments/*,zinc.zsh}" \
         atload'!prompt_zinc_setup; prompt_zinc_precmd'
zinit load robobenklein/zinc

# ZINC git info is already async, but if you want it
# even faster with gitstatus in Turbo mode:
# https://github.com/romkatv/gitstatus
zinit ice wait'1' atload'zinc_optional_depenency_loaded'
zinit load romkatv/gitstatus

# After finishing the configuration wizard change the atload'' ice to:
# -> atload'source ~/.p10k.zsh; _p9k_precmd'
zinit ice wait'!' lucid atload'true; _p9k_precmd' nocd
zinit light romkatv/powerlevel10k


# Add in snippets
#zinit snippet OMZP::git

. "$HOME/.asdf/asdf.sh"

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# Load completions
#autoload -U compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
# bindkey '^p' history-search-backward
# bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias bat='batcat'
alias fd='fdfind'

# Shell integrations
# eval "$(zoxide init --cmd cd zsh)"
source <(fzf --zsh)

. ~/.asdf/plugins/golang/set-env.zsh

# Load Angular CLI autocompletion.
source <(ng completion script)

# pnpm
export PNPM_HOME="/home/james/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
