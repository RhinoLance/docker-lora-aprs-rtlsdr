#!/bin/bash

/lora-aprs/lora.sh && tail -f /tmp/lora-aprs.log /tmp/lorarx.log /tmp/udpgate4.log /tmp/sdrtst.log /tmp/rtl_tcp.log 