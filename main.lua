local nest = require("nest").init({ console = "3ds", scale = 2 })
local editor = require("editor")
local stage =  require("stage")

stageWidth = 480
stageHeight = 360
stageScale = 1.52
depthEnabled = false

cat = love.graphics.rectangle("fill", 5, 5, 62, 118)
bp = "str"

function love.load()
  love.graphics.set3D(depthEnabled)
end
uname, ucode = love.system.getFriendInfo()
function love.draw(screen)
  local width, height = love.graphics.getDimensions(screen)
  depthSlider = math.floor(love.graphics.getDepth() * 100)
  love.graphics.setBackgroundColor(1,1,1)

  if screen == "bottom" then -- render bottom screen
    love.graphics.setColor(229/255,240/255,1)
    love.graphics.rectangle("fill", 0,0, width, 30)
    love.graphics.setColor(195/255, 204/255, 217/255)
    love.graphics.line(0, 31, width, 31)
    love.graphics.rectangle("line", 0, 31, 40, height)

    love.graphics.setColor(133/255,92/255,214/255)
    love.graphics.rectangle("fill", 0, height - 40, 40, 40)    
  end
  if screen ~= "bottom" then -- render top screen
    love.graphics.setColor(195/255, 204/255, 217/255)
    love.graphics.rectangle("line", width / 2 - stageWidth/stageScale/2, height / 2 - stageHeight/stageScale/2 , stageWidth/stageScale, stageHeight/stageScale)
    love.graphics.setColor(0.5,0.5,0.5)
    love.graphics.rectangle("fill", width / 2 - 62/stageScale/2, height/2  - 118/stageScale/2, 62/stageScale, 118/stageScale) 
    love.graphics.print(screen, 5, 5)
    love.graphics.print(bp, 5, 15)
  end
end

function love.gamepadpressed(joystick, button)
  love.graphics.setColor(0,0,1)
  bp = button
  if button == "x" then
    depthEnabled = not depthEnabled
    love.graphics.set3D(depthEnabled)
  end
  if button == "start" then
    love.event.quit()
  end
  if button == "y" then
    love.keyboard.setTextInput(true, {
      hint = "type word ;)"
    })
  end
end
