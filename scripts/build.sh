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

# Setup pre-requisites
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
}

# Build frontend output files
function buildOutput {
  showBanner "Build output files"
  pushd ${BASE_DIR}/frontend
    yarnInstall
    yarnBuild
  popd
}

# Copy frontend/build files to app static directory to be served
function copyFiles {
  showBanner "Copy build files for packaging"
  pushd ${BASE_DIR}
    runCommand "cp -r frontend/build/* src/main/resources/static"
  popd
}

# Use Maven to build our JAR, ready for deployment to PCF
function buildJar {
  showBanner "Building JAR"
  if [ -x "$(command -v mvn)" ]; then
    pushd ${BASE_DIR}
      runCommand "mvn -q -Dmaven.test.skip=true -DskipTests clean package"
      bright "  JAR${default}${dim}:  ${BASE_DIR}/$(ls target/*.jar)"
    popd
  else
    red "  Maven not found!"
    exit 1
  fi
}

# Clean up any items we may have touched that don't need to linger
function houseKeeping {
  showBanner "Cleanup"
}

# On any exit of the script, run cleanup
trap houseKeeping EXIT

# Run main function w/ args
main ${@}