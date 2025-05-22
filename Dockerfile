# Step 1: Build the app
FROM node:18-alpine as build-stage

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Step 2: Serve the built app with a web server
FROM nginx:alpine as production-stage

# Copy the build output to nginx's html directory
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copy custom nginx config to expose port 8080
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
