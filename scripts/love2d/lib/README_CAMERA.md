# hump.camera - Camera Module for LÖVE

**Author:** Matthias Richter (HUMP library)  
**Repository:** https://github.com/vrld/hump  
**License:** MIT

## Description

hump.camera is a powerful camera module from the HUMP (Helper Utilities for Massive Progression) library. It provides camera functionality for LÖVE2D games, including panning, zooming, and rotation with smooth interpolation.

## Installation

This library is already included in your Love2D project's `lib` directory as `camera.lua`.

## Basic Usage

```lua
local Camera = require 'lib.camera'

function love.load()
    -- Create a camera at position (200, 200)
    cam = Camera(200, 200)
    
    -- Or create at screen center (default)
    cam = Camera()
end

function love.update(dt)
    -- Move camera
    if love.keyboard.isDown('w') then cam:move(0, -100 * dt) end
    if love.keyboard.isDown('s') then cam:move(0, 100 * dt) end
    if love.keyboard.isDown('a') then cam:move(-100 * dt, 0) end
    if love.keyboard.isDown('d') then cam:move(100 * dt, 0) end
    
    -- Zoom
    if love.keyboard.isDown('q') then cam:zoom(1.1) end
    if love.keyboard.isDown('e') then cam:zoom(0.9) end
end

function love.draw()
    -- Attach camera before drawing
    cam:attach()
    
    -- Draw your game world here
    love.graphics.circle('fill', 200, 200, 50)
    love.graphics.rectangle('fill', 400, 300, 100, 100)
    
    -- Detach camera
    cam:detach()
    
    -- Draw UI elements (not affected by camera)
    love.graphics.print('FPS: ' .. love.timer.getFPS(), 10, 10)
end
```

## Key Features

- **Position Control**: Move and look at specific coordinates
- **Zoom**: Scale the view in and out
- **Rotation**: Rotate the camera view
- **Smooth Movement**: Built-in interpolation for smooth camera transitions
- **Camera Locking**: Lock camera to follow entities with customizable smoothing
- **Coordinate Conversion**: Convert between world and screen coordinates

## Common Methods

### Camera Creation
- `Camera(x, y, zoom, rotation, smoother)` - Create a new camera

### Movement
- `camera:lookAt(x, y)` - Point camera at position
- `camera:move(dx, dy)` - Move camera by offset
- `camera:position()` - Get current position

### Zoom & Rotation
- `camera:zoom(multiplier)` - Zoom by multiplier
- `camera:zoomTo(zoom)` - Set zoom level
- `camera:rotate(angle)` - Rotate by angle
- `camera:rotateTo(angle)` - Set rotation

### Rendering
- `camera:attach(x, y, w, h, noclip)` - Begin camera transformation
- `camera:detach()` - End camera transformation
- `camera:draw(func)` - Draw with camera in one call

### Camera Following
- `camera:lockPosition(x, y, smoother, ...)` - Smoothly follow position
- `camera:lockWindow(x, y, x_min, x_max, y_min, y_max, smoother, ...)` - Follow within window

### Coordinate Conversion
- `camera:worldCoords(x, y)` - Screen to world coordinates
- `camera:cameraCoords(x, y)` - World to screen coordinates
- `camera:mousePosition()` - Get mouse position in world coordinates

## Example: Following Player

```lua
local Camera = require 'lib.camera'

function love.load()
    cam = Camera()
    player = {x = 400, y = 300}
end

function love.update(dt)
    -- Update player position
    if love.keyboard.isDown('left') then player.x = player.x - 200 * dt end
    if love.keyboard.isDown('right') then player.x = player.x + 200 * dt end
    
    -- Camera follows player with smooth damping
    cam:lockPosition(player.x, player.y, Camera.smooth.damped(5))
end

function love.draw()
    cam:attach()
    love.graphics.circle('fill', player.x, player.y, 20)
    cam:detach()
end
```

## Smooth Movement Options

```lua
-- No smoothing (instant)
Camera.smooth.none()

-- Linear smoothing (constant speed)
Camera.smooth.linear(100) -- speed parameter

-- Damped smoothing (ease in/out)
Camera.smooth.damped(5) -- stiffness parameter
```

## Documentation

For full HUMP library documentation, visit: https://hump.readthedocs.io/
