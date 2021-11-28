# current directory
directory() {
  echo "%{${fg[green]}%}%2~%{$reset_color%}"
}

# current time, only hours and minutes
current_time() {
  echo "%T"
}

if [ $UID -eq 0 ]; then CARETCOLOR="red"; else CARETCOLOR="blue"; fi
caret() {
  echo "%{${fg_bold[$CARETCOLOR]}%}»%{${reset_color}%}"
}

PROMPT='$(directory) $(git_prompt_info)$(caret) '
RPROMPT='$(current_time)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
