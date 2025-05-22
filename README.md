# Vue Project

This is a Vue.js project that can be run both locally and via Docker. The application runs on port `8080`.

---

## Getting Started

### 🛠️ Local Development

To run the project locally, follow these steps:

1. **Clone the repository**

   ```bash
   git clone https://github.com/shakeelahmed5/heat-map.git
   cd <project-directory>
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Run the development server**

   ```bash
   npm run dev
   ```

4. **Access the app**

   Visit [http://localhost:8080](http://localhost:8080) in your browser.

### 🐳 Docker Setup

This project includes a Docker configuration to run the application in a containerized environment.

1. **Build the Docker Image**

   ```bash
   docker build -t vue-app .
   ```

2. **Run the Docker Container**

   ```bash
   docker run -p 8080:8080 vue-app
   ```

3. **Access the app**

   The application will be available at [http://localhost:8080](http://localhost:8080).

## 🎥 Demo

Here’s a quick preview of the final product:

![Demo](https://s8.ezgif.com/tmp/ezgif-8393737be371d4.gif)

