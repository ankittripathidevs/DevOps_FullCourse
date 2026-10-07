# Jenkins Notes

- **EC2 Workspace:** `/var/lib/jenkins/workspace/`
- **GitHub Repo:** `https://github.com/ankittripathidevs/Javascript-test.git`

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
sudo vim /var/lib/jenkins/workspace/basic.sh
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

# =========================

# -------- Day-6 ----------

# =========================

## Project: Email Notification When Build Fails or Success

### Topic: E-mail Notification

Configure Jenkins to send an e-mail when a build **fails, becomes unstable, or returns to stable**.

---

## 1. Create Gmail App Password

Go to your **Google Account**.

```text
Google Account
→ Enable 2-Step Verification
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

 ## Do not forget to allow from inbound rule SMPTS port 465


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

# =========================

# -------- Day-7 ----------

# =========================

## Topic: Role-Based Access Control (RBAC)

### 1. Create a New User

Login with Jenkins Admin.

Go to:

```text
Manage Jenkins
→ Users
→ Create User
```

Example:

```text
Username: dhoni
Password: ********
Name: Dhoni
Email: ********
```

Click **Create User**.


---

## 2. Install Role Based Authorization Strategy Plugin

Go to:

```text
Manage Jenkins
→ Plugins
→ Available plugins
```

Search:

```text
Role-Based Authorization Strategy
```

Install the plugin.


---

## 3. Enable Role Based Authorization Strategy

Go to:

```text
Manage Jenkins
→ Security
→ Authorization
```

Select:

```text
Role-Based Strategy
```

Click:

```text
Save
```


---

## 4. Test New User

Logout from Jenkins.

Login with the newly created user:

```text
Username: dhoni
Password: ********
```

You will see:

```text
Access Denied

dhoni is missing the Overall/Read permission.
```

### Reason:

The user has been created, but no role has been assigned to the user yet.


---

## 5. Login Back with Admin

Logout from `dhoni`.

Login again with:

```text
Username: admin
```

Go to:

```text
Manage Jenkins
→ Role Management
```


---

## 6. Manage Roles

Go to:

```text
Manage Jenkins
→ Role Management
→ Manage Roles
```

Click:

```text
Add Role
```

Example Role Names:

```text
Trainee
Developer
Intern
Read-Only
```

For this example:

```text
Role Name: Trainee
```


---

## 7. Give Permissions

Select the permissions according to the requirement.

Example:

```text
Overall:
    ☑ Read

Job:
    ☑ Read
    ☑ Build

View:
    ☑ Read
```

Do not give unnecessary permissions.

Example:

```text
Overall/Administer    ❌
Job/Delete            ❌
Job/Configure         ❌
```


---

## 8. Assign Role to User

Go to:

```text
Manage Jenkins
→ Role Management
→ Assign Roles
```

Select:

```text
Global roles
```

Click:

```text
Add User or Group
```

Enter:

```text
User ID: dhoni
```

Add the user.

Assign:

```text
dhoni → Trainee
```

Click:

```text
Save
```


---

## 9. Test User Permissions

Logout from Admin.

Login with:

```text
Username: dhoni
Password: ********
```

Now `dhoni` will have the custom permissions
defined in the `Trainee` role.

Example:

```text
Login Jenkins       ✓
Read Jenkins        ✓
Read Job            ✓
Build Job           ✓

Manage Jenkins      ✗
Delete Job           ✗
Configure Job        ✗
Administer Jenkins  ✗
```


---

## RBAC Concept

```text
User
  ↓
Role
  ↓
Permissions
```

Example:

```text
dhoni
  ↓
Trainee
  ↓
Overall/Read
Job/Read
Job/Build
View/Read
```


## Day-7 Learning

```text
Create User
     ↓
Install Role Based Authorization Strategy
     ↓
Enable Role Based Strategy
     ↓
Create Role
     ↓
Give Permissions
     ↓
Assign Role to User
     ↓
Login with User
     ↓
User gets Custom Permissions
```

---

## Important

Creating a user does **not** automatically give
the user Jenkins permissions.

The permissions are controlled through roles.

```text
User ≠ Role ≠ Permission

User:
    dhoni

Role:
    Trainee

Permissions:
    Overall/Read
    Job/Read
    Job/Build
    View/Read
```

---

# =========================
# -------- Day-8 ----------
# =========================

## Topic: Custom Environment Variable

### 1. Configure Global Environment Variable

Go to:

```text
Manage Jenkins
→ System
→ Global Properties
```

Enable:

```text
Environment variables
```

Add:

```text
Name: LOGIN_USER
Value: Ankit(admin)
Name: OS
Value: Linux (ubuntu)
```

Click **Save**.

---

## 2. Access Environment Variable

The environment variable is now **globally accessible** to Jenkins jobs.

Create a new project:

```text
New Item
→ Freestyle Project
```

### Build Step

Go to:

```text
Build Steps
→ Execute shell
```

Add:

```bash
echo $LOGIN_USER
echo "$OS"
```

### Run

```text
Save
→ Build Now
→ Build #
→ Console Output
```

The value of `$OS` will be available to the Jenkins job.

---
