local nest = require("nest").init({ console = "3ds", scale = 1 })
local json = require("json")

stageWidth = 480
stageHeight = 360
stageScale = 1.52
depthEnabled = false
clickCoords = "None"

scene = "editor:code"
frame = 0

theLog = "## LOG ##"
prevScene = nil

scroll = 0

projData = {
  targets ={{
    isStage = true,
    name = "Stage",
    variables = {myvariable = {"my variable",0}},
    lists = {},
    broadcasts = {},
    blocks = {},
    comments = {},
    currentCostume = 0,
    costumes = {{
      name = "backdrop1",
      dataFormat = "png",
      assetId = nil,
      md5ext = nil
    }},
    sounds = {{}},
    volume = 100,
    layerOrder = 0,
    tempo = 60,
    videoTransparency = 50,
    videoState = "on",
    textToSpeechLanguage = nil,
    visible = true,
    x = 0,
    y = 0,
    size = 100,
    direction = 90,
    draggable = false,
    rotationStyle = "all around"
  }},
  monitors = {},
  extensions = {},
  meta = {
    semver = "3.0.0",
    vm = "4.8.32",
    agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
  }
}

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
    orange = {
      r = 255 /255, 
      g = 140 /255,
      b = 26 /255,
    },
    black = {
      r = 29 /255, 
      g = 40 /255,
      b = 61 /255,
    },
  }, bg = {
    r = 1, 
    g = 1,
    b = 1,
  },
}

currentAccent = color.accent.purple

sceneList = {
  "editor:code", "extentions"
}

icons = {
  scr3DS = love.graphics.newImage("assets/scr3DSwordmark.png"),

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
  closeStart = love.graphics.newImage("assets/xStart.png"),
  new = love.graphics.newImage("assets/+.png"),
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
    backToProjList = {
      x = 12, 
      y = 12 + 26 * 6 + topPanelY,
      width = bottomDimensions.width - 12 * 2, 
      height = 26,
      enabled=true
    },
  },
  settings = {
    accent = {
      x = 12, 
      y = 12 + topPanelY,
      width = bottomDimensions.width - 12 * 2, 
      height = 26,
      enabled=true,

      red = {
        x = 12, 
        y = 12 + 26 * 1 + topPanelY,
        width = bottomDimensions.width - 12 * 2, 
        height = 26,
        enabled=true
      },
      blue = {
        x = 12,
        y = 12 + 26 * 2 + topPanelY,
        width = bottomDimensions.width - 12 * 2, 
        height = 26,
        enabled=true
      },
      purple = {
        x = 12, 
        y = 12 + 26 * 3 + topPanelY,
        width = bottomDimensions.width - 12 * 2, 
        height = 26,
        enabled=true
      },
      orange = {
        x = 12, 
        y = 12 + 26 * 3 + topPanelY,
        width = bottomDimensions.width - 12 * 2, 
        height = 26,
        enabled=true
      },
    },
  },
}

-- !!        THIS HANDLES SB3 FILES DIRECTLY         !! --
-- !! DO NOT EDIT UNLESS YOU KNOW WHAT YOU'RE DOING. !! --

projData = {
  targets ={{
    isStage = true,
    name = "Stage",
    variables = {myvariable={"the",0}},
    lists = {list={"list",{}}},
    broadcasts = {message1 = "message1"},
    blocks = {
      a = {
        opcode = "event_whenflagclicked",
        next = nil,
        parent = nil,
        inputs = nil,
        fields = nil,
        shadow = false,
        topLevel = true,
        x = 0,
        y = 0,
      }
    },
    comments = {a = {
      blockId = nil,
      x = 100,
      y = 100,
      width = 200,
      height = 200,
      minimized = false,
      text = "This is a comment"
    }},
    currentCostume = 0,
    costumes = {{
      name = "backdrop1",
      dataFormat = "png",
      assetId = "cd21514d0531fdffb22204e0ec5ed84a",
      md5ext = nil
    }},
    sounds = {},
    volume = 100,
    layerOrder = 0,
    tempo = 60,
    videoTransparency = 50,
    videoState = "on",
    textToSpeechLanguage = nil,
    visible = true,
    x = 0,
    y = 0,
    size = 100,
    direction = 90,
    draggable = false,
    rotationStyle = "all around"
  }},
  monitors = {},
  extensions = {},
  meta = {
    semver = "3.0.0",
    vm = "4.8.32",
    agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36",
    platform = {
      name = "Scratch-3DS",
      url = "https://github.com/windnedr/scratch-3ds"
    }
  }
}

