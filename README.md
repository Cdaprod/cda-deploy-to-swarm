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