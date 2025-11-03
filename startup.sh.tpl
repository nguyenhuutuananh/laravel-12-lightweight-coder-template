#!/bin/bash
set -e

# Define variables
WORKSPACE_DIR="${workspace_dir}"
USER_HOME="/home/${username}"
CODE_SERVER_PASSWORD="${code_server_password}"
DOTFILES_URL="${dotfiles_url}"
INIT_LARAVEL="${init_laravel}"

# Create workspace directory
echo "Creating workspace directory: $USER_HOME/$WORKSPACE_DIR"
mkdir -p $USER_HOME/$WORKSPACE_DIR
cd $USER_HOME/$WORKSPACE_DIR

# Configure code-server
echo "Configuring code-server..."
cat > ~/.config/code-server/config.yaml <<-EOF
bind-addr: 0.0.0.0:13337
auth: password
password: $CODE_SERVER_PASSWORD
cert: false
disable-telemetry: true
disable-update-check: true
EOF

echo "Code-server password has been set"

# Start code-server in the background
echo "Starting code-server..."
nohup code-server --config ~/.config/code-server/config.yaml $USER_HOME/$WORKSPACE_DIR > /tmp/code-server.log 2>&1 &
CODE_SERVER_PID=$!
echo "code-server started with PID $CODE_SERVER_PID"

# Wait for code-server to start
sleep 2

# Check if code-server is running
if ps -p $CODE_SERVER_PID > /dev/null; then
  echo "✅ code-server is running successfully"
else
  echo "❌ ERROR: code-server failed to start. Check /tmp/code-server.log for details"
  cat /tmp/code-server.log
fi

# Install dotfiles if provided
if [ -n "$DOTFILES_URL" ]; then
  echo "Installing dotfiles from $DOTFILES_URL"
  coder dotfiles -y $DOTFILES_URL
fi

# Create Laravel project if enabled
if [ "$INIT_LARAVEL" = "true" ]; then
  if [ ! -f "composer.json" ] && [ ! -d "laravel-app" ]; then
    echo "Creating new Laravel project..."
    composer create-project laravel/laravel laravel-app
    cd laravel-app
    echo "✅ Laravel project created successfully"
  else
    echo "Laravel project already exists, skipping creation"
  fi
fi

echo "🎉 Workspace initialization complete!"