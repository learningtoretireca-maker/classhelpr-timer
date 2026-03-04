FROM nginx:alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom config and site files
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
COPY audio/ /usr/share/nginx/html/audio/

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