function love.load()
  if love._console == "3ds" then
    love.graphics.set3D(depthEnabled)
  end
  bottomDimensions.width, bottomDimensions.height = love.graphics.getDimensions(bottom)
  button.ext = {x = 0, y = bottomDimensions.height, width = 40, height = 40, enabled=true, state="normal"}--Button object

  font = love.graphics.newFont(12)
  fontBig = love.graphics.newFont(24)

  log("Load")

  json.decode("{}")

  log(love._console.." running on: "..love._os)
  log(projData.targets[1].variables.myvariable[1])
  
end

function love.draw(screen)
  button.extClicks = scene

  button.startMenu.code.y = 12 + 26 + topPanelY
  button.startMenu.costume.y = 12 + 26 * 2 + topPanelY
  button.startMenu.sound.y = 12 + 26 * 3 + topPanelY
  button.startMenu.sprite.y = 12 + 26 * 4 + topPanelY
  button.startMenu.file.y = 12 + 26 * 5 + topPanelY
  button.startMenu.setting.y = 12 + 26 * 6 + topPanelY
  button.startMenu.backToProjList.y = 12 + 26 * 7 + topPanelY

  button.settings.y = 12 + topPanelY

  button.settings.accent.y = 12 + 30 * 1 + topPanelY

  button.settings.accent.red.y = 12 + 30 * 1 + topPanelY
  button.settings.accent.blue.y = 12 + 30 * 2 + topPanelY
  button.settings.accent.purple.y = 12 + 30 * 3 + topPanelY
  button.settings.accent.orange.y = 12 + 30 * 4 + topPanelY



  local sysDepth = love.graphics.getDepth() -- -love.graphics.getDepth()

  local width, height = love.graphics.getDimensions(screen)
  if love._console == "3ds" then
    depthSlider = math.floor(love.graphics.getDepth() * 100)
  else
    depthSlider = 0
  end
  love.graphics.setBackgroundColor(1,1,1)

  frame = frame + 1

  if screen == "right" then
    sysDepth = -sysDepth
  end

  if scene == "editor:code" then
    if screen == "bottom" then -- render bottom screen
    
      love.graphics.setColor(229/255,240/255,1)
      love.graphics.rectangle("fill", 0,0, width, 30)
      love.graphics.setColor(195/255, 204/255, 217/255)
      love.graphics.line(0, 31, width, 31)
      love.graphics.rectangle("line", 0, 31, 40, height)

      -- Extentions Button
      love.graphics.setColor(currentAccent.r, currentAccent.g, currentAccent.b)
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
    love.graphics.setBackgroundColor(currentAccent.r, currentAccent.g, currentAccent.b, topPanelY / -40 + 0.5)

    if screen == "bottom" then -- render bottom screen
      love.graphics.setColor(1,1,1)
      love.graphics.print("Choose an Extention", 320 / 2 - font:getWidth("Choose an Extention") / 2, 10 - topPanelY)

      love.graphics.setColor(1,1,1)
      love.graphics.rectangle("fill", button.ext.x, button.ext.y - button.ext.height, button.ext.width, button.ext.height)    
      love.graphics.setColor(currentAccent.r, currentAccent.g, currentAccent.b)

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
    love.graphics.setBackgroundColor(currentAccent.r, currentAccent.g, currentAccent.b, topPanelY / -40 + 0.5)

    if screen == "bottom" then -- render bottom screen
      love.graphics.setColor(1,1,1)
      love.graphics.setColor(1,1,1)
      love.graphics.rectangle("fill", button.ext.x, button.ext.y - button.ext.height, button.ext.width, button.ext.height)    
      love.graphics.setColor(currentAccent.r, currentAccent.g, currentAccent.b)

      love.graphics.draw(icons.close, button.ext.width / 2 + button.ext.x - icons.close:getWidth() / 2 , button.ext.y - button.ext.height / 2 - icons.close:getHeight() / 2 )

      -- !! Buttons !! --

      -- code
      love.graphics.setColor(1,1,1,0.3)
      love.graphics.rectangle("fill", button.settings.accent.x,button.settings.accent.y - button.settings.accent.height, button.settings.accent.width, button.settings.accent.height) 
      love.graphics.setColor(1,1,1)

      love.graphics.draw(icons.cost, button.settings.accent.x + 5, button.settings.accent.y + 2 - button.settings.accent.height)
      love.graphics.print("Accent", button.settings.accent.x + 30,button.settings.accent.y + 5 - button.settings.accent.height)
    end
    
    if screen ~= "bottom" then -- render top screen

      love.graphics.setColor(1,1,1)
      love.graphics.setFont(fontBig)
      love.graphics.print("Settings", width / 2 - fontBig:getWidth("Settings") / 2, height - fontBig:getHeight() - 5 - topPanelY)
      love.graphics.setFont(font)


      love.graphics.draw(icons.set, width - icons.set:getWidth() - 5, height - icons.set:getHeight() + topPanelY - 5)
      topPanelY = topPanelY / 1.4

      love.graphics.print(screen, 5, 5)
      love.graphics.print(bp, 5, 15)

      love.graphics.print(button.extClicks, 5, 25)
      love.graphics.print(clickCoords, 5, 35)

    end
  end

  if scene == "settings:accent" then
    love.graphics.setBackgroundColor(currentAccent.r, currentAccent.g, currentAccent.b, topPanelY / -40 + 0.5)

    if screen == "bottom" then -- render bottom screen
      love.graphics.setColor(1,1,1)
      love.graphics.setColor(1,1,1)
      love.graphics.rectangle("fill", button.ext.x, button.ext.y - button.ext.height, button.ext.width, button.ext.height)    
      love.graphics.setColor(currentAccent.r, currentAccent.g, currentAccent.b)

      love.graphics.draw(icons.close, button.ext.width / 2 + button.ext.x - icons.close:getWidth() / 2 , button.ext.y - button.ext.height / 2 - icons.close:getHeight() / 2 )

      -- !! Buttons !! --

      -- red
      love.graphics.setColor(color.accent.red.r, color.accent.red.g, color.accent.red.b)
      love.graphics.rectangle("fill", button.settings.accent.red.x,button.settings.accent.red.y - button.settings.accent.red.height, button.settings.accent.red.width, button.settings.accent.red.height) 
      love.graphics.setColor(1,1,1)
      love.graphics.print("Turbowarp Red", button.settings.accent.red.x + 30,button.settings.accent.red.y + 5 - button.settings.accent.red.height)

      -- blue
      love.graphics.setColor(color.accent.blue.r, color.accent.blue.g, color.accent.blue.b)
      love.graphics.rectangle("fill", button.settings.accent.blue.x,button.settings.accent.blue.y - button.settings.accent.blue.height, button.settings.accent.blue.width, button.settings.accent.blue.height) 
      love.graphics.setColor(1,1,1)
      love.graphics.print("Scratch Blue", button.settings.accent.blue.x + 30,button.settings.accent.blue.y + 5 - button.settings.accent.blue.height)

      -- purple
      love.graphics.setColor(color.accent.purple.r, color.accent.purple.g, color.accent.purple.b)
      love.graphics.rectangle("fill", button.settings.accent.purple.x,button.settings.accent.purple.y - button.settings.accent.purple.height, button.settings.accent.purple.width, button.settings.accent.purple.height) 
      love.graphics.setColor(1,1,1)
      love.graphics.print("Scratch Purple", button.settings.accent.purple.x + 30,button.settings.accent.purple.y + 5 - button.settings.accent.purple.height)

      -- purple
      love.graphics.setColor(color.accent.orange.r, color.accent.orange.g, color.accent.orange.b)
      love.graphics.rectangle("fill", button.settings.accent.orange.x,button.settings.accent.orange.y - button.settings.accent.orange.height, button.settings.accent.orange.width, button.settings.accent.orange.height) 
      love.graphics.setColor(1,1,1)
      love.graphics.print("Scratch Orange", button.settings.accent.orange.x + 30,button.settings.accent.orange.y + 5 - button.settings.accent.orange.height)
    end
    
    if screen ~= "bottom" then -- render top screen

      love.graphics.setColor(1,1,1)
      love.graphics.setFont(fontBig)
      love.graphics.print("Settings / Accent", width / 2 - fontBig:getWidth("Settings / Accent") / 2, height - fontBig:getHeight() - 5 - topPanelY)
      love.graphics.setFont(font)

      love.graphics.draw(icons.set, width - icons.set:getWidth() - 5, height - icons.set:getHeight() + topPanelY - 5)
      topPanelY = topPanelY / 1.4

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

      love.graphics.setColor(currentAccent.r, currentAccent.g, currentAccent.b)
      love.graphics.rectangle("fill", button.ext.x, button.ext.y - button.ext.height, button.ext.width, button.ext.height)    
      love.graphics.setColor(1,1,1)

      love.graphics.draw(icons.ext, button.ext.width / 2 + button.ext.x - icons.ext:getWidth() / 2 , button.ext.y - button.ext.height / 2 - icons.ext:getHeight() / 2 )

      love.graphics.setColor(0,0,0,topPanelY / -40 + 0.7)
      love.graphics.rectangle("fill", 0,0, width, height) 
      love.graphics.setColor(currentAccent.r,currentAccent.g,currentAccent.b)
      love.graphics.rectangle("fill", 10,10 + topPanelY, 320 - 20, 240 - 20) 
      love.graphics.setColor(1,1,1, 0.2)
      love.graphics.rectangle("line", 11,11 + topPanelY, 320 - 22, 240 - 22) 

      if scene == "startMenu" then
        topPanelY = topPanelY / 1.4
      end

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

      -- back to project list
      love.graphics.setColor(0,0,0,0.1)
      love.graphics.rectangle("fill", button.startMenu.backToProjList.x,button.startMenu.backToProjList.y - button.startMenu.code.height, button.startMenu.backToProjList.width, button.startMenu.backToProjList.height) 
      love.graphics.setColor(1,1,1)

      love.graphics.draw(icons.closeStart, button.startMenu.backToProjList.x + 5, button.startMenu.backToProjList.y + 2 - button.startMenu.code.height)
      love.graphics.print("Quit to Project List", button.startMenu.backToProjList.x + 30,button.startMenu.backToProjList.y + 5 - button.startMenu.code.height)

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

      love.graphics.setColor(currentAccent.r,currentAccent.g,currentAccent.b)
      love.graphics.rectangle("fill", 0,height - 40 + topPanelY, width, 40) 
      love.graphics.setColor(1,1,1)
      love.graphics.setFont(font)
      love.graphics.print("Select Menu", width / 2 - font:getWidth("Select Menu") / 2, height - 20 - font:getHeight() / 2 + topPanelY / 2)
    end
  end

  if scene == "projectList" then
    love.graphics.setBackgroundColor(currentAccent.r, currentAccent.g, currentAccent.b)

    if screen == "bottom" then -- render bottom screen      
      button.ext.state = "newProj"
      -- !! Buttons !! --
      love.graphics.setColor(1,1,1)
      love.graphics.rectangle("fill", button.ext.x, button.ext.y - button.ext.height, button.ext.width, button.ext.height)    
      love.graphics.setColor(currentAccent.r, currentAccent.g, currentAccent.b)

      love.graphics.draw(icons.new, button.ext.width / 2 + button.ext.x - icons.close:getWidth() / 2 , button.ext.y - button.ext.height / 2 - icons.close:getHeight() / 2 )

      love.graphics.draw(icons.code, button.settings.accent.x + 5, button.settings.accent.y + 2 - button.settings.accent.height)
      love.graphics.print("Accent", button.settings.accent.x + 30,button.settings.accent.y + 5 - button.settings.accent.height)
    end
    
    if screen ~= "bottom" then -- render top screen
      love.graphics.setColor(1,1,1)

      love.graphics.draw(icons.scr3DS, width / 2 - icons.scr3DS:getWidth() / 2, height / 2 - icons.scr3DS:getHeight() / 2)
      topPanelY = topPanelY / 1.4

      love.graphics.print(screen, 5, 5)
      love.graphics.print(bp, 5, 15)

      love.graphics.print(button.extClicks, 5, 25)
      love.graphics.print(clickCoords, 5, 35)

    end
  end

  if scene == "console" then
    if screen ~= "bottom" then -- render top screen
      love.graphics.setColor(0,0,0,1)
      love.graphics.rectangle("fill", 0,0, width, height)
      love.graphics.setColor(1,1,1)
      love.graphics.print(theLog, 0, scroll)
    end

    if screen == "bottom" then -- render bottom screen
      love.graphics.setColor(0,0,0,1)
      love.graphics.rectangle("fill", 0,0, width, height)
      love.graphics.setColor(1,1,1)
      love.graphics.print("Press B to Exit. \n Y to reset Scroll. \n DP to scroll. \n X to Save", 0,0)
    end
  end
