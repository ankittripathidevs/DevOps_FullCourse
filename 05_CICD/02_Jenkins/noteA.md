# Jenkins Notes

**EC2 Workspace:** `/var/lib/jenkins/workspace/`
**GitHub Repo:** `https://github.com/ankittripathidevs/Javascript-test.git`

---

# =========================

# -------- Day-1 ----------

# =========================

## Project: FirstJob

### New Item

```text
Jenkins Dashboard → New Item
```

```text
Item Name: FirstJob
Project Type: Freestyle Project
Description: This is my first Job
```

Click **OK**.

### General

Enable:

```text
Discard old builds
Strategy: Log Rotation
```

### Create `basic.sh` manually

On EC2:

```bash
sudo nano /var/lib/jenkins/workspace/basic.sh
```

```bash
#!/bin/bash

echo "This is my basic shell script"
echo "Jenkins is executing this script"
```

```bash
sudo chmod +x /var/lib/jenkins/workspace/basic.sh
```

### Build Step

```text
Configure → Build Steps → Execute shell
```

```bash
echo "Hello Dosto"

echo "Hello Ji Kaise Ho Sare" > /var/lib/jenkins/workspace/first_job.txt

cat /var/lib/jenkins/workspace/first_job.txt

bash /var/lib/jenkins/workspace/basic.sh
```

### Run

```text
Save → Build Now → Build #1 → Console Output
```

---

# =========================

# -------- Day-2 ----------

# =========================

## Project: ParamatrizeType-CICD

### New Item

```text
Jenkins Dashboard → New Item
```

```text
Item Name: ParamatrizeType-CICD
Project Type: Freestyle Project
Description: This is my paramatrize Type Job
```

### Parameters

Enable:

```text
This project is parameterized
```

### String Parameter

```text
Name: FULL_NAME
Default Value: Ankit Tripathi
Description: This is my string parameter
```

### Choice Parameter

```text
Name: SEX

MALE
FEMALE
OTHERS
```

### Build Step

```text
Build → Execute shell
```

```bash
echo "hello $FULL_NAME, $SEX"
```

### Run

```text
Save → Build with Parameters → Select values → Build
```

---

# =========================

# -------- Day-3 ----------

# =========================

## Project: CronJob-CICD

### New Item

```text
Jenkins Dashboard → New Item
```

```text
Item Name: CronJob-CICD
Project Type: Freestyle Project
```

### General

```text
Description: This is my Cron Job
```

Enable:

```text
Discard old builds
Strategy: Log Rotation
```

### Parameters

Enable:

```text
This project is parameterized
```

#### String Parameter — Name

```text
Name: Name
Default Value: Ankit
Description: Enter your name
Trim the string: ✓
```

#### String Parameter — Address

```text
Name: Address
Default Value: Delhi
Description: Enter your address
Trim the string: ✓
```

#### Choice Parameter — Gender

```text
Name: Gender

Male
Female
Others
```

#### Boolean Parameter — IsMarried

```text
Name: IsMarried
Set by Default: Unchecked
```

### Build Trigger

```text
Build Triggers → Build periodically
```

Schedule:

```text
*/1 * * * *
```

Runs every **1 minute**.

### Build Step

```text
Build → Execute shell
```

```bash
echo "Hello My name is $Name"

echo "My address is $Address"

echo "My Gender is $Gender"

if [ "$IsMarried" = "true" ]; then
    echo "Yes i am Married"
else
    echo "No i am not Married"
fi
```

### Run

```text
Save → Build with Parameters → Enter values → Build → Console Output
```

---
# =========================

# -------- Day-4 ----------

# =========================

## Project: Git-CICD

### New Item

```text
Jenkins Dashboard → New Item
```

```text
Item Name: Git-CICD
Project Type: Freestyle Project
```

Click **OK**.

### General

```text
Description:
Git CI/CD Project
```

Optional:

```text
Discard old builds
```

---

## Source Code Management

Select:

```text
Source Code Management → Git
```

### Repository

```text
Repository URL:
https://github.com/ankittripathidevs/Javascript-test.git
```

```text
Credentials:
- none -
```

### Branch

```text
Branch Specifier:
*/main
```

---

## Build Steps

Go to:

```text
Build
→ Add build step
→ Execute shell
```

Add:

```bash
echo "Hello"

node app.js
```

---

## Run

```text
Save
→ Build Now
→ Build #
→ Console Output
```
---



# =========================

# ----- Useful Commands ----

# =========================

### Jenkins

```bash
sudo systemctl status jenkins
sudo systemctl start jenkins
sudo systemctl restart jenkins
```

### Workspace

```bash
ls -lah /var/lib/jenkins/workspace/
```

### Jenkins User

```bash
whoami
```

### Node.js

```bash
node -v
npm -v
```

### Git

```bash
git --version
```

---

# -------- Learning Flow --------

```text
Day-1 → First Jenkins Job
          ↓
Day-2 → Parameters
          ↓
Day-3 → Cron Job
          ↓
Day-4 → Git + Jenkins
          ↓
Day-5 → GitHub Webhook
          ↓
Day-6 → Jenkins Pipeline
          ↓
Day-7 → Jenkinsfile + Docker
```

# Quick Reference

| Day   | Project                | Topic                |
| ----- | ---------------------- | -------------------- |
| Day-1 | `FirstJob`             | Freestyle + Shell    |
| Day-2 | `ParamatrizeType-CICD` | Parameters           |
| Day-3 | `CronJob-CICD`         | Cron + Parameters    |
| Day-4 | `Git-demo-CICD`        | Git + Jenkins        |
| Day-5 | —                      | GitHub Webhook       |
| Day-6 | —                      | Pipeline             |
| Day-7 | —                      | Jenkinsfile + Docker |

```
```

