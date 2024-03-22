FROM nginx:latest

# Copy the custom NGINX config file into the container
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for HTTP traffic
EXPOSE 80

# NGINX runs by default; no custom ENTRYPOINT or CMD is needed.