Dude = Object:extend()
require "bump"
bump = require "bump"
world = bump.newWorld(64)


function Dude:new()
    self.atlas = love.graphics.newImage("EnlargedPlayerAtlas.png")
    self.player = love.graphics.newQuad(0, 96, 96, 96, self.atlas:getWidth(), self.atlas:getHeight())
    self.frames = {7, 7, 8, 8}
    self.index = 1
    self.maxIndex = 4
    self.offsetX = 0
    self.timeBetweenFrame = 1 / 8
    self.currentAnimationTime = 0
    self.direction = 0
    self.state = 0
    --animation variables

    self.hasJumped = false
    self.onGround = false
    self.gravity = 1.3
    self.onGround = false
    --jumping variables

    self.velocityY = 1.1
    self.velocityX = 7
    self.x = 9200
    self.y = 500
    self.acceleration = 1
    self.maxSpeed = 12
    self.friction = 0.6
    --displacement variables

    self.wallPower = 40
    self.wallBank = 0
    self.jumpPower = 5
    self.maxJumpForce = 8
    self.canBounce = true
    --wall jump variables

    playerBox = {
        boxW = 54,
        boxH = 64,
        boxVelX = self.velocityX,
        boxVelY = self.velocityY,
        name = "player"
    }

    playerBox.boxX = self.x 
    playerBox.boxY = self.y

    wall = {
        x = 400,
        y = 230,
        w = 50,
        h = 90,
        name = "obsticle"
    }

    playerFloor = {
        x = playerBox.boxX,
        y = playerBox.boxY + playerBox.boxH,
        w = playerBox.boxW,
        h = 1
    }

    function filter(item, other)
        local type = ""
        if other.name == "corner" or other.name == "floor" or other.name == "wall" or other.name == "water" then
            type = "slide"
        elseif other.name == "heart" or other.name == "greenGem" or other.name == "blueGem" or other.name == "redGem" then
            type = "cross"
        else
            type = nil
        end
        
        return type
    end

    world:add(playerBox, playerBox.boxX - 30, playerBox.boxY - 20, playerBox.boxW, playerBox.boxH)

end

function Dude:idle()
    if self.state == 0 then
        return
    end

    self.frames = { 7, 7, 8, 8 }
    self.state = 0
    self.index = 1
    self.maxIndex = 4
    self.offsetX = 0
end

function Dude:walk()
    if self.state == 1 then
        return
    end
    self.frames = { 1, 2, 3, 4 }
    self.state = 1
    self.index = 1
    self.maxIndex = 4
    self.offsetX = 0
end

function Dude:fall()
    if self.state == 2 then
        return
    end
    self.frames = { 7 }
    self.state = 2
    self.index = 1
    self.maxIndex = 1
    self.offsetX = 0
end

function Dude:rise()
    if self.state == 3 then
        return
    end
    self.frames = { 6 }
    self.state = 3
    self.index = 1
    self.maxIndex = 1
    self.offsetX = 0
end

