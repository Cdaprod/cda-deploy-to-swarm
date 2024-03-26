# cdaprod/cda.deploy-to-swarm
## .github/workflows/.
### Build and Push Docker Images Workflow (build-latest.yml)

This workflow is triggered on pushes or pull requests to the main branch that modify files in the minio, weaviate, or nginx directories. It can also be manually initiated. The workflow’s primary function is to build and push Docker images for specified services to Docker Hub.

#### Triggers:
- Pushes or pull requests affecting minio/**, weaviate/**, nginx/**.
- Manual (workflow_dispatch).
#### Jobs:
- build-and-push: Executes the following steps for each service:
- Checkout code: Fetches the latest version of the code from the repository.
- Set up Docker Buildx: Prepares the environment for building multi-platform Docker images.
- Login to Docker Hub: Authenticates to Docker Hub using credentials stored in GitHub secrets.
- Build and push images: Constructs the Docker image for each service (MinIO, Weaviate, NGINX) and uploads them to Docker Hub, tagging them as latest and targeting linux/amd64 and linux/arm64 platforms.

### Deploy Services Workflow (deploy-latest.yml)

This workflow is set to run upon the successful completion of the "Build and Push Docker Images" workflow on the main branch, facilitating the deployment of services to Docker Swarm. It can also be initiated manually.

#### Triggers:
- Completion of the "Build and Push Docker Images" workflow (workflow_run).
- Manual (workflow_dispatch).
#### Jobs:
- deploy: Executes the deployment process, encompassing the following actions:
- Checkout Repository: Obtains the most current codebase from the repository.
- Log in to Docker Hub: Authenticates to Docker Hub to ensure access to Docker images.
- Deploy Stacks: Utilizes docker stack deploy with specific docker-compose files for deploying each service stack (MinIO, Weaviate, NGINX) to Docker Swarm. For MinIO, it sets environment variables like MINIO_ROOT_USER and MINIO_ROOT_PASSWORD from GitHub secrets for secure deployment.

### Best Practices and Considerations

- Ensure version specificity in Docker tags beyond latest for predictable deployments.
- Keep sensitive data like passwords and API keys secure using GitHub secrets.
- Consider deployment strategies and rollback plans for maintaining service availability.
- Documentation within README.md should include clear descriptions of each workflow and step, ensuring maintainability and clarity for team members.