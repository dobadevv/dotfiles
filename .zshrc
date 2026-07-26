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

# bun completions
# [ -s "/Users/doba/.bun/_bun" ] && source "/Users/doba/.bun/_bun"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# . "/Users/doba/.deno/env"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/doba/.docker/completions $fpath)
autoload -Uz compinit
compinit

ZSH_THEME="robbyrussell"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(fzf --zsh)"

source <(ng completion script)
source ~/.zshrc.alias
source ~/.fzfrc

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/doba/.sdkman"
[[ -s "/Users/doba/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/doba/.sdkman/bin/sdkman-init.sh"

# pnpm
export PNPM_HOME="/Users/doba/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
