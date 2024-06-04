#!/bin/sh

/Applications/PollyMC.app/Contents/MacOS/pollymc -I ~/Library/Application\ Support/PollyMC/MiladyCraft_localhost.zip
program_pid=$!

wait $program_pid

rm ~/Library/Application\ Support/PollyMC/MiladyCraft_localhost.zip

exit 0