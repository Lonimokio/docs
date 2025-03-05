# filepath: /home/lonimokio/Programming/testing/docs/dockerfile
FROM node:18 AS builder

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

# Use Nginx to serve the static files
FROM nginx:alpine
COPY --from=builder /app/docs/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]