# Overview

This repo defines a docker container which will create a RX-only APRS LoRa iGate, with an RTL-SDR radio.

It is containerises the work done by Jean-Michael Grobel (DO2JMG) in his [blog article](https://do2jmg.de/lora-aprs-internetgateway-mit-rtl-sdr/)

## 1. Installation
Note that these instructions assume you are starting from a 'fresh' Raspbian or Debian-like system installation. If you're using a Raspberry Pi there are plenty of good guides online on how to get setup, such as [this one from the Raspberry Pi Foundation](https://www.raspberrypi.com/documentation/computers/getting-started.html).
### 1.1. Docker
It is highly recommended that you use the latest version of Docker, rather than the one available from your systems default package repositories. If your system has docker installed already (Can you run a `docker ps` command and get some kind of response?) then you might want to uninstall these packages. On Debian-based system (Debian/Ubuntu/Raspbian), you can do this by running:
```
sudo apt-get remove docker-engine docker docker.io docker-ce docker-ce-cli docker-compose-plugin
```
A quick way to install the latest version of Docker is by using the [convenience script](https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script):
```sh
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```
To be able to run `docker` commands as your non-root user (recommended!!), run:
```sh 
sudo usermod -aG docker $(whoami)
```
You will need to logout and log back in afterwards to pick up the changes to group membership.
### 1.2. RTL-SDR Kernel Blacklisting
The RTL DVB kernel modules must first be blacklisted on the Docker **host**. RTL-SDR itself is not required on the Docker host. This can be accomplished using the following commands:
```sh
echo 'blacklist dvb_usb_rtl28xxu' | sudo tee /etc/modprobe.d/blacklist-dvb_usb_rtl28xxu.conf
sudo modprobe -r dvb_usb_rtl28xxu
```
If the `modprobe -r` command errors, a reboot may be required to unload the module.
### 1.3. Configuring lora-aprs

Start by downloading the three configuration templates:
```
wget http://www.do2jmg.de/download/qrg.txt
wget http://www.do2jmg.de/download/lora-options.conf
wget http://www.do2jmg.de/download/beacon.txt
```
`qrg.txt` The parameters for the "sdrtst" command, including the listening frequency.

`lora-options` The APRS settings, including your callsign and password.  You can also set your RTL-SDR dongle if 
you have more than one.

`beacon.txt` The text to be beaconed by the iGate.

### 1.4. Running the container
**Make sure you have downloaded and edited the configuration files as per the above steps before running this command!**

```sh
docker run \
	-d \
  	--name lora-aprs-rtlsdr \
  	--restart="always" \
	--device=/dev/bus/usb \
	--network=host \
	-v ~/lora-aprs/qrg.txt:/lora-aprs/qrg.txt:ro \
	-v ~/lora-aprs/lora-options.conf:/lora-aprs/lora-options.conf:ro \
	-v ~/lora-aprs/beacon.txt:/lora-aprs/beacon.txt:ro \
	rhinolance/aprs-lora-rtlsdr:latest
```
Note that the above is one single command spread across multiple lines. Copy and paste it into your terminal. 
**Once this is run, the Docker image will automatically start on system boot.**

Substitute `~/lora-aprs/qrg.txt`, `~/lora-aprs/lora-options.conf` and `~/lora-aprs/beacon.txt` in the above command with the relevant local paths on your Docker host if not storing these in your home directory as per the above examples.

`--restart="always"` will result in the container automatically restarting after a failure or host system reboot, so you don't need to run this command again unless updating the docker image (see below).

**You can check the status of the container by checking the log output:**
```sh
docker logs --tail 50 --follow lora-aprs-rtlsdr
```

## 2. Other useful commands
These commands may be useful when performing maintenance on your system.

### 2.1. Updating the container
```sh
# get the latest version of the image
docker pull rhinolance/aprs-lora-rtlsdr:latest

# stop the container
docker stop lora-aprs-rtlsdr

# remove the container with the old image
docker rm lora-aprs-rtlsdr
```

Now follow the instructions above for running the container, which will 
generate a new container from the latest image

### 2.2. Restarting the container
Restarting the container is useful for picking up changes to configuration files.
```sh
docker restart lora-aprs-rtlsdr
```
### 2.3. Stopping the container
```sh
docker stop lora-aprs-rtlsdr
```
### 2.4. Removing the container
```sh
docker rm lora-aprs-rtlsdr
```
### 2.5. Viewing the containers logs
#### All logs
```sh
docker logs lora-aprs-rtlsdr
```
#### Last 50 lines
```sh
docker logs --tail 50 lora-aprs-rtlsdr
```
#### Following the logs in real-time
```sh
docker logs --tail 50 --follow lora-aprs-rtlsdr
```
### 2.6. Opening a shell within an existing running container
```sh
docker exec -it lora-aprs-rtlsdr /bin/bash
```

## 3. Debugging

The following will assist with debugging the container:

### 3.1. Temp container with shell
Start a new container with a shell, which wil be deleted when 
you exit the shell.  No processes will be started on the container.
```sh
docker run \
	--device=/dev/bus/usb \
	--network=host \
	-v /home/pi/lora-aprs/qrg.txt:/lora-aprs/qrg.txt:ro \
	-v /home/pi/lora-aprs/lora-options.conf:/lora-aprs/lora-options.conf:ro \
	-v /home/pi/lora-aprs/beacon.txt:/lora-aprs/beacon.txt:ro \
	--rm \
	-it \
	--entrypoint /bin/bash \
	rhinolance/aprs-lora-rtlsdr:latest 
```

### 3.2. Generate the container yourself
If you believe there are errors in the container setup, you can generate the raw
container yourself with the following command:
```sh
docker run \
	--device=/dev/bus/usb \
	--network=host \
	-v /home/pi/lora-aprs/qrg.txt:/lora-aprs/qrg.txt:ro \
	-v /home/pi/lora-aprs/lora-options.conf:/lora-aprs/lora-options.conf:ro \
	-v /home/pi/lora-aprs/beacon.txt:/lora-aprs/beacon.txt:ro \
	--rm \
	-it \
	--entrypoint /bin/bash \
	rhinolance/aprs-lora-rtlsdr:latest 
```

Then from within the container, execute the commands within envSetup.sh