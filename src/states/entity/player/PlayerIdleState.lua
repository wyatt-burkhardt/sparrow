PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    print('IDLE STATE >>>>>>>>>>>')
end

function PlayerIdleState:update(dt)
    EntityIdleState.update(self, dt)
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
            print('WHAT THE HELL')
            self.entity:changeState('walk')
    end

    -- if love.keyboard.wasPressed('space') then
    --     self.entity:changeState('swing-sword')
    -- end
end