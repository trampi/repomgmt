#!/bin/sh
set -e 
set -o pipefail

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR
docker login
docker build -t trampi/repomgmt .
docker push trampi/repomgmt
