Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/entity_defs'
require 'src/GameObject'
require 'src/game_objects'
require 'src/Player'
require 'src/StateMachine'
require 'src/Util'

require 'src/world/Doorway'
require 'src/world/Dungeon'
require 'src/world/Room'

require 'src/states/BaseState'

require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerWalkState'

require 'src/states/game/StartState'
require 'src/states/game/PlayState'

gTextures = {
    ['background'] = love.graphics.newImage('graphics/sparrowStartBG.jpg'),
    ['tiles'] = love.graphics.newImage('graphics/floorTiles.png'),
    ['character-walk'] = love.graphics.newImage('graphics/player.png'),
    ['keys'] = love.graphics.newImage('graphics/keyObj.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['character-walk'] = GenerateQuads(gTextures['character-walk'], 16, 32),
    ['keys'] = GenerateQuads(gTextures['keys'], 16, 16)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}


gSounds = {
    ['music'] = love.audio.newSource('sounds/background-music.wav'),
    ['keyPickup'] = love.audio.newSource('sounds/Pickup_Key.wav'),
    ['doorOpen'] = love.audio.newSource('sounds/door.wav')
}