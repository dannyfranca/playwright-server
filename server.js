const { chromium } = require('playwright');

(async () => {
  const port = 5400;
  const wsPath = 'ws'; 

  console.log(`Starting Playwright Server (Node.js) on port ${port} at path /${wsPath}`);

  // Launch the server
  // host: '0.0.0.0' binds to all interfaces, allowing external connections
  const browserServer = await chromium.launchServer({
    port: port,
    wsPath: wsPath,
    host: '0.0.0.0', 
    headless: true
  });
  
  console.log(`Server listening at: ${browserServer.wsEndpoint()}`);
  
  // Keep the process alive indefinitely
  await new Promise(() => {}); 
})();
