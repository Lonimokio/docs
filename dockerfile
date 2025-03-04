FROM node:16

WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY MainDocs/docusaurus.config.js ./
COPY MainDocs/sidebar.js ./
COPY MainDocs/src ./src
COPY MainDocs/docs ./docs

# Build the Docusaurus site
RUN npm run build -- --config docusaurus.config.js --out-dir docs/build

# Expose the port for the static site
EXPOSE 3000

# Start the Docusaurus site
CMD ["npm", "start"]