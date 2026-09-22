# Stage 1: Build
FROM node:20-alpine AS build
RUN apk add --no-cache git
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
ENV YAML_CONFIG=./deploy/config.yml
ENV JS_CONFIG=./deploy/config.js
RUN yarn build

# Stage 2: Serve
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
