#!/bin/sh

/Applications/PollyMC.app/Contents/MacOS/pollymc -I ~/Library/Application\ Support/PollyMC/Miladycraft\ 1.5.zip
program_pid=$!

wait $program_pid

rm ~/Library/Application\ Support/PollyMC/Miladycraft\ 1.5.zip

exit 0