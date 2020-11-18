#!/bin/bash
# Exit the script on any errors
set -e

# Run all the sub functions, ran after loading the entire script
function main {
  setup
  buildOutput
  copyFiles
  buildJar
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
# end color functions

# This runs between each step in this file, to show the steps that are happening
function showBanner {
  echo ""
  green "================================================================"
  echo -e "  ${bright}${1}${default}"
  green "================================================================"
  echo ""
}

# Setup pre-requisites
function setup {
  showBanner "Setup"
  echo -e "  Configuring ${bright}BASE_DIR${default}"
  BASE_DIR="$(dirname $( cd "$(dirname "$0")" ; pwd -P ))"
  echo -e "    ${bright}BASE_DIR${default} = ${BASE_DIR}"
  echo ""
  echo -e "  Checking for ${bright}yarn${default}"
  if [ -x "$(command -v yarn)" ]; then
    green "    Found yarn! ${default}${dim}$(which yarn)"
  else
    red "    Yarn not found, exiting"
    exit 1
  fi
}

# Build frontend output files
function buildOutput {
  showBanner "Build output files"
  pushd ${BASE_DIR}/frontend
    echo "  Installing dependencies"
    echo ""
    yarn

    echo ""
    echo "  Building output files with Yarn"
    echo ""
    yarn build
  popd
}

# Copy frontend/build files to app static directory to be served
function copyFiles {
  showBanner "Copying files for packaging"
  pushd ${BASE_DIR}
    cp -r frontend/build/* src/main/resources/static
    dim "  Files copied, ready for packaging"
  popd
}

# Use Maven to build our JAR, ready for deployment to PCF
function buildJar {
  showBanner "Building JAR"
  pushd ${BASE_DIR}
    echo -e "  Executing ${dim}mvn -q -Dmaven.test.skip=true -DskipTests clean package${default}"
    mvn -q -Dmaven.test.skip=true -DskipTests clean package
    bright "  JAR built: ${default}${BASE_DIR}/$(ls target/*.jar)"
  popd
}

# Clean up any items we may have touched that don't need to linger
function cleanup {
  showBanner "Cleanup"
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

# Run main function w/ args
main ${@}