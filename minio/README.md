# My Default Buckets

weaviate-backups
cda-datasets
raw-objects
clean-objects
my-prompt-bucket
feature-store-bucket

## How to Programatically create default bucket data

Building and populating data in MinIO buckets programmatically can be achieved using various methods, depending on your specific needs and the nature of the data you're dealing with. You can use the MinIO Client (`mc`), MinIO's SDKs for different programming languages, or direct REST API calls. Below, I'll outline methods using the MinIO Client and Python SDK, as these are among the most common and versatile approaches.

### Using MinIO Client (`mc`)

The MinIO Client (`mc`) can be used for a wide range of bucket and object management tasks, including file uploads, setting policies, and mirroring data. To programmatically upload data to your buckets, you could write shell scripts that use `mc cp` or `mc mirror` for uploading files.

#### Uploading a Single File

```sh
mc cp /path/to/your/file.txt myminio/your-bucket-name
```

#### Uploading Multiple Files or Directories

```sh
mc cp --recursive /path/to/your/directory myminio/your-bucket-name
```

#### Example Script for Uploading Data

```sh
#!/bin/sh

# Define your bucket names and data sources
declare -A buckets_and_data=(
  ["weaviate-backups"]="/path/to/backup/data"
  ["cda-datasets"]="/path/to/datasets"
  # Add more as needed
)

# Loop through the associative array
for bucket in "${!buckets_and_data[@]}"; do
  data_source="${buckets_and_data[$bucket]}"
  echo "Uploading data from $data_source to $bucket..."
  mc cp --recursive "$data_source" myminio/"$bucket"
done
```

### Using Python and MinIO Python SDK

The MinIO Python SDK is a powerful tool for interacting with MinIO in a programmatic way, allowing for more complex operations and integration into your Python applications.

First, ensure you have the MinIO Python SDK installed:

```sh
pip install minio
```

Then, you can write a Python script to upload files:

#### Python Script Example

```python
from minio import Minio
from minio.error import S3Error
import os

def upload_directory_to_bucket(minio_client, bucket_name, directory_path):
    for root, _, files in os.walk(directory_path):
        for file in files:
            file_path = os.path.join(root, file)
            # Define the object name in the bucket; here, it keeps the directory structure
            object_name = os.path.relpath(file_path, start=directory_path)
            try:
                minio_client.fput_object(bucket_name, object_name, file_path)
                print(f"Uploaded {file_path} as {object_name} in bucket {bucket_name}")
            except S3Error as exc:
                print(f"Failed to upload {file_path} to {bucket_name}: {exc}")

if __name__ == "__main__":
    # Create a MinIO client
    minio_client = Minio(
        "minio:9000",
        access_key="your-access-key",
        secret_key="your-secret-key",
        secure=False  # Set to True for https
    )

    # Define your buckets and corresponding data directories
    buckets_and_data = {
        "weaviate-backups": "/path/to/backup/data",
        "cda-datasets": "/path/to/datasets",
        # Add more as needed
    }

    # Upload data for each bucket
    for bucket, data_dir in buckets_and_data.items():
        upload_directory_to_bucket(minio_client, bucket, data_dir)
```

This Python script demonstrates how to upload an entire directory's worth of files to specific MinIO buckets, maintaining the directory structure within the bucket. It iterates over a dictionary of bucket names and their corresponding local directories, uploading each file found within those directories to the correct bucket.

By using these approaches, you can programmatically build and populate your MinIO buckets with the necessary data, either through shell scripts utilizing the `mc` tool or via Python scripts using MinIO's Python SDK.