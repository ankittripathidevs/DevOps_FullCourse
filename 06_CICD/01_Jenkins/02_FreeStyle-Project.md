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

======================================
## Day-6: Custom Environment Variable
======================================

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
| Day-6 | Custom Environment Variable | Global Variables |

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


