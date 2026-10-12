# Day-7: E-mail Notification in Jenkins

## Objective

Configure Jenkins to send email notifications when a build succeeds or fails. These notes cover Gmail SMTP Setup.

**Recommendation:** Use `emailext()` for the Pipeline example. It is provided by the Email Extension Plugin and offers more flexible notification controls than `mail()`.

---

## Step 1 — Create a Gmail App Password

1. Open the Google Account for `ankittripathi.jet@gmail.com`.
2. Enable **2-Step Verification**.
3. Search Google Account settings for **App passwords**.
4. Create an app password named `jenkins`.
5. Copy the generated password and keep it secure.

> Use the app password, not your normal Gmail password. Never commit it to a Git repository or put it directly in a Jenkinsfile.

---

## Step 2 — Add Gmail SMTP Credentials in Jenkins

Navigate to:

```text
Manage Jenkins
  ↓
Credentials
  ↓
Select the appropriate credentials store and domain
  ↓
Add Credentials
```

Choose **Username with password** and configure:

| Field | Value |
|---|---|
| Username | `ankittripathi.jet@gmail.com` |
| Password | Your Gmail App Password (paste the copied password we have created for App password) |
| ID | `gmail-smtp-credentials` |
| Description | Gmail SMTP Credentials |

Click **Create**. Use the same credential ID in the email configuration.

---

## Step 3 — Configure Extended E-mail Notification

The Pipeline example uses `emailext()`, so configure the **Email Extension Plugin**.

Navigate to:

```text
Manage Jenkins
  ↓
System
  ↓
Extended E-mail Notification
```

Configure:

| Setting | Value |
|---|---|
| SMTP server | `smtp.gmail.com` |
| SMTP port | `465` |
| Credentials | `gmail-smtp-credentials` |
| Use SSL | Enabled |

Save the settings. Configure any additional required fields shown by your Jenkins installation.

### Optional: Basic E-mail Notification

The separate **E-mail Notification** section is used by the Mailer Plugin and the `mail()` Pipeline step. You do not need to configure both email sections if your job only uses `emailext()`.

If you also want to configure basic email notifications, navigate to:

```text
Manage Jenkins
  ↓
System
  ↓
E-mail Notification
```

Typical Gmail settings:

```text
SMTP server: smtp.gmail.com
SMTP port: 465
SMTP authentication: Enabled
Username: ankittripathi.jet@gmail.com
Password: Gmail App Password ((paste the copied password from App password))
Use SSL: Enabled
Charset: UTF-8
```

The **Default User E-mail Suffix** is optional. Do not use `@jenkinstest.com` unless that is a domain you actually use.

---

## Step 4 — Test Email Configuration

In the email configuration section, use the test-email option if available.

Recipient:

```text
ankittripathi2k24@gmail.com
```

Send the test email and confirm that it arrives. Save the configuration.

---

# Part A — Freestyle Project Setup

## Step 5 — Configure the `Git-CICD` Job

Open:

```text
Dashboard
  ↓
Git-CICD
  ↓
Configure
```

### General

Description:

```text
This job pulls code from GitHub and builds the application.
```

### Source Code Management

Select **Git**.

| Field | Value |
|---|---|
| Repository URL | `https://github.com/ankittripathidevs/Javascript-test.git` |
| Credentials | `- none -` (for a public repository) |
| Branch Specifier | `*/main` |
| Repository Browser | `(Auto)` |

If the repository is private, configure Git credentials instead of selecting `- none -`.

## Step 6 — Configure Poll SCM

Under **Build Triggers**, enable **Poll SCM**.

Example schedule:

```text
H/1 * * * *
```

This checks approximately every minute, subject to Jenkins scheduling. Frequent polling can increase load; use a longer interval when appropriate.

## Step 7 — Configure the Build Step

Under **Build Steps**, choose **Add build step → Execute shell**.

Example command from these notes:

```bash
node app.js
```


## Step 8 — Configure Post-build E-mail Notifications

Under **Post-build Actions**, add **E-mail Notification** if that option is available in your Jenkins installation.

Recipient:

```text
ankittripathi2k24@gmail.com
```

Configure the available options for failure, unstable builds, and recovery to a normal build. Exact controls depend on the plugin and job configuration.

Save the job and run a test build.

---

# Part B — Pipeline Project Setup

For a Pipeline job, put notification logic in the `post` section of the Jenkinsfile. Do not nest one `post` block inside another.

The example assumes:
- The Email Extension Plugin and SMTP settings are configured.

