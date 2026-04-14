# stable official Java runtime base image (Pull a base images which gives all the required tools & Libraries )
FROM eclipse-temurin:17-jdk  

# Create a folder where the app code will be stored (working directory)
WORKDIR /app

# Copy source code from HOST machine into the container
COPY src/Main.java /app/Main.java

# Compile the Java code
RUN javac Main.java

# Run the Java application when the container starts
CMD ["java", "Main"]
