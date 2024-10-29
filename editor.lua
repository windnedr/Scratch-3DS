function love.draw(scren)
  if screen ~= "bottom" then
    love.graphics.setColor(0,0,0)
    love.graphics.print("hi", 50,  50)
  end
end
