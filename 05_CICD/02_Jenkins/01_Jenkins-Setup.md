
# Jenkins Setup on AWS EC2 — Ubuntu

============================================
## Day-1: Setup Jenkins on AWS EC2 (Ubuntu)
============================================

### Step 1 — Create an EC2 Instance

Create an **Ubuntu EC2 instance** on AWS.

After the instance is running, connect to it using SSH.

Open in Browser:

```text
http://EC2_PUBLIC_IP
```

---

### Step 2 — Update & Upgrade Ubuntu

```bash
sudo apt update
sudo apt upgrade -y
```

---

### Step 3 — Install Java 21

Jenkins requires Java to run.

Install **Java 21**:

```bash
sudo apt install fontconfig openjdk-21-jre -y
```

Check Java version:

```bash
java --version
```
---

### Step 4 — Install Jenkins

#### Add Jenkins Repository Key

```bash
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
```

#### Add Jenkins Repository

```bash
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
https://pkg.jenkins.io/debian-stable binary/ | \
sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
```

#### Install Jenkins

```bash
sudo apt update
sudo apt install jenkins -y
```

#### Start + Enable Jenkins

```bash
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

#### Check Jenkins Status

```bash
sudo systemctl status jenkins
```

#### Check Jenkins Version

```bash
jenkins --version
```

---

### Step 5 — Allow Jenkins Port 8080

By default, Jenkins runs on:

```text
Port: 8080
```

Go to:

```text
AWS Console
    ↓
EC2
    ↓
Security Groups
    ↓
Inbound Rules
    ↓
Edit Inbound Rules
```

Add a rule:

```text
Type:       Custom TCP
Port:       8080
Source:     Your IP / Required CIDR
```

> For learning purposes, `0.0.0.0/0` can be used, but for production it is better to restrict access to your IP or use a secure reverse proxy/VPN.

Open Jenkins in Browser:

```text
http://EC2_PUBLIC_IP:8080
```

---

### Get Jenkins Initial Admin Password

Run:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Copy the password and paste it into the Jenkins setup page.

---

# Extra Setup

## Step 6 — Install Git

Install Git:

```bash
sudo apt install git -y
git --version
```

### Configure Git

Set username & Email:

```bash
git config --global user.name "ankittripathidevs"
git config --global user.email "ankittripathi2k24@gmail.com"
```

Check Git configuration:

```bash
git config --global --list
```

---

## Step 7 — Install Node.js + npm (LTS)

Install the latest Node.js LTS version using NodeSource.

### Add NodeSource Repository

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
```

### Install Node.js

```bash
sudo apt install -y nodejs
```

### Check Node.js & npm Version

```bash
node -v
npm -v
```

---

------------------------------------------------------------------------

## Step 8 --- Connect GitHub to EC2 for Project Cloning

Configure SSH authentication between the EC2 instance and GitHub.

This allows the EC2 server to clone private GitHub repositories using
SSH.

### Check Existing SSH Keys

``` bash
ls -la ~/.ssh
```

If an existing SSH key is already available, you can use it. Otherwise,
create a new SSH key.

### Create SSH Key

``` bash
ssh-keygen -t ed25519
```

Press **Enter** to accept the default file location.

You can optionally configure a passphrase for additional security.

### Show Public Key

``` bash
cat ~/.ssh/id_ed25519.pub
```

Copy the complete public key.

### Add Public Key to GitHub

Go to:

``` text
GitHub
    ↓
Settings
    ↓
SSH and GPG keys
    ↓
New SSH key
```

Add the copied public key.

``` text
Title: EC2-Jenkins
Key type: Authentication Key
Key: <Paste your public SSH key>
```

Click **Add SSH key**.

### Test GitHub SSH Connection

Run:

``` bash
ssh -T git@github.com
```

The first time, you may see a message asking whether you want to
continue connecting.

Type:

``` text
yes
```

A successful connection will show a message similar to:

``` text
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

### Clone a GitHub Project Using SSH

Use the SSH repository URL:

``` bash
git clone git@github.com:USERNAME/REPOSITORY.git
```

Example:

``` bash
git clone git@github.com:ankittripathidevs/my-project.git
```

Check the cloned project:

``` bash
ls
```

------------------------------------------------------------------------

