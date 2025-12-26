# Use Ubuntu Jammy as base for Playwright compatibility
FROM ubuntu:jammy

WORKDIR /app

# Install Node.js (LTS) and required system utilities
RUN apt-get update && apt-get install -y curl gnupg2 ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Copy package files
COPY package.json .

# Install dependencies
RUN npm install

# Install Playwright Chromium browser and system dependencies
# This ensures we only download Chrome, keeping the image lighter than the official one
RUN npx playwright install chromium --with-deps

# Copy the server script
COPY server.js .

# Expose the Playwright Server port
EXPOSE 5400

# Run the server script
CMD ["node", "server.js"]