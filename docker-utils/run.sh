#!/bin/bash
# This script is used by docker to run the application inside a container.

/etc/init.d/ntp start
/etc/init.d/supervisor restart
