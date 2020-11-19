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

# Perform unit tests (Frontend / Backend)
function unitTests {
  showBanner "Unit Tests" "Backend"
  pushd ${BASE_DIR}
    runCommand "mvn -q test | grep -v 'INFO'" ""
    green "  Backend tests pass!"
  popd

  showBanner "Frontend"
  pushd ${BASE_DIR}/frontend
    CI=true yarn test
  popd
}

# Setup variables and verify dependencies are met
function setup {
  # Store the location of the currently running script
  scriptDir="$(dirname $0)"

  # Source our functions.sh
  source $scriptDir/functions.sh

  # Source any needed Environment Vars
  source $scriptDir/env.sh

  showBanner "Setup"
  cfgBaseDir
  chkCmd "yarn"
  
  pushd ${BASE_DIR}/frontend
    yarnInstall
  popd

  mkdir -p ${BASE_DIR}/tmp
}

# Clean up any items we may have touched that don't need to linger
function houseKeeping {
  showBanner "Cleanup"
  dim "Nothing happens here yet, but here there be cleanup"
}

# On any exit of the script, run cleanup
trap houseKeeping EXIT

# This is the main function, with args
main ${@}