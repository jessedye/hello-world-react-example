FROM node:20.16.0-alpine3.20 AS builder

USER node

WORKDIR /home/node
COPY --chown=node:node . .
EXPOSE 80

RUN export NODE_OPTIONS=--openssl-legacy-provider
RUN npm install
RUN npm run build

FROM nginx:alpine

# Switch to root temporarily to set permissions
USER root

# Ensure directories exist and set permissions to the nginx user
RUN mkdir -p /www /app/src && \
    chown -R nginx:nginx /www /app/src

# Copy the files and set ownership to nginx user
COPY --from=builder --chown=nginx:nginx /home/node/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder --chown=nginx:nginx /home/node/build /www
COPY --from=builder --chown=nginx:nginx /home/node/src /app/src

# Switch back to the nginx user
USER nginx

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]