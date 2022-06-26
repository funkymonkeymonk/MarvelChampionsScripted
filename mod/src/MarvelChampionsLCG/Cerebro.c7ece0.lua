local publicDeckURL="https://marvelcdb.com/api/public/decklist/"
local privateDeckURL="https://marvelcdb.com/api/public/deck/"
local cardURL="https://marvelcdb.com/api/public/card/"
local subnameCards={{name="Hawkeye"},{name="Spider-Man"},{name="Ant-Man"},{name="Wasp"},{name="Falcon"}}
local multiAspectCards={{name="Mockingbird"},{name="War Machine"},{name="Gamora"},{name="Iron Man"},{name="Captain Marvel"}, {name="Spider-Man"}, {name="Agent 13"}}
local enteredDeckId = 0
local deckId = 0
local privateDeckSelection = true
local cardList = {}
local doneSlots = 0
local totalCards = 0

function onLoad()
  createDeckIdInput()
  createPrivateCheckbox() 
  createSearchButton() 
end

function importDeck(params)
  deckId = params.deckId
  deckPos = params.deckPosition

  local privateDeck = params.privateDeck

  resetCardListAndCounters()

  callApi(privateDeck)
end

function resetCardListAndCounters()
  cardList = {}
  doneSlots = 0
  totalCards = 0
end

function callApi(privateDeck)
  local deckURL = privateDeck and privateDeckURL or publicDeckURL

  WebRequest.get(deckURL .. deckId, self, 'deckReadCallback')
end

function deckReadCallback(req)
  -- Result check..
  if req.is_done and not req.is_error then
    if string.find(req.text, "<!DOCTYPE html>") then
      broadcastToAll("Deck "..deckId.." is not shared", {0.5,0.5,0.5})
      return
    end
    JsonDeckRes = JSON.decode(req.text)
  else
    print (req.error)
    return
  end

  if (JsonDeckRes == nil) then
    broadcastToAll("Deck not found!", {0.5,0.5,0.5})
    return
  else
    print("Found decklist: "..JsonDeckRes.name)
  end

  -- Count number of cards in decklist
  numSlots=0
  for cardid,number in pairs(JsonDeckRes.slots) do
    numSlots = numSlots + 1
  end

  -- Save card id, number in table and request card info from MarvelCDB
  for cardID,number in pairs(JsonDeckRes.slots) do
    local row = {}
    row.cardName = ""
    row.cardCount = number
    cardList[cardID] = row
    WebRequest.get(cardURL .. cardID, self, 'cardReadCallback')
    totalCards = totalCards + number
  end
end

function cardReadCallback(req)
  -- Result check..
  if req.is_done and not req.is_error then
    -- Find unicode before using JSON.decode since it doesnt handle hex UTF-16
    local tmpText = string.gsub(req.text,"\\u(%w%w%w%w)", convertHexToDec)
    JsonCardRes = JSON.decode(tmpText)
  else
    print(req.error)
    return
  end

  cardList[JsonCardRes.code].cardName = JsonCardRes.real_name

  -- Check for subname
  for k,v in pairs(subnameCards) do
    if (v.name == JsonCardRes.real_name) then
      cardList[JsonCardRes.code].subName = JsonCardRes.subname
    end
  end

  -- Check for multiaspect
  for k,v in pairs(multiAspectCards) do
    if (v.name == JsonCardRes.real_name) then
      cardList[JsonCardRes.code].subName = 
        (cardList[JsonCardRes.code].subName and cardList[JsonCardRes.code].subName .. "-" .. JsonCardRes.faction_name or JsonCardRes.faction_name)
      log(cardList[JsonCardRes.code].subName)
    end
  end

  -- Update number of processed slots, if complete, start building the deck
  doneSlots = doneSlots + 1
  if (doneSlots == numSlots) then
    createDeck()
  end
end

function createDeck()
  tmpDeck = getCardPool()
  for k,v in pairs(cardList) do
    searchForCard(v.cardName, v.subName, v.cardCount)
  end

  tmpDeck.destruct()
end

function getCardPool()
  local importerBag = getObjectFromGUID('3ca6e4')
  local cardPool = importerBag.takeObject(getObjectFromGUID('7d65df'))
  cardPool.setPosition{-15.75,1.62,-137.25}
  cardPool.setRotation{180,0,0}

  local poolCopy = cardPool.clone({0, 0, 50})

  importerBag.putObject(cardPool)

  return poolCopy
end

function searchForCard(cardName, subName, cardCount)
  allCards = tmpDeck.getObjects()
  for k,v in pairs(allCards) do
    if (v.nickname == cardName) then
      if(subName == nil or v.description == subName) then
        tmpDeck.takeObject({
          position = {10, 0, 20},
          callback = 'cardTaken',
          callback_owner=self,
          index = v.index,
          smooth = false,
          params = { cardName, cardCount, v.guid }
        })
        --print('Added '.. cardCount .. ' of ' .. cardName)
        return
      end
    end
  end
  broadcastToAll("Card not found: "..cardName, {0.5,0.5,0.5})
