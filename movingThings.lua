moving = Object:extend()

function moving:new(x, y, xVelocity, yVelocity, gravity)
    self.x = x
    self.y = y
    self.xVelocity = xVelocity
    self.yVelocity = yVelocity
    self.gravity = gravity
end
