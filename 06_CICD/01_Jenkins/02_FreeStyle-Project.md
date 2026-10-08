# Jenkins Freestyle Project Notes

===================================
## Day-1: First Freestyle Project
===================================

### Project: `FirstJob`

### Step 1 — Create a New Item

Go to:

```text
Jenkins Dashboard
    ↓
New Item
```

Enter:

```text
Item Name: FirstJob
Project Type: Freestyle Project
Description: This is my first Job
```

Click **OK**.

---

### Step 2 — General Configuration

Enable:

```text
Discard old builds
Strategy: Log Rotation
```

This helps Jenkins automatically manage old build records.

---

### Step 3 — Create `basic.sh` Manually

On the EC2 Jenkins server:

```bash
sudo vim /var/lib/jenkins/workspace/basic.sh
```

Add:

```bash
#!/bin/bash

echo "This is my basic shell script"
echo "Jenkins is executing this script"
```

Make the script executable:

```bash
sudo chmod +x /var/lib/jenkins/workspace/basic.sh
```

---

### Step 4 — Add Build Step

Go to:

```text
Configure
    ↓
Build Steps
    ↓
Execute shell
```

Add:

```bash
echo "Hello Dosto"

echo "Hello Ji Kaise Ho Sare" > /var/lib/jenkins/workspace/first_job.txt

cat /var/lib/jenkins/workspace/first_job.txt

bash /var/lib/jenkins/workspace/basic.sh
```

---

### Step 5 — Run the Job

```text
Save
    ↓
Build Now
    ↓
Build #1
    ↓
Console Output
```

---

### Day-1 Learning Flow

```text
Create Freestyle Project
        ↓
Configure Project
        ↓
Add Build Step
        ↓
Execute Shell Commands
        ↓
Build Now
        ↓
Check Console Output
```

---

===================================
## Day-2: Parameterized Freestyle Project
===================================

### Project: `ParamatrizeType-CICD`

### Step 1 — Create New Item

Go to:

```text
Jenkins Dashboard
    ↓
New Item
```

Enter:

```text
Item Name: ParamatrizeType-CICD
Project Type: Freestyle Project
Description: This is my paramatrize Type Job
```

Click **OK**.

---

### Step 2 — Enable Parameters

Enable:

```text
This project is parameterized
```

---

### Step 3 — Add String Parameter

```text
Name: FULL_NAME
Default Value: Ankit Tripathi
Description: This is my string parameter
```

---

### Step 4 — Add Choice Parameter

```text
Name: SEX

MALE
FEMALE
OTHERS
```

---

### Step 5 — Add Build Step

Go to:

```text
Build
    ↓
Execute shell
```

Add:

```bash
echo "hello $FULL_NAME, $SEX"
```

---

### Step 6 — Run with Parameters

```text
Save
    ↓
Build with Parameters
    ↓
Select / Enter values
    ↓
Build
    ↓
Console Output
```

---

### Day-2 Learning Flow

```text
Enable Parameterization
        ↓
Create Parameters
        ↓
Use Parameters in Shell
        ↓
Build with Parameters
        ↓
Check Console Output
```

---

===================================
## Day-3: Scheduled / Cron Job
===================================

### Project: `CronJob-CICD`

### Step 1 — Create New Item

Go to:

```text
Jenkins Dashboard
    ↓
New Item
```

Enter:

```text
Item Name: CronJob-CICD
Project Type: Freestyle Project
Description: This is my Cron Job
```

Click **OK**.

---

### Step 2 — General Configuration

Enable:

```text
Discard old builds
Strategy: Log Rotation
```

---

### Step 3 — Enable Parameters

Enable:

```text
This project is parameterized
```

---

### String Parameter — Name

```text
Name: Name
Default Value: Ankit
Description: Enter your name
Trim the string: ✓
```

---

### String Parameter — Address

```text
Name: Address
Default Value: Delhi
Description: Enter your address
Trim the string: ✓
```

---

### Choice Parameter — Gender

```text
Name: Gender

Male
Female
Others
```

---

### Boolean Parameter — IsMarried

```text
Name: IsMarried
Set by Default: Unchecked
```

---

### Step 4 — Configure Build Trigger

Go to:

```text
Build Triggers
    ↓
Build periodically
```

Schedule:

```text
*/1 * * * *
```

This runs the job every **1 minute**.

> Note: `Build periodically` schedules builds based on time. It is different from `Poll SCM`, which checks a source-code repository for changes.

---

### Step 5 — Add Build Step

Go to:

```text
Build
    ↓
Execute shell
```

Add:

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

---

### Step 6 — Run

```text
Save
    ↓
Build with Parameters
    ↓
Enter values
    ↓
Build
    ↓
Console Output
```

---

### Day-3 Learning Flow

