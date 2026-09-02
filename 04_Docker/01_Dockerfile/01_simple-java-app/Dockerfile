# (1) Pull a Java 21 base image that already contains the JDK and required Java tools
FROM amazoncorretto:21
  
# (2) Set the working directory inside the container (where the app code will be stored)
WORKDIR /app

# (3) Copy Java source code from HOST to CONTAINER
COPY src/Main.java /app/Main.java

# (4) Compile the Java code  
RUN javac Main.java

# (5) Run the Java application when the container starts 
CMD ["java", "Main"]
