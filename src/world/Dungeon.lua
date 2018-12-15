Dungeon = Class{}

-- Add player to dungeon 
function Dungeon:init(player)
    self.player = player

    self.rooms = {}
    self.currentRoom = Room(self.player)

    self.nextRoom = nil

    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false


end


function Dungeon:update(dt)
    if not self.shifting then
        self.currentRoom:update(dt)
    else
        self.player.currentAnimation:update(dt)
    end
end

function Dungeon:render()
    self.currentRoom:render()
end