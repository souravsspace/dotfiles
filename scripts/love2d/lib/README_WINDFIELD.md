# Windfield - Physics Module for LÖVE

**Author:** a327ex  
**Repository:** https://github.com/a327ex/windfield  
**License:** MIT

## Description

Windfield is a physics module for LÖVE2D that wraps around Box2D to provide a simpler and more Lua-friendly API. It makes working with physics in LÖVE much easier with intuitive methods and helpful utilities.

## Installation

This library is already included in your Love2D project's `lib/physics` directory.

## Basic Usage

```lua
local wf = require 'lib.physics'

function love.load()
    -- Create a physics world
    world = wf.newWorld(0, 512, true) -- gravity_x, gravity_y, sleep
    
    -- Create a ground
    ground = world:newRectangleCollider(0, 550, 800, 50)
    ground:setType('static')
    
    -- Create a box
    box = world:newRectangleCollider(400, 200, 50, 50)
    box:setRestitution(0.5) -- bounciness
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    -- Draw colliders (for debugging)
    world:draw()
    
    -- Or draw your own sprites at collider positions
    local x, y = box:getPosition()
    love.graphics.rectangle('fill', x - 25, y - 25, 50, 50)
end
```

## Key Features

- **Simple API**: Easy-to-use wrapper around Box2D
- **Multiple Shapes**: Rectangles, circles, polygons, lines, and chains
- **Collision Detection**: Built-in collision callbacks and queries
- **Query Methods**: Raycast, area queries, and point queries
- **Collision Classes**: Tag-based collision filtering
- **Debug Drawing**: Built-in visualization for development

## Creating Colliders

### Rectangle
```lua
collider = world:newRectangleCollider(x, y, width, height)
```

### Circle
```lua
collider = world:newCircleCollider(x, y, radius)
```

### Polygon
```lua
-- Vertices as x, y pairs
collider = world:newPolygonCollider({x1, y1, x2, y2, x3, y3, ...})
```

### Line
```lua
collider = world:newLineCollider(x1, y1, x2, y2)
```

### Chain
```lua
-- For complex shapes or terrain
collider = world:newChainCollider({x1, y1, x2, y2, x3, y3, ...}, loop)
```

## Common Methods

### World
- `world:update(dt)` - Update physics simulation
- `world:draw()` - Draw all colliders (debug)
- `world:destroy()` - Destroy the world
- `world:setGravity(x, y)` - Set gravity
- `world:queryRectangleArea(x, y, w, h, collision_class_names)` - Get colliders in area
- `world:queryCircleArea(x, y, radius, collision_class_names)` - Get colliders in circle

### Collider
- `collider:setType(type)` - Set type: 'static', 'dynamic', or 'kinematic'
- `collider:getPosition()` - Get x, y position
- `collider:setPosition(x, y)` - Set position
- `collider:getLinearVelocity()` - Get velocity
- `collider:setLinearVelocity(vx, vy)` - Set velocity
- `collider:applyForce(fx, fy)` - Apply force
- `collider:applyLinearImpulse(ix, iy)` - Apply impulse
- `collider:setRestitution(value)` - Set bounciness (0-1)
- `collider:setFriction(value)` - Set friction
- `collider:destroy()` - Remove collider

## Example: Player Movement

```lua
local wf = require 'lib.physics'

function love.load()
    world = wf.newWorld(0, 512, true)
    
    -- Create ground
    ground = world:newRectangleCollider(0, 550, 800, 50)
    ground:setType('static')
    
    -- Create player
    player = world:newRectangleCollider(400, 450, 40, 60)
    player:setFixedRotation(true) -- Prevent rotation
end

function love.update(dt)
    world:update(dt)
    
    -- Player movement
    local vx, vy = player:getLinearVelocity()
    
    if love.keyboard.isDown('left') then
        player:setLinearVelocity(-200, vy)
    elseif love.keyboard.isDown('right') then
        player:setLinearVelocity(200, vy)
    else
        player:setLinearVelocity(0, vy)
    end
    
    -- Jump
    if love.keyboard.isDown('space') and isGrounded() then
        player:applyLinearImpulse(0, -3000)
    end
end

function isGrounded()
    -- Check if player is touching ground
    local contacts = player:getEnter('Ground')
    return #contacts > 0
end
```

## Collision Classes

```lua
function love.load()
    world = wf.newWorld(0, 512, true)
    
    -- Define collision classes
    world:addCollisionClass('Player')
    world:addCollisionClass('Enemy')
    world:addCollisionClass('Wall')
    world:addCollisionClass('Projectile', {ignores = {'Projectile'}})
    
    -- Create colliders with classes
    player = world:newRectangleCollider(100, 100, 40, 60)
    player:setCollisionClass('Player')
    
    enemy = world:newCircleCollider(300, 100, 20)
    enemy:setCollisionClass('Enemy')
end
```

## Collision Callbacks

```lua
function love.load()
    world = wf.newWorld(0, 512, true)
    world:addCollisionClass('Player')
    world:addCollisionClass('Coin')
    
    player = world:newRectangleCollider(100, 100, 40, 60)
    player:setCollisionClass('Player')
end

function love.update(dt)
    world:update(dt)
    
    -- Check for collisions
    if player:enter('Coin') then
        print('Collected coin!')
    end
    
    -- Get all colliding objects
    local collisions = player:getEnter('Enemy')
    for _, collision in ipairs(collisions) do
        print('Hit enemy!')
    end
end
```

## Raycasting

```lua
function love.update(dt)
    world:update(dt)
    
    -- Cast a ray
    local x1, y1 = 100, 100
    local x2, y2 = 500, 100
    
    local colliders = world:queryLine(x1, y1, x2, y2)
    
    for _, collider in ipairs(colliders) do
        print('Ray hit:', collider)
    end
end
```

## Tips

- Use `setType('static')` for walls and platforms that don't move
- Use `setFixedRotation(true)` for player characters to prevent tipping
- Collision classes help organize and filter collision detection
- Use `world:draw()` during development to visualize physics
- Apply impulses for instant changes (jumping), forces for gradual changes (wind)

## Documentation

For full documentation and examples, visit: https://github.com/a327ex/windfield
