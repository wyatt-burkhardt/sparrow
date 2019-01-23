Doorway = Class{}

function Doorway:init(direction, open, room)
    self.direction = direction
    self.open = open
    self.room = room

    if direction == 'top' then
        self.x = MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2 * TILE_SIZE) - TILE_SIZE
        self.y = MAP_RENDER_OFFSET_Y
        self.height = 16
        self.width = 32
end

function Doorway:render(offsetX, offsetY)
    local texture = gTextures['tiles']
    local quads = gFrames['tiles']

    -- used for shifting doors when sliding rooms
    self.x = self.x + offsetX
    self.y = self.y + offsetY

    if self.direction == 'top' then
        if self.open then
            -- top left
            love.graphics.draw(texture, quads[31], self.x, self.y - TILE_SIZE)
            -- top right
            love.graphics.draw(texture, quads[32], self.x + TILE_SIZE, self.y - TILE_SIZE)
            -- bottom left
            love.graphics.draw(texture, quads[37], self.x, self.y)
            -- bottom right
            love.graphics.draw(texture, quads[38], self.x + TILE_SIZE, self.y)
        else
            -- top left
            love.graphics.draw(texture, quads[33], self.x, self.y - TILE_SIZE)
            -- top right
            love.graphics.draw(texture, quads[34], self.x + TILE_SIZE, self.y - TILE_SIZE)
            -- bottom left
            love.graphics.draw(texture, quads[39], self.x, self.y)
            -- bottom right
            love.graphics.draw(texture, quads[40], self.x + TILE_SIZE, self.y)
        end
    end
end
    -- revert to original position
    -- self.x = self.x - offsetX
    -- self.y = self.y - offsetY
end