#!/bin/bash

set -eux -o pipefail

echo "Starting ics-producer-consumer-tests.sh which will execute sample-services/ics-producer-consumer/start.sh"

bash start.sh

echo "Finished ics-producer-consumer-tests.sh"
