#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting deployment to Cloudflare Pages..."

# Install pnpm if not already installed
echo "📦 Checking pnpm installation..."
if ! command -v pnpm &> /dev/null; then
    echo "Installing pnpm..."
    npm install -g pnpm
else
    echo "pnpm is already installed"
fi

echo "📦 Installing dependencies..."
pnpm install

echo "🏗️ Building the application..."
# Clean up any existing build directory
rm -rf build
# Run the build command
NODE_ENV=production pnpm run build

# Verify build directory exists
if [ ! -d "build" ]; then
    echo "❌ Build directory not found!"
    exit 1
fi

# Deploy to Cloudflare Pages using Wrangler
echo "🚀 Deploying to Cloudflare Pages..."
if ! command -v wrangler &> /dev/null; then
    echo "Installing wrangler..."
    pnpm add -g wrangler
fi

wrangler pages deploy build \
  --project-name=unichat-ra \
  --branch=main

echo "✅ Deployment complete!"
