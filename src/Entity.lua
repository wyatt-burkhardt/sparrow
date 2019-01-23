Entity = Class{}

function Entity:init(def)
    self.direction = 'down'

    self.animations = self:createAnimations(def.animations)

    -- entity dimensions
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    -- offsets for padded sprites
    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0

    self.walkSpeed = def.walkSpeed

    self.heath = def.health

    self.inventory = {}


    -- flags for the flashing when hit
    self.invulnerable = false
    self.invulnerableDuration = 0
    self.invulnerableTimer = 0
    self.flashTimer = 0

    self.dead = false
end

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end
    return animationsReturned
end

-- AABB with some slight shrinkage of box on top side for perspective
function Entity:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Entity:damage(dmg)
    self.health = self.health - dmg
end

function Entity:goInvulnerable(duration)
    self.invulnerable = true
    self.invulnerableDuration = duration
end

function Entity:changeState(name)
    self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:addItemToInventory(inventory,item,amount)
	if (inventory[item] ~= nil) then  --there are items like this in the inventory already
		inventory[item] = inventory[item] + amount --so we add the amount to the ones already there
	else --there is no item like this in the inventory
		inventory[item] = amount --so the new amount of that item is the one we're adding
	end
end

function Entity:removeItemFromInventory(inventory, item, amount)
    if (inventory[item] ~= nil) then
        if (inventory[item] >= 1) then
            inventory[item] = inventory[item] - amount
        else
            inventory[item] = nil
        end
    end
end

function Entity:update(dt)
    if self.invulnerable then
        self.flashTimer = self.flashTimer + dt
        self.invulnerableTimer = self.invulnerableTimer + dt

        if self.invulnerableTimer > self.invulnerableDuration then
            self.invulnerable = false
            self.invulnerableTimer = 0
            self.invulnerableDuration = 0
            self.flashTimer = 0
        end
    end

    self.stateMachine:update(dt)

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

function Entity:render(adjacentOffsetX, adjacentOffsetY)
    -- draw sprite slightly transparent if invulnerable every 0.04 seconds
    if self.invulnerable and self.flashTimer > 0.06 then
        self.flashTimer = 0
        love.graphics.setColor(255, 255, 255, 64)
    end

    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    self.stateMachine:render()
    love.graphics.setColor(255, 255, 255, 255)
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end


