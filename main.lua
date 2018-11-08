--[[
A Tetris Clone by Alex Nascimento


TODOs em ordem de prioridade
todo game over
todo nextPiece
todo menus e customização

]]
function love.load()
  lastTime = love.timer.getTime()
  
  mtxBase={} -- matriz base contém as peças que já foram colocadas
  mtxR = {}
  gridHeight = 20
  gridWidth = 10
  spacing = 25
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  message = { "1", "2", "3", "4", "5", "6" }
  
  currentPos = { row = 1, col = 5}
  lastPos = { row = 1, col = 5 }
  rotation = 1
  
  bToBTetris = false
  score = 0
  level = 1
  nextLevel = { 5, 17, 38, 70, 115, 175, 255, 360, 495, 2000 }
  nextLevelIndex = 1
  regularFont = love.graphics.newFont(10)
  valuesFont = love.graphics.newFont("fonts/ShareTechMono-Regular.ttf",60)
  textFont = love.graphics.newFont("fonts/ShareTechMono-Regular.ttf",20)

  levelText = love.graphics.newText(textFont, "Level")
  nextLevelText = love.graphics.newText(textFont, "Next Level")
  scoreText = love.graphics.newText(textFont, "Score")
  pauseText = love.graphics.newText(valuesFont, "PAUSED")
  gameOverText = love.graphics.newText(valuesFont, "GAME\nOVER")
  tryAgainText = love.graphics.newText(textFont, "press R to try again")
  
  levelValueText = love.graphics.newText(valuesFont,level)
  nextLevelValueText = love.graphics.newText(valuesFont,nextLevel[nextLevelIndex])
  scoreValueText = love.graphics.newText(valuesFont,score)
  
  gameOver = false
  isPaused = false
  timer = { 1, 0.7, 0.5, 0.4, 0.3, 0.2, 0.15, 0.12, 0.1, 0.08 }-- timer reinicia a cada descida da peça e vai acelerando ao lonog do jogo
  
  love.graphics.setFont(valuesFont)
  
  
  --pieces
  shapes = {
    {
      {
        {".",".",".","."},
        {"I","I","I","I"},
        {".",".",".","."},
        {".",".",".","."}
      },
      {
        {".",".","I","."},
        {".",".","I","."},
        {".",".","I","."},
        {".",".","I","."}
      },
      {
        {".",".",".","."},
        {".",".",".","."},
        {"I","I","I","I"},
        {".",".",".","."}
      },
      {
        {".","I",".","."},
        {".","I",".","."},
        {".","I",".","."},
        {".","I",".","."}
      }
    },
    {
      {
        {".",".","."},
        {"J",".","."},
        {"J","J","J"}
      },
      {
        {".","J","J"},
        {".","J","."},
        {".","J","."}
      },
      {
        {".",".","."},
        {"J","J","J"},
        {".",".","J"}
      },
      {
        {".","J","."},
        {".","J","."},
        {"J","J","."}
      }
    },
    {
      {
        {".",".","."},
        {".",".","L"},
        {"L","L","L"}
      },
      {
        {"L","L","."},
        {".","L","."},
        {".","L","."}
      },      
      {
        {".",".","."},
        {"L","L","L"},
        {"L",".","."}
      },
      {
        {".","L","."},
        {".","L","."},
        {".","L","L"}
      }
    },
    {
      {
        {"O","O"},
        {"O","O"}
      }
    },
    {
      {
        {".",".","."},
        {".","S","S"},
        {"S","S","."}
      },
      {
        {".","S","."},
        {".","S","S"},
        {".",".","S"}
      },
      {
        {".",".","."},
        {".","S","S"},
        {"S","S","."}
      },
      {
        {"S",".","."},
        {"S","S","."},
        {".","S","."}
      }
    },
    {
      {
        {".",".","."},
        {".","T","."},
        {"T","T","T"}
      },
      {
        {".","T","."},
        {".","T","T"},
        {".","T","."}
      },
      {
        {".",".","."},
        {"T","T","T"},
        {".","T","."}
      },     
      {
        {".","T","."},
        {"T","T","."},
        {".","T","."}
      }
    },
    {
      {
        {".",".","."},
        {"Z","Z","."},
        {".","Z","Z"}
      },
      {
        {".",".","Z"},
        {".","Z","Z"},
        {".","Z","."}
      },
      {
        {".",".","."},
        {"Z","Z","."},
        {".","Z","Z"}
      },
      {
        {".","Z","."},
        {"Z","Z","."},
        {"Z",".","."}
      }
    }
  }
  
  mtxPiecesSample = {
    {".","I",".",".",".","."},
    {".","I",".","O","O","."},
    {".","I",".","O","O","."},
    {".","I",".",".",".","."},
    {".",".",".",".",".","."},
    {".","J",".","L",".","."},
    {".","J",".","L",".","."},
    {"J","J",".","L","L","."},
    {".",".",".",".",".","."},
    {".","S","S",".",".","."},
    {"S","S",".","Z","Z","."},
    {".",".",".",".","Z","Z"},
    {".",".","T",".",".","."},
    {".","T","T","T",".","."},
    {".",".",".",".",".","."},
  }
  
  createGrids()
  initPiece()
