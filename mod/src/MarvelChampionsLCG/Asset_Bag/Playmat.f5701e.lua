local OFFSET_ENCOUNTER_DRAW = {}
local OFFSET_PLAYER_DECK = {}
local OFFSET_PLAYER_DISCARD = {}

local data = {}

function onload(saved_data)
   OFFSET_ENCOUNTER_DRAW = Global.getTable("PLAYMAT_OFFSET_ENCOUNTER_CARD")
   OFFSET_PLAYER_DECK = Global.getTable("PLAYMAT_OFFSET_DECK")
   OFFSET_PLAYER_DISCARD = Global.getTable("PLAYMAT_OFFSET_DISCARD")

   loadSavedData(saved_data)

   setUpUI(getValue("showRemoveButton", true))
end

function loadSavedData(saved_data)
   if saved_data ~= "" then
      local loaded_data = JSON.decode(saved_data)
      data = loaded_data
   end
end

function setValue(key, value)
   data[key] = value
   local saved_data = JSON.encode(data)
   self.script_state = saved_data
end

function getValue(key, default)
   if data[key] == nil then
      return default
   end

   return data[key]
end

function setUpUI(showRemoveButton)
   local ui = 
   {
      {
         tag="Panel",
         attributes={            
            height="200",
            width="350",
            color="rgba(0,0,0,0)",
            position="0 0 -12",
            rotation="0 0 180"
         },
         children={
            {
               tag="Button",
               value="1",
               attributes={
                  id="firstPLayerButton",
                  rectAlignment="UpperRight",
                  onClick="movePlayerOne",
                  textColor="rgb(0,0,0)",
                  color="rgb(0,1,0)",
                  scale="0.25 0.25",
                  height="80",
                  width="80",
                  fontSize="60",
                  fontStyle="Bold",
                  offsetXY="-10 -40",
                  onMouseEnter="showTooltip",
                  onMouseExit="hideTooltip"
               }
            },
            {
               tag="Panel",
               attributes={
                  id="firstPLayerButtonTooltip",
                  scale="0.25 0.25",
                  padding="20 20 10 10",
                  color="rgba(0,0,0,0.75)",
                  contentSizeFitter="both",
                  position="155 50 -100",
                  visibility="invisible"
               },
               children={
                  {
                     tag="Text",
                     value="Take First Player",
                     attributes={
                        fontSize="24",
                        color="rgb(1,1,1)",
                        alignment="MiddleLeft"
                     }
                  }
               }
            },
            {
               tag="Button",
               value="R",
               attributes={
                  id="readyAllButton",
                  rectAlignment="UpperRight",
                  onClick="untapAll",
                  textColor="rgb(0,0,0)",
                  color="rgb(0.3,0.6,1)",
                  scale="0.25 0.25",
                  height="80",
                  width="80",
                  fontSize="60",
                  fontStyle="Bold",
                  offsetXY="-10 -65",
                  onMouseEnter="showTooltip",
                  onMouseExit="hideTooltip"
               }
            },
            {
               tag="Panel",
               attributes={
                  id="readyAllButtonTooltip",
                  scale="0.25 0.25",
                  padding="20 20 10 10",
                  color="rgba(0,0,0,0.75)",
                  contentSizeFitter="both",
                  position="155 25 -100",
                  visibility="invisible"
               },
               children={
                  {
                     tag="Text",
                     value="Ready All Cards",
                     attributes={
                        fontSize="24",
                        color="rgb(1,1,1)",
                        alignment="MiddleLeft"
                     }
                  }
               }
            },
            {
               tag="Button",
               value="D",
               attributes={
                  id="discardRandomButton",
                  rectAlignment="UpperRight",
                  onClick="discardRandom",
                  textColor="rgb(0,0,0)",
                  color="rgb(1,0.5, 1)",
                  scale="0.25 0.25",
                  height="80",
                  width="80",
                  fontSize="60",
                  fontStyle="Bold",
                  offsetXY="-10 -90",
                  onMouseEnter="showTooltip",
                  onMouseExit="hideTooltip"
               }
            },
            {
               tag="Panel",
               attributes={
                  id="discardRandomButtonTooltip",
                  scale="0.25 0.25",
                  padding="20 20 10 10",
                  color="rgba(0,0,0,0.75)",
                  contentSizeFitter="both",
                  position="155 0 -100",
                  visibility="invisible"
               },
               children={
                  {
                     tag="Text",
                     value="Discard a Random Card",
                     attributes={
                        fontSize="24",
                        color="rgb(1,1,1)",
                        alignment="MiddleLeft"
                     }
                  }
               }
            },
            {
               tag="Button",
               value="!!",
               attributes={
                  id="drawEncounterButton",
                  rectAlignment="UpperRight",
                  onClick="drawEncounter",
                  textColor="rgb(0,0,0)",
                  color="rgb(1,1,0)",
                  scale="0.25 0.25",
                  height="80",
                  width="80",
                  fontSize="60",
                  fontStyle="Bold",
                  offsetXY="-10 -115",
                  onMouseEnter="showTooltip",
                  onMouseExit="hideTooltip"
               }
            },
            {
               tag="Panel",
               attributes={
                  id="drawEncounterButtonTooltip",
                  scale="0.25 0.25",
                  padding="20 20 10 10",
                  color="rgba(0,0,0,0.75)",
                  contentSizeFitter="both",
                  position="155 -25 -100",
                  visibility="invisible"
               },
               children={
                  {
                     tag="Text",
                     value="Draw an Encounter Card",
                     attributes={
                        fontSize="24",
                        color="rgb(1,1,1)",
                        alignment="MiddleLeft"
                     }
                  }
               }
            },
            {
               tag="Button",
               value="X",
               attributes={
                  id="discardEncounterButton",
                  rectAlignment="UpperRight",
                  onClick="discardEncounter",
                  textColor="rgb(0,0,0)",
                  color="rgb(1,0,0)",
                  scale="0.25 0.25",
                  height="80",
                  width="80",
                  fontSize="60",
                  fontStyle="Bold",
                  offsetXY="-10 -140",
                  onMouseEnter="showTooltip",
                  onMouseExit="hideTooltip"
               }
            },
            {
               tag="Panel",
               attributes={
                  id="discardEncounterButtonTooltip",
                  scale="0.25 0.25",
                  padding="20 20 10 10",
                  color="rgba(0,0,0,0.75)",
                  contentSizeFitter="both",
                  position="155 -50 -100",
                  visibility="invisible"
               },
               children={
                  {
                     tag="Text",
                     value="Discard Encounter Card",
                     attributes={
                        fontSize="24",
                        color="rgb(1,1,1)",
                        alignment="MiddleLeft"
                     }
                  }
               }
            },
            {
               tag="Button",
               value="N",
               attributes={
                  id="spawnNemesisButton",
                  rectAlignment="UpperRight",
                  onClick="spawnNemesis",
                  textColor="rgb(1,1,1)",
                  color="rgb(0,0,0)",
                  scale="0.25 0.25",
                  height="80",
                  width="80",
                  fontSize="60",
                  fontStyle="Bold",
                  offsetXY="-10 -170",
                  onMouseEnter="showTooltip",
                  onMouseExit="hideTooltip"
               }
            },
            {
               tag="Panel",
               attributes={
                  id="spawnNemesisButtonTooltip",
                  scale="0.25 0.25",
                  padding="20 20 10 10",
                  color="rgba(0,0,0,0.75)",
                  contentSizeFitter="both",
                  position="155 -80 -100",
                  visibility="invisible"
               },
               children={
                  {
                     tag="Text",
                     value="Summon Your Nemesis!",
                     attributes={
                        fontSize="24",
                        color="rgb(1,1,1)",
                        alignment="MiddleLeft"
                     }
                  }
               }
            },
            {
               tag="Button",
               value="REMOVE",
               attributes={
                  id="removeButton",
                  active=showRemoveButton,
                  onClick="clearPlaymat",
                  textColor="rgb(1,0,0)",
                  color="rgb(0,0,0)",
                  scale="0.25 0.25",
                  height="60",
                  width="220",
                  fontSize="40",
                  rectAlignment="LowerCenter",
                  offsetXY="0 10"
               }
            }
         }
      }
   }

   self.UI.setXmlTable(ui)   
