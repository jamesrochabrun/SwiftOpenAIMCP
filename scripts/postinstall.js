#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');

const platform = os.platform();
const arch = os.arch();

// Map Node.js arch to our binary naming
const archMap = {
  'x64': 'x64',
  'arm64': 'arm64'
};

const mappedArch = archMap[arch] || arch;

// Check if platform is supported
const supportedPlatforms = ['darwin', 'linux'];
if (!supportedPlatforms.includes(platform)) {
  console.error(`Platform ${platform} is not supported.`);
  console.error('Supported platforms: macOS (darwin), Linux');
  process.exit(1);
}

// Construct path to binary
const binaryName = 'swiftopenai-mcp';
const binaryPath = path.join(__dirname, '..', 'dist', `${platform}-${mappedArch}`, binaryName);

// Check if binary exists
if (!fs.existsSync(binaryPath)) {
  console.error(`Binary not found at ${binaryPath}`);
  console.error(`Platform: ${platform}, Architecture: ${mappedArch}`);
  console.error('This might be a development installation or an unsupported platform.');
  console.error('You may need to build from source using: npm run build');
} else {
  // Make binary executable
  try {
    fs.chmodSync(binaryPath, 0o755);
    console.log('SwiftOpenAI MCP server installed successfully!');
    console.log(`Binary location: ${binaryPath}`);
  } catch (err) {
    console.error('Failed to make binary executable:', err);
    process.exit(1);
  }
}