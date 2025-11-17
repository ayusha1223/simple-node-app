# 1. Base image
FROM node:18-alpine

# 2. Working directory
WORKDIR /usr/src/app

# 3. Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# 4. Copy rest of app
COPY . .

# 5. Expose port 3000
EXPOSE 3000

# 6. Start the app
CMD ["npm", "start"]