end

function createGrids()
  for row = 1, gridHeight do
    mtxBase[row] = {}
    mtxR[row] = {}
    for col = 1, gridWidth do
      mtxBase[row][col] = "."
      mtxR[row][col] = "."
    end
  end
end
--------------------------------------------------------------------------

function love.update(dt)
  if isPaused == false and gameOver == false then
    currentTime = love.timer.getTime()
    addToMtx(mtxBase, mtxR, 1, 1) -- reinicia o grid
    addPieceToMtx(shapes[currentPiece][rotation], mtxR, currentPos.row, currentPos.col) -- coloca a peça
    -- gravity movement
    if(currentTime - lastTime > timer[level]) then
      lastTime = love.timer.getTime()
      if(isPositionValid("down")) then
        currentPos.row = currentPos.row + 1
      else
        placePiece()
      end
    end
  end
end

-----------------------------------------------------------------------------
-- input
function love.keypressed(key, scancode, isrepeat)
  if isPaused == false and gameOver == false then
    if key == "left"  then
      if isPositionValid("left") then currentPos.col = currentPos.col - 1 end
    end
    if key == "right" then 
      if isPositionValid("right") then currentPos.col = currentPos.col + 1 end
    end
    if key == "down" then 
      if isPositionValid("down") then 
        currentPos.row = currentPos.row + 1
        lastTime = love.timer.getTime()
      end
    end
    if key == "space" then
      while isPositionValid("down") do
        currentPos.row = currentPos.row + 1
      end
      placePiece()
      lastTime = love.timer.getTime()
    end
    if key == "up" then
      rotatePiece()
    end
  end
  if key == "p"  and gameOver == false then isPaused = not isPaused end
  if key == "escape" then love.event.quit() end
  if key == "r" then love.load(); end
end
----------------------------------------------------------------------------

function love.draw()
  drawRectGrid(mtxR, width/2 - ((gridWidth/2)*spacing), 50)
    love.graphics.setShader()
  drawLeftPanel()
  
  if isPaused == true then drawPauseScreen() end
  if gameOver == true then drawGameOverScreen() end
    
  drawLog()  
  --drawRectGrid(mtxPiecesSample, width - 200, 50)
end

function drawLeftPanel()
  drawLeftPanelStructure()
  drawLevelBlock()
  drawScoreBlock()
  drawNextLevelBlock()
end

function drawLeftPanelStructure()
  love.graphics.setColor(0.2,0.2,0.2)
  love.graphics.rectangle("fill", 100,50,150,500)
  love.graphics.setColor(0.1,0.1,0.1)
  love.graphics.rectangle("fill", 110,60,130,140)
  love.graphics.setColor(0.1,0.1,0.1)
  love.graphics.rectangle("fill", 110,230,130,140)
  love.graphics.setColor(0.1,0.1,0.1)
  love.graphics.rectangle("fill", 110,400,130,140)
end

function drawLevelBlock()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(levelText, 120,65)
  love.graphics.setColor(1,1,0)
  love.graphics.draw(levelValueText, 120, 120)
end

function drawNextLevelBlock()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(nextLevelText, 120,235)
  love.graphics.setColor(1,1,0)
  love.graphics.draw(nextLevelValueText, 120, 290)
  
