#!/bin/sh
cd ~/Library/Application\ Support/PollyMC/instances

if [ -d "Miladycraft 1.5" ]; then
    rm -rf Miladycraft\ 1.5
fi

mkdir -p Miladycraft\ 1.5/.minecraft
/usr/bin/unzip -q MiladyCraft\ 1.5.zip -d MiladyCraft\ 1.5
rm MiladyCraft\ 1.5.zip

if [ -d "Miladycraft 1.4" ]; then
    cp Miladycraft\ 1.4/.minecraft/.sl_password MiladyCraft\ 1.5/.minecraft/.sl_password
    cp -rf Miladycraft\ 1.4/.minecraft/XaeroWaypoints MiladyCraft\ 1.5/.minecraft/XaeroWaypoints
    cp -rf Miladycraft\ 1.4/.minecraft/XaeroWorldMap MiladyCraft\ 1.5/.minecraft/XaeroWorldMap
fi

exit 0