DevOps Project - README
This project outlines the steps and configurations needed to set up a CI/CD pipeline using Jenkins, Ansible, and Kubernetes. The pipeline automates the deployment of a Dockerized portfolio application hosted on GitHub, triggered by a webhook for continuous integration (CI) and continuous deployment (CD).

Technologies Used
Jenkins: For continuous integration and automation
Ansible: For configuration management and orchestration of deployments
Docker: For containerizing the application
Kubernetes: For container orchestration, managing container deployment, scaling, and load balancing
Project Structure
Deployment.yml: Defines the Kubernetes deployment configuration
Service.yml: Specifies the Kubernetes service for exposing the application
Dockerfile: Contains instructions for building the Docker image of the application
ansible.yml: Ansible playbook to deploy the application on the Kubernetes cluster
Prerequisites
Infrastructure Setup:

Three EC2 instances:
Jenkins: t2.micro
Ansible: t2.micro
Kubernetes (Master Node): t2.medium
Software Requirements:

Jenkins installed on the Jenkins server with plugins for Docker and SSH.
Docker installed on Jenkins, Ansible, and Kubernetes instances.
Ansible installed on the Jenkins instance, configured to connect to the Kubernetes instance.
Webhook configured on the GitHub repository to trigger Jenkins builds on code changes.
Credentials:

Docker Hub credentials in Jenkins for pushing the Docker image.
SSH keys for secure access between Jenkins, Ansible, and Kubernetes instances.
Setup Process
Step 1: Deploy Jenkins and Configure Webhook
Launch EC2 for Jenkins:
Set up a t2.micro instance, install Jenkins, and configure necessary plugins (Docker, SSH).
GitHub Webhook:
Set up a webhook in your GitHub repository to notify Jenkins on code changes, triggering the CI/CD pipeline.
Step 2: Configure Ansible for Deployment
Launch EC2 for Ansible:
Set up a t2.micro instance, install Ansible, and configure it to connect to the Kubernetes instance.
Set Up Playbook (ansible.yml):
Create and configure the Ansible playbook (ansible.yml) to automate the deployment on Kubernetes.
Step 3: Set Up Kubernetes Cluster
Launch EC2 for Kubernetes (Master Node):
Use a t2.medium instance to set up Kubernetes.
Deploy the Deployment.yml and Service.yml files to manage the application.
Step 4: CI/CD Pipeline in Jenkins
Create a Jenkins Pipeline with the following stages:

Stage 1: Git Checkout

Jenkins clones the repository from GitHub on each triggered build.
Stage 2: Transfer Docker File to Ansible Server

Use SSH to copy necessary files (e.g., Dockerfile) to the Ansible server.
Stage 3: Build Docker Image

Build the Docker image on the Ansible server using Docker.
Stage 4: Docker Image Tagging and Push

Tag the Docker image and push it to Docker Hub.
Stage 5: Deploy Using Ansible to Kubernetes

Ansible executes the deployment on the Kubernetes cluster.

Pipeline Script for Jenkins:

node {
    stage('Git Checkout') {
        git 'https://github.com/rangarohitnallamolu/DevOps-Project.git'
    }
    stage('Transfer Docker File to Ansible') {
        sshagent(['ansible']) {
            sh 'scp /var/lib/jenkins/workspace/pip/* ubuntu@<Ansible-Server-IP>:/home/ubuntu'
        }
    }
    stage('Docker Build Image') {
        sshagent(['ansible']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@<Ansible-Server-IP> docker image build -t $JOB_NAME:v1.$BUILD_ID .'
        }
    }
    stage('Docker Image Tagging') {
        sshagent(['ansible']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@<Ansible-Server-IP> docker image tag $JOB_NAME:v1.$BUILD_ID rangarohit/$JOB_NAME:v1.$BUILD_ID'
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@<Ansible-Server-IP> docker image tag $JOB_NAME:v1.$BUILD_ID rangarohit/$JOB_NAME:latest'
        }
    }
    stage('Push Docker Image to Docker Hub') {
        sshagent(['ansible']) {
            withCredentials([string(credentialsId: 'dockerhub_password', variable: 'dockerhub_password')]) {
                sh "ssh -o StrictHostKeyChecking=no ubuntu@<Ansible-Server-IP> docker login -u rangarohit -p ${dockerhub_password}"
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@<Ansible-Server-IP> docker image push rangarohit/$JOB_NAME:v1.$BUILD_ID'
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@<Ansible-Server-IP> docker image push rangarohit/$JOB_NAME:latest'
            }
        }
    }
    stage('Deploy Application using Ansible') {
        sshagent(['ansible']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@<Kubernetes-Server-IP> ansible-playbook /path/to/ansible.yml'
        }
    }
}
