# HOW TO RUN

This challenge is containerized using Docker.

## Prerequisites

- Docker must be installed and running
  - [Install Docker](https://www.docker.com/products/docker-desktop/)

## Build the Docker Image

Open a bash terminal inside the project directory:

docker build -t session_fixation .

## Run the container

docker run -p 5000:5000 session_fixation

## Access the challenge

http://localhost:5000
