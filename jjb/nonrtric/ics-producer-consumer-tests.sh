#!/bin/bash

set -eux -o pipefail

echo "Starting ics-producer-consumer-tests.sh"
echo "Executing sample-services/ics-producer-consumer/start.sh"
cd sample-services/ics-producer-consumer
bash start.sh
echo "Finished Test 1"
echo "Executing sample-services/ics-simple-producer-consumer/tests/start_ics_producer_consumer_test.sh"
cd ../../sample-services/ics-simple-producer-consumer/tests/
bash start_ics_producer_consumer_test.sh
echo "Finished Test 1"
echo "Finished ics-producer-consumer-tests.sh"
