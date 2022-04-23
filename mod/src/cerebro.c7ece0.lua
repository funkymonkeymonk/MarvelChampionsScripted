--[[ Lua code. See documentation: http://berserk-games.com/knowledgebase/scripting/ --]]

--[[ The onLoad event is called after the game save finishes loading. --]]
function onLoad()
  --[[ print('onLoad!') --]]
  init()
  -- Setup...
  publicDeckURL="https://marvelcdb.com/api/public/decklist/"
  privateDeckURL="https://marvelcdb.com/api/public/deck/"
  cardURL="https://marvelcdb.com/api/public/card/"
  subnameCards={{name="Hawkeye"},{name="Spider-Man"},{name="Ant-Man"},{name="Wasp"}}
  multiClassCards={{name="Mockingbird"},{name="War Machine"},{name="Gamora"},{name="Iron Man"},{name="Captain Marvel"}}

  local tileGUID = 'c7ece0'
  tile = getObjectFromGUID(tileGUID)
  makeText()
  makeButton() 
  makeCheckboxPP() 
  privateDeck = true
end

function spawnZone()
  -- Clean up scripting zone
  if pcZone then
    pcZone.destruct()
  end
  if weaknessZone then
    weaknessZone.destruct()
  end
  deckPos = LocalPos(self,{0,1.5,-2})
  permPos = LocalPos(self,{-4.63,1.5,1.8})
  pcZonePos = {-15.75,1.62,-137.25}
  zoneSpawn = {position = pcZonePos
       , scale = { 10.57, 5.1, 10.47 }
       , type = 'ScriptingTrigger'
--       , callback = 'zoneCallback'
       , callback_owner = self
       , rotation = self.getRotation() }
  pcZone = spawnObject(zoneSpawn)

  -- get a scripting zone at the weakness deck
  --local weaknessZonePosition = self.positionToWorld({-7.5, 2.6 , 1.8})
  local weaknessZonePosition = LocalPos(self, {-7.5, 0 , 1.8})
  weaknessZone = spawnObject({
    position = weaknessZonePosition,
    type = 'ScriptingTrigger',
    rotation = self.getRotation()
  })

  for i=1,1 do
       coroutine.yield(0)
   end

   local objectsInZone = pcZone.getObjects()
   for i,v in pairs(objectsInZone) do
     if v.tag == 'Deck' then
       playerCardDeck = v
     end
   end

   local objectsInZone = weaknessZone.getObjects()
   for i,v in pairs(objectsInZone) do
     if v.getName() == 'All Weaknesses' then
       weaknessDeck = v
     end
   end

   -- Get deck from MarvelCDB
   local deckURL
   if privateDeck then deckURL = privateDeckURL
   else deckURL = publicDeckURL
   end

   WebRequest.get(deckURL .. deckID, self, 'deckReadCallback')

   return 1
end

function init()
  cardList = {}
  doneSlots = 0
  playerCardDeck = {}
  totalCards = 0
end

function buttonClicked()
importerBag = getObjectFromGUID('3ca6e4')
cardPool = importerBag.takeObject(getObjectFromGUID('ced3f3'))
cardPool.setPosition{-15.75,1.62,-137.25}
cardPool.setRotation{180,0,0}
  -- Reset
  init()
  -- Spawn scripting zone
  startLuaCoroutine(self, "spawnZone")
Wait.time(returnImporter,10)
end

function returnImporter()
importerBag = getObjectFromGUID('3ca6e4')
clonePool = getObjectFromGUID('ced3f3')
importerBag.putObject(clonePool)
end

function makeCheckboxPP()
  local checkbox_parameters = {}
  checkbox_parameters.click_function = "checkboxPPClicked"
  checkbox_parameters.function_owner = self
  checkbox_parameters.position = {0,0.2,0.4}
  checkbox_parameters.width = 1700
  checkbox_parameters.height = 400
  checkbox_parameters.tooltip = "Click to toggle Private/Public deck ID"
  checkbox_parameters.label = "Private"
  checkbox_parameters.font_size = 350
  checkbox_parameters.scale = {0.2,0.2,0.2}
  tile.createButton(checkbox_parameters)
end

function checkboxPPClicked()
  buttons = tile.getButtons()
  for k,v in pairs(buttons) do
    if (v.label == "Private") then
      local button_parameters = {}
      button_parameters.label = "Public"
      button_parameters.index = v.index
      tile.editButton(button_parameters)
      privateDeck = false
    else
      if (v.label == "Public") then
        local button_parameters = {}
        button_parameters.label = "Private"
        button_parameters.index = v.index
        tile.editButton(button_parameters)
        privateDeck = true
      end
    end
  end
end

function deckReadCallback(req)
  -- Result check..
  if req.is_done and not req.is_error
  then
    if string.find(req.text, "<!DOCTYPE html>")
    then
      broadcastToAll("Deck "..deckID.." is not shared", {0.5,0.5,0.5})
      return
    end
    JsonDeckRes = JSON.decode(req.text)
  else
    print (req.error)
    return
  end
  if (JsonDeckRes == nil)
  then
    broadcastToAll("Deck not found!", {0.5,0.5,0.5})
    return
  else
    print("Found decklist: "..JsonDeckRes.name)
  end
  -- Count number of cards in decklist
  numSlots=0
  for cardid,number in
  pairs(JsonDeckRes.slots)
  do
    numSlots = numSlots + 1
  end

  -- Save card id, number in table and request card info from MarvelCDB
  for cardID,number in pairs(JsonDeckRes.slots)
  do
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
  if req.is_done and not req.is_error
  then
    -- Find unicode before using JSON.decode since it doesnt handle hex UTF-16
    local tmpText = string.gsub(req.text,"\\u(%w%w%w%w)", convertHexToDec)
    JsonCardRes = JSON.decode(tmpText)
  else
    print(req.error)
    return
  end

  -- Update card name in table
  if(JsonCardRes.xp == nil or JsonCardRes.xp == 0)
  then
    cardList[JsonCardRes.code].cardName = JsonCardRes.real_name
  else
    cardList[JsonCardRes.code].cardName = JsonCardRes.real_name .. " (" .. JsonCardRes.xp .. ")"
  end

  -- Check for subname
  for k,v in pairs(subnameCards) do
    if (v.name == JsonCardRes.real_name and (v.xp == JsonCardRes.xp or JsonCardRes.xp == nil))
    then
      cardList[JsonCardRes.code].subName = JsonCardRes.subname
    end
  end

  -- Check for multiclass
  for k,v in pairs(multiClassCards) do
    if (v.name == JsonCardRes.real_name and (v.xp == JsonCardRes.xp or JsonCardRes.xp == nil))
    then
      cardList[JsonCardRes.code].subName = JsonCardRes.faction_name
    end
  end

  -- Update number of processed slots, if complete, start building the deck
  doneSlots = doneSlots + 1
  if (doneSlots == numSlots)
  then
    createDeck()
  end
end

function createDeck()
  -- Create clone of playerCardDeck to use for drawing cards
  local cloneParams = {}
  cloneParams.position = {0,0,50}
  tmpDeck = playerCardDeck.clone(cloneParams)
  for k,v in pairs(cardList) do
    searchForCard(v.cardName, v.subName, v.cardCount)
  end

  tmpDeck.destruct()
end

function searchForCard(cardName, subName, cardCount)
  allCards = tmpDeck.getObjects()
  for k,v in pairs(allCards) do
    if (v.nickname == cardName)
    then
      if(subName == nil or v.description == subName)
      then
        tmpDeck.takeObject({
          position = {10, 0, 20},
          callback = 'cardTaken',
          callback_owner=self,
          index = v.index,
          smooth = false,
          params = { cardName, cardCount, v.guid }
        })
        print('Added '.. cardCount .. ' of ' .. cardName)
        return
      end
    end
  end
  broadcastToAll("Card not found: "..cardName, {0.5,0.5,0.5})
end

function cardTaken(card, params)
  local destPos
  if (params[3] == true) then
    destPos = permPos
  else
    destPos = deckPos
  end

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


function makeText()
  -- Create textbox
  local input_parameters = {}
  input_parameters.input_function = "inputTyped"
  input_parameters.function_owner = self
  input_parameters.position = {0,0.2,0.2}
  input_parameters.width = 3620
  input_parameters.scale = {0.1,0.1,0.1}
  input_parameters.height = 900
  input_parameters.font_size = 8000
  input_parameters.tooltip = "Input deck ID from MarvelCDB"
  input_parameters.alignment = 3 -- (1 = Automatic, 2 = Left, 3 = Center, 4 = Right, 5 = Justified) –Optional
  input_parameters.value=""
  tile.createInput(input_parameters)
end

function makeButton()
  -- Create Button
  local button_parameters = {}
  button_parameters.click_function = "buttonClicked"
  button_parameters.function_owner = self
  button_parameters.position = {0,0.2,0.7}
  button_parameters.width = 1700
  button_parameters.height = 400
  button_parameters.label = "Search"
  button_parameters.font_size = 350
  button_parameters.scale = {0.3,0.3,0.3}
  button_parameters.tooltip = "Search for Heroes!"
  button_parameters.color = {1,1,0}
  tile.createButton(button_parameters)
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
    deckID = input_value
end

--[[ The onUpdate event is called once per frame. --]]
function onUpdate ()
    --[[ print('onUpdate loop!') --]]
end

