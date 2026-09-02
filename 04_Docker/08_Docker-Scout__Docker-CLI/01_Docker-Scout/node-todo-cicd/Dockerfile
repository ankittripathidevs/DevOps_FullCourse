# Node Base Image
FROM node:22-alpine

#Working Directry
WORKDIR /app

#Install packages 
COPY package*.json ./

#Copy the Code
COPY . .

#Install the dependecies
RUN npm install
RUN npm run test

# Expose application at port 
EXPOSE 8000

#Run the code
CMD ["node","app.js"]
