=======================================================

## Day-4: CI/CD Pipeline with Jenkins + Docker

=======================================================

### Overview

In Day-1, Jenkins and Java were Installed on the AWS EC2 Ubuntu
instance. This day focuses on installing Docker, connecting Jenkins to
Docker Hub, building and deploying the Two-Tier Flask Application, and
automating the pipeline with a GitHub webhook.

**Application repository:**

```text
https://github.com/ankittripathidevs/two-tier-flask-app.git
```

**Pipeline flow:**

```text
GitHub → Jenkins → Docker Build → Test → Docker Hub → Deploy on EC2
```

---

========================================================================

# Task-1 --- Install Docker and Docker Compose

========================================================================

## Step 1 --- Install Docker

```bash
sudo apt update
sudo apt install docker.io -y
```

Check Docker version:

```bash
docker --version
```

Start, enable, and check Docker:

```bash
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
```

Allow the current user to use Docker:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

> Group membership changes apply to new sessions. If access does not
> work, log out and back in, or reconnect through SSH.

Test Docker:

```bash
docker run hello-world
docker ps
```

---

## Step 2 --- Install Docker Compose V2

```bash
sudo apt install docker-compose-v2 -y
docker compose version
```

```bash
# Start services in the background
docker compose up -d

# Stop and remove the application's containers and network
docker compose down
```

---

## Step 3 --- Give Jenkins Permission to Use Docker

Jenkins needs Docker access to build images and run containers.

Add Jenkins to the Docker group:

```bash
sudo usermod -aG docker jenkins
```

Restart Jenkins:

```bash
sudo systemctl restart jenkins
```

Test Docker access as Jenkins:

```bash
sudo -u jenkins docker ps
```

Test Docker Compose access as Jenkins:

```bash
sudo -u jenkins docker compose version
```

---

========================================================================

# Task-2 --- Create the Jenkins CI/CD Pipeline

========================================================================

## Step 1 --- Create a New Jenkins Item

```text
Jenkins Dashboard
    ↓
New Item
    ↓
Name: Two-Tier-Flask-App
    ↓
Select: Pipeline
    ↓
OK
```

## Step 2 --- Configure the GitHub Project

Inside the Jenkins job, open **General** and enable **GitHub project**.

Project URL:

```text
https://github.com/ankittripathidevs/two-tier-flask-app
```

## Step 3 --- Configure the Pipeline Script

Go to:

```text
Pipeline
    ↓
Definition: Pipeline script
    ↓
Pipeline script
```

Use this Declarative Pipeline as a starting point. It assumes the
repository contains a valid `Dockerfile` and a Compose file in the
repository root.

```groovy
pipeline {
    agent any

    stages {
        // 1. Clone source code
        stage('Code Clone') {
            steps {
                echo 'Cloning code from GitHub'
                git branch: 'main',
                    url: 'https://github.com/ankittripathidevs/two-tier-flask-app.git'
            }
        }

        // 2. Build Docker image
        stage('Build') {
            steps {
                echo 'Building Docker image'
                sh 'docker build -t flask-app:latest .'
            }
        }

        // 3. Test
        stage('Test') {
            steps {
                echo 'Testing the application'
                // Add actual automated tests here.
                // This stage currently does not run application tests.
            }
        }

        // 4. Log in and push the image to Docker Hub
        stage('Push to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'DockerHub_Credentials',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_PASS'
                    )
                ]) {
                    sh '''

                        echo "Logging into DockerHub"
                        echo "$DOCKERHUB_PASS" | docker login \
                            --username "$DOCKERHUB_USER" \
                            --password-stdin


                        echo "Tagging Docker Image"
                        docker tag flask-app:latest \
                            "$DOCKERHUB_USER/two-tier-flask-app:latest"


                        echo "Pushing Docker Image"
                        docker push \
                            "$DOCKERHUB_USER/two-tier-flask-app:latest"

                    '''
                }
            }
        }

        // 5. Deploy with Docker Compose
        stage('Deploy') {
            steps {
                echo 'Deploying the application'
                sh 'docker compose up -d --build'
            }
        }
    }

    // Optional email notifications; requires Jenkins email configuration
    post {
        success {
            echo 'Deployment pipeline completed successfully'
            mail(
                to: 'ankittripathi2k24@gmail.com',
                subject: "SUCCESS: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
                body: "Build successful.\n\nBuild URL: ${env.BUILD_URL}"
            )
        }

        failure {
            echo 'Pipeline failed'
            mail(
                to: 'ankittripathi2k24@gmail.com',
                subject: "FAILURE: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
                body: "Build failed. Check the console output.\n\nBuild URL: ${env.BUILD_URL}"
            )
        }
    }
}
```

