#!/bin/bash

set -e

pio-start

cd /ANOMALY
pio build --verbose
pio train
pio deploy