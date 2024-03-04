#!/bin/sh

/usr/bin/curl -L "https://ewr1.vultrobjects.com/miladycraft/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.3_7.pkg" -o temurin17.pkg
/usr/sbin/installer -pkg ./temurin17.pkg -target /
/bin/rm temurin17.pkg

exit 0