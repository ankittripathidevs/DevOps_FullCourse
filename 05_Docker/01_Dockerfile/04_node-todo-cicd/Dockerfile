# (1) Node Base Image
FROM node:22-alpine

# (2) Set Working Directory 
WORKDIR /app

# (3) Install packages 
COPY package*.json ./

# (4) Copy the Code
COPY . .

# (5) Install the dependecies
RUN npm install
RUN npm run test

# (6) Expose application at port 
EXPOSE 8000

# (7) Run the code
CMD ["node","app.js"]
