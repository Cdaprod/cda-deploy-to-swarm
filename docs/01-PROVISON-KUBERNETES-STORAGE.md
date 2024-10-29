To provision your Raspberry Pi Docker Swarm with extra NVMe storage for compatibility with Kubernetes development, you'll need to follow a few steps. This includes setting up your storage with Docker, configuring your Raspberry Pi nodes, and preparing for Kubernetes deployment. Here's a detailed guide:

### 1. Set Up NVMe Storage on Raspberry Pi

#### A. Prepare the NVMe Storage

1. **Connect the NVMe SSD to your Raspberry Pi**:
   - Ensure the NVMe SSD is properly connected and recognized by the Raspberry Pi.

2. **Format the NVMe SSD**:
   ```sh
   sudo mkfs.ext4 /dev/nvme0n1
   ```

3. **Mount the NVMe SSD**:
   ```sh
   sudo mkdir -p /mnt/nvme
   sudo mount /dev/nvme0n1 /mnt/nvme
   ```

4. **Update `/etc/fstab` for Persistent Mounting**:
   ```sh
   echo '/dev/nvme0n1 /mnt/nvme ext4 defaults 0 0' | sudo tee -a /etc/fstab
   ```

### 2. Configure Docker Swarm with NVMe Storage

#### A. Label Nodes with Storage Capabilities

1. **Label the Nodes**:
   ```sh
   docker node update --label-add storage=nvme <node-id>
   ```

2. **Update Docker Compose File to Use the NVMe Storage**

```yaml
version: '3.8'

x-defaults: &defaults
  restart: unless-stopped
  env_file: .env

x-labels: &labels
  com.example.project: "MyApp"
  com.example.version: "1.0.0"
  com.example.description: "A description of MyApp"
  com.example.maintainer: "me@example.com"

x-driver-opts-nvme: &driver_opts_nvme
  type: none
  device: /mnt/nvme/data
  o: bind

services:
  web:
    <<: *defaults
    image: cdaprod/cda-minio-control:latest
    labels:
      <<: *labels
    environment:
      OPENAI_API_KEY: ${OPENAI_API_KEY}
      MINIO_ENDPOINT: minio1:9000
      MINIO_ROOT_USER: ${MINIO_ROOT_USER}
      MINIO_ROOT_PASSWORD: ${MINIO_ROOT_PASSWORD}
    ports:
      - "8000:8000"
    networks:
      - app_network
    depends_on:
      - weaviate
      - minio1
    deploy:
      replicas: 3
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure
      resources:
        limits:
          cpus: "1.0"
          memory: "512M"

  minio1:
    <<: *defaults
    image: minio/minio:latest
    labels:
      <<: *labels
    environment:
      MINIO_ROOT_USER: ${MINIO_ROOT_USER}
      MINIO_ROOT_PASSWORD: ${MINIO_ROOT_PASSWORD}
    command: server http://minio{1...4}/data
    volumes:
      - minio_data1:/data
    ports:
      - "9000:9000"
      - "9001:9001"
    networks:
      - app_network
      - minio_net
    deploy:
      placement:
        constraints:
          - node.labels.storage == nvme

volumes:
  minio_data1:
    driver: local
    driver_opts:
      <<: *driver_opts_nvme

networks:
  app_network:
    driver: overlay
  minio_net:
    driver: overlay
```

### 3. Transition to Kubernetes

#### A. Install Kubernetes on Raspberry Pi

1. **Set Up Kubernetes**:
   - Follow the [Kubernetes documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) to install Kubernetes using `kubeadm` on your Raspberry Pi.

2. **Initialize the Kubernetes Cluster**:
   ```sh
   sudo kubeadm init --pod-network-cidr=10.244.0.0/16
   ```

3. **Set Up `kubectl` for Your User**:
   ```sh
   mkdir -p $HOME/.kube
   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
   sudo chown $(id -u):$(id -g) $HOME/.kube/config
   ```

4. **Deploy a Pod Network**:
   ```sh
   kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
   ```

#### B. Configure Storage for Kubernetes

1. **Create a StorageClass for NVMe Storage**:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nvme-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

2. **Create a PersistentVolume**:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nvme-pv
spec:
  capacity:
    storage: 100Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: nvme-storage
  local:
    path: /mnt/nvme
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: storage
              operator: In
              values:
                - nvme
```

3. **Create a PersistentVolumeClaim**:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nvme-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Gi
  storageClassName: nvme-storage
```

#### C. Deploy Applications in Kubernetes

1. **Use the PersistentVolumeClaim in a Pod**:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
spec:
  containers:
    - name: myapp-container
      image: cdaprod/cda-minio-control:latest
      volumeMounts:
        - mountPath: "/data"
          name: nvme-storage
  volumes:
    - name: nvme-storage
      persistentVolumeClaim:
        claimName: nvme-pvc
```

### Summary

1. **Set Up NVMe Storage on Raspberry Pi**:
   - Format, mount, and configure NVMe SSD.

2. **Configure Docker Swarm**:
   - Label nodes, update Docker Compose to use NVMe storage.

3. **Transition to Kubernetes**:
   - Install Kubernetes, configure StorageClass, PersistentVolume, and PersistentVolumeClaim.

By following these steps, you can effectively provision your Raspberry Pi Docker Swarm with NVMe storage and transition to a Kubernetes environment for development and staging. This setup ensures your storage is configured properly for application development and deployment.