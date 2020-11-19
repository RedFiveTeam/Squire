# Establish some vars for ANSI colors
default="\033[0m"
bright="\033[1m"
dim="\033[2m"

red="\033[31m"
green="\033[32m"
yellow="\033[33m"
blue="\033[34m"
magenta="\033[35m"
cyan="\033[36m"

# wrappers for echo -e for entire lines in specific colors
function bright {
  echo -e "${bright}${1}${default}"
}

function dim {
  echo -e "${dim}${1}${default}"
}

function red {
  echo -e "${red}${1}${default}"
}

function green {
  echo -e "${green}${1}${default}"
}

function yellow {
  echo -e "${yellow}${1}${default}"
}

function blue {
  echo -e "${blue}${1}${default}"
}

function magenta {
  echo -e "${magenta}${1}${default}"
}

function cyan {
  echo -e "${cyan}${1}${default}"
}
# end color functions

function cfgBaseDir {
  echo -e "  Configuring ${bright}BASE_DIR${default}..."
  BASE_DIR="$(dirname $( cd "$(dirname "$0")" ; pwd -P ))"
  echo -e "    ${bright}BASE_DIR${default}:  ${BASE_DIR}"
  echo ""
}

function chkCmd {
  local cmd="${1}"
    echo -e "  Checking for ${bright}${cmd}${default}..."
  if [ -x "$(command -v ${cmd})" ]; then
    echo -e "    ${bright}${cmd}${default}:  $(which ${cmd})"
  else
    red "    ${cmd} not found, exiting"
    exit 1
  fi
  echo ""
}

function cleanup {
  if [ -f ${BASE_DIR}/tmp/squire.pid ]; then
      cat ${BASE_DIR}/tmp/squire.pid | xargs kill -9
      rm ${BASE_DIR}/tmp/squire.pid
  fi
}

# This runs between each step in this file, to show the steps that are happening
function showBanner {
  echo ""
  green "================================================================"
  bright "  ${1}"
  green "================================================================"

  if [ ${2} ]; then
    green "================================================================"
    bright "  ${2}"
    green "================================================================"
  fi

  echo ""
}

function runCommand {
  local cmd="${1}"
  local out="${2}"

  if [ "${out}" ]; then
    bright "  $out"
  else
    bright "  Executing "
  fi

  dim "    '$cmd'"

  if [ ! $CI ]; then
    $cmd > /dev/null &
    showSpinner "$!"
  else
    $cmd > /dev/null
  fi
  
  bright "      Done!"
  echo ""
}

# Show a fancy spinner, useful in local to show something is happening
function showSpinner {
  local -r pid="${1}"
  local -r delay='0.3'
  local spinstr='/-\|'
  local temp
  while ps a | awk '{print $1}' | grep -q "${pid}"; do
    temp="${spinstr#?}"
    printf "    %c " "${spinstr}"
    spinstr=${temp}${spinstr%"${temp}"}
    sleep "${delay}"
    printf "\b\b\b\b\b\b"
  done
}

function yarnBuild {
  runCommand "yarn build" "Building output files with Yarn"
}

function yarnInstall {
  runCommand "yarn" "Installing dependencies"
}

# silence pushd/popd default output
function pushd {
  command pushd "$@" > /dev/null
}

function popd {
  command popd "$@" > /dev/null
}