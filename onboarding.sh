#!/bin/bash

# Marvel Heroes Environment Setup Script

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install dependencies
install_dependencies() {
    echo "Installing dependencies..."
    
    # Check if bundler is installed
    if ! command_exists bundle; then
        echo "Installing bundler..."
        if command_exists sudo; then
            sudo gem install bundler
        else
            gem install bundler
        fi
    fi
    
    # Check if Gemfile exists and run bundle
    if [ -f "Gemfile" ]; then
        echo "Running bundle update..."
        bundle update
    else
        echo "Warning: Gemfile not found. Installing arkana directly..."
        if command_exists sudo; then
            sudo gem install arkana
        else
            gem install arkana
        fi
    fi
}

# Main script
echo "Hello There!, Welcome to Marvel Heroes"
echo "Basically this is just a simple quick script to setup Marvel environment"
echo "As of now, we are using Arkana and Fastlane, so we will be needing the following..."

# Install dependencies
install_dependencies

# Get environment variables from user
echo -n "3. Public_KEY_Debug for Marvel: "
read input_value
export publicKeyDebug="$input_value"

echo -n "4. Private_KEY_Debug for Marvel: "
read input_value
export privateKeyDebug="$input_value"

echo -n "5. Public_KEY_Release for Marvel: "
read input_value
export privateKeyRelease="$input_value"

echo -n "6. Private_KEY_Release for Marvel: "
read input_value
export publicKeyRelease="$input_value"

# Run arkana
echo "Running arkana..."
if command_exists bundle; then
    bundle exec arkana
else
    arkana
fi

# Open in Xcode (if on macOS)
if command_exists xed; then
    xed .
else
    echo "Note: xed command not available (not on macOS?). Please open your project manually."
fi

echo "✅ All Done! ✅"
