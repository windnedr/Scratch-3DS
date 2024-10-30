local nest = require("nest").init({ console = "3ds", scale = 2 })
-- local tove = require("tove")
local editor = require("editor")
local stage = require("stage")

stageWidth = 480
stageHeight = 360
stageScale = 1.52
depthEnabled = false
ExtButtonClicks = 0
clickCoords = "None"

scene = "editor"
frame = 0

color = {
  accent = {
    r = 133/255, 
    g = 92/255,
    b = 214/255,

  }, bg = {
    r = 1, 
    g = 1,
    b = 1,
  },
}

sceneList = {
  "editor", "extentions"
}

icons = {
  ext = love.graphics.newImage("assets/ext.png"),

  -- 3DS
  n3DS = love.graphics.newImage("assets/3ds/n3DS.png"),
  n3DSTrans = love.graphics.newImage("assets/3ds/n3DSTrans.png"),
  o3DS = love.graphics.newImage("assets/3ds/o3DS.png"),
  o3DSTrans = love.graphics.newImage("assets/3ds/o3DSTrans.png"),

}
sfx = {
  select = love.audio.newSource("assets/SFX/Ready.wav", "static"),
  back = love.audio.newSource("assets/SFX/Unready.wav", "static"),


  fadeIn = love.audio.newSource("assets/SFX/fadeIn.wav", "static"),
  fadeOut = love.audio.newSource("assets/SFX/fadeOut.wav", "static"),
}

cat = love.graphics.rectangle("fill", 5, 5, 62, 118)
bp = love._os

bottomDimensions = {width=0,height=0}

function love.load()
  love.graphics.set3D(depthEnabled)
  bottomDimensions.width, bottomDimensions.height = love.graphics.getDimensions(bottom)
  extButton = {x = 0, y = bottomDimensions.height, width = 40, height = 40, enabled=true}--Button object
  
end

function love.draw(screen)
  local sysDepth = 1 -- -love.graphics.getDepth()

  local width, height = love.graphics.getDimensions(screen)
  depthSlider = math.floor(love.graphics.getDepth() * 100)
  love.graphics.setBackgroundColor(1,1,1)

  frame = frame + 1

  if screen == "right" then
    sysDepth = -sysDepth
  end

  if scene == "editor" then
    if screen == "bottom" then -- render bottom screen
    
      love.graphics.setColor(229/255,240/255,1)
      love.graphics.rectangle("fill", 0,0, width, 30)
      love.graphics.setColor(195/255, 204/255, 217/255)
      love.graphics.line(0, 31, width, 31)
      love.graphics.rectangle("line", 0, 31, 40, height)

      -- Extentions Button
      love.graphics.setColor(color.accent.r, color.accent.g, color.accent.b)
      love.graphics.rectangle("fill", extButton.x, extButton.y - extButton.height, extButton.width, extButton.height)    
      love.graphics.setColor(1,1,1)

      love.graphics.draw(icons.ext, extButton.width / 2 + extButton.x - icons.ext:getWidth() / 2 , extButton.y - extButton.height / 2 - icons.ext:getHeight() / 2 )
    end
    
    if screen ~= "bottom" then -- render top screen
      love.graphics.setColor(195/255, 204/255, 217/255)
      love.graphics.rectangle("line", width / 2 - stageWidth/stageScale/2, height / 2 - stageHeight/stageScale/2 , stageWidth/stageScale, stageHeight/stageScale)
      love.graphics.setColor(0.5,0.5,0.5)
      love.graphics.rectangle("fill", width / 2 - 62/stageScale/2, height/2  - 118/stageScale/2, 62/stageScale, 118/stageScale) 
      love.graphics.print(screen, 5, 5)
      love.graphics.print(bp, 5, 15)

      love.graphics.print(ExtButtonClicks, 5, 25)
      love.graphics.print(clickCoords, 5, 35)

    end
  end

  if scene == "extentions" then
    love.graphics.setBackgroundColor(color.accent.r, color.accent.g, color.accent.b)
    font = love.graphics.newFont(24)

    if screen == "bottom" then -- render bottom screen
      love.graphics.setColor(1,1,1)
      love.graphics.print("Extentions",320 / 2 - font:getWidth("hehe") / 2, 10)
    end
    
    if screen ~= "bottom" then -- render top screen
    love.graphics.setColor(1,1,1)
      love.graphics.draw(icons.n3DS, width / 2 - icons.n3DS:getWidth() / 2 - sysDepth * 5, height / 2 - icons.n3DS:getHeight() / 2)
      love.graphics.print("Placeholder", 165, 60)

      love.graphics.print(screen, 5, 5)
      love.graphics.print(bp, 5, 15)

      love.graphics.print(ExtButtonClicks, 5, 25)
      love.graphics.print(clickCoords, 5, 35)
    end
  end
end

-- !! END OF DRAW !! --

function love.gamepadpressed(joystick, button)
  love.graphics.setColor(0,0,1)
  bp = button
  if scene == "editor" then
    if button == "rightshoulder" then
      depthEnabled = not depthEnabled
      love.graphics.set3D(depthEnabled)
    end

    if button == "x" then
      openExt()
    end
    
    if button == "y" then
      love.keyboard.setTextInput(true, {
        hint = "type word ;)"
      })
    end
    
    if button == "start" then
      love.event.quit()
    end
  end

  if scene == "extentions" then
    if button == "b" then
      closeExt()
    end
  end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  love.graphics.setColor(0,0,0)
  clickCoords = {x,", ",y }
  love.graphics.print(x,y)
  if x > extButton.x and x < extButton.x + extButton.width and
  y < extButton.y and y > extButton.y - extButton.height and extButton.enabled then -- Checks if the mouse is on the button
      openExt()
    end
end

function openExt()
  love.audio.play(sfx.select)
  switchSceneTo("extentions")
  -- love.audio.play(sfx.fadeIn)
  extButton.enabled = false
end

function closeExt()
  love.audio.play(sfx.back)
  switchSceneTo("editor")
  -- love.audio.play(sfx.fadeOut)
  extButton.enabled = true
end

function switchSceneTo(ID)
  scene = ID
end