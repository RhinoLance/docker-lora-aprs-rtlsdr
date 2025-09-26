FROM debian:trixie-slim

ENV LORA_APRS=/lora-aprs

COPY scripts/envSetup.sh /

# All setup takes place in the envSetup.sh script in order to only add a single 
# layer to the image, whilst maintaining readability.
RUN chmod +x ./envSetup.sh && \
	. ./envSetup.sh varsAreSet