end

function drawScoreBlock()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(scoreText, 120, 405)
  love.graphics.setColor(1,1,0)
  love.graphics.draw(scoreValueText, 120, 460)
end

function drawCharGrid(matrix)
  for row = 1, gridHeight do
    for col =  1, gridWidth do
      love.graphics.print(matrix[row][col], (col-1) * spacing, (row-1) * spacing, 0, 1,1, -width/2+((gridWidth-1)/2)*spacing,-30) -- matriz centralizada
    end
  end
end

function drawRectGrid(matrix, x, y)
  
  local rectSize = 20
  for row = 1, #matrix do
    for col =  1, #matrix[1] do
      if     matrix[row][col] == "." then
        love.graphics.setColor(0.2,0.2,0.2)
        love.graphics.rectangle("fill", x + (col-1) * spacing, y + (row-1) * spacing, rectSize, rectSize)
      elseif matrix[row][col] == "I" then
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", x + (col-1) * spacing, y + (row-1) * spacing, rectSize, rectSize)
        love.graphics.setColor(0,1,1)
        love.graphics.rectangle("fill", x + (col-1) * spacing + 2, y + (row-1) * spacing + 2, rectSize - 2, rectSize - 2)
        love.graphics.setColor(0.1,0.9,0.9)
        love.graphics.rectangle("fill", x + (col-1) * spacing + 5, y + (row-1) * spacing + 5, 11, 11)
      elseif matrix[row][col] == "J" then
        love.graphics.setColor(0.5,0.6,1)
        love.graphics.rectangle("fill", x + (col-1) * spacing, y + (row-1) * spacing, rectSize, rectSize)
        love.graphics.setColor(0.2,0.4,0.9)
        love.graphics.rectangle("fill", x + (col-1) * spacing + 2, y + (row-1) * spacing + 2, rectSize - 2, rectSize - 2)
        love.graphics.setColor(0.1,0.3,0.8)
        love.graphics.rectangle("fill", x + (col-1) * spacing + 5, y + (row-1) * spacing + 5, 11, 11)
      elseif matrix[row][col] == "L" then
        love.graphics.setColor(1,0.8,0.5)
        love.graphics.rectangle("fill", x + (col-1) * spacing, y + (row-1) * spacing, rectSize, rectSize)
        love.graphics.setColor(1,0.45,0)
        love.graphics.rectangle("fill", x + (col-1) * spacing + 2, y + (row-1) * spacing + 2, rectSize - 2, rectSize - 2)
        love.graphics.setColor(0.9,0.4,0)
        love.graphics.rectangle("fill", x + (col-1) * spacing + 5, y + (row-1) * spacing + 5, 11, 11)
      elseif matrix[row][col] == "O" then
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", x + (col-1) * spacing, y + (row-1) * spacing, rectSize, rectSize)
        love.graphics.setColor(1,0.85,0)
        love.graphics.rectangle("fill", x + (col-1) * spacing + 2, y + (row-1) * spacing + 2, rectSize - 2, rectSize - 2)
        love.graphics.setColor(0.9,0.8,0)
        love.graphics.rectangle("fill", x + (col-1) * spacing + 5, y + (row-1) * spacing + 5, 11, 11)
      elseif matrix[row][col] == "S" then
        love.graphics.setColor(0.8,1,0.8)
        love.graphics.rectangle("fill", x + (col-1) * spacing, y + (row-1) * spacing, rectSize, rectSize)
        love.graphics.setColor(0.1,0.9,0.1)
        love.graphics.rectangle("fill", x + (col-1) * spacing + 2, y + (row-1) * spacing + 2, rectSize - 2, rectSize - 2)
        love.graphics.setColor(0.1,0.8,0.1)
        love.graphics.rectangle("fill", x + (col-1) * spacing + 5, y + (row-1) * spacing + 5, 11, 11)
      elseif matrix[row][col] == "T" then
        love.graphics.setColor(1,0.5,1)
        love.graphics.rectangle("fill", x + (col-1) * spacing, y + (row-1) * spacing, rectSize, rectSize)
        love.graphics.setColor(0.9,0,1)
        love.graphics.rectangle("fill", x + (col-1) * spacing + 2, y + (row-1) * spacing + 2, rectSize - 2, rectSize - 2)
        love.graphics.setColor(0.8,0.1,0.9)
        love.graphics.rectangle("fill", x + (col-1) * spacing + 5, y + (row-1) * spacing + 5, 11, 11)
      elseif matrix[row][col] == "Z" then
        love.graphics.setColor(1,0.5,0.5)
        love.graphics.rectangle("fill", x + (col-1) * spacing, y + (row-1) * spacing, rectSize, rectSize)
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", x + (col-1) * spacing + 2, y + (row-1) * spacing + 2, rectSize - 2, rectSize - 2)
        love.graphics.setColor(0.9,0,0)
        love.graphics.rectangle("fill", x + (col-1) * spacing + 5, y + (row-1) * spacing + 5, 11, 11)
      end
    end
  end
