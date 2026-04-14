# Java-docker-test
- A simple java app that runs on docker 

# How to Run 
```bash
# Step:1 Build Images
- docker build -t customImageName .
# Exmaple:
- docker build -t java-app .

# Step:2 Run Containers
- docker run -name customContainerName ImageName
# Example:
- docker run --name java-docker java-app

```
# Real-world Tip
-  -t --→ tags your image with a readable name.

-  --name -→ gives your container a fixed name
 (otherwise Docker assigns random names like crazy_volhard).

# Instructor 
- trainwithsubham
