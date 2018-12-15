PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        walkSpeed = ENTITY_DEFS['player'].walkSpeed,
        x = VIRTUAL_WIDTH / 2 - 8,
        y = VIRTUAL_HEIGHT / 2 - 11,
        width = 16,
        height = 22,
        offsetY = 5
    }
    self.dungeon = Dungeon(self.player)
    self.currentRoom = Room(self.player)
    print(self.dungeon)
    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self.dungeon) end,
        ['idle'] = function() return PlayerIdleState(self.player) end
    }
    self.player:changeState('idle')   
end

function PlayState:enter(params)

end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    if love.keyboard.isDown('space')then
       self.player.walkSpeed = PLAYER_WALK_SPEED * 3 
    else
        self.player.walkSpeed = PLAYER_WALK_SPEED
    end
    self.dungeon:update(dt)
end

function PlayState:render()
    love.graphics.push()
    self.dungeon:render()
    love.graphics.pop()


end
