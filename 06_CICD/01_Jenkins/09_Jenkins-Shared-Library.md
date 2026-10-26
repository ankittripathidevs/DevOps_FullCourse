# Day-9: Jenkins Shared Library

## Objective

Learn to create reusable Jenkins Pipeline functions using Groovy and call them from a `Jenkinsfile` to reduce code duplication and simplify CI/CD pipelines.

## 1. What Is a Jenkins Shared Library?

- Stores reusable Jenkins Pipeline code.
- Reduces repeated code across multiple pipelines.
- Functions are commonly written in Groovy.
- Global functions are stored in the `vars/` directory.
- Each `.groovy` filename becomes the function name.

Example: `vars/clone.groovy` can be called using `clone()`.

## 2. Configure the Shared Library

Navigate to:

```text
Manage Jenkins
    ↓
System
    ↓
Global Trusted Pipeline Libraries
    ↓
Add
```

| Setting | Value |
|---|---|
| Name | `Shared` |
| Default version | `main` |
| Retrieval method | Git / SCM |
| Repository | `https://github.com/ankittripathidevs/Jenkins-Shared-Library.git` |

Save the configuration. The library name must match `@Library('Shared')` in your `Jenkinsfile`.

## 3. Shared Library Structure

```text
Jenkins-Shared-Library/
└── vars/
    ├── clone.groovy
    ├── trivy_scan.groovy
    ├── docker_build.groovy
    ├── docker_push.groovy
    └── docker_compose.groovy
```

## 4. Create Reusable Functions

### A. Clone Repository — `vars/clone.groovy`

```groovy
def call(String url, String branch) {
    git branch: branch, url: url
}
```

**Usage:**

```groovy
clone(
    'https://github.com/ankittripathidevs/Expenses-Tracker-WebApp.git',
    'main'
)
```

### B. Trivy Scan — `vars/trivy_scan.groovy`

```groovy
def call() {
    sh 'trivy fs . --output results.json'
}
```

**Usage:**

```groovy
stage('Trivy Scan') {
    steps {
        trivy_scan()
    }
}
```

Scans the workspace and generates `results.json`. Trivy must be installed on the Jenkins agent. This command does not fail the build based on vulnerability severity by default.

### C. Build Docker Image — `vars/docker_build.groovy`

```groovy
def call(String imageName, String imageTag = 'latest') {
    echo "Building ${imageName}:${imageTag}"
    sh "docker build -t ${imageName}:${imageTag} ."
}
```

**Usage:**

```groovy
docker_build('expenses-tracker-app', 'latest')
```

### D. Push to Docker Hub — `vars/docker_push.groovy`

Requires a Jenkins credential with ID `DockerHub_Credentials`, configured as **Username with password**. Use a Docker Hub access token as the password.

```groovy
def call(String imageName, String dockerHubRepo, String imageTag = 'latest') {
    withCredentials([
        usernamePassword(
            credentialsId: 'DockerHub_Credentials',
            usernameVariable: 'DockerHub_USER',
            passwordVariable: 'DockerHub_PASS'
        )
    ]) {
        try {
            sh '''
                set +x
                echo "$DockerHub_PASS" | docker login \
                    -u "$DockerHub_USER" --password-stdin
            '''

            sh """
                docker image tag '${imageName}:${imageTag}' \
                    "\$DockerHub_USER/${dockerHubRepo}:${imageTag}"

                docker push \
                    "\$DockerHub_USER/${dockerHubRepo}:${imageTag}"
            """
        } finally {
            sh 'docker logout || true'
        }
    }
}
```

**Usage:**

```groovy
docker_push(
    'expenses-tracker-app',
    'expenses-tracker',
    'latest'
)
```

Never hardcode or commit credentials.

### E. Deploy with Docker Compose — `vars/docker_compose.groovy`

```groovy
def call() {
    echo 'Deploying application'
    sh 'docker compose up -d --build'
}
```

**Usage:**

```groovy
stage('Deploy') {
    steps {
        docker_compose()
    }
}
```

Docker and the Compose V2 plugin must be installed. If deployment should use the image pushed to Docker Hub, configure the Compose file to reference the intended image.

## 5. Use the Shared Library in a Jenkinsfile

Place `@Library` before the pipeline definition.

```groovy
@Library('Shared') _

pipeline {
    agent { label 'dev' }

    stages {
        stage('Code Clone') {
            steps {
                clone(
                    'https://github.com/ankittripathidevs/Expenses-Tracker-WebApp.git',
                    'main'
                )
            }
        }

        stage('Resolve Maven Dependencies') {
            steps {
                sh 'chmod +x mvnw'
                sh './mvnw -B dependency:resolve'
            }
        }

        stage('Trivy Scan') {
            steps {
                trivy_scan()
            }
        }

        stage('Build Docker Image') {
            steps {
                docker_build('expenses-tracker-app', 'latest')
            }
        }

        stage('Push to Docker Hub') {
            steps {
                docker_push(
                    'expenses-tracker-app',
                    'expenses-tracker',
                    'latest'
                )
            }
        }

        stage('Deploy') {
            steps {
                docker_compose()
            }
        }
    }
}
```

Update the agent label, repository URL, image names, and credentials to match your environment.

## 6. Pipeline Workflow

```text
Load Shared Library
        ↓
Clone Repository
        ↓
Resolve Maven Dependencies
        ↓
Trivy Security Scan
        ↓
Build Docker Image
        ↓
Push to Docker Hub
        ↓
Deploy with Docker Compose
        ↓
Archive Trivy Report
```

## 7. Quick Revision

| File | Purpose | Function |
|---|---|---|
| `clone.groovy` | Clone repository | `clone(url, branch)` |
| `trivy_scan.groovy` | Scan workspace | `trivy_scan()` |
| `docker_build.groovy` | Build image | `docker_build(name, tag)` |
| `docker_push.groovy` | Push image | `docker_push(name, repo, tag)` |
| `docker_compose.groovy` | Deploy application | `docker_compose()` |

## Important Notes

- Configure the library in Jenkins before using `@Library('Shared') _`.
- Store reusable functions inside `vars/`.
- Ensure the Jenkins agent has Git, Java, Trivy, Docker, and Docker Compose as required.
- Store secrets in Jenkins Credentials.
- Archive `results.json` to retain the scan report.
- Maven Central rate limits may affect dependency resolution.
- Test individual functions before running the complete pipeline.
- Use meaningful image tags instead of relying exclusively on `latest` for production deployments.
