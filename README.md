# cda.Deploy-to-Swarm
## Central deployment of cda-microservices
 
[![Build and Push Docker Images](https://github.com/Cdaprod/cda-deploy-to-swarm/actions/workflows/build-latest.yml/badge.svg)](https://github.com/Cdaprod/cda-deploy-to-swarm/actions/workflows/build-latest.yml)
[![Deploy Services](https://github.com/Cdaprod/cda-deploy-to-swarm/actions/workflows/deploy-latest.yml/badge.svg)](https://github.com/Cdaprod/cda-deploy-to-swarm/actions/workflows/deploy-latest.yml)

<!-- DIRECTORY_TREE_START -->
```
.
├── DIRECTORY_TREE.txt
├── README.md
├── docker-compose.yaml
├── minio
│   ├── Dockerfile
│   ├── docker-compose.minio.yaml
│   └── entrypoint.sh
├── nginx
│   ├── Dockerfile
│   ├── docker-compose.nginx.yaml
│   └── nginx.conf
└── weaviate
    ├── Dockerfile
    └── docker-compose.weaviate.yaml

3 directories, 11 files

```
<!-- DIRECTORY_TREE_END -->

## Required Docker Swarm Secrets

```bash
echo "<your-openai-api-key>" | docker secret create OPENAI_API_KEY -
echo "<your-minio-root-user>" | docker secret create MINIO_ROOT_USER -
echo "<your-minio-root-password>" | docker secret create MINIO_ROOT_PASSWORD -
echo "<your-langchain-tracing-v2-value>" | docker secret create LANGCHAIN_TRACING_V2 -
echo "<your-langchain-api-key>" | docker secret create LANGCHAIN_API_KEY -
echo "<your-langchain-project>" | docker secret create LANGCHAIN_PROJECT -
echo "<your-weaviate-environment>" | docker secret create WEAVIATE_ENVIRONMENT -
echo "<your-weaviate-api-key>" | docker secret create WEAVIATE_API_KEY -
``` 


## Example of extending additional services

In a Docker Swarm deployment, especially when using separate repositories for different components of your system, it's not necessary to maintain a physical directory for the MinIO system control app within the `cdaprod/cda.deploy-to-swarm.git` repository. Instead, you can directly reference the MinIO system control Docker image within your Docker Compose file used for the deployment. This approach simplifies the deployment process and keeps your repositories focused on their specific purposes.

### Including the MinIO System Control App in `docker-compose.yml`

In your Docker Compose file within the `cdaprod/cda.deploy-to-swarm.git` repository, you would include a service definition for the MinIO system control app that references the Docker image built and pushed from the `cdaprod/cda.minio-system-control.git` repository. Here's an example of how you might define this service:

```yaml
services:
  minio-system-control:
    image: cdaprod/cda-minio-system-control:latest
    ports:
      - "8000:8000"
    environment:
      MINIO_ACCESS_KEY: "minio-access-key"
      MINIO_SECRET_KEY: "minio-secret-key"
    # Add other configurations as necessary
```

This service definition assumes that you have already built and pushed the Docker image `cdaprod/cda-minio-system-control:latest` to a Docker registry accessible by your Docker Swarm cluster.

### Benefits of This Approach

- **Separation of Concerns**: Keeping your application code in its dedicated repository (`cdaprod/cda.minio-system-control.git`) and your deployment configurations in another (`cdaprod/cda.deploy-to-swarm.git`) helps maintain clarity and separation of concerns.
- **Modularity**: This method allows for more modular deployments. You can update, scale, or modify the MinIO system control application independently of other services defined in your Docker Compose file.
- **Simplicity in Updates**: When updates are made to the MinIO system control application, you only need to rebuild and push the Docker image. The deployment can automatically use the latest image without needing to adjust the repository containing your Docker Compose files, assuming you use tags appropriately.

Remember to update the Docker Compose file with the correct version of the Docker image if you're not using the `latest` tag, ensuring that your Swarm deployment always uses the intended version of each service.