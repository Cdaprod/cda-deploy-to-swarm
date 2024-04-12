#!/bin/bash

# Start Tailscale and authenticate using the pre-auth key
tailscale up --authkey=${TS_AUTH_KEY}

# Keep the container running
exec "$@"