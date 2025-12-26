# Playwright Server

This project provides a Dockerized Playwright Server running on Ubuntu (Jammy), exposed via WebSocket. It is configured to support **Chromium only** to minimize image size and resource usage.

It uses **Node.js** as the runtime for the server script.

## Setup & Running

### Option 1: Docker Compose

1.  Build and start the container:
    ```bash
    docker-compose up -d --build
    ```
2.  The server will be available at `ws://localhost:5400/ws`.

### Option 2: Podman Quadlet

**Using Makefile (Recommended):**

We provide a `Makefile` to automate the build and installation process.

1.  Install and start the service:
    ```bash
    make install-quadlet
    ```
    This will build the image, copy the configuration to `~/.config/containers/systemd/`, reload systemd, and start the service.

2.  To uninstall:
    ```bash
    make uninstall-quadlet
    ```

**Manual Setup:**

1.  Build the image manually:
    ```bash
    podman build -t playwright-server .
    ```
2.  Copy the `.container` file to your Quadlet directory (e.g., `~/.config/containers/systemd/`):
    ```bash
    mkdir -p ~/.config/containers/systemd/
    cp playwright-server.container ~/.config/containers/systemd/
    systemctl --user daemon-reload
    systemctl --user start playwright-server
    ```

## Connecting Clients

The server exposes a WebSocket endpoint at:
`ws://<container-ip>:5400/ws`

If running locally with port mapping, it is:
`ws://127.0.0.1:5400/ws`

### 1. Using Playwright SDK

To connect your automation scripts to this server, use the `connect` method with `chromium`.

**Installation:**
```bash
npm install playwright
```

**Code Example (`client.js`):**
```javascript
const { chromium } = require('playwright');

(async () => {
  // Connect to the remote Playwright server
  // Replace '127.0.0.1' with the actual IP if running remotely
  const browser = await chromium.connect('ws://127.0.0.1:5400/ws');
  
  const page = await browser.newPage();
  await page.goto('https://example.com');
  console.log('Title:', await page.title());
  
  await browser.close();
})();
```

### 2. Using MCP Server (`playwright-mcp`)

You can use the [Microsoft Playwright MCP](https://github.com/microsoft/playwright-mcp) server to allow LLMs to control this browser instance.

**Installation:**
Follow the official instructions to install `playwright-mcp` (e.g., via `uvx` or `pip`).

**Configuration:**
You need to configure `playwright-mcp` to use the remote endpoint.

Create or update your MCP configuration (e.g., `playwright-mcp.config.json`):

```json
{
  "browser": {
    "remoteEndpoint": "ws://127.0.0.1:5400/ws"
  }
}
```

*Note: Verify the exact configuration schema in the `playwright-mcp` repository.*

