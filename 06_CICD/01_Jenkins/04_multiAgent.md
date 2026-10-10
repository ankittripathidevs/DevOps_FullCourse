# Day-5: Jenkins Master-Agent Setup (Nodes / Agents)

## Why?

```text
Building on the built-in node can be a security risk.
        ↓
Set up distributed builds using Jenkins Agents.
        ↓
Separate the Jenkins controller from build workloads.
```

## Step-1: Create an Agent Server

Create another AWS EC2 instance.

```text
Instance Name: Jenkins-Agent
OS: Ubuntu
```
===============================================================

## Step-2: Install Java on the Agent

Install Java 21:

```bash
sudo apt install fontconfig openjdk-21-jre -y
```

Check the Java version:

```bash
java --version
```

===============================================================

## Step-3: Create an SSH Key on the Jenkins Master

Connect to the Jenkins Master EC2 instance.

Navigate to the SSH directory:

```bash
cd ~/.ssh
ls -la
```

If an appropriate SSH key does not already exist, generate key:

```bash
ssh-keygen
```

Press Enter to accept the default file location. Set a passphrase if required by your security setup.

This creates:

```text
Private Key → id_ed25519
Public Key  → id_ed25519.pub
```

===============================================================

## Step-4: Connect the Master to the Agent Using SSH

The Jenkins Master connects to the Jenkins-Agent through SSH.

```text
Jenkins Master EC2
        |
        | SSH using private key
        ↓
Jenkins-Agent EC2
```

### On the Jenkins Master

Display the public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy the complete public key.

### On the Jenkins-Agent

Open the authorized keys file:
```bash
cd ~/.ssh
ls
vim ~/.ssh/authorized_keys
```

Paste the public key copied from the Jenkins Master on a new line and save the file.


The file is located at:

```text
/home/ubuntu/.ssh/authorized_keys
```

**Important:** The master's public key goes into the agent's `authorized_keys` file. The private key stays on the master and is copied into Jenkins credentials for SSH authentication.

===============================================================

### Step-5 Create the Remote Root Directory

On the Jenkins-Agent EC2 instance:

```bash
mkdir -p /home/ubuntu/jenkins-work
```

Use the absolute path `/home/ubuntu/jenkins-work` in the Remote root directory field.

===============================================================


## Step-6: Configure the Agent in Jenkins UI

Open the Jenkins dashboard.

```text
Jenkins Dashboard
       ↓
Manage Jenkins
       ↓
Nodes
       ↓
New Node
```

Enter the node name and select **Permanent Agent**, then click **Create**.

### Configure Node Details

Fill in the Jenkins UI fields as follows:

| Jenkins UI Field | Value |
|---|---|
| Name | `Jenkins-Agent` |
| Description | This is my agent for development |
| Number of executors | `1` |
| Remote root directory | `/home/ubuntu/jenkins-work` |
| Labels | `dev` |
| Usage | Use this node as much as possible |
| Launch method | Launch agents via SSH |

### Configure SSH Credentials

Under the SSH launch configuration, click **Add → Jenkins**.

Create the credential with these settings:

```text
Kind: SSH Username with private key
Scope: Global
ID: agent-ssh-key
Description: This is my agent key for dev
Username: ubuntu
Private Key: Enter directly
```

On the Jenkins Master, display the private key:

```bash
cat ~/.ssh/id_ed25519
```

Copy the complete private key, including the `BEGIN` and `END` lines, into the Private Key field. Save the credential.

Then select the newly created SSH credential from the Credentials dropdown.


### Host Key Verification Strategy
Select:

```text
Non verifying Verification Strategy
```


### Availability
Select:

```text
Keep this agent online as much as possible
```

Click **Save**

===============================================================


## Step-7: Verify the Agent Connection

Navigate to:

```text
Manage Jenkins
     ↓
   Nodes
     ↓
Jenkins-Agent
     ↓
Launch Agent
     ↓
    Logs
```

Successful connection should show messages similar to:

```text
Launcher: SSHLauncher
Communication Protocol: Standard in/out
This is a Unix agent
Agent successfully connected and online
```

If the agent does not connect, check:

1. Java is installed on the agent.
2. The EC2 security group allows inbound SSH on port `22` from the Jenkins Master.
3. The SSH username is `ubuntu`.
4. The public key is present in `authorized_keys`.

Check Java on the agent:

```bash
java --version
```

