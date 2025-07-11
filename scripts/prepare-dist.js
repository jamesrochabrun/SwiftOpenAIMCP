#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const distDir = path.join(__dirname, '..', 'dist');
const buildDir = path.join(__dirname, '..', '.build', 'release');
const binaryName = 'swiftopenai-mcp';

// Create dist directory
if (!fs.existsSync(distDir)) {
  fs.mkdirSync(distDir, { recursive: true });
}

// Detect platform
const platform = process.platform;
const arch = process.arch === 'x64' ? 'x64' : 'arm64';

const targetDir = path.join(distDir, `${platform}-${arch}`);
if (!fs.existsSync(targetDir)) {
  fs.mkdirSync(targetDir, { recursive: true });
}

// Copy binary from build directory
const sourceBinary = path.join(buildDir, binaryName);
const targetBinary = path.join(targetDir, binaryName);

if (fs.existsSync(sourceBinary)) {
  console.log(`Copying binary from ${sourceBinary} to ${targetBinary}`);
  fs.copyFileSync(sourceBinary, targetBinary);
  fs.chmodSync(targetBinary, 0o755);
  console.log('Distribution prepared successfully!');
} else {
  console.error(`Binary not found at ${sourceBinary}`);
  console.error('Please run "npm run build" first');
  process.exit(1);
}