-- Write your own app code here!
local app = {}

function app:load()
    self.timer = 0
    self.mouse = {love.mouse.getPosition()}

    self.circleSelectorRadius = 10

    local radius = 200
    self.points = {}
    for i = 0, 2 do
        local radians = math.pi*2/3*i - math.pi/2
        table.insert(self.points, {x=math.cos(radians)*radius, y=math.sin(radians)*radius})
    end

    self:sendPoints()

    shaders.triangle:send('color1', {1, 0, 0, 1})
    shaders.triangle:send('color2', {0, 1, 0, 1})
    shaders.triangle:send('color3', {0, 0, 1, 1})
end

function app:sendPoints()
    local x, y = love.graphics.getWidth()/2, love.graphics.getHeight()/2

    shaders.triangle:send('point1', {self.points[1].x + x, self.points[1].y + y})
    shaders.triangle:send('point2', {self.points[2].x + x, self.points[2].y + y})
    shaders.triangle:send('point3', {self.points[3].x + x, self.points[3].y + y})
end

function app:update(dt)
    self.timer = self.timer + dt
    self.mouse[1], self.mouse[2] = love.mouse.getPosition()
end

function app:resize(w, h)

end

function app:getMinMax()
    local minX, minY, maxX, maxY = self.points[1].x, self.points[1].y, self.points[1].x, self.points[1].y
    for i = 2, #self.points do
        local point = self.points[i]
        minX = point.x < minX and point.x or minX
        minY = point.y < minY and point.y or minY
        maxX = point.x > maxX and point.x or maxX
        maxY = point.y > maxY and point.y or maxY
    end

    return minX, minY, maxX, maxY
end

function app:mousemoved(x, y, dx, dy)
    if not love.mouse.isDown(1) then return end
    
    for k, point in pairs(self.points) do
        local x, y = love.graphics.getWidth()/2, love.graphics.getHeight()/2
        local dist = math.sqrt((point.x+x-self.mouse[1])^2 + (point.y+y-self.mouse[2])^2)
        if dist <= self.circleSelectorRadius then
            point.x = point.x + dx
            point.y = point.y + dy
        end
    end

    self:sendPoints()
end

function app:draw()
    love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)

    love.graphics.clear(love.graphics.getBackgroundColor())
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setShader(shaders.triangle)
    love.graphics.setColor(255, 255, 255)

    local minX, minY, maxX, maxY = self:getMinMax()
    love.graphics.rectangle('fill', minX, minY, maxX-minX, maxY-minY)
    love.graphics.setShader()

    love.graphics.setColor(255, 0, 0)
    for k, point in pairs(self.points) do
        love.graphics.circle('line', point.x, point.y, self.circleSelectorRadius)
    end
end

return app
