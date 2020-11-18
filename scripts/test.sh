#!/bin/bash
# Exit the script on any errors
set -e

# Run all the sub functions, ran after loading the entire script
function main {
  setup

  case "${1}" in
    # anj)
      # acceptanceTests ${@}
    # ;;
    # acc|acceptance)
      # yarnBuild
      # jarBuild
      # acceptanceTests ${@}
    # ;;
    # unit)
      # unitTests
    # ;;
    *)
      # yarnBuild
      unitTests
      # jarBuild
      # acceptanceTests
    ;;
  esac
}

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
# End colors

# wrappers for echo -e for entire lines in specific colors
function bright {
  echo -e "${bright}${1}${default}"
}

function dim {
  echo -e "${dim}${1}${default}"
}

function green {
  echo -e "${green}${1}${default}"
}

function red {
  echo -e "${red}${1}${default}"
}
# End wrappers

# Perform unit tests (Frontend / Backend)
function unitTests {
  showBanner "Unit Tests"
  showBanner "Backend"
  pushd ${BASE_DIR}
    if [[ $CI == true ]]; then
      mvn -q test | grep -v "INFO"
    else
      mvn -q test | grep -v "INFO" &
      showSpinner "$!"
    fi
    green "  Backend tests pass!"
  popd

  showBanner "Frontend"
  pushd ${BASE_DIR}/frontend
    CI=true yarn test
  popd
}

# Show a fancy spinner, useful in local to show something is happening
function showSpinner {
  local -r pid="${1}"
  local -r delay='0.3'
  local spinstr='/-\|'
  local temp
  while ps a | awk '{print $1}' | grep -q "${pid}"; do
    temp="${spinstr#?}"
    printf " [%c]  " "${spinstr}"
    spinstr=${temp}${spinstr%"${temp}"}
    sleep "${delay}"
    printf "\b\b\b\b\b\b"
  done
}

# This runs between each step in this file, to show the steps that are happening
function showBanner {
  echo ""
  green "================================================================"
  echo "  ${bright}${1}${default}"
  green "================================================================"
  echo ""
}

# Setup variables and verify dependencies are met
function setup {
  showBanner "Setup"
  echo -e "  Configuring ${bright}BASE_DIR${default}..."
  BASE_DIR="$(dirname $( cd "$(dirname "$0")" ; pwd -P ))"
  echo -e "    ${bright}BASE_DIR${default} = ${BASE_DIR}"
  echo ""
  echo -e "  Checking for ${bright}yarn${default}..."
  if [ -x "$(command -v yarn)" ]; then
    echo -e "    ${bright}yarn${default} = $(which yarn)"
  else
    red "    Yarn not found, exiting"
    exit 1
  fi
  pushd ${BASE_DIR}/frontend
    echo ""
    echo -e "Installing ${bright}dependencies${default}..."
    echo ""
    yarn --silent
  popd
  # source "${BASE_DIR}/scripts/setup_env.sh"
  # REACT_APP_HOST=http://localhost:9090
  # mkdir -p ${BASE_DIR}/tmp
}

# Clean up any items we may have touched that don't need to linger
function cleanup {
  showBanner "Cleanup"
  dim "Nothing happens here yet either, but here there be cleanup"
  # if [[ -f ${BASE_DIR}/tmp/squire.pid ]]; then
  #     cat ${BASE_DIR}/tmp/squire.pid | xargs kill -9
  #     rm ${BASE_DIR}/tmp/squire.pid
  # fi
}

# On any exit of the script, run cleanup
trap cleanup EXIT

# silence pushd/popd default behaviors
function pushd {
  command pushd "$@" > /dev/null
}

function popd {
  command popd "$@" > /dev/null
}

# This is the main function, with args
main ${@}