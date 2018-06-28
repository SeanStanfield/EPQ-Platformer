Collectable = Object:extend()
bump = require "bump"

function Collectable:new(hx, hy, type)

    if type == "heart" then
        self.atlas = love.graphics.newImage("Heart.png")
        self.imageWidth = self.atlas:getWidth()
        self.imageHeight = self.atlas:getHeight()
        self.coll = love.graphics.newQuad(1, 1, 1, 1, self.imageWidth, self.imageHeight)
        self.frames = {0, 1, 2, 3, 2, 1, 0} --the order of the quads
        self.index = 1 --the current quad number
        self.maxIndex = 7 --amount of cycles before needs to be reset
        self.timeBetweenFrame = 1/10 --speed of animation
        self.currentAnimationTime = 0 --time passed since last frame change
        self.offsetX = 40 -- was 6
        self.offsetY = 33 -- distance from the top of the image until the first quad
        self.changeX = 80 -- distance between the start of each quad
        self.quadWidth = 35 -- width of the quad
        self.quadHeight = 35 -- height of the quad
        self.Ymultiplier = 1 --the row that the quad is on
        self.yDistance = 1 --the amount needed to jump to the next row down
        self.consumable = { -- collision data 
            w = 35,
            h = 35,
            name = "heart",
            x = hx,
            y = hy
        }

    else
        self.atlas = love.graphics.newImage("Gems.png")
        self.imageWidth = self.atlas:getWidth()
        self.imageHeight = self.atlas:getHeight()
        self.coll = love.graphics.newQuad(1, 1, 1, 1, self.imageWidth, self.imageHeight)
        self.frames = {0, 1, 3, 2, 2, 3, 1, 0}
        self.index = 1
        self.maxIndex = 8
        self.timeBetweenFrame = 1/15
        self.currentAnimationTime = 0
        self.offsetX = 6 -- used to be 50
        self.offsetY = 5
        self.changeX = 33
        self.quadWidth = 27
        self.quadHeight = 54
        self.yDistance = 63
        self.consumable = {
            w = 27,
            h = 54,
            x = hx,
            y = hy,
            name = "gem"
        }

        if  type == "greenGem" then

        self.Ymultiplier = 0
        self.consumable.name = "greenGem"

    elseif type == "blueGem" then

        self.Ymultiplier = 1
        self.consumable.name = "blueGem"
    elseif type == "redGem" then

        self.Ymultiplier = 2
        self.consumable.name = "redGem"

        else
            return ("Wrong parameter data")
        end
    end

    world:add(self.consumable, self.consumable.x, self.consumable.y, self.consumable.w, self.consumable.h)
end

function Collectable:update(dt)
    self.currentAnimationTime = self.currentAnimationTime + dt

    while self.currentAnimationTime >= self.timeBetweenFrame do
        self.index = self.index + 1
        self.currentAnimationTime = self.currentAnimationTime - self.timeBetweenFrame
    end  

    if self.index > self.maxIndex then
        self.index = 1
    end

    self.coll:setViewport((self.offsetX + (self.frames[self.index]) * self.changeX), self.offsetY + (self.Ymultiplier * self.yDistance) , self.quadWidth, self.quadHeight)
end

function Collectable:draw()
    love.graphics.draw(self.atlas, self.coll, self.consumable.x, self.consumable.y)
    --love.graphics.rectangle("line", self.consumable.x, self.consumable.y, self.consumable.w, self.consumable.h)
end