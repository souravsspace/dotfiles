# STI - Simple Tiled Implementation

**Repository:** https://github.com/karai17/Simple-Tiled-Implementation 
**License:** MIT

## Description

STI (Simple Tiled Implementation) is a Tiled map loader for LÖVE2D. It allows you to load and render maps created with the Tiled Map Editor, supporting layers, tilesets, objects, and more.

## Installation

This library is already included in your Love2D project's `lib/tiled` directory.

## Basic Usage

```lua
local sti = require 'lib.tiled'

function love.load()
    -- Load a map exported from Tiled
    map = sti('assets/maps/level1.lua')
end

function love.update(dt)
    -- Update map animations and objects
    map:update(dt)
end

function love.draw()
    -- Draw the entire map
    map:draw()
    
    -- Or draw at a specific position
    -- map:draw(-100, -50)
    
    -- Or with scale and rotation
    -- map:draw(0, 0, 2, 2, math.pi/4)
end
```

## Key Features

- **Layer Support**: Tile layers, object layers, and image layers
- **Tileset Management**: Multiple tilesets per map
- **Animations**: Animated tiles from Tiled
- **Custom Properties**: Access custom properties from Tiled
- **Object Layers**: Work with objects, shapes, and collision data
- **Plugins**: Extensible with custom plugins (box2d, bump, etc.)

## Common Methods

### Map Loading
- `sti(path, plugins, ox, oy)` - Load a Tiled map

### Rendering
- `map:draw(tx, ty, sx, sy, r)` - Draw the map
- `map:drawLayer(layer, tx, ty, sx, sy, r)` - Draw a specific layer

### Updates
- `map:update(dt)` - Update animations and dynamic elements

### Layer Access
- `map:getLayer(name)` - Get a layer by name
- `map:setLayerVisible(name, visible)` - Show/hide a layer

### Map Information
- `map:getWidth()` - Get map width in tiles
- `map:getHeight()` - Get map height in tiles
- `map:getTileWidth()` - Get tile width in pixels
- `map:getTileHeight()` - Get tile height in pixels

### Coordinate Conversion
- `map:convertPixelToTile(x, y)` - Convert pixel coordinates to tile coordinates
- `map:convertTileToPixel(x, y)` - Convert tile coordinates to pixel coordinates

## Example: Using with Camera

```lua
local sti = require 'lib.tiled'
local Camera = require 'lib.camera'

function love.load()
    map = sti('assets/maps/world.lua')
    cam = Camera()
end

function love.update(dt)
    map:update(dt)
    
    -- Move camera
    if love.keyboard.isDown('left') then cam:move(-200 * dt, 0) end
    if love.keyboard.isDown('right') then cam:move(200 * dt, 0) end
end

function love.draw()
    cam:attach()
    map:draw()
    cam:detach()
end
```

## Example: Working with Object Layers

```lua
function love.load()
    map = sti('assets/maps/level.lua')
    
    -- Get objects from an object layer
    local objectLayer = map:getLayer('Collision')
    
    if objectLayer then
        for _, obj in ipairs(objectLayer.objects) do
            print(obj.name, obj.x, obj.y, obj.width, obj.height)
            
            -- Access custom properties
            if obj.properties then
                print('Type:', obj.properties.type)
            end
        end
    end
end
```

## Using with Physics (Box2D Plugin)

```lua
local sti = require 'lib.tiled'

function love.load()
    -- Create physics world
    world = love.physics.newWorld(0, 9.81 * 64, true)
    
    -- Load map with box2d plugin
    map = sti('assets/maps/level.lua', {'box2d'})
    
    -- Initialize collision layer
    map:box2d_init(world)
    
    -- Get collision objects
    local layer = map:getLayer('Collision')
    layer:box2d_draw()
end

function love.update(dt)
    world:update(dt)
    map:update(dt)
end
```

## Exporting from Tiled

1. Create your map in Tiled Map Editor
2. File → Export As → Lua
3. Save to your `assets/maps/` directory
4. Load in LÖVE with `sti('assets/maps/yourmap.lua')`

## Tips

- Use object layers for collision boundaries, spawn points, and triggers
- Custom properties in Tiled are accessible via `object.properties`
- Layer visibility can be toggled with `map:setLayerVisible()`
- For large maps, consider using `map:drawLayer()` for selective rendering

## Documentation

For full documentation and examples, visit: https://github.com/karai17/Simple-Tiled-Implementation/wiki
