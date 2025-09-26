#!/bin/bash

/lora-aprs/lora.sh > /tmp/lora-aprs.log && tail -f /tmp/lora-aprs.log /tmp/lorarx.log /tmp/udpgate4.log /tmp/sdrtst.log /tmp/rtl_tcp.log 
