# filepath: /home/lonimokio/Programming/testing/docs/entrypoint.sh
#!/bin/sh

# Create the necessary directories for Certbot
mkdir -p /var/www/certbot /etc/letsencrypt

# Substitute environment variables in the nginx configuration template
envsubst < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Check if the domain and email are provided
if [ -n "$DOMAIN" ] && [ -n "$EMAIL" ]; then
    # Start NGINX in the background
    nginx -g 'daemon off;' &

    # Obtain SSL certificates using Certbot
    certbot certonly --webroot -w /var/www/certbot -d "$DOMAIN" --email "$EMAIL" --agree-tos --non-interactive

    # Reload NGINX to apply the new certificates
    nginx -s reload
else
    echo "DOMAIN and EMAIL not provided, skipping SSL setup."
    # Start NGINX without SSL
    nginx -g 'daemon off;'
fi

# Keep the container running
tail -f /dev/null