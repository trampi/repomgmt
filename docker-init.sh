#!/bin/sh

echo "Removing old docker images (if they exist)"
sudo docker rm -f repomgmt &> /dev/null
DIR="$( cd "$( dirname "$0" )" && pwd )"
echo "Starting rails instance and forwarding bash to you..."

sudo docker run -v ${DIR}:/data/repomgmt \
           -p 3000:3000 \
           -i -t \
           -w /data/repomgmt \
           --name repomgmt trampi/repomgmt /bin/bash -c "bundle install && exec /bin/bash"
