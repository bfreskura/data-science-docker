# data-science-docker

Dockerized OS setup for Data Science purposes.

## How to use

1. Install docker
2. Install NVIDIA Drivers on the host machine 
3. [Install](https://github.com/NVIDIA/nvidia-docker) `nvidia-docker`.
4. Pull the `data-science-docker` image
5. Use `nvidia-docker` instead of the `docker` to run the container

### Running example
`nvidia-docker run --name ml_test -p 10000-11000:10000-11000 -v /path/host:/path/container -it barty777/data-science-docker`
