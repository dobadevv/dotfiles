
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

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
if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then export FPATH="$HOME/.zsh/completions:$FPATH"; fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
. "$HOME/.deno/env"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)
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
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