If you change SSH credentials or agent configuration, relaunch the agent and review the logs. Restarting Jenkins on the master is not normally necessary.

===============================================================

## Step-8: Run the Pipeline on the Agent

Open your GitHub repository:

`two-tier-flask-app`

Edit the `Jenkinsfile` at the root of the repository.

Use the `dev` label configured in Step-5:

```groovy
pipeline {
    agent {
        label 'dev'
    }

    stages {
        stage('Build') {
            steps {
                echo 'Running on Jenkins Agent'
                sh 'hostname'
            }
        }
    }
}
```

Keep your existing pipeline stages and add the agent declaration at the appropriate level.

For example, if your existing pipeline builds and pushes Docker images, those stages will run on the agent when the top-level pipeline agent uses the `dev` label.

### Configure Jenkins to Use the GitHub Jenkinsfile

If your Jenkins job is not already configured to read the Jenkinsfile from GitHub:

```text
Jenkins Dashboard
       ↓
Open Your Pipeline Job
       ↓
Configure
       ↓
Pipeline
       ↓
Definition: Pipeline script from SCM
       ↓
SCM: Git
       ↓
Repository URL: Your GitHub repository URL
       ↓
Script Path: Jenkinsfile
       ↓
Save
       ↓
Build Now
```

Check the Console Output. The `hostname` command should identify the Jenkins-Agent machine.

===============================================================

## Step-9: Install Docker on the Agent

If your pipeline uses Docker commands, Docker must be installed on the Jenkins-Agent EC2 instance.

```bash
sudo apt update
sudo apt install docker.io
sudo apt install docker-compose-v2
```

Start Docker and enable it at boot:

```bash
sudo systemctl enable --now docker
```

Check Docker:

```bash
docker --version
docker compose version
```

### Give the Ubuntu User Docker Access

The agent connects through the `ubuntu` user. Add that user to the Docker group:

```bash
sudo usermod -aG docker $USER
sudo usermod -aG docker ubuntu
newgrp docker 

```

If Jenkins still reports a Docker permission error, disconnect and relaunch the agent's SSH session so the updated group membership takes effect.

===============================================================

## Step-10: Access the Application

After the pipeline successfully builds and starts the application, access it through the public IP address of the EC2 instance running the application container.

### Jenkins Master

```text
http://54.184.28.223:5000
```

### Jenkins Agent

```text
http://35.160.15.110:5000
```

The agent URL is correct only if the application container is running on the Jenkins-Agent instance and port `5000` is accessible.

**Important:**

- Confirm the current public IP addresses in the EC2 console.
- Public IPs may change when instances are stopped and restarted.
- Configure the EC2 security group to allow inbound port `5000` from your intended clients.


===============================================================

##  Remember: Update EC2 IP Addresses

When an EC2 instance is stopped and started, its public IP address may change. Always verify the current IP addresses in the AWS EC2 Console.

### 1. Update the Jenkins Master IP in GitHub Webhook

Navigate to:

```text
GitHub Repository
      ↓
two-tier-flask-app
      ↓
Settings
      ↓
Webhooks
      ↓
Select Jenkins Webhook
      ↓
Edit
```

Update the **Payload URL** with the current Jenkins Master EC2 public IP:

```text
http://JENKINS_MASTER_EC2_IP:8080/github-webhook/
```

Replace `JENKINS_MASTER_EC2_IP` with the current public IP address of your Jenkins Master EC2 instance.

### 2. Update the Jenkins Agent IP in Jenkins UI

Navigate to:

```text
Jenkins Dashboard
      ↓
Manage Jenkins
      ↓
Nodes
      ↓
Jenkins-Agent
      ↓
Configure
      ↓
Host
```

Update the **Host** field with the current reachable IP address of the Jenkins Agent EC2 instance.

Click **Save** after updating the configuration.

**Remember:** Always verify the current EC2 IP addresses after stopping and starting instances. Update the GitHub webhook with the Jenkins Master IP and the Jenkins Agent configuration with the Agent IP.


===============================================================

## Final Verification

Run your pipeline again and check the Console Output.

```text
GitHub Repository
        ↓
Jenkins Master / Controller
        ↓
Jenkins Agent (label: dev)
        ↓
Execute Pipeline Stages
        ↓
Build Docker Image
        ↓
Push Image to Docker Hub
        ↓
Run Application Container
        ↓
Access Application through Agent IP:5000
```
