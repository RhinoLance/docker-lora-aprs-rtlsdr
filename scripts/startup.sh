#!/bin/bash

# Seed the log files
> /tmp/lora-aprs.log
> /tmp/lorarx.log 
> /tmp/udpgate4.log 
> /tmp/sdrtst.log 
> /tmp/rtl_tcp.log

# Start lora-aprs
/lora-aprs/lora.sh > /tmp/lora-aprs.log

# Keep the container running and display the logs
tail -f /tmp/lora-aprs.log /tmp/lorarx.log /tmp/udpgate4.log /tmp/sdrtst.log /tmp/rtl_tcp.log 
