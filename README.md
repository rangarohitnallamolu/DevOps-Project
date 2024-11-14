DevOps Project - README

This project contains the scripts and configurations for building and deploying a Dockerized application to a Kubernetes cluster.

Technologies Used

Docker: Containerization platform
Ansible: Configuration management tool
Kubernetes: Container orchestration platform (assumed)

Project Structure

Deployment.yml: YAML file defining the Kubernetes deployment configuration.
Dockerfile: Docker build instructions for the application image.
Service.yml: YAML file defining the Kubernetes service configuration.
ansible.yml: Ansible playbook for deploying the application to Kubernetes.

Prerequisites

A running Jenkins server with necessary plugins installed (e.g., Docker, SSH)
An accessible Kubernetes cluster
Docker installed on the Jenkins server and the target machine
Ansible installed on the Jenkins server and configured to connect to the Kubernetes cluster

Usage

Edit the configuration files (Deployment.yml, Service.yml) according to your application's requirements.
Push the project code to your Git repository.
The Jenkins pipeline will be triggered automatically and perform the following steps:
Clone the project repository.
Use SSH to connect to the target machine (assumed to be the Kubernetes master).
Copy the project files (Deployment.yml, Dockerfile, Service.yml, ansible.yml) to the target machine.
Build the Docker image on the target machine using Docker.
Tag and push the image to a Docker registry (requires Docker Hub credentials in Jenkins).
Use Ansible to deploy the application to the Kubernetes cluster using the provided configuration files.
