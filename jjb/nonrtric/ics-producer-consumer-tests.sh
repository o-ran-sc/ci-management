#!/bin/bash

echo "Starting ics-producer-consumer-tests.sh which will execute sample-services/ics-producer-consumer/start.sh"

cd sample-services/ics-producer-consumer || exit

# Run the start.sh script and capture its exit status
./start.sh
start_status=$?

# Check the exit status of the start.sh script
if [ $start_status -eq 0 ]; then
    echo "start.sh exited successfully (exit code 0)"
else
    echo "start.sh exited with an error (exit code $start_status)"
fi
