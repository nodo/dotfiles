short_machine_name() {
  echo "%m"
}

two_blue_dots() {
  echo "%{${fg_bold[blue]}%}::%{$reset_color%}"
}

# current directory
directory() {
  echo "%{${fg[green]}%}%1~%{$reset_color%}"
}

caret() {
  echo "%{${fg_bold[blue]}%}»%{${reset_color}%}"
}

# current time, only hours and minutes
current_time() {
  echo "%T"
}

PROMPT='$(short_machine_name) $(two_blue_dots) $(directory) $(git_prompt_info)$(caret) '
RPROMPT='$(current_time)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
