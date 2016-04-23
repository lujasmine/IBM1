#!/bin/bash

##########################
# Rename this to local.sh
##########################

##################################
# Settings common to all variants
##################################
PIO_HOME='/PredictionIO-0.9.6/'
LOG_DIR='/ANOMALY/logs'

# Email for the log file/error message
FROM_EMAIL='darian.sastre@gmail.com'
TARGET_EMAIL='d.sastrestanescu@cs.ucl.ac.uk'

# Change the default binding IP if neeeded
IP=0.0.0.0

EVENT_SERVER_PORT=7070

# Sanity check below

check_non_empty() {
  # $1 is the content of the variable in quotes e.g. "$FROM_EMAIL"
  # $2 is the error message
  if [[ $1 == "" ]]; then
    echo "ERROR: specify $2"
    exit -1
  fi
}

check_non_empty "$PIO_HOME"     "PIO_HOME in local.sh"
check_non_empty "$LOG_DIR"      "LOG_DIR in local.sh"
check_non_empty "$FROM_EMAIL"   "FROM_EMAIL in local.sh"
check_non_empty "$TARGET_EMAIL" "TARGET_EMAIL in local.sh"