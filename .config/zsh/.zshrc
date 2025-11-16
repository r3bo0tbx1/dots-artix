HISTFILE=~/.cache/zsh/history
HISTSIZE=10000
SAVEHIST=10000

autoload -U compinit; compinit
[ -f /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.zsh ] && source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.zsh
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh ] && source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh
[ -f /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh ] && source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh
[ -f /usr/share/zsh/plugins/zsh-auto-notify/auto-notify.plugin.zsh ] && source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh


[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"


if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
    # To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
    [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
    source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
else

fi


eval "$(zoxide init zsh)"

pi() {
  clear
  local selection pkglist

  selection=$(
    paru -Sl --color=always |
    awk '{printf "%s/%s\t%-10s %-40s %s\n", $1, $2, $1, $2, $3}' |
    fzf --ansi \
        --multi \
        --exact \
        --reverse \
        --delimiter='\t' \
        --with-nth=2 \
        --prompt='[Repo Package] ' \
        --header=$'TAB = multi-select • ENTER = confirm\n' \
        --preview 'bash -c "
          repopkg=\$(echo {} | cut -f1)
          paru -Si \${repopkg} 2>/dev/null
        "' \
        --height=100%
  )

  [[ -z "$selection" ]] && return

  pkglist=$(echo "$selection" | cut -f1)

  clear
  echo
  echo "Selected package(s):"
  echo "$pkglist"
  echo
  printf "Install selected package(s)? [Y/n]: "
  read REPLY </dev/tty
  echo

  if [[ -z "$REPLY" || "$REPLY" =~ ^[Yy]$ ]]; then
      echo "$pkglist" | awk '{print $1}' | xargs -ro paru -Sy
  else
      echo "Cancelled."
  fi
}

pmi() {
  clear
  local selection pkglist

  selection=$(
    pacman -Sl --color=always |
    awk '{printf "%s/%s\t%-10s %-40s %s\n", $1, $2, $1, $2, $3}' |
    fzf --ansi \
        --multi \
        --exact \
        --reverse \
        --delimiter='\t' \
        --with-nth=2 \
        --prompt='[Repo Package] ' \
        --header=$'TAB = multi-select • ENTER = confirm\n' \
        --preview 'bash -c "
          repopkg=\$(echo {} | cut -f1)
          paru -Si \${repopkg} 2>/dev/null
        "' \
        --height=100%
  )

  [[ -z "$selection" ]] && return

  pkglist=$(echo "$selection" | cut -f1)

  clear
  echo
  echo "Selected package(s):"
  echo "$pkglist"
  echo
  printf "Install selected package(s)? [Y/n]: "
  read REPLY </dev/tty
  echo

  if [[ -z "$REPLY" || "$REPLY" =~ ^[Yy]$ ]]; then
      echo "$pkglist" | awk '{print $1}' | xargs -ro doas pacman -Sy
  else
      echo "Cancelled."
  fi
}



fastfetch

