# Simple Java App — Docker

A simple **Java 21 application** containerized using Docker.
The application prints a greeting along with the current date and time.

## Tech Stack

* Java 21
* Amazon Corretto 21
* Docker

## Project Structure

```text
01_simple-java-app/
├── Dockerfile
├── README.md
└── src/
    └── Main.java
```

## Dockerfile

The Dockerfile:

1. Uses **Amazon Corretto 21**
2. Sets `/app` as the working directory
3. Copies `Main.java` into the container
4. Compiles the Java application using `javac`
5. Runs the application using `java Main`

## Build Docker Image

```bash
docker build -t simple-java-app .
```

## Run Container

```bash
docker run simple-java-app
```

### Example Output

```text
Hello, Dosto! Current date and time: Wed Sep 03 03:00:00 UTC 2026
```

