Room = Class{}

-- TODO: Add player to room 
function Room:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.tiles = {}
    self:generateWallsAndFloors()

    self.objects = {}
    self:generateObjects()

    self.doorways = {}
    table.insert(self.doorways, Doorway('top', false, self))

    self.player = player

    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0

    
end

function Room: generateObjects()
    table.insert(self.objects, GameObject(
        GAME_OBJECT_DEFS['key'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 -16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE -16)
    ))

    local key = self.objects[1]

    key.onCollide = function()
        print('HELLZ YEA A KEY!!!')
        gSounds['keyPickup']:play()
        key.pickedUp = true
        Entity:addItemToInventory(self.player.inventory, "Key", 1)
    end
end

function Room:generateWallsAndFloors()
    for y = 1, self.height do
        table.insert(self.tiles, {})

        for x = 1, self.width do
            local id = TILE_EMPTY
            
            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                id = TILE_BOTTOM_RIGHT_CORNER
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == self.width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == self.height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
                id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end

            table.insert(self.tiles[y], {
                id = id
            })
        end
    end
end


function Room:update(dt)
    -- don't update anything if we are sliding to another room (we have offsets)
    if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end

    self.player:update(dt)

    for k, object in pairs(self.objects) do
        object:update(dt)

        --trigger collision callback on object
        if self.player:collides(object) then
            object:onCollide()
        end
    end

    for k, doorway in pairs(self.doorways) do
        if self.player:collides(doorway) then
            if self.player.inventory['Key'] ~= nil then
                doorway.open = true
                Entity:removeItemFromInventory(self.player.inventory, "Key", 1)
                gSounds['doorOpen']:play()
            end
        end
    end
end

function Room:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX, 
                (y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY)
        end
    end

    for k, doorway in pairs(self.doorways) do
        doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end
    
    for k, object in pairs(self.objects) do
        if object.pickedUp == false then
            object:render(self.adjacentOffsetX, self.adjacentOffsetY)
        else
            table.remove(self.objects, k)
        end
    end
    if self.player then
        self.player:render()
    end
end