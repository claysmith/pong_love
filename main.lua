require "collision"

function love.load()
    ball = {}
    ball.x = love.graphics.getWidth()/2
    ball.y = love.graphics.getHeight()/2
    ball.radius = 10
    ball.segments = 25
    ball.xVel = 2
    ball.yVel = 5
    ball.moveSpeed = 10

    player = {}
    player.w = 100
    player.h = 20
    player.x = love.graphics.getWidth()/2 - player.w/2
    player.y = love.graphics.getHeight() - player.h - 10
    player.moveSpeed = 10

    enemy = {}
    enemy.w = 100
    enemy.h = 20
    enemy.x = love.graphics.getWidth()/2 - enemy.w/2
    enemy.y = 10
    enemy.moveSpeed = 10
    enemy.centerX = enemy.x + enemy.w/2

    score = {}
    score.playerScore = 0
    score.enemyScore = 0

    love.window.setTitle("Love Pong")

    font = love.graphics.newFont(14)
    love.graphics.setFont(font)

end
   
   
function love.update(dt)

  updatePlayer(dt)
  updateEnemy(dt)
  updateBall(dt)

end
  
function love.draw()

  drawPlayer()
  drawEnemy()
  drawBall()
  drawScore()
end

function drawBlue()
  love.graphics.setColor(0, 0, 1)
end

function drawRed()
  love.graphics.setColor(1, 0, 0)
end 

function drawPlayer()
  drawBlue()
  love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
end

function drawEnemy()
  drawBlue()
  love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.w, enemy.h)
end

function drawBall()
  drawRed()
  love.graphics.circle("fill", ball.x, ball.y, ball.radius, ball.segments)  
end

function updatePlayer(dt)

  if love.keyboard.isDown("left") then
    player.x = player.x - player.moveSpeed

  end

  if love.keyboard.isDown("right") then
    player.x = player.x + player.moveSpeed

  end

end

function updateEnemy(dt)

  enemy.centerX = enemy.x + (enemy.w/2)

  if ball.x > enemy.centerX then
    enemy.x = enemy.x + enemy.moveSpeed
  end 

  if ball.x < enemy.centerX then
    enemy.x = enemy.x - enemy.moveSpeed
  end 

end

function drawScore()
  drawRed()
  love.graphics.print("Player Score: " .. score.playerScore, 0, 0)
  love.graphics.print("Enemy Score: "  .. score.enemyScore, love.graphics.getWidth()-130,0)

end


function updateBall(dt)

  ball.y = ball.y + ball.yVel
  ball.x = ball.x + ball.xVel

  if boxCircleCollision(player,ball) then
    ball.yVel = -ball.yVel;
  end

  if boxCircleCollision(enemy,ball) then
    ball.yVel = -ball.yVel;
  end

  if (ball.x + ball.radius) > love.graphics.getWidth() then
    ball.xVel = -ball.xVel
  end

  if ball.x < 0 then
    ball.xVel = -ball.xVel
  end

  --handle scoring
  if ball.y < 0 then
    score.playerScore = score.playerScore+1

    ball.x = love.graphics.getWidth()/2
    ball.y = love.graphics.getHeight()/2
  end

  if ball.y > love.graphics.getHeight() then
    score.enemyScore = score.enemyScore+1

    ball.x = love.graphics.getWidth()/2
    ball.y = love.graphics.getHeight()/2
  end


end 