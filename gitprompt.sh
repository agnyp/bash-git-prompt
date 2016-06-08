#!/bin/sh

function async_run()
{
  {
    $1 &> /dev/null
  }&
}

function git_prompt_dir()
{
  # assume the gitstatus.py is in the same directory as this script
  # code thanks to http://stackoverflow.com/questions/59895
  if [ -z "${__GIT_PROMPT_DIR}" ]; then
    local SOURCE="${BASH_SOURCE[0]}"
    while [ -h "${SOURCE}" ]; do
      local DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
      SOURCE="$(readlink "${SOURCE}")"
      [[ $SOURCE != /* ]] && SOURCE="${DIR}/${SOURCE}"
    done
    __GIT_PROMPT_DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
  fi
}

function git_prompt_config()
{
  # Colors
  ResetColor="\[\033[0m\]"            # Text reset

  # Regular Colors
  local Black="\[\033[0;30m\]"        # Black
  local Red="\[\033[0;31m\]"          # Red
  local Green="\[\033[0;32m\]"        # Green
  local Yellow="\[\033[0;33m\]"       # Yellow
  local Blue="\[\033[0;34m\]"         # Blue
  local Purple="\[\033[0;35m\]"       # Purple
	local Pink="\[\033[0;49;95m\]"			# Pink
  local Cyan="\[\033[0;36m\]"         # Cyan
  local White="\[\033[0;37m\]"        # White

  # Bold
  local BBlack="\[\033[1;30m\]"       # Black
  local BRed="\[\033[1;31m\]"         # Red
  local BGreen="\[\033[1;32m\]"       # Green
  local BYellow="\[\033[1;33m\]"      # Yellow
  local BBlue="\[\033[1;34m\]"        # Blue
  local BPurple="\[\033[1;35m\]"      # Purple
  local BCyan="\[\033[1;36m\]"        # Cyan
  local BWhite="\[\033[1;37m\]"       # White

  # Underline
  local UBlack="\[\033[4;30m\]"       # Black
  local URed="\[\033[4;31m\]"         # Red
  local UGreen="\[\033[4;32m\]"       # Green
  local UYellow="\[\033[4;33m\]"      # Yellow
  local UBlue="\[\033[4;34m\]"        # Blue
  local UPurple="\[\033[4;35m\]"      # Purple
  local UCyan="\[\033[4;36m\]"        # Cyan
  local UWhite="\[\033[4;37m\]"       # White

  # Background
  local On_Black="\[\033[40m\]"       # Black
  local On_Red="\[\033[41m\]"         # Red
  local On_Green="\[\033[42m\]"       # Green
  local On_Yellow="\[\033[43m\]"      # Yellow
  local On_Blue="\[\033[44m\]"        # Blue
  local On_Purple="\[\033[45m\]"      # Purple
  local On_Cyan="\[\033[46m\]"        # Cyan
  local On_White="\[\033[47m\]"       # White

  # High Intensty
  local IBlack="\[\033[0;90m\]"       # Black
  local IRed="\[\033[0;91m\]"         # Red
  local IGreen="\[\033[0;92m\]"       # Green
  local IYellow="\[\033[0;93m\]"      # Yellow
  local IBlue="\[\033[0;94m\]"        # Blue
  local IPurple="\[\033[0;95m\]"      # Purple
  local ICyan="\[\033[0;96m\]"        # Cyan
  local IWhite="\[\033[0;97m\]"       # White

  # Bold High Intensty
  local BIBlack="\[\033[1;90m\]"      # Black
  local BIRed="\[\033[1;91m\]"        # Red
  local BIGreen="\[\033[1;92m\]"      # Green
  local BIYellow="\[\033[1;93m\]"     # Yellow
  local BIBlue="\[\033[1;94m\]"       # Blue
  local BIPurple="\[\033[1;95m\]"     # Purple
  local BICyan="\[\033[1;96m\]"       # Cyan
  local BIWhite="\[\033[1;97m\]"      # White

  # High Intensty backgrounds
  local On_IBlack="\[\033[0;100m\]"   # Black
  local On_IRed="\[\033[0;101m\]"     # Red
  local On_IGreen="\[\033[0;102m\]"   # Green
  local On_IYellow="\[\033[0;103m\]"  # Yellow
  local On_IBlue="\[\033[0;104m\]"    # Blue
  local On_IPurple="\[\033[10;95m\]"  # Purple
  local On_ICyan="\[\033[0;106m\]"    # Cyan
  local On_IWhite="\[\033[0;107m\]"   # White


  #Checking if root to change output
  _isroot=false
  [[ $UID -eq 0 ]] && _isroot=true

  # source the user's ~/.git-prompt-colors.sh file, or the one that should be
  # sitting in the same directory as this script

  if [[ -z "$__GIT_PROMPT_COLORS_FILE" ]]; then
    local pfx file dir
    for dir in "$HOME" "$__GIT_PROMPT_DIR" ; do
      for pfx in '.' '' ; do
        file="$dir/${pfx}git-prompt-colors.sh"
        if [[ -f "$file" ]]; then
          __GIT_PROMPT_COLORS_FILE="$file"
          break 2
        fi
      done
    done
  fi

   # Various variables you might want for your PS1 prompt instead
  local Time12a="\$(date +%H:%M)"
  # local Time12a="(\$(date +%H:%M:%S))"
  # local Time12a="(\@))"
  local PathShort="\w"

  # if the envar is defined, source the file for custom colors
  if [[ -n "$__GIT_PROMPT_COLORS_FILE" && -f "$__GIT_PROMPT_COLORS_FILE" ]]; then
    source "$__GIT_PROMPT_COLORS_FILE"
  else
    # Default values for the appearance of the prompt.  Do not change these
    # below.  Instead, copy these to `~/.git-prompt-colors.sh` and change them
    # there.
    GIT_PROMPT_PREFIX="["
    GIT_PROMPT_SUFFIX="]"
    GIT_PROMPT_SEPARATOR=" |"
    GIT_PROMPT_BRANCH="${BoldCyan}"
    GIT_PROMPT_STAGED="${Green}!"
    GIT_PROMPT_CONFLICTS="${Red} "
    GIT_PROMPT_CHANGED="${Blue}+"
    GIT_PROMPT_REMOTE=" "
    GIT_PROMPT_UNTRACKED="${Cyan}…"
    GIT_PROMPT_STASHED="${BoldBlue} "
    GIT_PROMPT_CLEAN="${BoldGreen}✔"
    GIT_PROMPT_COMMAND_OK="${Green}✔ "
    GIT_PROMPT_COMMAND_FAIL="${Red}✘ "

    GIT_PROMPT_START_USER="${Yellow}${PathShort}${ResetColor}"
    GIT_PROMPT_START_ROOT="${Yellow}${PathShort}${ResetColor}"
    GIT_PROMPT_END_USER=" \n${White}${Time12a}${ResetColor} $ "
    GIT_PROMPT_END_ROOT=" \n${White}${Time12a}${ResetColor} # "

    # Please do not add colors to these symbols
    GIT_PROMPT_SYMBOLS_AHEAD="↑·"
    GIT_PROMPT_SYMBOLS_BEHIND="↓·"
    GIT_PROMPT_SYMBOLS_PREHASH=":"
  fi

  if [ "x${GIT_PROMPT_SHOW_LAST_COMMAND_INDICATOR}" == "x1" ]; then
  	if [ $LAST_COMMAND_STATE = 0 ]; then
  		LAST_COMMAND_INDICATOR="${GIT_PROMPT_COMMAND_OK}";
  	else
  		LAST_COMMAND_INDICATOR="${GIT_PROMPT_COMMAND_FAIL}";
  	fi
  fi

  if [ "x${GIT_PROMPT_START}" == "x" ]; then
    #First statment is for non root behavior second for root
    if $_isroot; then
      PROMPT_START="${GIT_PROMPT_START_ROOT}"
    else
      PROMPT_START="${GIT_PROMPT_START_USER}"
    fi
  else
    PROMPT_START="${GIT_PROMPT_START}"
  fi

  if [ "x${GIT_PROMPT_END}" == "x" ]; then
    #First statment is for non root behavior second for root
    if ! $_isroot; then
      PROMPT_END="${GIT_PROMPT_END_USER}"
    else
      PROMPT_END="${GIT_PROMPT_END_ROOT}"
    fi
  else
    PROMPT_END="${GIT_PROMPT_END}"
  fi

  # set GIT_PROMPT_LEADING_SPACE to 0 if you want to have no leading space in front of the GIT prompt
  if [ "x${GIT_PROMPT_LEADING_SPACE}" == "x0" ]; then
    PROMPT_LEADING_SPACE=""
  else
    PROMPT_LEADING_SPACE=" "
  fi

  if [ "x${GIT_PROMPT_ONLY_IN_REPO}" == "x1" ]; then
    EMPTY_PROMPT=$OLD_GITPROMPT
  else
    if [[ -n "${VIRTUAL_ENV}" ]]; then
      EMPTY_PROMPT="${LAST_COMMAND_INDICATOR}(${Blue}$(basename "${VIRTUAL_ENV}")${ResetColor}) ${PROMPT_START}$($prompt_callback)${PROMPT_END}"
    elif [[ -n "${CONDA_DEFAULT_ENV}" ]]; then
      EMPTY_PROMPT="${LAST_COMMAND_INDICATOR}(${Blue}$(basename "${CONDA_DEFAULT_ENV}")${ResetColor}) ${PROMPT_START}$($prompt_callback)${PROMPT_END}"
    else
      EMPTY_PROMPT="${LAST_COMMAND_INDICATOR}${PROMPT_START}$($prompt_callback)${PROMPT_END}"
    fi
  fi

  # fetch remote revisions every other $GIT_PROMPT_FETCH_TIMEOUT (default 5) minutes
  GIT_PROMPT_FETCH_TIMEOUT=${1-5}
  if [ "x$__GIT_STATUS_CMD" == "x" ]
  then
    git_prompt_dir
    local sfx file
    # look first for a '.sh' version, then use the python version
    for sfx in sh py ; do
      file="${__GIT_PROMPT_DIR}/gitstatus.$sfx"
      if [[ -x "$file" ]]; then
        __GIT_STATUS_CMD="$file"
        break
      fi
    done
  fi
}

function setGitPrompt() {
  LAST_COMMAND_STATE=$?

  local EMPTY_PROMPT
  local __GIT_STATUS_CMD

  git_prompt_config

  local repo=`git rev-parse --show-toplevel 2> /dev/null`
  if [[ ! -e "${repo}" ]]; then
    PS1="${EMPTY_PROMPT}"
    return
  fi

  local FETCH_REMOTE_STATUS=1
  if [[ "x${GIT_PROMPT_FETCH_REMOTE_STATUS}" == "x0" ]]; then
    FETCH_REMOTE_STATUS=0
  fi

  if [[ -e "${repo}/.bash-git-rc" ]]; then
  	source "${repo}/.bash-git-rc"
  fi

  if [ "x${FETCH_REMOTE_STATUS}" == "x1" ]; then
  	checkUpstream
  fi

  updatePrompt
}

function checkUpstream() {
  local GIT_PROMPT_FETCH_TIMEOUT
  git_prompt_config

  local FETCH_HEAD="${repo}/.git/FETCH_HEAD"
  # Fech repo if local is stale for more than $GIT_FETCH_TIMEOUT minutes
  if [[ ! -e "${FETCH_HEAD}"  ||  -e `find "${FETCH_HEAD}" -mmin +${GIT_PROMPT_FETCH_TIMEOUT}` ]]
  then
    if [[ -n $(git remote show) ]]; then
      (
        async_run "git fetch --quiet"
        disown -h
      )
    fi
  fi
}

function updatePrompt() {
  local GIT_PROMPT_PREFIX
  local GIT_PROMPT_SUFFIX
  local GIT_PROMPT_SEPARATOR
  local GIT_PROMPT_BRANCH
  local GIT_PROMPT_STAGED
  local GIT_PROMPT_CONFLICTS
  local GIT_PROMPT_CHANGED
  local GIT_PROMPT_REMOTE
  local GIT_PROMPT_UNTRACKED
  local GIT_PROMPT_STASHED
  local GIT_PROMPT_CLEAN
  local LAST_COMMAND_INDICATOR
  local PROMPT_LEADING_SPACE
  local PROMPT_START
  local PROMPT_END
  local EMPTY_PROMPT
  local GIT_PROMPT_FETCH_TIMEOUT
  local __GIT_STATUS_CMD
  local Blue="\[\033[0;34m\]"

  git_prompt_config

  local -a GitStatus
  GitStatus=($("${__GIT_STATUS_CMD}" 2>/dev/null))

  local GIT_BRANCH=${GitStatus[0]}
  local GIT_REMOTE=${GitStatus[1]}
  if [[ "." == "$GIT_REMOTE" ]]; then
    unset GIT_REMOTE
  fi
  local GIT_STAGED=${GitStatus[2]}
  local GIT_CONFLICTS=${GitStatus[3]}
  local GIT_CHANGED=${GitStatus[4]}
  local GIT_UNTRACKED=${GitStatus[5]}
  local GIT_STASHED=${GitStatus[6]}
  local GIT_CLEAN=${GitStatus[7]}

  if [[ -n "${GitStatus}" ]]; then
    local STATUS="${PROMPT_LEADING_SPACE}${GIT_PROMPT_PREFIX}${GIT_PROMPT_BRANCH}${GIT_BRANCH}${ResetColor}"

    if [[ -n "${GIT_REMOTE}" ]]; then
      STATUS="${STATUS}${GIT_PROMPT_REMOTE}${GIT_REMOTE}${ResetColor}"
    fi

    STATUS="${STATUS}${GIT_PROMPT_SEPARATOR}"
    if [ "${GIT_STAGED}" -ne "0" ]; then
      STATUS="${STATUS}${GIT_PROMPT_STAGED}${GIT_STAGED}${ResetColor}"
    fi

    if [ "${GIT_CONFLICTS}" -ne "0" ]; then
      STATUS="${STATUS}${GIT_PROMPT_CONFLICTS}${GIT_CONFLICTS}${ResetColor}"
    fi

    if [ "${GIT_CHANGED}" -ne "0" ]; then
      STATUS="${STATUS}${GIT_PROMPT_CHANGED}${GIT_CHANGED}${ResetColor}"
    fi

    if [ "${GIT_UNTRACKED}" -ne "0" ]; then
      STATUS="${STATUS}${GIT_PROMPT_UNTRACKED}${GIT_UNTRACKED}${ResetColor}"
    fi

    if [ "${GIT_STASHED}" -ne "0" ]; then
      STATUS="${STATUS}${GIT_PROMPT_STASHED}${GIT_STASHED}${ResetColor}"
    fi

    if [ "${GIT_CLEAN}" -eq "1" ]; then
      STATUS="${STATUS}${GIT_PROMPT_CLEAN}"
    fi

    STATUS="${STATUS}${ResetColor}${GIT_PROMPT_SUFFIX}"


    PS1="${LAST_COMMAND_INDICATOR}${PROMPT_START}$($prompt_callback)${STATUS}${PROMPT_END}"
    if [[ -n "${VIRTUAL_ENV}" ]]; then
      PS1="(${Blue}$(basename ${VIRTUAL_ENV})${ResetColor}) ${PS1}"
    fi

    if [[ -n "${CONDA_DEFAULT_ENV}" ]]; then
      PS1="(${Blue}$(basename ${CONDA_DEFAULT_ENV})${ResetColor}) ${PS1}"
    fi

  else
    PS1="${EMPTY_PROMPT}"
  fi
}

function prompt_callback_default {
    return
}

function run {
  if [ "`type -t prompt_callback`" = 'function' ]; then
      prompt_callback="prompt_callback"
  else
      prompt_callback="prompt_callback_default"
  fi

  if [ -z "$OLD_GITPROMPT" ]; then
    OLD_GITPROMPT=$PS1
  fi

  if [ -z "$PROMPT_COMMAND" ]; then
    PROMPT_COMMAND=setGitPrompt
  else
    PROMPT_COMMAND=${PROMPT_COMMAND%% }; # remove trailing spaces
    PROMPT_COMMAND=${PROMPT_COMMAND%\;}; # remove trailing semi-colon

    local new_entry="setGitPrompt"
    case ";$PROMPT_COMMAND;" in
      *";$new_entry;"*)
        # echo "PROMPT_COMMAND already contains: $new_entry"
        :;;
      *)
        PROMPT_COMMAND="$PROMPT_COMMAND;$new_entry"
        # echo "PROMPT_COMMAND does not contain: $new_entry"
        ;;
    esac
  fi

  git_prompt_dir
  source "$__GIT_PROMPT_DIR/git-prompt-help.sh"
}

run