function Dude:move()
    -- maxJumpVel = 6
    -- onGround = false
    -- jumpAcceleration = 2
    
    local playerXCols = {}
    local playerYCols = {}
    local playerNamesCols = {}

    actX, actY, cols, len = world:move(playerBox, self.x + self.velocityX, self.y + self.velocityY, filter)
    self.x = actX
    self.y = actY


    if love.keyboard.isDown("d") then
        if self.velocityX < self.maxSpeed then
            self.velocityX = self.velocityX + self.acceleration
        else
            self.velocityX = self.maxSpeed
        end
        self.direction = 1

    elseif love.keyboard.isDown("a") then

        if self.velocityX > - self.maxSpeed then
            self.velocityX = self.velocityX - self.acceleration
        else
            self.velocityX = -self.maxSpeed
        end
        self.direction = -1

    else
        if self.velocityX > 2 or self.velocityX < -2 then
            self.velocityX = self.velocityX * self.friction
        else
            self.velocityX = 0
        end
    end


    function doesContain(table, value)
        for i,v in ipairs(table) do
            if v == value then
                return true
            else return false
            end
        end
    end

    for i,v in pairs(cols) do
        playerNamesCols[i] = (cols[i].other.name)
        playerYCols[i] = (cols[i].normal.y)
        playerXCols[i] = (cols[i].normal.x)


        --print(playerXCols[i], playerYCols[i], playerNamesCols[i], self.velocityY)
    end
    
    if doesContain(playerYCols, -1) and doesContain(playerNamesCols, "floor") and not self.onGround then
        self.velocityY = 0
        self.onGround = true
    end

    function love.keypressed(key, isrepeat)
        --print("any key pressed")
        if key ~= "w" then return end
        --self.canBounce = true

        if (doesContain(playerYCols, -1) and (doesContain(playerNamesCols, "floor") or doesContain(playerNamesCols, "corner"))) or (self.velocityY == 1.3) then
            self.velocityY = -25
            --self.onGround = false
        end

        if doesContain(playerXCols, 1) and (doesContain(playerNamesCols, "wall") or doesContain(playerNamesCols, "corner")) then
            self.velocityY = -25
            self.wallBank = 500
            self.velocityX = 10
            self.canBounce = false
            --print("left wall bounce", self.canBounce)

        elseif doesContain(playerXCols, -1) and (doesContain(playerNamesCols, "wall") or doesContain(playerNamesCols, "corner")) then
            self.velocityY = -25
            self.wallBank = 500
            self.velocityX = -10
            self.canBounce = false
            print("right wall bounce", self.canBounce)
        
        end

        print(self.canBounce)

            return key, isrepeat
    end

    if (self.wallBank > 5 and (not (doesContain(playerNamesCols, "wall") or doesContain(playerNamesCols, "corner")))) then
        if (doesContain(playerXCols, 1) and (not(doesContain(playerNamesCols, "redGem") or doesContain(playerNamesCols, "greenGem") or doesContain(playerNamesCols, "blueGem")))) then
            self.velocityX = self.velocityX + self.wallPower
            
        elseif (doesContain(playerXCols, -1) and (not(doesContain(playerNamesCols, "redGem") or doesContain(playerNamesCols, "greenGem") or doesContain(playerNamesCols, "blueGem")))) then
            self.velocityX = self.velocityX - self.wallPower
        end
        self.wallBank = self.wallBank - self.wallPower
    end
    

    -- if love.keyboard.isDown("w") and playerColY == -1 and playerColName == "ground" then
    --     --print("jump attempt")
    --     self.velocityY = -20
    --     self.onGround = false
    -- end

    -- if love.keypressed("w") and playerColX == 1 and playerColName == "ground" then
    --     --print("wall Jump attempt")
    --     self.velocityY = -20
    --     self.velocityX = 30
    --     --self.wallBank = 0
    -- end

    -- if love.keypressed("w") and playerColX == -1 and playerColName == "ground" then
    --     --print("wall Jump attempt")
    --     self.velocityY = -20
    --     self.velocityX = -30
    -- end
    if not (doesContain(playerYCols, -1) and (doesContain(playerNamesCols, "floor") or doesContain(playerNamesCols, "corner"))) then
        self.velocityY = self.velocityY + self.gravity
    else
        self.velocityY = 0
    end
end

function Dude:update(dt)
    self.currentAnimationTime = self.currentAnimationTime + dt

    while self.currentAnimationTime >= self.timeBetweenFrame do
        self.index = self.index + 1
        self.currentAnimationTime = self.currentAnimationTime - self.timeBetweenFrame
    end  

    if self.index > self.maxIndex then
        self.index = 1
    end

    self.player:setViewport((self.offsetX + (self.frames[self.index]) * 96), 99, 96, 96)
    love.graphics.setColor(255, 255, 255)


    -- acX, acY, colls, len = world:move(playerBox, self.x, self.y + self.velocityY)
    -- self.y = actY

    -- if love.keyboard.isDown("space") then
    --     if self.velocityY == 0 then
    --         self.velocityY = self.jumpHeight
    --     end
    -- end

    -- if self.velocityY ~= 0 then
    --     self.y = self.y +  self.velocityY * dt
    --     self.velocityY = self.velocityY - self.gravity * dt
    -- end

    -- if self.y > self.ground then
    --     self.velocityY = 0
    --     self.y = self.ground


    playerBox.boxX = self.x
    playerBox.boxY = self.y

end

function Dude:draw()
    
    love.graphics.draw(self.atlas, self.player, self.x + 30, self.y+20, 0, self.direction, 1, 48, 48)
    --love.graphics.rectangle("line", playerBox.boxX, playerBox.boxY, playerBox.boxW, playerBox.boxH)
    love.graphics.rectangle("fill", playerFloor.x, playerFloor.y, playerFloor.w, playerFloor.h)
    love.graphics.print(tostring(self.velocityX), self.x - 20, self.y - 20)
    love.graphics.print(tostring(self.velocityY), self.x + 40, self.y - 20)

end

return Dude