```text
Parameters
    ↓
Build Periodically
    ↓
Execute Shell
    ↓
Use Parameter Values
    ↓
Automatic Build
```

---

===================================
## Day-4: Git Integration
===================================

### Project: `Git-CICD`

### Step 1 — Create New Item

Go to:

```text
Jenkins Dashboard
    ↓
New Item
```

Enter:

```text
Item Name: Git-CICD
Project Type: Freestyle Project
Description: Git CI/CD Project
```

Click **OK**.

---

### Step 2 — General Configuration

Optional:

```text
Discard old builds
```

---

### Step 3 — Source Code Management

Go to:

```text
Source Code Management
    ↓
Git
```

Repository URL:

```text
https://github.com/ankittripathidevs/Javascript-test.git
```

Credentials:

```text
- none -
```

Branch Specifier:

```text
*/main
```

---

### Step 4 — Add Build Step

Go to:

```text
Build
    ↓
Add build step
    ↓
Execute shell
```

Add:

```bash
echo "Hello"

node app.js
```

---

### Step 5 — Run

```text
Save
    ↓
Build Now
    ↓
Build #
    ↓
Console Output
```

---

### Git-CICD Flow

```text
GitHub Repository
        ↓
Jenkins Git Checkout
        ↓
Workspace
        ↓
Execute Shell
        ↓
node app.js
        ↓
Build Result
```

---

===================================
## Day-5: Poll SCM
===================================

### Project: `Git-CICD`

### Topic: Poll SCM

**Poll SCM = Poll Source Code Management**

Jenkins periodically checks the Git repository at a scheduled interval for new changes.

---

### Step 1 — Source Code Management

Go to:

```text
Jenkins Job
    ↓
Configure
    ↓
Source Code Management
```

Select:

```text
Git
```

Repository URL:

```text
https://github.com/ankittripathidevs/Javascript-test.git
```

Credentials:

```text
- none -
```

Branch Specifier:

```text
*/main
```

Repository Browser:

```text
(Auto)
```

Additional Behaviours:

```text
No additional behaviour
```

---

### Step 2 — Configure Poll SCM

Go to:

```text
Configure
    ↓
Build Triggers
    ↓
Poll SCM
```

Enable:

```text
Poll SCM
```

Schedule:

```text
*/1 * * * *
```

This checks the Git repository every **1 minute**.

Another example:

```text
H/2 * * * *
```

This checks approximately every **2 minutes**, with Jenkins choosing the starting minute.

---

### Step 3 — Build Step

Go to:

```text
Build
    ↓
Add build step
    ↓
Execute shell
```

Add:

```bash
node app.js
```

---

### How Poll SCM Works

```text
GitHub Repository
        ↓
Jenkins Poll SCM
        ↓
Check for Changes
        ↓
Changes Found?
     /       \
   YES        NO
    ↓          ↓
Start Build   No New Build
    ↓
Execute Shell
    ↓
node app.js
```

If there are **no changes**, Jenkins does not start a new build.

---

===================================
## Day-6: E-mail Notification
===================================

### Topic: E-mail Notification

Configure Jenkins to send an e-mail when a build fails, becomes unstable, or returns to stable.

---

### Step 1 — Create Gmail App Password

Go to your **Google Account**.

Enable:

```text
Google Account
    ↓
2-Step Verification
```

Search for:

```text
App password
```

Create a new app-specific password.

App Name:

```text
jenkins
```

After creating it:

```text
Copy the generated App Password immediately.
```

> The generated password may not be shown again.

---

### Step 2 — Configure Jenkins E-mail

Go to:

```text
Manage Jenkins
    ↓
System
    ↓
E-mail Notification
```

SMTP Server:

```text
smtp.gmail.com
```

Default User E-mail Suffix:

```text
@jenkinstest.com
```

---

### Advanced SMTP Settings

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
<Your Gmail App Password>
```

Security:

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

> Use the Gmail App Password rather than your normal Gmail password.

---

### Step 3 — Test E-mail

Go to:

```text
E-mail Notification
    ↓
Test configuration by sending test e-mail
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
Save
    ↓
Apply
```

---

### Step 4 — Configure `Git-CICD`

Open:

```text
Git-CICD
    ↓
Configure
```

Description:

```text
This pull a code from Github
```

Source Code Management:

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

### Step 5 — Poll SCM

Go to:

```text
Build Triggers
    ↓
Poll SCM
```

Schedule:

```text
*/1 * * * *
```

This checks the Git repository every **1 minute**.

---

### Step 6 — Build Step

Go to:

```text
Build
    ↓
Execute shell
```

Add:

```bash
node app.js
```

---

### Step 7 — Post-build E-mail Notification

Go to:

```text
Post-build Actions
    ↓
