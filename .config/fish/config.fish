set -x QT_QPA_PLATFORMTHEME qt6ct

# Disable fish greeting message
function fish_greeting; end
fnm env --use-on-cd | source
echo ======================================
echo Hyallo!
date
echo ======================================


# ==========================================
# Aliases
# ==========================================
# alias cd=z									# use z for cd
alias hf="eval (history | fzf)"							# history

# eza 
alias ls="eza --icons --group-directories-first"				# ls with eza
alias ll="eza -l --icons --git --group-directories-first --header -h"		# Long listing
alias la="eza -la --icons --git --group-directories-first --header -h"		# Show all including hidden
alias lt="eza --tree --icons --level=2 --group-directories-first"		# Tree view (2 levels)


if status is-interactive
    # Commands to run in interactive sessions can go here
    oh-my-posh init fish --config ~/.config/oh-my-posh/themes/custom-theme.omp.json | source
    zoxide init fish | source 
end
