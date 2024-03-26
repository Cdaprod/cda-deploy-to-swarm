#!/bin/sh

set -e

# Start MinIO in the background
minio server /data --console-address ":9001" &

# Wait for MinIO to start
sleep 5

# Set up alias for MinIO
mc alias set myminio http://minio:9000 "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}"

# Function to create a bucket if it doesn't exist
create_bucket_if_not_exists() {
  bucket_name=$1
  if ! mc ls myminio/"${bucket_name}" &> /dev/null; then
    echo "Creating bucket: ${bucket_name}"
    mc mb myminio/"${bucket_name}"
  else
    echo "Bucket ${bucket_name} already exists."
  fi
}

# Space-separated list of buckets to check and create if they don't exist
buckets="weaviate-backups cda-datasets raw-objects clean-objects prompt-bucket feature-store-bucket"

# Iterate over the list and create each bucket if it doesn't exist
for bucket in $buckets; do
  create_bucket_if_not_exists "$bucket"
done

# Keep the script running to prevent the container from exiting
tail -f /dev/null