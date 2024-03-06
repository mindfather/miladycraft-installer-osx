#!/bin/sh

if [[ $(uname -m) == "arm64" ]]; then
    /usr/bin/curl -L "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2%2B13/OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.2_13.pkg" -o temurin21.pkg
else
    /usr/bin/curl -L "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2%2B13/OpenJDK21U-jdk_x64_mac_hotspot_21.0.2_13.pkg" -o temurin21.pkg
fi

/usr/sbin/installer -pkg ./temurin21.pkg -target /
/bin/rm temurin21.pkg

exit 0