E-mail Notification
```

Recipients:

```text
ankittripathi2k24@gmail.com
```

Jenkins sends the e-mail when the build:

```text
Fails
Becomes unstable
Returns to stable
```

Optional:

```text
Send e-mail for every unstable build
Send separate e-mails to individuals who broke the build
```

---

### Final E-mail Notification Flow

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
Build Result
    ↓
E-mail Notification
    ↓
Gmail
```

---

===================================
## Day-7: Role-Based Access Control (RBAC)
===================================

### Topic: Role-Based Authorization Strategy

RBAC allows Jenkins administrators to control what different users can access and perform.

---

### Step 1 — Create a New User

Login with Jenkins Admin.

Go to:

```text
Manage Jenkins
    ↓
Users
    ↓
Create User
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

### Step 2 — Install Role-Based Authorization Strategy Plugin

Go to:

```text
Manage Jenkins
    ↓
Plugins
    ↓
Available plugins
```

Search:

```text
Role-Based Authorization Strategy
```

Install the plugin.

---

### Step 3 — Enable Role-Based Strategy

Go to:

```text
Manage Jenkins
    ↓
Security
    ↓
Authorization
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

### Step 4 — Test the New User

Logout from Jenkins.

Login with:

```text
Username: dhoni
Password: ********
```

You may see:

```text
Access Denied

dhoni is missing the Overall/Read permission.
```

### Reason

The user has been created, but no role has been assigned to the user yet.

---

### Step 5 — Login Back with Admin

Logout from `dhoni`.

Login with:

```text
Username: admin
```

Go to:

```text
Manage Jenkins
    ↓
Role Management
```

---

### Step 6 — Manage Roles

Go to:

```text
Manage Jenkins
    ↓
Role Management
    ↓
Manage Roles
```

Click:

```text
Add Role
```

Example role names:

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

### Step 7 — Give Permissions

Select permissions according to the requirement.

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

### Step 8 — Assign Role to User

Go to:

```text
Manage Jenkins
    ↓
Role Management
    ↓
Assign Roles
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

Assign:

```text
dhoni → Trainee
```

Click:

```text
Save
```

---

### Step 9 — Test User Permissions

Logout from Admin.

Login with:

```text
Username: dhoni
Password: ********
```

Now `dhoni` will have the custom permissions defined in the `Trainee` role.

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

### RBAC Concept

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

---

### Day-7 Learning Flow

```text
Create User
    ↓
Install Role-Based Authorization Strategy
    ↓
Enable Role-Based Strategy
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

### Important

Creating a user does **not** automatically give the user Jenkins permissions.

Permissions are controlled through roles.

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

===================================
## Day-8: Custom Environment Variable
===================================

### Topic: Global Environment Variables

Global environment variables can be configured in Jenkins and then accessed by Jenkins jobs.

---

### Step 1 — Configure Global Environment Variables

Go to:

```text
Manage Jenkins
    ↓
System
    ↓
Global Properties
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

### Step 2 — Access Environment Variables

The environment variables are now globally accessible to Jenkins jobs.

Create a new project:

```text
New Item
    ↓
Freestyle Project
```

---

### Step 3 — Add Build Step

Go to:

```text
Build Steps
    ↓
Execute shell
```

Add:

```bash
echo $LOGIN_USER
echo "$OS"
```

---

### Step 4 — Run the Job

```text
Save
    ↓
Build Now
    ↓
Build #
    ↓
Console Output
```

The values of the global environment variables will be available to the Jenkins job.

---

### Day-8 Learning Flow

```text
Manage Jenkins
    ↓
System
    ↓
Global Properties
    ↓
Environment Variables
    ↓
Create / Configure Job
    ↓
Execute Shell
    ↓
Access Variables
```

---

# Jenkins Freestyle Projects — Overall Learning Flow

```text
Day-1
First Freestyle Project
        ↓
Day-2
Parameterized Project
        ↓
Day-3
Build Periodically / Cron
        ↓
Day-4
Git Integration
        ↓
Day-5
Poll SCM
        ↓
Day-6
E-mail Notification
        ↓
Day-7
Role-Based Access Control
        ↓
Day-8
Global Environment Variables
```

---

# Important Jenkins Concepts Covered

| Day | Topic | Main Concept |
|---|---|---|
| Day-1 | FirstJob | Freestyle Project + Execute Shell |
| Day-2 | ParamatrizeType-CICD | Build Parameters |
| Day-3 | CronJob-CICD | Scheduled Builds |
| Day-4 | Git-CICD | Git Integration |
| Day-5 | Poll SCM | Repository Change Detection |
| Day-6 | E-mail Notification | Build Notifications |
| Day-7 | RBAC | Users, Roles & Permissions |
| Day-8 | Custom Environment Variable | Global Variables |

---

# Useful Paths

### Jenkins Workspace

```text
/var/lib/jenkins/workspace/
```

### GitHub Repository

```text
https://github.com/ankittripathidevs/Javascript-test.git
```


