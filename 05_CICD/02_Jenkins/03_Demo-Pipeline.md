# Jenkins Demo Pipeline

**============================================**  
** Day-3: Create Jenkins Demo Pipeline**  
**============================================**

** Step 1 — Create a New Pipeline Job**

Open Jenkins Dashboard.

Go to:

```text
Jenkins Dashboard
      ↓
New Item
```

Enter the project name:

```text
Demo-Pipeline
```

Select:

```text
Pipeline
```

Click:

```text
OK
```

---

**### Step 2 — Add Pipeline Description**

Add a description for the pipeline.

Example:

```text
This is my first Jenkins Declarative Pipeline.
```

---

**### Step 3 — Configure Pipeline**

Scroll down to the **Pipeline** section.

Select:

```text
Definition: Pipeline script
```

In the **Pipeline script** section, add the following Declarative Pipeline:

**Demo-Pipeline - 1**

```groovy
pipeline {

    agent any

    stages {

        stage('Build') {
            steps {
                echo 'Building Application...'
            }
        }

        stage('Test') {
            steps {
                echo 'Testing Application...'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying Application...'
            }
        }
    }
}
```

Click:

```text
Save
```

---

**### Step 4 — Run the Pipeline**

Open the `Demo-Pipeline` project.

Click:

```text
Build Now
```

Jenkins will create a new build.

Example:

```text
Build #1
```

Click:

```text
#1
```

Then:

```text
Console Output
```

---

**### Step 5 — Check Console Output**

```text
[Pipeline] Start of Pipeline

[Pipeline] stage
[Pipeline] { (Build)
Building Application...
[Pipeline] }

[Pipeline] stage
[Pipeline] { (Test)
Testing Application...
[Pipeline] }

[Pipeline] stage
[Pipeline] { (Deploy)
Deploying Application...
[Pipeline] }

[Pipeline] End of Pipeline

Finished: SUCCESS
```

---

**### Step 6 — Understand the Pipeline**

```text
pipeline
    ↓
agent
    ↓
stages
    ↓
stage
    ↓
steps
```

---

**### Demo-Pipeline - 2**

**#### Step 1 — Configure Global Environment Variables**

Go to:

```text
Jenkins Dashboard
      ↓
Manage Jenkins
      ↓
System
      ↓
Global properties
      ↓
Environment variables
```

Enable:

```text
Environment variables
```

Add:

```text
Name: NAME
Value: Ankit
```

Add:

```text
Name: AGE
Value: 26
```

Click:

```text
Save
```

---

**#### Step 2 — Configure Jenkins Secret Credential**

Go to:

```text
Jenkins Dashboard
      ↓
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

Configure:

```text
Kind: Secret text

Scope: Global

Secret: <Your Secret Password>

ID: PASSWD

Description: This is my Secret Password
```

Click:

```text
Save
```

---

**#### Step 3 — Pipeline Script**

```groovy
pipeline {

    agent any

    environment {
        PASS = credentials("PASSWD")
    }

    stages {

        stage("Hello") {
            steps {
                sh '''
                    echo "Hello"
                    echo $NAME
                    echo $AGE
                '''
            }
        }

        stage("Credentials Check") {
            steps {
                sh '''
                    echo "Credentials is Available"
                    echo "$PASS"
                '''
            }
        }
    }
}
```

---

**#### Step 4 — Build Pipeline**

```text
Save
  ↓
Build Now
  ↓
Console Output
```

---

**## Final Result**

```text
Demo-Pipeline - 1
Build → Test → Deploy
```

```text
Demo-Pipeline - 2

Global Environment Variables
        ↓
NAME = Ankit
AGE = 26
        ↓
Jenkins Credentials
        ↓
PASSWD
        ↓
Pipeline
```
