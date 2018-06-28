

love.keyboard.setKeyRepeat(enable)

function love.load()


    --love.window.maximize()

    Object = require "class"
    require "camera"
    --require "SheetCutMap"
    require "collectable"
    require "dude"
    require "levelOne"
    require "bump"
    bump = require "bump"
    dude = Dude()
    map = Map()


    heart2 = Collectable(9350, 2600, "blueGem")
    heart3 = Collectable(9400, 2800, "heart")
    greenGem = Collectable(9600, 2800, "greenGem")
    blueGem = Collectable(9700, 2800, "blueGem")
    redGem = Collectable(9800, 2800, "redGem")


    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    r = 0
    g = 0
    b = 0
    love.graphics.setBackgroundColor(r, g, b)
    sean = {3, 4, 2}


end

function love.update(dt)


    dude:update(dt)
    map:update()
    dude:move()

    -- if dude.velocityY > 0 and playerColName ~= "ground" then
    --     dude:fall()
    -- elseif dude.velocityY < 0 and playerColName ~= "ground" then
    --     dude:rise()




    
    if (dude.velocityY < 2) then
        dude:rise()
        print("rising")
    elseif (dude.velocityY >= 2) then
        dude:fall()
        print("falling")
    end

    if ((dude.velocityX == 0) and (dude.velocityY < 2) and (dude.velocityY > 0)) then
        dude:idle()
        print("idle")
    elseif((dude.velocityX ~= 0) and (dude.velocityY < 2) and (dude.velocityY > 0)) then
        print("walking")
        dude:walk()
    end
    print(dude.velocityX, dude.velocityY)

    heart3:update(dt)
    heart2:update(dt)
    greenGem:update(dt)
    blueGem:update(dt)
    redGem:update(dt)
    camera:setPos(dude.x - width/3, dude.y - height/2)

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    if love.keyboard.isDown("r") then
        dude.velocityX = 0
        dude.velocityY = 0
        dude.y = 2800
        dude.x = 9300
    end
   
end

function love.draw()
    camera:set()
    map:draw()
    dude:draw()
    heart2:draw()
    heart3:draw()
    greenGem:draw()
    blueGem:draw()
    redGem:draw()
    love.graphics.setColor(50, 50, 100)
    camera:unset()
    love.graphics.setBackgroundColor(70, 180, 220)
   
end