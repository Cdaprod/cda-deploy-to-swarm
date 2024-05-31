# Use the official Mosquitto image as a parent image
FROM eclipse-mosquitto:latest

# Set the working directory in the container to /mqtt
WORKDIR /mqtt

# Copy the entrypoint script into the /mqtt directory
COPY entrypoint.sh /mqtt/entrypoint.sh

# Ensure the script is executable
RUN chmod +x /mqtt/entrypoint.sh

# Mosquitto configuration can be placed in this directory or explicitly copied
# COPY mosquitto.conf /mqtt/mosquitto.conf

# Use the custom entrypoint script
ENTRYPOINT ["/mqtt/entrypoint.sh"]

# Default command uses the Mosquitto configuration from /mqtt directory
CMD ["/usr/sbin/mosquitto", "-c", "/mqtt/mosquitto.conf"]