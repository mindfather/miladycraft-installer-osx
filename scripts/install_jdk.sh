#!/bin/sh

if [[ $(uname -m) == "arm64" ]]; then
    /usr/bin/curl -L "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.10_7.pkg" -o temurin17.pkg
else
    /usr/bin/curl -L "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_x64_mac_hotspot_17.0.10_7.pkg" -o temurin17.pkg
fi

/usr/sbin/installer -pkg ./temurin17.pkg -target /
/bin/rm temurin17.pkg

exit 0