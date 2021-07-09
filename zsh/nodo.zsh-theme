ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}{"
ZSH_THEME_GIT_PROMPT_SUFFIX="} %{$reset_color%}"

PROMPT='%{$fg_bold[cyan]%}%c %{$reset_color%}$(git_prompt_info)$ '
RPROMPT='%T'
