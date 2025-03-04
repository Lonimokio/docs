FROM node:16

# Set the working directory
WORKDIR /app

# Copy the Docusaurus configuration and source files
COPY MainDocs/docusaurus.config.js ./
COPY MainDocs/sidebar.js ./
COPY MainDocs/src ./src
COPY MainDocs/docs ./docs

# Install dependencies
RUN npm install --global docusaurus

# Build the Docusaurus site
RUN npm run build -- --config docusaurus.config.js --out-dir docs/build

# Expose the port for the static site
EXPOSE 3000

# Command to serve the built site
CMD ["npx", "serve", "docs/build"]