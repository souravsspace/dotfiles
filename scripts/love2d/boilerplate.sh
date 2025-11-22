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

# Copy library files (excluding README files)
rsync -a --exclude='*.md' ~/dotfiles/scripts/love2d/lib/ lib/

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
-- Library dependencies
-- Uncomment the libraries you want to use in your project

-- Animation library (anim8)
-- Anim8 = require 'lib.animation'

-- Camera library (hump.camera)
-- Camera = require 'lib.camera'

-- Tiled map loader (STI)
-- Sti = require 'lib.tiled'

-- Physics library (windfield)
-- Wf = require 'lib.physics'

-- Example usage:
-- function love.load()
--     -- Animation
--     local image = love.graphics.newImage('assets/sprites/player.png')
--     local g = Anim8.newGrid(32, 32, image:getWidth(), image:getHeight())
--     local animation = Anim8.newAnimation(g('1-4', 1), 0.1)
--
--     -- Camera
--     cam = Camera()
--
--     -- Tiled map
--     map = Sti('assets/maps/level1.lua')
--
--     -- Physics
--     world = Wf.newWorld(0, 512, true)
-- end
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

# Create README.md
cat <<EOF > README.md
# $project_name

A LÖVE2D game project.

## Running the Game

\`\`\`bash
love .
\`\`\`

Or if you have the love function in your shell:

\`\`\`bash
love run
\`\`\`

## Project Structure

- \`assets/\` - Game assets (sprites, sounds, fonts)
- \`entities/\` - Game entities and objects
- \`scenes/\` - Game scenes/states
- \`ui/\` - UI components
- \`utils/\` - Utility functions
- \`lib/\` - Third-party libraries

## Available Libraries

This project includes the following libraries in the \`lib/\` directory:

- **anim8** (\`lib/animation.lua\`) - Sprite animation library
- **hump.camera** (\`lib/camera.lua\`) - Camera module with zoom, rotation, and smooth following
- **STI** (\`lib/tiled/\`) - Simple Tiled Implementation for loading Tiled maps
- **windfield** (\`lib/physics/\`) - Physics wrapper around Box2D

## Controls

- **ESC** - Quit game

## License

MIT
EOF


echo "Love2D project '$project_name' created successfully!"
