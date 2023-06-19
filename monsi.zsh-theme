#!/usr/bin/env zsh

# Customizable parameters.
PROMPT_PATH_MAX_LENGTH=30
PROMPT_DEFAULT_END='-'
PROMPT_ROOT_END=›

PROMPT_SUCCESS_COLOR=%F{#4DBADD}
PROMPT_FAILURE_COLOR=%F{#F2625E}
PROMPT_VCS_INFO_COLOR=$FG[242]
PROJECT_NAME_COLOR=%F{#E99051}
PATH_COLOR=%F{#F2D79E}

# Set required options.
setopt promptsubst

# Load required modules.
autoload -U add-zsh-hook
autoload -Uz vcs_info

# Add hook for calling vcs_info before each command.
add-zsh-hook precmd vcs_info

# Set vcs_info parameters.
zstyle ':vcs_info:*' enable hg bzr git
zstyle ':vcs_info:*:*' check-for-changes true # Can be slow on big repos.
zstyle ':vcs_info:*:*' unstagedstr '!'
zstyle ':vcs_info:*:*' stagedstr '+'
zstyle ':vcs_info:*:*' actionformats "%S" "%r/%s/%b %u%c (%a)"
zstyle ':vcs_info:*:*' formats "%S" "%r  %s/%b %u%c"
zstyle ':vcs_info:*:*' nvcsformats "%~" ""

# Set prompt variables formats.
missing_directory="%{$PATH_COLOR%}/"
arrow_format="%{$PROMPT_VCS_INFO_COLOR%} → %{$FX[reset]%}"
vcs_info_msg_1_format="%{$PROJECT_NAME_COLOR%}"'${vcs_info_msg_1_// */${arrow_format}${missing_directory}}'
path_format=$vcs_info_msg_1_format"%{$PATH_COLOR%}"'${vcs_info_msg_0_%%.}'"%{$FX[reset]%}"

# Define prompts.
PROMPT=$'\n'"%(0?.%{$PROMPT_SUCCESS_COLOR%}.%{$PROMPT_FAILURE_COLOR%})${SSH_TTY:+[%n@%m]}%{$FX[bold]%}%$PROMPT_PATH_MAX_LENGTH<..<"$path_format$'\n'"%(0?.%{$PROMPT_SUCCESS_COLOR%}.%{$PROMPT_FAILURE_COLOR%})${SSH_TTY:+[%n@%m]}%{$FX[no-bold]%}%$PROMPT_PATH_MAX_LENGTH<..<""%<<%(!.$PROMPT_ROOT_END.$PROMPT_DEFAULT_END)%{$FX[no-bold]%}%{$FX[reset]%} "

#RPROMPT="%{$PROMPT_VCS_INFO_COLOR%}"'$vcs_info_msg_1_'"%{$FX[reset]%}"
RPROMPT="%{$PROMPT_VCS_INFO_COLOR%}"'${vcs_info_msg_1_#* }'"%{$FX[reset]%}"