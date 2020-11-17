#!/bin/bash
set -e

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

function unitTests {
  showBanner "Unit Tests"
  # showBanner "Backend"
  pushd ${BASE_DIR}
  if [[ $CI == true ]] 
  then
    mvn -q test | grep -v "INFO"
  else
    mvn -q test | grep -v "INFO" &
    showSpinner "$!"
  fi
  echo -e "\033[32mTests Pass!\033[0m"
  popd

  # showBanner "Frontend"
  # pushd ${BASE_DIR}/client
  #     CI=true yarn test
  # popd
}

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

function showBanner {
  # This runs between each step in this file, to show the steps that are happening
  echo -e "\033[32m======================================================\033[0m"
  echo "  ${1}  ($(date))"
  echo -e "\033[32m======================================================\033[0m"
}

function setup {
  showBanner "Setup"
  echo -e "\033[2mNothing happens here yet, except building our BASE_DIR\033[0m"
  BASE_DIR="$(dirname $( cd "$(dirname "$0")" ; pwd -P ))"
  # source "${BASE_DIR}/scripts/setup_env.sh"
  # REACT_APP_HOST=http://localhost:9090
  # mkdir -p ${BASE_DIR}/tmp
}

function cleanup {
  showBanner "Cleanup"
  echo -e "\033[2mNothing happens here yet either, but this will run on every exit of the script\033[0m"
  # if [[ -f ${BASE_DIR}/tmp/squire.pid ]]; then
  #     cat ${BASE_DIR}/tmp/squire.pid | xargs kill -9
  #     rm ${BASE_DIR}/tmp/squire.pid
  # fi
}

# On any exit of the script, run cleanup
trap cleanup EXIT

# This is the main function, with args
main ${@}