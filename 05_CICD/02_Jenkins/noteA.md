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

# -------- Day-5 ----------

# =========================

## Project: Git-CICD

### Topic: Poll SCM

**Poll SCM = Poll Source Code Management**

Jenkins periodically checks the Git repository at a scheduled interval for new changes.

---

## Source Code Management

Go to:

```text
Jenkins Job
→ Configure
→ Source Code Management
```

Select:

```text
Git
```

### Repository

```text
Repository URL:

https://github.com/ankittripathidevs/Javascript-test.git
```

### Credentials

```text
- none -
```

### Branch

```text
Branch Specifier:

*/main
```

### Repository Browser

```text
(Auto)
```

### Additional Behaviours

```text
No additional behaviour
```

---

## Build Trigger — Poll SCM

Go to:

```text
Configure
→ Build Triggers
→ Poll SCM
```

Enable:

```text
Poll SCM
```

### Schedule

Example:

```text
*/1 * * * *
```

Checks the Git repository every **1 minute**.

Another example:

```text
H/2 * * * *
```

Checks approximately every **2 minutes**, with Jenkins choosing the starting minute.

---

## Build Step

Go to:

```text
Build
→ Add build step
→ Execute shell
```

```bash
node app.js
```

---

## How It Works

```text
GitHub Repository
       ↓
Jenkins Poll SCM
       ↓
Check for changes
       ↓
Changes found?
       ↓
      YES
       ↓
Start Build
       ↓
Execute Shell
       ↓
node app.js
```

If there are **no changes**, Jenkins does not start a new build.

---

## Build periodically vs Poll SCM

### Build periodically

```text
Runs the Jenkins job according to the schedule.
Git changes are not required.
```

### Poll SCM

```text
Checks the Git repository according to the schedule.
Build starts when Jenkins detects changes.
```

### GitHub Webhook

```text
GitHub detects push
       ↓
Webhook → Jenkins
       ↓
Build starts
```

---

## Run

```text
Save
→ Make a change in GitHub
→ Wait for Poll SCM
→ Jenkins detects change
→ Build starts
→ Console Output
```

---

## Day-5 Learning

```text
Git Repository
      ↓
Source Code Management
      ↓
Git + Branch
      ↓
Poll SCM
      ↓
Detect Changes
      ↓
Automatic Build
```
---


# =========================

# -------- Day-6 ----------

# =========================

## Project: Git-CICD

### Topic: E-mail Notification

Configure Jenkins to send an e-mail when a build **fails, becomes unstable, or returns to stable**.

---

## 1. Create Gmail App Password

Go to your **Google Account**.

```text
Google Account
→ 2-Step Verification
→ App Passwords
```

Search:

```text
App password
```

Create a new app-specific password.

### App Name

```text
jenkins
```

After creating it:

```text
Copy the generated App Password immediately.
```

> The generated password may not be shown again.

---

# 2. Jenkins E-mail Configuration

Go to:

```text
Manage Jenkins
→ System
→ E-mail Notification
```

### SMTP Configuration

```text
SMTP server:
smtp.gmail.com
```

```text
Default user e-mail suffix:
@jenkinstest.com
```

### Advanced

Enable:

```text
Use SMTP Authentication
```

Username:

```text
ankittripathi.jet@gmail.com
```

Password:

```text
<Your Gmail App Password> (Immediately copy password)
```

### Security

Enable:

```text
Use SSL
```

SMTP Port:

```text
465
```

Charset:

```text
UTF-8
```

---

## 3. Test E-mail

Under:

```text
E-mail Notification
→ Test configuration by sending test e-mail
```

Test recipient:

```text
ankittripathi2k24@gmail.com
```

Click:

```text
Test configuration
```

Expected:

```text
Email was successfully sent
```

Then:

```text
Save → Apply
```

---

# 4. Git-CICD Project Configuration

Open:

```text
Git-CICD
→ Configure
```

### General

Description:

```text
This pull a code from Github
```

### Source Code Management

Select:

```text
Git
```

Repository:

```text
https://github.com/ankittripathidevs/Javascript-test.git
```

Credentials:

```text
- none -
```

Branch:

```text
*/main
```

Repository Browser:

```text
(Auto)
```

---

# 5. Poll SCM

Go to:

```text
Build Triggers
→ Poll SCM
```

Schedule:

```text
*/1 * * * *
```

Checks the Git repository every **1 minute**.

---

# 6. Build Step

Go to:

```text
Build
→ Execute shell
```

```bash
node app.js
```

---

# 7. Post-build E-mail Notification

Go to:

```text
Post-build Actions
→ E-mail Notification
```

### Recipients

```text
ankittripathi2k24@gmail.com
```

### E-mail Behavior

Jenkins sends the e-mail when the build:

```text
Fails
Becomes unstable
Returns to stable
```

Optional:

```text
Send e-mail for every unstable build
```

```text
Send separate e-mails to individuals who broke the build
```

---

## 8. Final Configuration Flow

```text
GitHub
   ↓
Poll SCM
   ↓
Jenkins detects change
   ↓
Git checkout
   ↓
node app.js
   ↓
Build result
   ↓
E-mail Notification
   ↓
Gmail
```

---

## Day-6 Learning

```text
Gmail App Password
        ↓
Jenkins SMTP
        ↓
smtp.gmail.com
        ↓
SMTP Authentication
        ↓
SSL + Port 465
        ↓
Test E-mail
        ↓
Post-build E-mail
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