end

function love.update()

end

-- !! END OF DRAW !! --

function love.gamepadpressed(joystick, button)
--  log(button.." pressed")
  love.graphics.setColor(0,0,1)
  bp = button

  if button == "leftshoulder" then
    openConsole()
  end

  if scene == "editor:code" then
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
      save("proj")
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

  if scene == "settings:accent" then
    if button == "b" then
      love.audio.play(sfx.back)
      scene = "settings"
    end
  end

  if scene == "settings" then
    if button == "b" then
      love.audio.play(sfx.back)
      scene = "editor:code"
    end
  end

  if scene == "console" then
    if button == "b" then
      scene = prevScene
    end
    if button == "dpup" then
      if scroll + 10 <= 0 then
        scroll = scroll + 10
        else
          scroll = 0
        end
    end
    if button == "dpdown" then
      scroll = scroll - 10
    end
    if button == "y" then
      scroll = 0
    end
    if button == "x" then
      save("log")
    end
  end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  love.graphics.setColor(0,0,0)
  clickCoords = {x,", ",y }
  love.graphics.print(x,y)

  -- extentions
  if scene == "editor:code" or scene == "extentions" or scene == "projectList" then
    if x > button.ext.x and x < button.ext.x + button.ext.width and y < button.ext.y and y > button.ext.y - button.ext.height and button.ext.enabled then -- Checks if the mouse is on the button
      if button.ext.state == "normal" then
        openExt()
      end
      if button.ext.state == "close" then
        closeExt()
      end
      if button.ext.state == "newProj" then
        love.audio.play(sfx.select)
      end
    end
  end

  if scene == "startMenu" then
    -- file
    if x > button.startMenu.file.x and x < button.startMenu.file.x + button.startMenu.file.width and y < button.startMenu.file.y and y > button.startMenu.file.y - button.startMenu.file.height then 
      clickCoords = {x,", ",y, ":file"}
      love.audio.play(sfx.select)
      startMenu("close")
      save("proj")
    end
    -- settings
    if x > button.startMenu.setting.x and x < button.startMenu.setting.x + button.startMenu.setting.width and y < button.startMenu.setting.y and y > button.startMenu.setting.y - button.startMenu.setting.height then 
      topPanelY = 30
      love.audio.play(sfx.select)
      switchSceneTo("settings")
    end
  end

  if scene == "settings" then
    -- settings : accent
    if x > button.settings.accent.x and x < button.settings.accent.x + button.settings.accent.width and y < button.settings.accent.y and y > button.settings.accent.y - button.settings.accent.height then 
      topPanelY = 30
      love.audio.play(sfx.select)
      switchSceneTo("settings:accent")
      button.settings.accent.enabled = false
    end
  end

  if scene == "settings:accent" then

    -- settings : accent : red
    if x > button.settings.accent.red.x and x < button.settings.accent.red.x + button.settings.accent.red.width and y < button.settings.accent.red.y and y > button.settings.accent.red.y - button.settings.accent.red.height then 
      currentAccent = color.accent.red
      love.audio.play(sfx.select)
    end

    -- settings : accent : purple
    if x > button.settings.accent.purple.x and x < button.settings.accent.purple.x + button.settings.accent.purple.width and y < button.settings.accent.purple.y and y > button.settings.accent.purple.y - button.settings.accent.purple.height then 
      currentAccent = color.accent.purple
      love.audio.play(sfx.select)
    end

    -- settings : accent : blue
    if x > button.settings.accent.blue.x and x < button.settings.accent.blue.x + button.settings.accent.blue.width and y < button.settings.accent.blue.y and y > button.settings.accent.blue.y - button.settings.accent.blue.height then 
      currentAccent = color.accent.blue
      love.audio.play(sfx.select)
    end

    -- settings : accent : orange
    if x > button.settings.accent.orange.x and x < button.settings.accent.orange.x + button.settings.accent.orange.width and y < button.settings.accent.orange.y and y > button.settings.accent.orange.y - button.settings.accent.orange.height then 
      currentAccent = color.accent.orange
      love.audio.play(sfx.select)
    end
  end
