# Jenkins Demo Pipeline

**============================================**  
**## Day-3: Create Jenkins Demo Pipeline**  
**============================================**

**### Step 1 — Create a New Pipeline Job**

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

Click the build number:

```text
#1
```

Then select:

```text
Console Output
```

---

**### Step 5 — Check Console Output**

The console output should show the different pipeline stages.

Example:

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

The basic Jenkins Declarative Pipeline structure is:

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

**#### Jenkins Credentials**

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

**#### Pipeline Script**

```groovy
pipeline {

    agent any

    environment {
        NAME = "Ankit"
        AGE = "26"
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

**#### Build Pipeline**

```text
Save
  ↓
Build Now
  ↓
Console Output
```
