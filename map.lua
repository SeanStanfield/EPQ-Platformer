Map = Object:extend()
require "bump"
require "dude"
bump = require "bump"

function Map:new()

    self.tiles = love.graphics.newImage("sheet.png")
    self.bg = love.graphics.newImage("Level 1 TEST BIG.png")
    self.bgW = self.bg:getWidth()
    self.bgH = self.bg:getHeight()
    tileMapWidth = self.tiles:getWidth()
    tileMapHeight = self.tiles:getHeight()
    tileWidth, tileHeight = 64, 64


    Quadlocations = {
        {19, 64, 64},
        {21, 192, 64},
        {22, 256, 64},
        {1, 0, 0},
        {2, 64, 0},
        {3, 128, 0},
        {18, 0, 64},
        {20, 128, 64},
        {23, 320, 64}, --orange and green tiles
        {53, 64, 196},
        {36, 64, 128},
        {37, 128, 128},
        {35, 0, 128},
        {54, 128, 96},
        

    }

    self.Quads = {}

    for i,info in ipairs(Quadlocations) do
        self.Quads[info[1]] = love.graphics.newQuad(info[2], info[3], tileWidth, tileHeight, tileMapWidth, tileMapHeight)
    end
    
    self.floortiles = data


    theAlmightyFloors = {}
    for rowIndex, row in ipairs(self.floorTiles) do
        theAlmightyFloors[rowIndex] = {}
        for colIndex, keyCode in ipairs(row) do
            if keyCode ~= 0 then
                local posX, posY = (colIndex - 1)*tileWidth, (rowIndex -1)*tileHeight
                theAlmightyFloors[rowIndex][colIndex] = {name = "ground"}
                world:add(theAlmightyFloors[rowIndex][colIndex], posX, posY, tileWidth, tileHeight)
            end
        end
    end

end

function Map:update(dt)
end

function Map:draw()
    love.graphics.draw(self.bg, 0, 0, 0, 4, 8)
    for rowIndex, row in ipairs(self.floorTiles) do
        for colIndex, keyCode in ipairs(row) do
            if keyCode ~= "" then
                local x,y = (colIndex - 1)*tileWidth, (rowIndex -1)*tileHeight
                love.graphics.draw(self.tiles, self.Quads[keyCode], x, y, 0)
                love.graphics.rectangle("line", x, y, tileWidth, tileHeight)
                
            end
        end
    end
end