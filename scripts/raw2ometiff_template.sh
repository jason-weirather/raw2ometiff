#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
JAR_DIR="$(dirname "$SCRIPT_DIR")"
java -jar "$JAR_DIR/libs/raw2ometiff-unspecified.jar" "$@"