end

function openExt()
  log("ext opened!")
  topPanelY = 20
  love.audio.play(sfx.select)
  switchSceneTo("extentions")
  -- love.audio.play(sfx.fadeIn)
  button.ext.state = "close"
end

function closeExt()
  log("ext closed!")
  love.audio.play(sfx.back)
  switchSceneTo("editor:code")
  -- love.audio.play(sfx.fadeOut)
  button.ext.state = "normal"
end

function startMenu(state)
  log("startMenu() called with "..state)
  if state == "open" then
    topPanelY = 20
    switchSceneTo("startMenu")
    love.audio.play(sfx.fadeIn)
  end
  if state == "close" then
    switchSceneTo("editor:code")
    love.audio.play(sfx.fadeOut)
  end
end

function switchSceneTo(ID)
  scene = ID
end

function save(type)
  log("## STARTING SAVE "..type.."##")
  love.audio.play(sfx.load)

  if type == "proj" then 
    love.keyboard.setTextInput(true)
    savefolder = "projects"
    saveLocation = "/"..savefolder.."/"
    log("Saving in "..saveLocation)

    if not love.filesystem.getInfo(saveLocation) then
      love.filesystem.createDirectory(savefolder)
      log("Creating dir: "..saveLocation)
    end

    local saveFile = saveLocation.."project.json"
    love.filesystem.write(saveFile, json.encode(projData))

    local error = nil

    saveFile, error = love.filesystem.read(saveFile)

    log(error)
    love.window.showMessageBox( "Error!", error)

    if error == 40 then
      log("## SAVED SUCCESSFULLY ##")
    end
    if not love._os == "Horizon" or "cafe" then
      love.system.openURL("file://"..love.filesystem.getSaveDirectory()..saveLocation)
    end
  end

  if type == "log" then 
    savefolder = "logs"
    saveLocation = "/"..savefolder.."/"
    log("Saving in "..saveLocation)

    if not love.filesystem.getInfo(saveLocation) then
      love.filesystem.createDirectory(savefolder)
      log("Creating dir: "..saveLocation)
    end

    local saveFile = saveLocation..os.date("%b%d%Y-%I-%M-%S")..".txt"

    success, message = love.filesystem.write(saveFile, theLog)

    local error = nil

    saveFile, error = love.filesystem.read(saveFile)

    log(error)
    love.window.showMessageBox( "Error!", error)
    log("Log can be found: "..love.filesystem.getSaveDirectory()..saveLocation)

    if error == 40 then
      log("## SAVED SUCCESSFULLY ##")
    end
    if not love._os == "Horizon" or "cafe" then
      love.system.openURL("file://"..love.filesystem.getSaveDirectory()..saveLocation)
    end
  end
  love.audio.stop(sfx.load)
end

function openConsole()
  scroll = 0
  prevScene = scene
  switchSceneTo("console")
end

function log(message)
  theLog = theLog.."\n"..message
end