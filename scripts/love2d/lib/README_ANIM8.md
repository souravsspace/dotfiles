# anim8 - Animation Library for LÖVE

**Version:** 2.3.1  
**Author:** Enrique García Cota  
**Repository:** https://github.com/kikito/anim8  
**License:** MIT

## Description

anim8 is a simple and powerful animation library for LÖVE2D that allows you to create sprite animations from spritesheets. It provides an intuitive grid-based system for defining frames and creating animations.

## Installation

This library is already included in your Love2D project's `lib` directory as `animation.lua`.

## Basic Usage

```lua
local anim8 = require 'lib.animation'

function love.load()
    -- Load your spritesheet
    local image = love.graphics.newImage('assets/sprites/player.png')
    
    -- Create a grid (frameWidth, frameHeight, imageWidth, imageHeight)
    local g = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())
    
    -- Create animations
    -- First parameter: frames to use
    -- Second parameter: duration per frame (or table of durations)
    local walk = anim8.newAnimation(g('1-4', 1), 0.1)
    local idle = anim8.newAnimation(g('1-2', 2), 0.2)
    
    -- Store for later use
    animations = {walk = walk, idle = idle}
    currentAnim = animations.idle
end

function love.update(dt)
    currentAnim:update(dt)
end

function love.draw()
    currentAnim:draw(image, 100, 100)
end
```

## Key Features

- **Grid System**: Easily define frames from spritesheets
- **Flexible Durations**: Set different durations for different frames
- **Animation Control**: Play, pause, resume, and flip animations
- **Callbacks**: Execute code when animations loop

## Common Methods

### Grid
- `anim8.newGrid(frameWidth, frameHeight, imageWidth, imageHeight, left, top, border)` - Create a new grid

### Animation
- `anim8.newAnimation(frames, durations, onLoop)` - Create a new animation
- `animation:update(dt)` - Update the animation
- `animation:draw(image, x, y, r, sx, sy, ox, oy, kx, ky)` - Draw the animation
- `animation:pause()` - Pause the animation
- `animation:resume()` - Resume the animation
- `animation:flipH()` - Flip horizontally
- `animation:flipV()` - Flip vertically
- `animation:gotoFrame(position)` - Jump to a specific frame

## Example: Multiple Animations

```lua
local anim8 = require 'lib.animation'

function love.load()
    local image = love.graphics.newImage('player.png')
    local g = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())
    
    animations = {
        idle = anim8.newAnimation(g('1-4', 1), 0.2),
        walk = anim8.newAnimation(g('1-8', 2), 0.1),
        jump = anim8.newAnimation(g('1-2', 3), 0.15)
    }
    
    currentAnim = animations.idle
end

function love.keypressed(key)
    if key == 'space' then
        currentAnim = animations.jump
    elseif key == 'right' then
        currentAnim = animations.walk
    end
end
```

## Documentation

For full documentation, visit: https://github.com/kikito/anim8
