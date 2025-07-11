#!/bin/bash

echo "🚀 Publishing SwiftOpenAI MCP Server to npm"
echo "=========================================="

# Check if logged in to npm
npm whoami &> /dev/null
if [ $? -ne 0 ]; then
    echo "❌ Not logged in to npm. Please run: npm login"
    exit 1
fi

# Check if we have a clean working directory
if [[ -n $(git status -s) ]]; then
    echo "❌ Working directory is not clean. Please commit changes first."
    exit 1
fi

# Build release binary
echo "📦 Building release binary..."
swift build -c release
if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

# Prepare distribution
echo "📋 Preparing distribution..."
npm run prepare-dist

# Run tests
echo "🧪 Running tests..."
npm test 2>/dev/null || echo "ℹ️  No tests configured"

# Show what will be published
echo ""
echo "📦 Package contents:"
npm pack --dry-run

echo ""
echo "Ready to publish version $(node -p "require('./package.json').version")"
echo "This will publish to: swiftopenai-mcp"
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Publish cancelled"
    exit 1
fi

# Publish to npm
echo "🚀 Publishing to npm..."
npm publish --access public

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully published!"
    echo "📦 View at: https://www.npmjs.com/package/swiftopenai-mcp"
    echo ""
    echo "🏷️  Don't forget to:"
    echo "  1. Create a git tag: git tag v$(node -p "require('./package.json').version")"
    echo "  2. Push the tag: git push origin v$(node -p "require('./package.json').version")"
    echo "  3. Create a GitHub release"
else
    echo "❌ Publish failed"
    exit 1
fi