end

function setPlayerColor(params)
   setValue("playerColor", params.color)
end

function movePlayerOne()
   local playerColor = getValue("playerColor")
   local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
   heroManager.call("setFirstPlayer", {playerColor = playerColor})
end

function untapAll()
   local untapCards = findCardsAtPosition()
   
   for _, obj in ipairs(untapCards) do
      local oldSpin = obj.getRotation().y
      obj.setRotationSmooth({0,180,obj.getRotation().z})
      Global.call("rotateCountersWithCard", {card = obj, spin = 180, oldSpin = oldSpin})
   end
end

function findCardsAtPosition()
   matPos = self.getPosition()
   local objList = Physics.cast({
      origin       = matPos,
      direction    = {0,1,0},
      type         = 3,
      size         = {26,1,15},
      max_distance = 0,
      debug        = false,
   })
   local cards = {}
   for _, obj in ipairs(objList) do
      if obj.hit_object.tag == "Card" then
         table.insert(cards, obj.hit_object)
      end
   end
   return cards
end

function findObjectsAtPosition()
   matPos = self.getPosition()
   local objList = Physics.cast({
      origin       = matPos,
      direction    = {0,1,0},
      type         = 3,
      size         = {26,1,15},
      max_distance = 0,
      debug        = false,
   })
   local objects = {}
   for _, obj in ipairs(objList) do
      table.insert(objects, obj.hit_object)
   end
   return objects