```groovy
pipeline {
    agent { label 'dev' }

    stages {
        // 1. Test Jenkins Agent
        stage('Test Agent') {
            steps {
                echo 'Testing Jenkins Agent...'
                sh 'hostname'
                sh 'whoami'
                sh 'java --version'
            }
        }

        // 2. Clone Source Code
        stage('Code Clone') {
            steps {
                echo 'Cloning code from GitHub'
                git branch: 'main',
                    url: 'https://github.com/ankittripathidevs/two-tier-flask-app.git'
            }
        }

        // 3. Build Docker Image
        stage('Build') {
            steps {
                echo 'Building Docker image'
                sh 'docker build -t flask-app:latest .'
            }
        }

        // 4. Test Application
        stage('Test') {
            steps {
                echo 'Testing the application'
                // Add real automated tests here.
            }
        }

        // 5. Push Image to Docker Hub
        stage('Push to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'DockerHub_Credentials',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_PASS'
                    )
                ]) {
                    sh '''

                        echo "Logging into DockerHub"
                        echo "$DOCKERHUB_PASS" | docker login \
                            --username "$DOCKERHUB_USER" \
                            --password-stdin
                            
                        echo "Tagging Docker Image"
                        docker tag flask-app:latest \
                            "$DOCKERHUB_USER/two-tier-flask-app:latest"
                            
                        echo "Pushing Docker Image"
                        docker push \
                            "$DOCKERHUB_USER/two-tier-flask-app:latest"

                    '''
                }
            }
        }

        // 6. Deploy Application
        stage('Deploy') {
            steps {
                echo 'Deploying the application'
                sh 'docker compose up -d --build'
            }
        }
    }

    // 7. Post-build actions and email notifications
    post {
        success {
            echo 'Deployment Pipeline Successfully'

            emailext(
                to: 'ankittripathi2k24@gmail.com',
                subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                    Build completed successfully.
                    Job: ${env.JOB_NAME}
                    Build Number: ${env.BUILD_NUMBER}
                    Build URL: ${env.BUILD_URL}
                """
            )
        }

        failure {
            echo 'Deployment Pipeline Failed'

            emailext(
                to: 'ankittripathi2k24@gmail.com',
                subject: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                    Build failed.
                    Job: ${env.JOB_NAME}
                    Build Number: ${env.BUILD_NUMBER}
                    Build URL: ${env.BUILD_URL}
                """
            )
        } 
    }
}
```
---

## `mail()` vs `emailext()`

| Feature | `mail()` | `emailext()` |
|---|---|---|
| Plugin | Mailer Plugin | Email Extension Plugin |
| Basic email notifications | Yes | Yes |
| Advanced triggers and controls | More limited | More flexible |
| Custom templates | Limited | Supported |
| Best suited for | Simple notifications | Flexible CI/CD notifications |

**Recommendation:** Use `emailext()` for this Pipeline example. Configure Extended E-mail Notification and keep SMTP credentials in Jenkins Credentials.

---


## Optional — Use Simple Email Notification in the Pipeline

If you want to use the Mailer Plugin instead, use `mail()` in the `post` section and configure **E-mail Notification** under **Manage Jenkins → System**.

```groovy
post {
    success {
        echo 'Pipeline completed successfully'

        mail(
            to: 'ankittripathi2k24@gmail.com',
            subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: "Build successful.\n\nBuild URL: ${env.BUILD_URL}"
        )
    }

    failure {
        echo 'Pipeline failed'

        mail(
            to: 'ankittripathi2k24@gmail.com',
            subject: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: "Build failed. Check the console output.\n\nBuild URL: ${env.BUILD_URL}"
        )
    }
}
```

Use this `post` block **instead of**, not in addition to, the `emailext()` `post` block unless you intentionally want to send duplicate emails.

---

## Difference Between Simple and Extended E-mail Notification

| Feature | Simple Email (`mail()`) | Extended Email (`emailext()`) |
|---|---|---|
| Plugin | Mailer Plugin | Email Extension Plugin |
| Configuration Section | E-mail Notification | Extended E-mail Notification |
| Basic Email | Yes | Yes |
| Custom Subjects and Bodies | Yes | Yes |
| Advanced Triggers and Controls | More limited | More flexible |
| Custom Templates | Limited | Supported |
| Best Suited For | Basic notifications | Flexible CI/CD notifications |

**Recommendation:** Use `emailext()` for this Pipeline example because it provides more flexible notification options. Store SMTP credentials in Jenkins Credentials.

---

## Final Notification Flow

```text
GitHub Repository
       ↓
Poll SCM or another build trigger
       ↓
Jenkins checks out the source
       ↓
Build and test
       ↓
Push image and deploy
       ↓
Pipeline result
       ↓
post { success / failure }
       ↓
emailext() or mail()
       ↓
Email recipient
```

---

## Troubleshooting Checklist

- [ ] Gmail 2-Step Verification is enabled.
- [ ] A Gmail App Password has been generated.
- [ ] SMTP credentials are stored securely in Jenkins Credentials where supported.
- [ ] SMTP server is `smtp.gmail.com`.
- [ ] SSL is enabled on port `465`.
- [ ] The Mailer Plugin is installed if using `mail()`.
- [ ] The Email Extension Plugin is installed if using `emailext()`.
- [ ] The matching email configuration section is configured.
- [ ] A test email is delivered successfully.
- [ ] The job has the correct repository URL and branch.
- [ ] The notification recipient is correct.
- [ ] A test build confirms that success and failure emails work.

      
