# Jenkins CI/CD Portfolio Project

A simple Python Flask web app deployed via a Jenkins pipeline on AWS EC2 using Docker.

---

## Project Structure

```
cicd/
├── app.py               # Flask web application
├── requirements.txt     # Python dependencies
├── Dockerfile           # Docker image definition
├── docker-compose.yml   # Docker Compose config
├── Jenkinsfile          # Jenkins pipeline definition
└── README.md
```

---

## Prerequisites (on your AWS EC2 instance)

- Ubuntu 22.04 (recommended)
- Java 17+ (for Jenkins)
- Jenkins
- Docker
- Docker Compose
- Git

---

## EC2 Setup Guide

### 1. Install Java & Jenkins

```bash
sudo apt update
sudo apt install -y fontconfig openjdk-17-jre

# Add Jenkins repo and install
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

### 2. Install Docker

```bash
sudo apt install -y docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker

# Allow Jenkins to run Docker commands
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### 3. Open EC2 Security Group Ports

In your AWS console, open inbound rules for:
- Port **8080** — Jenkins UI
- Port **5000** — Flask app

---

## Jenkins Pipeline Setup

1. Open Jenkins at `http://<your-ec2-ip>:8080`
2. Install suggested plugins during setup
3. Create a new **Pipeline** job
4. Under **Pipeline > Definition**, select **Pipeline script from SCM**
5. Set SCM to **Git** and paste your repo URL
6. Set the script path to `Jenkinsfile`
7. Save and click **Build Now**

---

## Pipeline Stages

| Stage | Description |
|-------|-------------|
| Checkout | Pulls latest code from Git |
| Build Docker Image | Builds the Flask app Docker image |
| Run Tests | Smoke tests the container on port 5001 |
| Deploy | Runs the app via docker-compose on port 5000 |

---

## Access the App

Once the pipeline runs successfully:

```
http://<your-ec2-ip>:5000
```

You should see: **👋 Hi from Jenkins CI/CD!**