end

function drawEncounter(player, value, id)
   Global.call("dealEncounterCardToPlayer", {playerColor = getValue("playerColor"), faceUp = value == "-2"})
end

function discardEncounter()
   Global.call("discardEncounterCard", {playerColor = getValue("playerColor")})
end

function discardRandom(object, player)
   playerColor = getValue("playerColor")

   if playerColor == "Red" then
    pos = {-52.50, 2, -21.72}
   end
   if playerColor == "Blue" then
    pos = {-25.03, 2, -22.40}
   end
   if playerColor == "Green" then
    pos = {2.44, 2, -22.40}
   end
   if playerColor == "Yellow" then
    pos = {29.92, 2, -21.73}
   end

   local cardsInHand = Player[playerColor].getHandObjects()
   local handCount = #cardsInHand

   if(handCount == 0) then return end

   if(handCount == 1) then
      cardsInHand[1].setPosition(pos)
      return
   end

   rand = math.random(handCount)
   cardsInHand[rand].setPosition(pos)
end

function clearPlaymat()
   local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
   heroManager.call("clearHero", {playerColor = getValue("playerColor")})

   local objects = findObjectsAtPosition()

   for _, obj in ipairs(objects) do
      if(obj.tag ~= "Surface" and obj.tag ~= "Board" and obj.getVar("preventDeletion") ~= true) then
         obj.destruct()
      end
   end

   self.destruct()
end

function spawnNemesis()
   local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
   scenarioManager.call("spawnNemesis", {playerColor = getValue("playerColor")})
end

function hideRemoveButton()
   self.UI.setAttribute("removeButton", "active", false)

   setValue("showRemoveButton", false)
end

function showRemoveButton()
   self.UI.setAttribute("removeButton", "active", true)
   self.UI.setAttribute("removeButton", "textColor", "rgb(1,0,0)")
end

function getEncounterCardPosition()
   return self.positionToWorld(Vector(OFFSET_ENCOUNTER_DRAW))
end

function getPlayerDeckPosition()
   return self.getPosition() + Vector(OFFSET_PLAYER_DECK)
end

function getPlayerDiscardPosition()
   return self.getPosition() + Vector(OFFSET_PLAYER_DISCARD)
end

function showTooltip(player, value, id)
   local tooltipId = id .. "Tooltip"
   local playerColor = player.color
   local visibility = self.UI.getAttribute(tooltipId, "visibility")

   if string.find(visibility, playerColor) then return end

   self.UI.setAttribute(tooltipId, "visibility", visibility.."|"..playerColor)
end

function hideTooltip(player, value, id)
   local tooltipId = id .. "Tooltip"
   local playerColor = player.color
   local visibility = self.UI.getAttribute(tooltipId, "visibility")

   if not string.find(visibility, playerColor) then return end

   self.UI.setAttribute(tooltipId, "visibility", visibility:gsub("|"..playerColor, ""))
end

function drawCards(params)
   local objectToDrawFrom = params.objectToDrawFrom
   local numberToDraw = params.numberToDraw
   local positionColor = getValue("playerColor")

   local isDeck = objectToDrawFrom.tag == "Deck"
   local availableCards = isDeck and objectToDrawFrom.getQuantity() or 1
   local numberForSecondDraw = numberToDraw > availableCards and numberToDraw - availableCards or 0
   local isPlayerDeck = isPlayerDeck(objectToDrawFrom)
   local handPosition = Player[positionColor].getHandTransform().position

   objectToDrawFrom.deal(numberToDraw, getValue("playerColor"))

   Global.call("supressZones")
   
   Wait.frames(function()
      if(isPlayerDeck and numberToDraw >= availableCards) then
         local deckPosition = getPlayerDeckPosition()
         local discardPosition = getPlayerDiscardPosition()

         Global.call("refreshDeck", {deckPosition = deckPosition, discardPosition = discardPosition})
         Global.call("displayMessage", {message = "You cycled your deck. Time for an encounter card!", messageType = Global.getVar("MESSAGE_TYPE_INFO"), playerColor = positionColor})
         Global.call("dealEncounterCardToPlayer", {playerColor = positionColor})

         Wait.frames(function()
            local playerDeck = Global.call("getDeckOrCardAtPosition", {position = deckPosition})
            drawCards({objectToDrawFrom = playerDeck, numberToDraw = numberForSecondDraw})
         end, 
         30)
      end
   end,
   1)
end

function isPlayerDeck(deck)
   local deckPosition = deck.getPosition()
   local playerDeckPosition = getPlayerDeckPosition()

   local xDiff = math.abs(deckPosition.x - playerDeckPosition.x)
   local zDiff = math.abs(deckPosition.z - playerDeckPosition.z)

   if(xDiff < 0.5 and zDiff < 0.5) then
      return true
   end
end
