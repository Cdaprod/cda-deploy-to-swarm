## Dockerfile

To deploy docker jupyter lab container run the following commands on docker swarm leader (rpi-swarm runner), which is connected to Google Coral TPU

`docker build -t cda-jupyter .`

`docker run -it --privileged -v /dev/bus/usb/001/002:/dev/bus/usb -p 8888:8888 cda-jupyter`

## Docker Compose

- USB Access Volume: The first volume binding ../usb/001/002:/dev/bus/usb/001/002 assumes you have a specific USB device directory structure (../usb/001/002) on the host system that you want to map directly to the container. This path might need adjustment based on your host’s actual USB device path. It’s crucial for giving the Docker container access to the Coral TPU.
- Persistent Data Volume for Notebooks: The jupyter_data volume is defined to persist your Jupyter notebooks and any other important data. It is mapped to /home/jovyan/work inside the container, which is the default working directory for Jupyter notebooks in the Docker image. The driver_opts section under the volumes definition sets up a bind mount from a local directory (${PWD}/jupyter_data) to the volume, ensuring data persistence across container restarts or rebuilds.

### Running the Docker Compose File

To deploy your service with these volumes, navigate to the directory containing your docker-compose.jupyter.yaml and run:

`docker-compose -f docker-compose.jupyter.yaml up --build`

This command builds the image if not present and starts the JupyterLab service, making it accessible at http://localhost:8888. Notebooks and other data saved in /home/jovyan/work inside the container will persist in the jupyter_data volume on your host machine.

Important Note

Remember, Docker and Docker Compose paths and volume bindings must accurately reflect your system’s directory structure and device file paths. The given example paths may need to be adjusted to match your environment.