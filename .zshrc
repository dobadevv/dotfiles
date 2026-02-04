source ~/.zshrc.env
source ~/.zshrc.secret

# Auto install zsh plugins if missing
for plugin in zsh-syntax-highlighting zsh-autosuggestions; do
  if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
    git clone "https://github.com/zsh-users/$plugin.git" \
      "$ZSH_CUSTOM/plugins/$plugin"
  fi
done

# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/doba/.zsh/completions:"* ]]; then export FPATH="/Users/doba/.zsh/completions:$FPATH"; fi
source ~/.nvm/nvm.sh

# bun completions
[ -s "/Users/doba/.bun/_bun" ] && source "/Users/doba/.bun/_bun"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
. "/Users/doba/.deno/env"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/doba/.docker/completions $fpath)
autoload -Uz compinit
compinit

ZSH_THEME="robbyrussell"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(fzf --zsh)"

source <(ng completion script)
source ~/.zshrc.alias
source ~/.fzfrc

. "$HOME/.local/bin/env"
