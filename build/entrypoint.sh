#!/bin/bash
set -e

# If CODE_SERVER_PASSWORD environment variable is set, update the config
if [ -n "$CODE_SERVER_PASSWORD" ]; then
    echo "Setting custom code-server password..."
    sed -i "s/password: \"\"/password: \"$CODE_SERVER_PASSWORD\"/" ~/.config/code-server/config.yaml
else
    echo "No password provided. code-server will generate a random password."
    echo "To view the generated password, run: cat ~/.config/code-server/config.yaml"
fi

# Start code-server
exec code-server --bind-addr 0.0.0.0:13337 ~
