require "collision"

function love.load()
    ball = {}
    ball.x = love.graphics.getWidth()/2
    ball.y = love.graphics.getHeight()/2
    ball.radius = 10
    ball.segments = 25

    ball.additionMoveSpeed = 0

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
    enemy.moveSpeed = 6
    enemy.centerX = enemy.x + enemy.w/2

    score = {}
    score.playerScore = 0
    score.enemyScore = 0

    love.window.setTitle("Love Pong")

    font = love.graphics.newFont(14)
    love.graphics.setFont(font)

    bounceSnd = love.audio.newSource("bounce.mp3","static")


    initGame()

end
   
function initGame()
  ball.x = love.graphics.getWidth()/2
  ball.y = love.graphics.getHeight()/2

  ball.xVel = math.random(2,5)
  ball.yVel = math.random(3,6)

  if math.random(1,2) == 1 then
    ball.xVel = -ball.xVel
  end

  if math.random(1,2) == 1 then
    ball.yVel = -ball.yVel;
  end

  player.x = love.graphics.getWidth()/2 - player.w/2
  enemy.x = love.graphics.getWidth()/2 - enemy.w/2

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

  if love.keyboard.isDown("left") and player.x > 0 then
    player.x = player.x - player.moveSpeed

  end

  if love.keyboard.isDown("right") and player.x < (love.graphics.getWidth()-player.w) then
    player.x = player.x + player.moveSpeed

  end

end

function updateEnemy(dt)

  enemy.centerX = enemy.x + (enemy.w/2)

  if ball.x > enemy.centerX and enemy.x < (love.graphics.getWidth()-enemy.w) then
    enemy.x = enemy.x + enemy.moveSpeed
  end 

  if ball.x < enemy.centerX and enemy.x > 0 then
    enemy.x = enemy.x - enemy.moveSpeed
  end 

end

function drawScore()
  drawRed()
  love.graphics.print("Player Score: " .. score.playerScore, 0, 0)
  love.graphics.print("Enemy Score: "  .. score.enemyScore, love.graphics.getWidth()-130,0)

end


function updateBall(dt)

  ball.y = ball.y + ball.yVel --+ ball.additionMoveSpeed
  ball.x = ball.x + ball.xVel --+ ball.additionMoveSpeed

  if boxCircleCollision(player,ball) then
    bounceSnd:stop()
    bounceSnd:play()

    ball.yVel = -ball.yVel;

    --add to velocity
    if ball.yVel > 0 then
      ball.yVel = ball.yVel + 0.5
    end

    if ball.yVel < 0 then
      ball.yVel = ball.yVel - 0.5
    end

    if ball.xVel > 0 then
      ball.xVel = ball.xVel + 0.5
    end

    if ball.xVel < 0 then
      ball.xVel = ball.xVel - 0.5
    end

  end

  if boxCircleCollision(enemy,ball) then
    bounceSnd:stop()
    bounceSnd:play()

    ball.yVel = -ball.yVel;

    --add to velocity
    if ball.yVel > 0 then
      ball.yVel = ball.yVel + 0.5
    end

    if ball.yVel < 0 then
      ball.yVel = ball.yVel - 0.5
    end

    if ball.xVel > 0 then
      ball.xVel = ball.xVel + 0.5
    end

    if ball.xVel < 0 then
      ball.xVel = ball.xVel - 0.5
    end
  end

  if (ball.x + ball.radius) > love.graphics.getWidth() then
    bounceSnd:stop()
    bounceSnd:play()

    ball.xVel = -ball.xVel
  end

  if ball.x < 0 then
    bounceSnd:stop()
    bounceSnd:play()
    
    ball.xVel = -ball.xVel
  end

  --handle scoring
  if ball.y < 0 then
    score.playerScore = score.playerScore+1

    initGame()
  end

  if ball.y > love.graphics.getHeight() then
    score.enemyScore = score.enemyScore+1

    initGame()
  end


end 