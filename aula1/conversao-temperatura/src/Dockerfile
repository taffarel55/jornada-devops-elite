# ==== CONFIGURE =====
# Use a Node base image
FROM node:18.11.0
# Set the working directory to /usr/src/app inside the container
WORKDIR /usr/src/app
# Copy package.json and package-lock.json
COPY package*.json ./

# ==== BUILD =====
# Install dependencies
RUN npm install
# Copy files after install dependencies
COPY . .

# ==== RUN =======
# Expose the port on which the app will be running
EXPOSE 8080
# Start the app
CMD ["node", "server.js"]