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

# Install Certbot and other necessary packages
RUN apk add --no-cache certbot nginx-mod-http-headers-more

# Remove default Nginx HTML files
RUN rm -rf /usr/share/nginx/html/*

# Copy the built site from the builder stage
COPY --from=builder /app/docs/build /usr/share/nginx/html

# Copy the Nginx configuration template
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]