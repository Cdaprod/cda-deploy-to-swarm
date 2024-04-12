# Use an official Tailscale base image
FROM tailscale/tailscale:latest

# Set up the entry point script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]