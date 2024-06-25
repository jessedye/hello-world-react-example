FROM node:20.15.0-alpine3.20 AS builder

USER node

WORKDIR /home/node
COPY --chown=node:node . .
EXPOSE 80

RUN export NODE_OPTIONS=--openssl-legacy-provider
RUN npm run build

FROM nginx:alpine

COPY --from=builder --chown=nginx:nginx /home/node/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder --chown=nginx:nginx /home/node/build /www
COPY --from=builder --chown=nginx:nginx /home/node/src /app/src

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]

