#!/usr/bin/bash

# Environment variables created by system
# They exists before your script runs

echo "Home Directory: $HOME"
echo "Logged in User: $USER"
echo "Current Shell: $SHELL"
echo "Path Variable: $PATH"

# They are exported so child processes can access them
# So, they have bigger scope then normal variables
