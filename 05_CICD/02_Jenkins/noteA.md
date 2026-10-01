# Jenkins Notes

> **Course:** DevOps / CI-CD
> **Tool:** Jenkins
> **Days Covered:** Day 1 & Day 2

---

# Day 1 — First Jenkins Job

## 1. Create the First Job

Go to:

**Jenkins Dashboard → New Item**

### Job Details

| Field        | Value                  |
| ------------ | ---------------------- |
| Item Name    | `FirstJob`             |
| Project Type | `Freestyle Project`    |
| Description  | `This is my first Job` |

Click **OK**.

---

## 2. Discard Old Builds

In the job configuration:

**General → Discard Old Builds**

Enable this option when you want Jenkins to automatically remove older builds and prevent unnecessary disk usage.

> This becomes especially important on servers with limited disk space.

---

## 3. Add Build Step

Go to:

**Build → Add build step → Execute shell**

Add:

```bash
echo "Hello Dosto"

echo "Hello Ji Kaise Ho Sare" > /var/lib/jenkins/workspace/first_job.txt

cat /var/lib/jenkins/workspace/first_job.txt

bash /var/lib/jenkins/workspace/basic.sh
```

### What each command does

#### `echo`

```bash
echo "Hello Dosto"
```

Prints text to the Jenkins console output.

#### Create a file

```bash
echo "Hello Ji Kaise Ho Sare" > /var/lib/jenkins/workspace/first_job.txt
```

Creates `first_job.txt` and writes the text into it.

`>` means **write/overwrite** the file.

#### Read the file

```bash
cat /var/lib/jenkins/workspace/first_job.txt
```

Displays the contents of `first_job.txt`.

#### Execute a Bash script

```bash
bash /var/lib/jenkins/workspace/basic.sh
```

Runs the `basic.sh` script.

---

# 4. Create `basic.sh`

Before running the Jenkins job, create:

```text
/var/lib/jenkins/workspace/basic.sh
```

Example:

```bash
#!/bin/bash

echo "This is my basic shell script"
echo "Jenkins is executing this script"
```

Then:

```bash
chmod +x /var/lib/jenkins/workspace/basic.sh
```

You can also execute it using:

```bash
bash /var/lib/jenkins/workspace/basic.sh
```

In this case, `chmod +x` is not strictly required because `bash` is directly interpreting the script.

---

# 5. Save and Build

Click:

**Save → Build Now**

Then open:

**Build History → Build #1 → Console Output**

You should see output similar to:

```text
Hello Dosto
Hello Ji Kaise Ho Sare
This is my basic shell script
Jenkins is executing this script
```

---

# 6. Important Jenkins Concept

When Jenkins executes a shell command, the command normally runs using the Jenkins user's permissions.

Check the Jenkins user with:

```bash
ps aux | grep jenkins
```

or:

```bash
systemctl status jenkins
```

You can also check:

```bash
whoami
```

inside an **Execute shell** build step.

Example:

```bash
echo "Current user:"
whoami
```

This is important because Jenkins may not have permission to access or modify every file on the server.

---

# Day 2 — Parameterized CI/CD

## 1. Create a New Job

Go to:

**Jenkins Dashboard → New Item**

### Job Details

| Field        | Value                             |
| ------------ | --------------------------------- |
| Item Name    | `ParamatrizeType-CICD`            |
| Project Type | `Freestyle Project`               |
| Description  | `This is my paramatrize Type Job` |

> Recommended spelling for a future project would be `Parameterized-CICD`, but the existing job name can remain unchanged.

---

# 2. Enable Parameterization

Open:

**Configure → General**

Enable:

```text
This project is parameterized
```

Parameters allow us to provide values to a Jenkins build dynamically.

Instead of hard-coding:

```bash
echo "hello Ankit"
```

we can use:

```bash
echo "hello $FULL_NAME"
```

The value can then be selected or entered when starting the build.

---

# 3. String Parameter

Select:

**Add Parameter → String Parameter**

Configure:

| Field         | Value                         |
| ------------- | ----------------------------- |
| Name          | `FULL_NAME`                   |
| Default Value | `Ankit Tripathi`              |
| Description   | `This is my string parameter` |

Jenkins makes the value available to the shell as:

```bash
$FULL_NAME
```

---

# 4. Choice Parameter

Select:

**Add Parameter → Choice Parameter**

Configure:

| Field       | Value                      |
| ----------- | -------------------------- |
| Name        | `SEX`                      |
| Choices     | `MALE`                     |
|             | `FEMALE`                   |
|             | `OTHERS`                   |
| Description | `This is choice parameter` |

The choices can be written one per line:

```text
MALE
FEMALE
OTHERS
```

Jenkins will display these options when starting a build.

The selected value is available as:

```bash
$SEX
```

---

# 5. Build Periodically

Go to:

**Build Triggers → Build periodically**

Add:

```text
*/10 * * * *
```

This tells Jenkins to schedule the job every **10 minutes**.

### Cron Format

Jenkins cron has five fields:

```text
MINUTE HOUR DAY-OF-MONTH MONTH DAY-OF-WEEK
```

Example:

```text
*/10 * * * *
```

Means:

```text
Every 10 minutes
```

### Important

**Build periodically** and **Poll SCM** are different.

### Build periodically

Runs the job according to the schedule regardless of whether source code changed.

