local nest = require("nest").init({ console = "3ds", scale = 1 })
-- local tove = require("tove")
local editor = require("editor")
local stage = require("stage")

stageWidth = 480
stageHeight = 360
stageScale = 1.52
depthEnabled = false
clickCoords = "None"

scene = "editor"
frame = 0

color = {
  accent = {
    purple = {
      r = 133 /255, 
      g = 92 /255,
      b = 214 /255,
    }, 
    blue = {
      r = 77 /255, 
      g = 151 /255,
      b = 255 /255,
    },
    red = {
      r = 255 /255, 
      g = 76 /255,
      b = 76 /255,
    },


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

  -- 3DS
  n3DS = love.graphics.newImage("assets/3ds/n3DS.png"),
  n3DSTrans = love.graphics.newImage("assets/3ds/n3DSTrans.png"),
  o3DS = love.graphics.newImage("assets/3ds/o3DS.png"),
  o3DSTrans = love.graphics.newImage("assets/3ds/o3DSTrans.png"),
  nBottom = love.graphics.newImage("assets/3ds/NBottom.png"),
  nBottomTrans = love.graphics.newImage("assets/3ds/NBottomTrans.png"),
  oBottom = love.graphics.newImage("assets/3ds/OBottom.png"),
  oBottomTrans = love.graphics.newImage("assets/3ds/OBottomTrans.png"),

  -- Icons
  code = love.graphics.newImage("assets/code.png"),
  cost = love.graphics.newImage("assets/costume.png"),
  ext = love.graphics.newImage("assets/ext.png"),
  file = love.graphics.newImage("assets/file.png"),
  set = love.graphics.newImage("assets/setting.png"),
  snd = love.graphics.newImage("assets/snd.png"),
  spr = love.graphics.newImage("assets/spr.png"),
  close = love.graphics.newImage("assets/x1.png"),
}
sfx = {
  select = love.audio.newSource("assets/SFX/Ready.wav", "static"),
  back = love.audio.newSource("assets/SFX/Unready.wav", "static"),


  fadeIn = love.audio.newSource("assets/SFX/fadeIn.wav", "static"),
  fadeOut = love.audio.newSource("assets/SFX/fadeOut.wav", "static"),

  load = love.audio.newSource("assets/SFX/load.wav", "static"),

}

cat = love.graphics.rectangle("fill", 5, 5, 62, 118)
bp = love._os

topPanelY = 40

bottomDimensions = {width=320,height=240}

button = {
  ext = {
    x = 0, 
    y = bottomDimensions.height,
    width = 40, 
    height = 40,
    enabled=true,
    state="normal"
  },
  startMenu = {

    code = {
      x = 12, 
      y = 12 + topPanelY,
      width = bottomDimensions.width - 12 * 2, 
      height = 26,
      enabled=true
    },
    costume = {
      x = 12, 
      y = 12 + 26 + topPanelY,
      width = bottomDimensions.width - 12 * 2, 
      height = 26,
      enabled=true
    },
    sound = {
      x = 12, 
      y = 12 + 26 * 2 + topPanelY,
      width = bottomDimensions.width - 12 * 2, 
      height = 26,
      enabled=true
    },
    sprite = {
      x = 12, 
      y = 12 + 26 * 3 + topPanelY,
      width = bottomDimensions.width - 12 * 2, 
      height = 26,
      enabled=true
    },
    file = {
      x = 12, 
      y = 12 + 26 * 4 + topPanelY,
      width = bottomDimensions.width - 12 * 2, 
      height = 26,
      enabled=true
    },
    setting = {
      x = 12, 
      y = 12 + 26 * 5 + topPanelY,
      width = bottomDimensions.width - 12 * 2, 
      height = 26,
      enabled=true
    },
  }
}

function love.load()
  love.graphics.set3D(depthEnabled)
  bottomDimensions.width, bottomDimensions.height = love.graphics.getDimensions(bottom)
  button.ext = {x = 0, y = bottomDimensions.height, width = 40, height = 40, enabled=true, state="normal"}--Button object

  font = love.graphics.newFont(12)
  
end

function love.draw(screen)
  button.extClicks = scene

  button.startMenu.code.y = 12 + 26 + topPanelY
  button.startMenu.costume.y = 12 + 26 * 2 + topPanelY
  button.startMenu.sound.y = 12 + 26 * 3 + topPanelY
  button.startMenu.sprite.y = 12 + 26 * 4 + topPanelY
  button.startMenu.file.y = 12 + 26 * 5 + topPanelY
  button.startMenu.setting.y = 12 + 26 * 6 + topPanelY


  local sysDepth = love.graphics.getDepth() -- -love.graphics.getDepth()

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
      love.graphics.setColor(color.accent.purple.r, color.accent.purple.g, color.accent.purple.b)
      love.graphics.rectangle("fill", button.ext.x, button.ext.y - button.ext.height, button.ext.width, button.ext.height)    
      love.graphics.setColor(1,1,1)

      love.graphics.draw(icons.ext, button.ext.width / 2 + button.ext.x - icons.ext:getWidth() / 2 , button.ext.y - button.ext.height / 2 - icons.ext:getHeight() / 2 )
    end
    
    if screen ~= "bottom" then -- render top screen
      love.graphics.setColor(195/255, 204/255, 217/255)
      love.graphics.rectangle("line", width / 2 - stageWidth/stageScale/2, height / 2 - stageHeight/stageScale/2 , stageWidth/stageScale, stageHeight/stageScale)
      love.graphics.setColor(0.5,0.5,0.5)
      love.graphics.rectangle("fill", width / 2 - 62/stageScale/2, height/2  - 118/stageScale/2, 62/stageScale, 118/stageScale) 
      love.graphics.print(screen, 5, 5)
      love.graphics.print(bp, 5, 15)
      love.graphics.print(button.ext.state, 5, 45)

      love.graphics.print(button.extClicks, 5, 25)
      love.graphics.print(clickCoords, 5, 35)

    end
  end

  if scene == "extentions" then
    love.graphics.setBackgroundColor(color.accent.purple.r, color.accent.purple.g, color.accent.purple.b, topPanelY / -40 + 0.5)

    if screen == "bottom" then -- render bottom screen
      love.graphics.setColor(1,1,1)
      love.graphics.print("Extentions", 320 / 2 - font:getWidth("Extentions") / 2, 10 - topPanelY)

      love.graphics.setColor(1,1,1)
      love.graphics.rectangle("fill", button.ext.x, button.ext.y - button.ext.height, button.ext.width, button.ext.height)    
      love.graphics.setColor(color.accent.purple.r, color.accent.purple.g, color.accent.purple.b)

      love.graphics.draw(icons.close, button.ext.width / 2 + button.ext.x - icons.close:getWidth() / 2 , button.ext.y - button.ext.height / 2 - icons.close:getHeight() / 2 )
    end
    
    if screen ~= "bottom" then -- render top screen

      love.graphics.setColor(1,1,1)
      love.graphics.draw(icons.n3DS, width / 2 - icons.n3DS:getWidth() / 2 - sysDepth * 5, height / 2 - icons.n3DS:getHeight() / 2 + topPanelY)
      topPanelY = topPanelY / 1.4
      love.graphics.print("Placeholder", 165, 60 + topPanelY / 2)

      love.graphics.print(screen, 5, 5)
      love.graphics.print(bp, 5, 15)

      love.graphics.print(button.extClicks, 5, 25)
      love.graphics.print(clickCoords, 5, 35)

    end
  end

  if scene == "settings" then
    love.graphics.setBackgroundColor(color.accent.purple.r, color.accent.purple.g, color.accent.purple.b, topPanelY / -40 + 0.5)

    if screen == "bottom" then -- render bottom screen
      love.graphics.setColor(1,1,1)
      love.graphics.print("Settings", 320 / 2 - font:getWidth("Settings") / 2, 10 - topPanelY)

      love.graphics.setColor(1,1,1)
      love.graphics.rectangle("fill", button.ext.x, button.ext.y - button.ext.height, button.ext.width, button.ext.height)    
      love.graphics.setColor(color.accent.purple.r, color.accent.purple.g, color.accent.purple.b)

      love.graphics.draw(icons.close, button.ext.width / 2 + button.ext.x - icons.close:getWidth() / 2 , button.ext.y - button.ext.height / 2 - icons.close:getHeight() / 2 )
    end
    
    if screen ~= "bottom" then -- render top screen

      love.graphics.setColor(1,1,1)
      love.graphics.draw(icons.n3DS, width / 2 - icons.n3DS:getWidth() / 2 - sysDepth * 5, height / 2 - icons.n3DS:getHeight() / 2 + topPanelY)
      topPanelY = topPanelY / 1.4
      love.graphics.print("Placeholder", 165, 60 + topPanelY / 2)

      love.graphics.print(screen, 5, 5)
      love.graphics.print(bp, 5, 15)

      love.graphics.print(button.extClicks, 5, 25)
      love.graphics.print(clickCoords, 5, 35)

    end
  end



  if scene == "startMenu" then
    if screen == "bottom" then -- render bottom screen
      love.graphics.setColor(229/255,240/255,1)
      love.graphics.rectangle("fill", 0,0, width, 30)
      love.graphics.setColor(195/255, 204/255, 217/255)
      love.graphics.line(0, 31, width, 31)
      love.graphics.rectangle("line", 0, 31, 40, height)

      love.graphics.setColor(color.accent.purple.r, color.accent.purple.g, color.accent.purple.b)
      love.graphics.rectangle("fill", button.ext.x, button.ext.y - button.ext.height, button.ext.width, button.ext.height)    
      love.graphics.setColor(1,1,1)

      love.graphics.draw(icons.ext, button.ext.width / 2 + button.ext.x - icons.ext:getWidth() / 2 , button.ext.y - button.ext.height / 2 - icons.ext:getHeight() / 2 )

      love.graphics.setColor(0,0,0,topPanelY / -40 + 0.7)
      love.graphics.rectangle("fill", 0,0, width, height) 
      love.graphics.setColor(color.accent.purple.r,color.accent.purple.g,color.accent.purple.b)
      love.graphics.rectangle("fill", 10,10 + topPanelY, 320 - 20, 240 - 20) 
      love.graphics.setColor(1,1,1, 0.2)
      love.graphics.rectangle("line", 11,11 + topPanelY, 320 - 22, 240 - 22) 
      topPanelY = topPanelY / 1.4

      -- !! Buttons start here !! --

      -- code
      love.graphics.setColor(0,0,0,0.1)
      love.graphics.rectangle("fill", button.startMenu.code.x,button.startMenu.code.y - button.startMenu.code.height, button.startMenu.code.width, button.startMenu.code.height) 
      love.graphics.setColor(1,1,1)

      love.graphics.draw(icons.code, button.startMenu.code.x + 5, button.startMenu.code.y + 2 - button.startMenu.code.height)
      love.graphics.print("Code", button.startMenu.code.x + 30,button.startMenu.code.y + 5 - button.startMenu.code.height)

      -- costume
      love.graphics.setColor(0,0,0,0)
      love.graphics.rectangle("fill", button.startMenu.costume.x,button.startMenu.costume.y - button.startMenu.code.height, button.startMenu.costume.width, button.startMenu.costume.height) 
      love.graphics.setColor(1,1,1)

      love.graphics.draw(icons.cost, button.startMenu.costume.x + 5, button.startMenu.costume.y + 2 - button.startMenu.code.height)
      love.graphics.print("Costumes", button.startMenu.costume.x + 30,button.startMenu.costume.y + 5 - button.startMenu.code.height)

      -- sound
      love.graphics.setColor(0,0,0,0.1)
      love.graphics.rectangle("fill", button.startMenu.sound.x,button.startMenu.sound.y - button.startMenu.code.height, button.startMenu.sound.width, button.startMenu.sound.height) 
      love.graphics.setColor(1,1,1)

      love.graphics.draw(icons.snd, button.startMenu.sound.x + 5, button.startMenu.sound.y + 2 - button.startMenu.code.height)
      love.graphics.print("Sounds", button.startMenu.sound.x + 30,button.startMenu.sound.y + 5 - button.startMenu.code.height)

      -- sprite
      love.graphics.setColor(0,0,0,0)
      love.graphics.rectangle("fill", button.startMenu.sprite.x,button.startMenu.sprite.y - button.startMenu.code.height, button.startMenu.sprite.width, button.startMenu.sprite.height) 
      love.graphics.setColor(1,1,1)

      love.graphics.draw(icons.spr, button.startMenu.sprite.x + 5, button.startMenu.sprite.y + 2 - button.startMenu.code.height)
      love.graphics.print("Sprites", button.startMenu.sprite.x + 30,button.startMenu.sprite.y + 5 - button.startMenu.code.height)

      -- file
      love.graphics.setColor(0,0,0,0.1)
      love.graphics.rectangle("fill", button.startMenu.file.x,button.startMenu.file.y - button.startMenu.code.height, button.startMenu.file.width, button.startMenu.file.height) 
      love.graphics.setColor(1,1,1)

      love.graphics.draw(icons.file, button.startMenu.file.x + 5, button.startMenu.file.y + 2 - button.startMenu.code.height)
      love.graphics.print("File", button.startMenu.file.x + 30,button.startMenu.file.y + 5 - button.startMenu.code.height)

      -- settings
      love.graphics.setColor(0,0,0,0)
      love.graphics.rectangle("fill", button.startMenu.setting.x,button.startMenu.setting.y - button.startMenu.code.height, button.startMenu.setting.width, button.startMenu.setting.height) 
      love.graphics.setColor(1,1,1)

      love.graphics.draw(icons.set, button.startMenu.setting.x + 5, button.startMenu.setting.y + 2 - button.startMenu.code.height)
      love.graphics.print("Settings", button.startMenu.setting.x + 30,button.startMenu.setting.y + 5 - button.startMenu.code.height)

    end
    
    if screen ~= "bottom" then -- render top screen
      love.graphics.setColor(195/255, 204/255, 217/255)
      love.graphics.rectangle("line", width / 2 - stageWidth/stageScale/2, height / 2 - stageHeight/stageScale/2 , stageWidth/stageScale, stageHeight/stageScale)
      love.graphics.setColor(0.5,0.5,0.5)
      love.graphics.rectangle("fill", width / 2 - 62/stageScale/2, height/2  - 118/stageScale/2, 62/stageScale, 118/stageScale) 

      love.graphics.setColor(0,0,0,topPanelY / -40 + 0.7)

      love.graphics.rectangle("fill", 0,0, width, height) 

      love.graphics.setColor(1,1,1)

      love.graphics.print(screen, 5, 5)
      love.graphics.print(bp, 5, 15)

      love.graphics.print(button.extClicks, 5, 25)
      love.graphics.print(clickCoords, 5, 35)

      love.graphics.setColor(color.accent.purple.r,color.accent.purple.g,color.accent.purple.b)
      love.graphics.rectangle("fill", 0,height - 40 + topPanelY, width, 40) 
      love.graphics.setColor(1,1,1)
      love.graphics.setFont(font)
      love.graphics.print("Select Menu", width / 2 - font:getWidth("Select Menu") / 2, height - 20 - font:getHeight() / 2 + topPanelY / 2)
    end
  end
end

function love.update()

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
      --love.keyboard.setTextInput(true, {
      --  hint = "type word ;)"
      --})
      save()
    end
    
    if button == "start" then
      love.event.quit()
    end
    if button == "select" then
      startMenu("open")
    end
  end

  if scene == "extentions" then
    if button == "b" then
      closeExt()
    end

    if button == "y" then
      success = love.system.openURL( "https://scratch.mit.edu/" )
    end
  end

  if scene == "startMenu" then
    if button == "b" then
      startMenu("close")
    end
  end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  love.graphics.setColor(0,0,0)
  clickCoords = {x,", ",y }
  love.graphics.print(x,y)
  -- extentions
  if x > button.ext.x and x < button.ext.x + button.ext.width and y < button.ext.y and y > button.ext.y - button.ext.height and button.ext.enabled then -- Checks if the mouse is on the button
    if button.ext.state == "normal" then
      openExt()
    end
    if button.ext.state == "close" then
      closeExt()
    end
  end
  -- file
  if x > button.startMenu.file.x and x < button.startMenu.file.x + button.startMenu.file.width and y < button.startMenu.file.y and y > button.startMenu.file.y - button.startMenu.file.height then 
    clickCoords = {x,", ",y, ":file"}
    startMenu("close")
    save()
  end
  -- settings
  if x > button.startMenu.setting.x and x < button.startMenu.setting.x + button.startMenu.setting.width and y < button.startMenu.setting.y and y > button.startMenu.setting.y - button.startMenu.setting.height then 
    topPanelY = 30
    switchSceneTo("settings")
  end
end

function openExt()
  topPanelY = 20
  love.audio.play(sfx.select)
  switchSceneTo("extentions")
  -- love.audio.play(sfx.fadeIn)
  button.ext.state = "close"
end

function closeExt()
  love.audio.play(sfx.back)
  switchSceneTo("editor")
  -- love.audio.play(sfx.fadeOut)
  button.ext.state = "normal"
end

function startMenu(state)
  if state == "open" then
    topPanelY = 20
    switchSceneTo("startMenu")
    love.audio.play(sfx.fadeIn)
  end
  if state == "close" then
    switchSceneTo("editor")
    love.audio.play(sfx.fadeOut)
  end
end

function switchSceneTo(ID)
  scene = ID
end

function save()
  love.audio.play(sfx.load)
  savefolder = "projects"
  saveLocation = "./"..savefolder.."/"

  if not love.filesystem.getInfo(saveLocation) then
    love.filesystem.createDirectory(savefolder)
  end

  local saveFile = saveLocation.."save.txt"
  love.filesystem.write(saveFile, "The words are not important to the plot.")

  local error = nil

  saveFile, error = love.filesystem.read(saveFile)

  print(error)
  love.audio.stop(sfx.load)
end