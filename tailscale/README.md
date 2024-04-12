Let’s focus on setting up a dedicated directory for Tailscale integration in your existing GitHub repository, storing its authentication key as a GitHub Actions secret, and ensuring this setup enhances the security and efficiency of your CI/CD pipeline.

Step 1: Create a Tailscale Directory

First, you’ll need to create a new directory within your repository to manage your Tailscale configuration. This will help isolate Tailscale-related configurations and Dockerfiles, making the repository easier to navigate and manage.

Directory Structure:

.
├── tailscale
│   ├── Dockerfile
│   └── docker-compose.tailscale.yaml

Step 2: Tailscale Dockerfile

Inside the tailscale directory, create a Dockerfile that sets up Tailscale. This file will be used to build a Docker image configured to run Tailscale as a service.

# Use an official Tailscale base image
FROM tailscale/tailscale:latest

# Set up the entry point script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

entrypoint.sh:

#!/bin/bash
# Start Tailscale and authenticate using the pre-auth key
tailscale up --authkey=${TS_AUTH_KEY}
# Keep the container running
exec "$@"

Step 3: Docker Compose for Tailscale

Create a docker-compose.tailscale.yaml within the tailscale directory. This file will define how Tailscale is deployed within your Docker Swarm environment.

version: '3.8'
services:
  tailscale:
    build:
      context: ./tailscale
    image: cdaprod/cda-tailscale:latest
    volumes:
      - /dev/net/tun:/dev/net/tun
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    security_opt:
      - apparmor:unconfined
    environment:
      - TS_AUTH_KEY=${{ secrets.TS_AUTH_KEY }}
    networks:
      - app_network

networks:
  app_network:
    driver: overlay

Step 4: Store Tailscale Auth Key as GitHub Secret

Navigate to your repository’s settings in GitHub, go to the “Secrets” section under “Actions”, and add a new secret:

	•	Name: TS_AUTH_KEY
	•	Value: The pre-authentication key from your Tailscale account.

Step 5: Integrate Tailscale Service into CI/CD Workflows

Modify your GitHub Actions workflow files to include building and pushing the Tailscale image, as well as deploying it. For example:

Build and Push Workflow:

    - name: Build and push Tailscale image
      uses: docker/build-push-action@v3
      with:
        context: ./tailscale
        file: ./tailscale/Dockerfile
        push: true
        tags: cdaprod/cda-tailscale:latest
        platforms: linux/amd64,linux/arm64

Deployment Workflow:

      - name: Deploy Tailscale Stack
        run: |
          docker stack deploy -c ./tailscale/docker-compose.tailscale.yaml tailscale_stack

Step 6: Testing and Validation

Once all changes are made, commit them to your repository and monitor the GitHub Actions workflow to ensure everything builds and deploys correctly. Test connectivity via Tailscale to confirm the service is running and configured properly.

By structuring your repository this way and integrating Tailscale into your CI/CD pipeline, you maintain an organized codebase, ensure secure connectivity across your services, and facilitate seamless deployment processes. This setup not only optimizes your current infrastructure but also prepares your system for future expansions and integrations.