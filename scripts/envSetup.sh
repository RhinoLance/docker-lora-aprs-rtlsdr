# if an varsAreSet arg is not passed, then set the vars
if [ -z "$varsAreSet" ]
then
        ###################################
        # Set environment variables
        ###################################
        export LORA_APRS=/lora-aprs
fi

###################################
# Install prerequisites
###################################
apt update
apt install rtl-sdr wget -y

# clean up apt cache to reduce image size
apt autoremove && apt clean
rm -rf /var/lib/apt/lists/*

###################################
# dxlAPRS installation
###################################

# Create directories
cd /
mkdir lora-aprs
cd lora-aprs
mkdir bin
mkdir pidfiles
mkdir fifos

# Download binaries
cd $LORA_APRS/bin
wget http://oe5dxl.hamspirit.at:8025/aprs/bin/armv7hf/lorarx
wget http://oe5dxl.hamspirit.at:8025/aprs/bin/armv7hf/udpgate4
wget http://oe5dxl.hamspirit.at:8025/aprs/bin/armv7hf/sdrtst

# Make binaries executable
chmod +x lorarx
chmod +x udpgate4
chmod +x sdrtst

# Download the main script and config files
cd $LORA_APRS
wget http://www.do2jmg.de/download/lora.sh
#wget http://www.do2jmg.de/download/qrg.txt
#wget http://www.do2jmg.de/download/lora-options.conf
#wget http://www.do2jmg.de/download/beacon.txt

chmod +x $LORA_APRS/lora.sh
chmod +x /startup.sh

# Seed the log files
touch /tmp/lora-aprs.log /tmp/lorarx.log /tmp/udpgate4.log /tmp/sdrtst.log /tmp/rtl_tcp.log