### Poll SCM

Checks the source-control repository according to a schedule and triggers a build when Jenkins detects changes.

---

# 6. Execute Shell

Go to:

**Build → Add build step → Execute shell**

Add:

```bash
echo "hello $FULL_NAME, $SEX"
```

Jenkins substitutes the parameter values when the job runs.

For example, if:

```text
FULL_NAME = Ankit Tripathi
SEX = MALE
```

The output will be:

```text
hello Ankit Tripathi, MALE
```

---

# 7. Run Parameterized Build

Click:

**Save**

Then:

**Build with Parameters**

Jenkins will show:

```text
FULL_NAME: Ankit Tripathi

SEX:
  MALE
  FEMALE
  OTHERS
```

Select the required values and click:

**Build**

Then open:

**Build History → Console Output**

---

# Jenkins Parameters — Important Concept

Jenkins parameters become environment variables during the build.

For example:

```text
Parameter:
FULL_NAME = Ankit Tripathi
```

Can be accessed in shell as:

```bash
echo "$FULL_NAME"
```

Similarly:

```text
Parameter:
SEX = MALE
```

Can be accessed as:

```bash
echo "$SEX"
```

---

# Useful Jenkins Parameter Types

Common parameter types include:

| Parameter             | Purpose                        |
| --------------------- | ------------------------------ |
| String Parameter      | Accept text                    |
| Choice Parameter      | Select from predefined options |
| Boolean Parameter     | Enable/disable an option       |
| Password Parameter    | Enter sensitive values         |
| File Parameter        | Upload a file                  |
| Credentials Parameter | Select Jenkins credentials     |

---

# Day 1 vs Day 2

| Feature               | Day 1 | Day 2 |
| --------------------- | ----: | ----: |
| Freestyle Project     |     ✅ |     ✅ |
| Execute Shell         |     ✅ |     ✅ |
| Shell Script          |     ✅ |     ❌ |
| String Parameter      |     ❌ |     ✅ |
| Choice Parameter      |     ❌ |     ✅ |
| Build with Parameters |     ❌ |     ✅ |
| Build Periodically    |     ❌ |     ✅ |
| Cron                  |     ❌ |     ✅ |

---

# Commands Used

### Check Jenkins status

```bash
sudo systemctl status jenkins
```

### Start Jenkins

```bash
sudo systemctl start jenkins
```

### Restart Jenkins

```bash
sudo systemctl restart jenkins
```

### Check current user

```bash
whoami
```

### Check Jenkins process

```bash
ps aux | grep jenkins
```

### Check Jenkins workspace

```bash
ls -lah /var/lib/jenkins/workspace/
```

### Check a file

```bash
cat /var/lib/jenkins/workspace/first_job.txt
```

### Run a shell script

```bash
bash /var/lib/jenkins/workspace/basic.sh
```

---

# Key Takeaways

## Day 1

Learned how to:

* Create a Jenkins Freestyle job
* Configure a build step
* Execute Linux shell commands from Jenkins
* Create and read files from a Jenkins workspace
* Execute a Bash script
* View build logs through Console Output

## Day 2

Learned how to:

* Create a parameterized Jenkins job
* Use String Parameters
* Use Choice Parameters
* Pass Jenkins parameters to shell commands
* Build a job using **Build with Parameters**
* Schedule jobs using Jenkins Cron
* Understand the difference between parameters and hard-coded values

---

# Practice Tasks

## Task 1 — Add a Boolean Parameter

Create:

```text
RUN_SCRIPT
```

Type:

```text
Boolean Parameter
```

Then execute the script only when it is enabled.

Example:

```bash
if [ "$RUN_SCRIPT" = "true" ]; then
    bash basic.sh
else
    echo "Script execution skipped"
fi
```

---

## Task 2 — Add More Parameters

Create:

```text
PROJECT_NAME
ENVIRONMENT
VERSION
```

Example values:

```text
PROJECT_NAME = MyApp
ENVIRONMENT = DEV
VERSION = 1.0.0
```

Print them:

```bash
echo "Project: $PROJECT_NAME"
echo "Environment: $ENVIRONMENT"
echo "Version: $VERSION"
```

---

# Day 1 & Day 2 Learning Flow

```text
Jenkins
   │
   ├── Day 1
   │     │
   │     ├── Create Job
   │     ├── Freestyle Project
   │     ├── Execute Shell
   │     ├── Linux Commands
   │     ├── Shell Script
   │     └── Console Output
   │
   └── Day 2
         │
         ├── Parameters
         │     ├── String Parameter
         │     └── Choice Parameter
         │
         ├── Build with Parameters
         │
         └── Build Triggers
               └── Cron Schedule
```

# Next Concepts to Learn

After these two exercises, the natural Jenkins progression is:

```text
Freestyle Jobs
      ↓
Parameters
      ↓
Build Triggers
      ↓
Git + Jenkins
      ↓
GitHub Webhook
      ↓
Jenkins Pipeline
      ↓
Jenkinsfile
      ↓
Declarative Pipeline
      ↓
Docker
      ↓
CI/CD Pipeline
      ↓
Deploy to EC2
```

> **Goal:** Move from manually configured Freestyle jobs toward **Jenkinsfile-based Pipeline CI/CD**. This is the more important skill for real-world Jenkins work.

