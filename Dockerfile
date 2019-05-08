# STEP 1: Node builder
FROM node:9.10.1 as builder

WORKDIR /app
COPY . .
RUN npm install
RUN npm run build --production

FROM nginx

COPY  --from=builder app/dist /usr/share/nginx/html
