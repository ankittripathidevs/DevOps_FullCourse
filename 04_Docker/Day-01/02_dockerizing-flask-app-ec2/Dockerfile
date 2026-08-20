# (1) Use the latest Python base image
FROM python:3.14-slim

# (2) Set the working directory inside the container
WORKDIR /app

# (3) Copy requirements file from HOST to CONTAINER
COPY requirements.txt .

# (4) Copy the application files from HOST to CONTAINER
COPY . .

# (5) Install Python dependencies
RUN pip install -r requirements.txt

# (6) Document that the application uses port 80
EXPOSE 80

# (7) Run the application when the container starts
CMD ["python", "run.py"]