end

function cardTaken(card, params)
  local destPos
  destPos = deckPos
  if (card.getName() == params[1]) then
    for i=1,params[2]-1,1 do
      local cloneParams = {}
      cloneParams.position=destPos
      card.clone(cloneParams)
    end
    card.setPosition(destPos)
  else
    print('Wrong card: ' .. card.getName())
    tmpDeck.putObject(card)
  end
end

function buttonClicked()
  params = {
    deckId = enteredDeckId,
    privateDeck = privateDeckSelection,
    deckPosition = LocalPos(self,{0,1.5,-2})
  }
  importDeck(params)
end

function createPrivateCheckbox()
  self.createButton({
    click_function = "checkboxPPClicked",
    function_owner = self,
    position = {0,0.2,0.4},
    width = 1700,
    height = 400,
    tooltip = "Click to toggle Private/Public deck ID",
    label = "Private",
    font_size = 350,
    scale = {0.2,0.2,0.2}  
  })
end

function checkboxPPClicked()
  privateDeckSelection = not privateDeckSelection
  local newLabel = privateDeckSelection and "Private" or "Public"

  for k, v in pairs(self.getButtons()) do
    if (v.label == "Private" or v.label == "Public") then
      self.editButton({
        label = newLabel,
        index = v.index          
      })
    end
  end
end

function createDeckIdInput()
  self.createInput({
    input_function = "inputTyped",
    function_owner = self,
    position = {0,0.2,0.2},
    width = 3620,
    scale = {0.1,0.1,0.1},
    height = 900,
    font_size = 8000,
    tooltip = "Input deck ID from MarvelCDB",
    alignment = 3,
    value=""
  })
end

function createSearchButton()
  self.createButton({
    click_function = "buttonClicked",
    function_owner = self,
    position = {0,0.2,0.7},
    width = 1700,
    height = 400,
    label = "Search",
    font_size = 350,
    scale = {0.3,0.3,0.3},
    tooltip = "Search for Heroes!",
    color = {1,1,0}  
  })
end

-- Function to convert utf-16 hex to actual character since JSON.decode doesn't seem to handle utf-16 hex very well..
function convertHexToDec(a)
  return string.char(tonumber(a,16))
end
--------------
--------------
-- Start of Dzikakulka's positioning script


-- Return position "position" in "object"'s frame of reference
-- (most likely the only function you want to directly access)
function LocalPos(object, position)
    local rot = object.getRotation()
    local lPos = {position[1], position[2], position[3]}

    -- Z-X-Y extrinsic
    local zRot = RotMatrix('z', rot['z'])
    lPos = RotateVector(zRot, lPos)
    local xRot = RotMatrix('x', rot['x'])
    lPos = RotateVector(xRot, lPos)
    local yRot = RotMatrix('y', rot['y'])
    lPos = RotateVector(yRot, lPos)

    return Vect_Sum(lPos, object.getPosition())
end

-- Build rotation matrix
-- 1st table = 1st row, 2nd table = 2nd row etc
function RotMatrix(axis, angDeg)
    local ang = math.rad(angDeg)
    local cs = math.cos
    local sn = math.sin

    if axis == 'x' then
        return {
                    { 1,        0,             0 },
                    { 0,   cs(ang),   -1*sn(ang) },
                    { 0,   sn(ang),      cs(ang) }
               }
    elseif axis == 'y' then
        return {
                    {    cs(ang),   0,   sn(ang) },
                    {          0,   1,         0 },
                    { -1*sn(ang),   0,   cs(ang) }
               }
    elseif axis == 'z' then
        return {
                    { cs(ang),   -1*sn(ang),   0 },
                    { sn(ang),      cs(ang),   0 },
                    { 0,                  0,   1 }
               }
    end
end

-- Apply given rotation matrix on given vector
-- (multiply matrix and column vector)
function RotateVector(rotMat, vect)
    local out = {0, 0, 0}
    for i=1,3,1 do
        for j=1,3,1 do
            out[i] = out[i] + rotMat[i][j]*vect[j]
        end
    end
    return out
end

-- Sum of two vectors (of any size)
function Vect_Sum(vec1, vec2)
    local out = {}
    local k = 1
    while vec1[k] ~= nil and vec2[k] ~= nil do
        out[k] = vec1[k] + vec2[k]
        k = k+1
    end
    return out
end

-- End Dzikakulka's positioning script

function inputTyped(objectInputTyped, playerColorTyped, input_value, selected)
    enteredDeckId = input_value
end