## Step 4 --- Save and Run the Pipeline

```text
Jenkins
    ↓
Two-Tier-Flask-App
    ↓
Build Now
    ↓
Build #
    ↓
Console Output
```

Check each stage in the console output.

### If Jenkins Reports a Docker Permission Error

Run on the EC2 instance:

```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

Verify:

```bash
sudo -u jenkins docker ps
sudo -u jenkins docker compose version
```

Run the Jenkins build again after confirming access.

---

## Step 5 --- Create a Docker Hub Personal Access Token

Use a Docker Hub Personal Access Token instead of your account password.

```text
Docker Hub
    ↓
Account Settings
    ↓
Personal access tokens
    ↓
Generate access token
```

Copy the token and store it securely. Do not write the token directly in
the Jenkinsfile or commit it to GitHub.

## Step 6 --- Add Docker Hub Credentials to Jenkins

Open Jenkins:

```text
Manage Jenkins
    ↓
Credentials
    ↓
System
    ↓
Global credentials
    ↓
Add Credentials
```

Configure the credential:

```text
Kind:      Username with password
Username:  ankittripathidocker
Password:  <Docker Hub Personal Access Token>
ID:        DockerHub_Credentials
```

Click **Create**.

The pipeline references the credential using:

```groovy
withCredentials([
    usernamePassword(
        credentialsId: 'DockerHub_Credentials',
        usernameVariable: 'DOCKERHUB_USER',
        passwordVariable: 'DOCKERHUB_PASS'
    )
]) {
    // Commands can use the credential environment variables.
}
```

---

========================================================================

# Task-3 --- Automate the Pipeline with a GitHub Webhook

========================================================================

A webhook can trigger Jenkins when code is pushed to GitHub, so you do
not need to click **Build Now** for every change.

## Step 1 --- Enable the GitHub Webhook Trigger in Jenkins

Open the pipeline job:

```text
Jenkins
    ↓
Two-Tier-Flask-App
    ↓
Configure
    ↓
Build Triggers
```

Select:

```text
GitHub hook trigger for GITScm polling
```

Click **Save**.

> Use this option for webhook-based triggering. **Poll SCM** is an
> alternative that periodically checks the repository; it is not the
> same as an instant webhook trigger. Avoid enabling both unless you
> specifically need both behaviors.

### Alternative --- Poll SCM

If you want Jenkins to check GitHub on a schedule instead of using a
webhook, select **Poll SCM** and use:

```text
H/5 * * * *
```

This checks approximately every five minutes, with Jenkins distributing
the polling time. Polling is not instant.

---

## Step 2 --- Add a Webhook in GitHub

Open the GitHub repository:

```text
GitHub Repository
    ↓
Settings
    ↓
Webhooks
    ↓
Add webhook
```

Configure the webhook:

```text
Payload URL:  http://EC2_PUBLIC_IP:8080/github-webhook/
Content type: application/json
Events:       Just the push event
```

Replace `EC2_PUBLIC_IP` with your EC2 instance's public IP address or,
preferably, a stable hostname.

Click **Add webhook**.

### Network and Security Notes

- Jenkins must be reachable from GitHub for webhook delivery.
- Allow inbound port `8080` only as required. Do not expose Jenkins
  broadly to the internet without suitable protections.
- For production, use HTTPS through a properly configured reverse
  proxy or load balancer.
- Do not disable SSL verification when HTTPS is configured correctly.
  If testing with plain HTTP, the endpoint itself is not encrypted.

---

## Step 3 --- Verify the Webhook

1.  Push a small change to the configured GitHub branch.
2.  Open the repository's **Settings → Webhooks** page.
3.  Select the webhook and review its recent deliveries and response.
4.  Open Jenkins and check the job's build history and **Console
    Output**.

If no build starts, verify the webhook URL, EC2 security-group rules,
Jenkins trigger setting, repository branch, and Jenkins logs.

---

## Automated CI/CD Flow

```text
Developer
    ↓
git push
    ↓
GitHub Repository
    ↓
GitHub Webhook
    ↓
Jenkins Pipeline
    ↓
Code Clone
    ↓
Docker Image Build
    ↓
Test
    ↓
Push Image to Docker Hub
    ↓
Deploy Application on EC2
```

---
