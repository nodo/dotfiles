user() {
  echo "%n"
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

PROMPT='$(user) $(two_blue_dots) $(directory) $(git_prompt_info)$(caret) '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
