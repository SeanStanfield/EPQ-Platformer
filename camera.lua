local width = love.graphics.getWidth()
local height = love.graphics.getHeight()


camera = {
    x = 0,
    y = 0,
    scale = 0
}


function camera:set()
    love.graphics.push()
    love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
    love.graphics.pop()
end

function camera:setX(desired)
    self.x = desired
end

function camera:setY(desired)
    self.y = desired
end

function camera:setPos(x,y)
    self:setX(x)
    self:setY(y)
end
