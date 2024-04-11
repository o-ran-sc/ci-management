#!/bin/bash

# Clone the repository
git clone https://gerrit.o-ran-sc.org/r/nonrtric
cd nonrtric/sample-services/ics-producer-consumer || exit

# Run the start.sh script
./start.sh

# Check the exit status of the start.sh script
if [ $? -eq 0 ]; then
    echo "start.sh exited successfully (exit code 0)"
else
    echo "start.sh exited with an error (exit code $?)"
fi