end

function drawPauseScreen()
  love.graphics.draw(pauseText,300,250)
end

function drawGameOverScreen()
  love.graphics.setColor(0.6,0.6,0.6,0.6)
  love.graphics.rectangle("fill", 275,50,245,495)
  love.graphics.setColor(1,1,0)
  love.graphics.draw(gameOverText, 332,200)
  love.graphics.draw(tryAgainText, 290, 350)
end

function drawLog()
  love.graphics.setFont(regularFont)
  love.graphics.setColor(1,1,1)
  for i = 1, #message do
    love.graphics.print(message[i], 10, 20*i)
  end
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function rotatePiece()
  temp = rotation
  if rotation == #shapes[currentPiece] then 
    rotation = 1
  else 
    rotation = rotation + 1 
  end
  -- correct position if out of bounds
  if currentPos.col + getLeftmost() - 1 < 1 then
    currentPos.col = 2 - getLeftmost()
  end
  if currentPos.col + getRightmost() - 1 > gridWidth then
    currentPos.col = 1 + gridWidth - getRightmost()
  end
  if currentPos.row + getDownmost() - 1 > gridHeight then
    currentPos.row = 1 + gridHeight - getDownmost()
  end
  if currentPos.row + getUpmost() - 1 < 1 then
    currentPos.row = 2 - getUpmost()
  end
  
  -- check colision with other pieces
  if not isPositionValid("this") then
    if isPositionValid("up") then
      currentPos.row = currentPos.row - 1
    else rotation = temp
    end
  end
  
end


function addToMtx(matrix1, matrix2, r, c) -- matriz, linha, coluna
  for i = 1, #matrix1 do
    for j = 1, #matrix1[1] do
        matrix2[r+i-1][c+j-1] = matrix1[i][j]
    end
  end
end

function addPieceToMtx(piece, matrix, r, c) -- matriz(peça), linha, coluna
  for i = 1, #piece do
    for j = 1, #piece[1] do
      if piece[i][j] ~= "." then
        matrix[r+i-1][c+j-1] = piece[i][j]
      end
    end
  end
end

function placePiece()
  addPieceToMtx(shapes[currentPiece][rotation], mtxBase, currentPos.row, currentPos.col)
  checkLinesClear()
  initPiece()
end

function initPiece()
  sortPiece()
  rotation = 1
  currentPos.row = 2 - getUpmost()
  currentPos.col = 5
  if not isPositionValid("this") then -- game over
    gameOver = true
  end
end

