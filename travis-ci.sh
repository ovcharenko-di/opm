#!/bin/bash

set -e

echo "Устанавливаю версию OScript <$OSCRIPT_VERSION>"
curl -L http://oscript.io/downloads/$OSCRIPT_VERSION/x64/deb > oscript.deb
dpkg -i oscript.deb 
rm -f oscript.deb

apt-get update
apt-get install -y python3

opm update opm
opm install 1testrunner; 
opm install 1bdd; 
opm install notify;
opm install coverage;
opm install; 

opm run coverage; 



