#!/bin/bash

# Prompt for project name
read -p "Enter project name (default: my-game): " project_name

# Set default if empty
if [ -z "$project_name" ]; then
    project_name="my-game"
fi

# Create project directory
mkdir -p "$project_name"
cd "$project_name" || exit

# Create directory structure
mkdir -p assets/{sprites,sounds,fonts} entities scenes ui utils lib

# Create .luarc.json
cat <<EOF > .luarc.json
{
  "runtime": {
    "version": "LuaJIT"
  },
  "workspace": {
    "library": [
      "\${3rd}/love2d/library"
    ],
    "checkThirdParty": false
  }
}
EOF

# Create main.lua
cat <<EOF > main.lua
-- Load dependencies
require('dependencies')

function love.load()
    -- Set filter to nearest for pixel art look
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    print("Running...")
end

function love.update(dt)
    
end

function love.draw()
    love.graphics.print("Hello, world!", 10, 10)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
EOF

# Create dependencies.lua
cat <<EOF > dependencies.lua
-- Add library folder to path if needed
-- package.path = package.path .. ";lib/?.lua"

-- Require your modules here
-- push = require 'lib.push'
-- Class = require 'lib.class'
EOF

# Create conf.lua
cat <<EOF > conf.lua
function love.conf(t)
    t.window.title = "$project_name"
    t.window.width = 640
    t.window.height = 360
    t.window.resizable = true
    t.window.vsync = true
    t.window.minwidth = 320
    t.window.minheight = 180
end
EOF

echo "Love2D project '$project_name' created successfully!"