function sortPiece()
  currentPiece = love.math.random(#shapes)
end

function checkLinesClear() -- todo otimizar criando uma função getUpmost()
  local linesCleared = 0
  for i = currentPos.row, currentPos.row + getDownmost() - 1 do
    while i < 1 do
      i = i+1
    end
    local rowCompleted = true
    local j = 1
    while rowCompleted do
      if(mtxBase[i][j] == ".") then 
        rowCompleted = false
      elseif j <= gridWidth then
        j = j + 1
      else
        clearLine(i)
        downOneRow(i-1)
        linesCleared = linesCleared + 1
        break
      end
    end
  end
  countPoints(linesCleared)
end
function countPoints(amountCleared)
  if amountCleared == 1 then
    score = score + 1
    bToBTetris = false
  elseif amountCleared == 2 then
    score = score + 3
    bToBTetris = false
  elseif amountCleared == 3 then
    score = score + 5
    bToBTetris = false
  elseif amountCleared == 4 then
    if bToBTetris == true then
      score = score + 12
    else 
      score = score + 8
      bToBTetris = true
    end
  end
  if score >= nextLevel[nextLevelIndex] then
    nextLevelIndex = nextLevelIndex + 1
    nextLevelValueText:set(nextLevel[nextLevelIndex])
    level = level + 1
    levelValueText:set(level)
  end
  scoreValueText:set(score)
  
end

function clearLine(line)
  for i = 1, gridWidth do
    mtxBase[line][i] = "."
  end
end

function downOneRow(fromThisRowUp)
  for i = fromThisRowUp, 1, -1 do
    for j = 1, gridWidth do
      mtxBase[i+1][j] = mtxBase[i][j]
    end
    clearLine(i)
  end
end

function isPositionValid(direction)
  if(direction == "left") then
    if(currentPos.col + getLeftmost() - 1 >= 1) then
      if(testPosition(shapes[currentPiece][rotation], mtxBase, currentPos.row, currentPos.col, direction)) then return true else return false end
    else return false end
  end
  if(direction == "right") then
    if (currentPos.col + getRightmost() - 1 <= gridWidth) then
      if(testPosition(shapes[currentPiece][rotation], mtxBase, currentPos.row, currentPos.col, direction)) then return true else return false end
    else return false end
  end
  if(direction == "down") then
    if(currentPos.row + getDownmost() - 1 < gridHeight) then
      if(testPosition(shapes[currentPiece][rotation], mtxBase, currentPos.row, currentPos.col, direction)) then return true else return false end
    else return false end
  end
  if(direction == "this") then
    if(testPosition(shapes[currentPiece][rotation], mtxBase, currentPos.row, currentPos.col, direction)) then return true else return false end
  end
  if(direction == "up") then
    if(testPosition(shapes[currentPiece][rotation], mtxBase, currentPos.row, currentPos.col, direction)) then return true else return false end
  end
end

function testPosition(piece, matrix, r, c, direction) -- para ser usada dentro de isPositionValid()
  if direction == "left" then
    for i = 1, #piece do
      for j = 1, #piece[1] do
        if piece [i][j] ~= "." and matrix[r + i - 1][c + j - 2] ~= "." then return false end
      end
    end
    return true
  end
  if direction == "right" then
    for i = 1, #piece do
      for j = 1, #piece[1] do
        if piece [i][j] ~= "." and matrix[r + i - 1][c + j] ~= "." then return false end
      end
    end
    return true
  end
  if direction == "down" then
    for i = 1, #piece do
      for j = 1, #piece[1] do
        if piece [i][j] ~= "." and matrix[r + i][c + j -1] ~= "." then return false end
      end
    end
    return true
  end
  if direction == "this" then
    for i = 1, #piece do
      for j = 1, #piece[1] do
        if piece[i][j] ~= "." and matrix[r + i - 1][c + j - 1] ~= "." then return false end
      end
    end
    return true
  end
    if direction == "up" then
    for i = 1, #piece do
      for j = 1, #piece[1] do
        if piece[i][j] ~= "." and matrix[r + i - 2][c + j - 1] ~= "." then return false end
      end
    end
    return true
  end
end


function getLeftmost()
  for i = 1, #shapes[currentPiece][rotation][1] do
    for j = 1, #shapes[currentPiece][rotation] do
      if shapes[currentPiece][rotation][j][i] ~= "." then return i end
    end
  end
end

function getRightmost()
  for i = #shapes[currentPiece][rotation][1], 1, -1 do
    for j = 1, #shapes[currentPiece][rotation] do
      if shapes[currentPiece][rotation][j][i] ~= "." then return i end
    end
  end
end

function getDownmost()
  for i = #shapes[currentPiece][rotation], 1, -1 do
    for j = 1, #shapes[currentPiece][rotation][1] do
      if shapes[currentPiece][rotation][i][j] ~= "." then return i end
    end
  end
end

function getUpmost()
  for i = 1, #shapes[currentPiece][rotation] do
    for j = 1, #shapes[currentPiece][rotation][1] do
      if shapes[currentPiece][rotation][i][j] ~= "." then return i end
    end
  end
end