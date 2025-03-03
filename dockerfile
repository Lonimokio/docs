FROM node:16

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the Docusaurus documentation
RUN npm run build -- --config ./docusaurus.config.js --out-dir ./docs/build

# Expose the build directory as a volume
VOLUME [ "/usr/src/app/docs/build" ]

# Command to run when starting the container
CMD ["npm", "run", "serve"]