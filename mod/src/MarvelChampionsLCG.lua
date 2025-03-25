require('!/Cardplacer')
require('!/json')

DEFAULT_ROTATION = {0.00, 180.00, 0.00}

VILLAIN_HEALTH_COUNTER_POSITION = {-0.34, 0.96, 29.15}
VILLAIN_HEALTH_COUNTER_ROTATION = {0.00, 180, 0.00}
VILLAIN_HEALTH_COUNTER_SCALE    = {2.88, 1.00, 2.88}

ENCOUNTER_DECK_POSITION = {-12.75, 1.06, 22.25}
ENCOUNTER_DECK_ROTATION = {0.00, 180.00, 180.00}
ENCOUNTER_DECK_SCALE    = {2.12, 1.00, 2.12}

VILLAIN_POSITION = {-0.34, 1.00, 20.44}
VILLAIN_ROTATION = {0.00, 180.00, 0.00}
VILLAIN_SCALE    = {3.64, 1.00, 3.64}

MAIN_SCHEME_POSITION = {8.38, 2.00, 22.45}
MAIN_SCHEME_ROTATION = {0.00, 90.00, 180.00}
MAIN_SCHEME_SCALE    = {2.93, 1.00, 2.93}

MAIN_THREAT_COUNTER_POSITION = {8.38, 1.01, 28.48}
MAIN_THREAT_COUNTER_ROTATION = {0.00, 180.00, 0.00}
MAIN_THREAT_COUNTER_SCALE    = {1.61, 1.00, 1.61}

BLACK_HOLE_POSITION = {-9.05, 1.13, 28.48}
BLACK_HOLE_ROTATION = {0.00, 90.00, 0.00}
BLACK_HOLE_SCALE    = {0.55, 0.55, 0.55}

SIDE_SCHEME_POSITION = {16.75, 1.00, 21.75}
SIDE_SCHEME_ROTATION = {0.00, 90.00, 0.00}

CARD_SCALE_IDENTITY     = {1.88, 1.00, 1.88}
CARD_SCALE_PLAYER       = {1.27, 1.00, 1.27}
CARD_SCALE_VILLAIN      = {3.64, 1.00, 3.64}
CARD_SCALE_ENCOUNTER    = {2.12, 1.00, 2.12}
CARD_SCALE_MAIN_SCHEME  = {2.93, 1.00, 2.93}

SCALE_PLAYER_HEALTH_COUNTER = {1.13, 1.00, 1.13}
SCALE_HERO_SELECTOR         = {1.13, 1.00, 1.13}

ENCOUNTER_DECK_POS              = {-12.75, 1.05, 22.25}
ENCOUNTER_DECK_SPAWN_POS        = {-12.75, 3, 22.25}
ENCOUNTER_DECK_DISCARD_POSITION = {-17.75, 1.8, 22.25}
VILLAIN_POS                     = {-0.34,3,20.44}

BOOST_PANEL_POSITION = {0.25,1.00,13.40}
BOOST_POS            = {-0.30,1.10,7.70}
ENCOUNTER_RED_POS    = {-31.25,1.1,-5.25}
ENCOUNTER_BLUE_POS   = {-3.75,1.1,-5.75}
ENCOUNTER_GREEN_POS  = {23.75,1.1,-5.75}
ENCOUNTER_YELLOW_POS = {51.25,1.1,-5.25}

PLAYER_CONTROL_GUID_RED    = "faa6bd"
PLAYER_CONTROL_GUID_BLUE   = "6066d3"
PLAYER_CONTROL_GUID_GREEN  = "34be58"
PLAYER_CONTROL_GUID_YELLOW = "d9c509"

PLAYMAT_POSITION_RED    = {-41.19, 1.04, -17.12}
PLAYMAT_POSITION_BLUE   = {-13.75, 1.04, -17.75}
PLAYMAT_POSITION_GREEN  = {13.74, 1.04, -17.76}
PLAYMAT_POSITION_YELLOW = {41.21, 1.04, -17.08}

PLAYMAT_OFFSET_HEALTH_COUNTER = {-10.42, 0.10, 5.50}
PLAYMAT_OFFSET_IDENTITY       = {-9.89, 0.15, 1.00}
PLAYMAT_OFFSET_DECK           = {-8.40, 0.30, -4.66}
PLAYMAT_OFFSET_DISCARD        = {-11.30, 2.00, -4.66}
PLAYMAT_OFFSET_ENCOUNTER_CARD = {-1.275, 0.5, -1.533}

HERO_MAIN_COUNTER_SCALE = {0.58, 1.00, 0.58}
HERO_MAIN_COUNTER_OFFSET = {-6.85, 0.2, 5.50}

SETUP_BUTTON_FONT_SIZE_INACTIVE = 400
SETUP_BUTTON_FONT_SIZE_ACTIVE   = 500

GUID_HERO_MANAGER              = "ff377b"
GUID_SCENARIO_MANAGER          = "06c2fd"
GUID_MODULAR_SET_MANAGER       = "608543"
GUID_LAYOUT_MANAGER            = "0d33cc"
GUID_CAMPAIN_MANAGER           = "71f4e2"
ASSET_BAG_GUID                 = "91eba8"
FIRST_PLAYER_TOKEN_GUID        = "d93792"
GUID_GENERAL_COUNTER_BAG       = "aec1c4"
GUID_LARGE_GENERAL_COUNTER_BAG = "65c1cc"
GUID_THREAT_COUNTER_BAG        = "eb5d6d"
GUID_HEALTH_COUNTER_BAG        = "029e3b"
GUID_SELECTOR_TILE             = "c04e76"
GUID_MODULAR_SET_SELECTOR_TILE = "740464"

ASSET_GUID_BLACK_HOLE             = "740595"
ASSET_GUID_PLAYMAT                = "f5701e" 
ASSET_GUID_HERO_HEALTH_COUNTER    = "16b5bd"
ASSET_GUID_VILLAIN_HEALTH_COUNTER = "8cf3d6"
ASSET_GUID_MAIN_THREAT_COUNTER    = "a9f7b8"
ASSET_GUID_BOOST_PANEL            = "ef27d7"

PLAYER_COLOR_RED = "Red"
PLAYER_COLOR_BLUE = "Blue"
PLAYER_COLOR_GREEN = "Green"
PLAYER_COLOR_YELLOW = "Yellow"

MESSAGE_TINT_RED = {.7804, .0902, .0824, 100}
MESSAGE_TINT_BLUE = {.1020, .4784, .9098, 100}
MESSAGE_TINT_GREEN = {.1725, .6392, .1490, 100}
MESSAGE_TINT_YELLOW = {.8235, .8157, .1529, 100}
MESSAGE_TINT_FLAVOR = {0.5, 0.5, 0.5, 100}
MESSAGE_TINT_INSTRUCTION = {1, 1, 1, 100}
MESSAGE_TINT_INFO = {1, 1, 1, 100}

MESSAGE_TYPE_FLAVOR_TEXT = "flavor"
MESSAGE_TYPE_INSTRUCTION = "instruction"
MESSAGE_TYPE_INFO = "info"
MESSAGE_TYPE_PLAYER = "player"

ZONE_SIDE_SCHEME = {
   position = {14.25, 1.00, 11.75},
   scale = {21.00, 1.00, 15.00},
   firstCardPosition = {7.25, 0.98, 16.75},
   horizontalGap = 7,
   verticalGap = 5,
   layoutDirection = "vertical",
   width = 3,
   height = 3
}

ZONE_ENVIRONMENT = {
   position = {20.75, 2.00, 29.75},
   scale = {15.00, 4.00, 7.00},
   firstCardPosition = {15.75, 0.97, 29.75},
   horizontalGap = 5,
   verticalGap = 0,
   layoutDirection = "horizontal",
   width = 3,
   height = 1   
}

ZONE_ATTACHMENT = {
   position = {-7.25, 1.00, 15.25},
   scale = {5.60, 1.00, 21.00},
   firstCardPosition = {-7.25, 0.97, 22.25},
   horizontalGap = 0,
   verticalGap = 7,
   layoutDirection = "vertical",
   width = 1,
   height = 3
}

ZONE_ENCOUNTER_DECK = {
   position = {-15.25, 1.00, 22.00},
   scale = {9.75, 2.00, 7.00}
}

ZONE_VICTORY_DISPLAY = {
   position = {78.00, 0.50, 10.75},
   scale = {33.00, 1.00, 23.50},
   firstCardPosition = {66.75, 0.51, 18.25},
   horizontalGap = 7.5,
   verticalGap = 7.5,
   layoutDirection = "horizontal",
   width = 4,
   height = 3
}

IS_RESHUFFLING = false
supressZoneInteractions = false

function supressZones()
   supressZoneInteractions = true

   Wait.time(function()
      supressZoneInteractions = false
   end, 3)
end

function onLoad()
   -- Create context Menus
   addContextMenuItem("Spawn Card", createUI)
end

function findInRadiusBy(pos, radius, filter, debug)
   local radius = (radius or 1)
   local objList = Physics.cast({
      origin       = pos,
      direction    = {0,1,0},
      type         = 2,
      size         = {radius, radius, radius},
      max_distance = 0,
      debug        = debug
   })

   local filteredList = {}
   for _, obj in ipairs(objList) do
      if filter == nil then
         table.insert(filteredList, obj.hit_object)
      elseif filter and filter(obj.hit_object) then
         table.insert(filteredList, obj.hit_object)
      end
   end
   return filteredList
end

function isCard(x)
   return x.tag == 'Card'
end

function isDeck(x)
   return x.tag == 'Deck'
end

function isCardOrDeck(x)
   return isCard(x) or isDeck(x)
end

function dealEncounterCardsToAllPlayers(params)
   local numberOfCards = params.numberOfCards
   local heroManager = getObjectFromGUID(GUID_HERO_MANAGER)
   local selectedHeroes = heroManager.call("getSelectedHeroes")

   function dealCardsCoroutine()
      for i = 1, numberOfCards do
         for color, _ in pairs(selectedHeroes) do
            dealEncounterCardToPlayer({playerColor = color})

            for i = 1, 5 do
               coroutine.yield(0)
            end
         end
      end

      return 1
   end

   startLuaCoroutine(self, "dealCardsCoroutine")
end

function dealEncounterCardToPlayer(params)
   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
   if(not scenarioManager.call("isScenarioInProgress")) then return end

   local heroManager = getObjectFromGUID(GUID_HERO_MANAGER)
   local playerColor = params.playerColor
   local playmat = heroManager.call("getPlaymat", {playerColor = playerColor})
   local faceUp = params.faceUp ~= nil and params.faceUp or false
   local dealToPosition = Vector(playmat.call("getEncounterCardPosition"))
   local dealToRotation = faceUp and {0, 180, 0} or {0, 180, 180}
   local encounterDeckPosition = Vector(scenarioManager.call('getEncounterDeckPosition'))

   local items = findInRadiusBy(encounterDeckPosition, 4, isCardOrDeck)

   if #items == 0 then
      reshuffleEncounterDeck(dealToPosition, dealToRotation)
      return
   end

   for i, v in ipairs(items) do
      if v.tag == 'Deck' then
         supressZones()
         v.takeObject({index = 0, position = dealToPosition, rotation = dealToRotation})
         return
      end
   end

   supressZones()
   items[1].setPositionSmooth(dealToPosition, false, false)
   items[1].setRotationSmooth(dealToRotation, false, false)
end

function drawBoostcard()
   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
   local encounterDeckPosition = Vector(scenarioManager.call('getEncounterDeckPosition'))
   local drawToPosition = Vector(scenarioManager.call('getBoostDrawPosition'))
   local drawToRotation = {0,180,180}
   local items = findInRadiusBy(encounterDeckPosition, 4, isCardOrDeck)

   if #items > 0 then
      for i, v in ipairs(items) do
         if v.tag == 'Deck' then
            supressZones()
            v.takeObject({index = 0, position = drawToPosition, rotation = drawToRotation})
            return
         end
      end

      supressZones()
      items[1].setPositionSmooth(drawToPosition, false, false)
      items[1].setRotationSmooth(drawToRotation, false, false)
      return
   end

   reshuffleEncounterDeck(drawToPosition, drawToRotation)
end

function discardBoostcard(params)
   local rotation = params[1]
   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
   local encounterDiscardPosition = Vector(scenarioManager.call('getEncounterDiscardPosition'))

   local items = findInRadiusBy(BOOST_POS, 4, isCardOrDeck)

   if #items > 0 then
      for i, v in ipairs(items) do
         if v.tag == 'Deck' then
            v.takeObject({index = 0, position = encounterDiscardPosition, rotation = {0,180,0}})
            return
         end
      end

      supressZones()
      items[1].setPositionSmooth(encounterDiscardPosition, false, false)
      items[1].setRotationSmooth({0,rotation.y,0}, false, false)
      return
   end
end

function discardEncounterCard(params)
   local playerColor = params.playerColor
   local encounterPosition

   if(playerColor == "Red") then
      encounterPosition = ENCOUNTER_RED_POS
   end
   if(playerColor == "Blue") then
      encounterPosition = ENCOUNTER_BLUE_POS
   end
   if(playerColor == "Green") then
      encounterPosition = ENCOUNTER_GREEN_POS
   end
   if(playerColor == "Yellow") then
      encounterPosition = ENCOUNTER_YELLOW_POS
   end

   local items = findInRadiusBy(encounterPosition, 4, isCardOrDeck)

   if #items > 0 then
      local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
      local encounterDiscardPosition = Vector(scenarioManager.call('getEncounterDiscardPosition'))

     for i, v in ipairs(items) do
        if v.tag == 'Deck' then
           v.takeObject({position = encounterDiscardPosition, rotation = {0,180,0}, top = false})
           return
        end
      end

      supressZones()
      items[1].setPositionSmooth(encounterDiscardPosition, false, false)
      items[1].setRotationSmooth({0,180,0}, false, false)
   end
end

function reshuffleEncounterDeck(drawToPosition, drawToRotation)
   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
   local encounterDiscardPosition = Vector(scenarioManager.call('getEncounterDiscardPosition'))
   local encounterDeckPosition = Vector(scenarioManager.call('getEncounterDeckPosition'))
   local encounterDeckSpawnPosition = {x = encounterDeckPosition.x, y = encounterDeckPosition.y + 1.5, z = encounterDeckPosition.z}

   local function move(deck)
      deck.setPositionSmooth(encounterDeckSpawnPosition, true, false)

      Wait.frames(
         function()
            IS_RESHUFFLING = false 
         end, 
         15)
      
      if(drawToPosition) then
         Wait.time(function()
            deck.takeObject({index = 0, position = drawToPosition, rotation = drawToRotation})
         end,
         15)
      end
   end

   if IS_RESHUFFLING then
      return
   end

   local discarded = findInRadiusBy(encounterDiscardPosition, 4, isDeck)

   if #discarded > 0 then
      IS_RESHUFFLING = true
      local deck = discarded[1]
      if not deck.is_face_down then
         deck.flip()
      end
      deck.shuffle()
      Wait.time(function() move(deck) end, 0.3)
      displayMessage({message = "Reshuffling the encounter deck. Add an accelleration token.", messageType = MESSAGE_TYPE_INSTRUCTION})
   else
      printToAll("Couldn't find encounter discard pile to reshuffle", {1,0,0})
   end
end

function nameDeck(params)
   local deckPosition = Vector(params.deckPosition)
   local name = params.name

   local items = findInRadiusBy(deckPosition, 6, isDeck)

   if #items > 0 then
      items[1].setName(name)
   end
end

function shuffleDeck(params)
   local items = findInRadiusBy(params.deckPosition, 4, isDeck)

   if (not items) then
      log("no deck found at position " .. params.deckPosition)
      return
   end

   local deck = items[1]

   if(not deck) then return end

   deck.shuffle()
end

function isFaceUp(params)
   local object = params.object
   local z = object.getRotation()["z"]

   return z > -5 and z < 5
end

function onPlayerAction(player, action, targets)
   if(action == Player.Action.Delete) then
      for _, target in ipairs(targets) do
         if not target.getVar("preventDeletion") then
            target.destroy()
         end
      end

      return false
   end

   if(action == Player.Action.PickUp) then
      if(#targets > 1) then return true end
      local card = targets[1]

      if(not isCard(card)) then return true end

      if(not isFaceUp({object = card})) then return true end

      local zones = card.getZones()
      if #zones > 0 then return true end

      local cardType = getCardProperty({card = card, property = "type"}) or ""
      local zoneType = nil

      if(string.sub(cardType, -11) == "side_scheme") then
         zoneType = "sideScheme"
      elseif(cardType == "attachment") then
         zoneType = "attachment"
      elseif(cardType == "environment") then
         zoneType = "environment"
      elseif(cardType == "minion") then
         zoneType = "minion"
      end

      if(not zoneType) then return true end

      local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
      local zones = scenarioManager.call("getZonesByType", {zoneType = zoneType})
      
      for _, zone in ipairs(zones) do
         local pingPosition = getNewZoneCardPosition({zoneIndex = zone.getVar("zoneIndex"), forNextCard = true})

         if(pingPosition) then
            player.pingTable(pingPosition)
         end
      end
   end

   return true
end

function shuffleTable(params)
   local tbl = params.table
   math.randomseed(os.time())
 
   for i = #tbl, 2, -1 do
     local j = math.random(i)
     tbl[i], tbl[j] = tbl[j], tbl[i]
   end
 
   return tbl
end
 
function deleteCardAtPosition(params)
   local position = params.position
   local items = findInRadiusBy(position, 3, isCard, false)

   if #items > 0 then
     items[1].destroy()
   end
end

function discardCardAtPosition(params)
   local position = params.position
   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
   local discardPosition = Vector(scenarioManager.call('getEncounterDiscardPosition'))
   local items = findInRadiusBy(position, 3, isCard, false)

   if #items > 0 then
     items[1].setPositionSmooth(discardPosition, false, false)
     items[1].setRotationSmooth({0,180,0}, false, false)
   end
end

function moveDeck(params)
   local originPosition = params.origin
   local destinationPosition = params.destinationPosition
   local destinationRotation = params.destinationRotation

   local items = findInRadiusBy(originPosition, 4, isCardOrDeck)

   if #items == 0 then return end

   items[1].setPositionSmooth(destinationPosition, false, false)

   if(destinationRotation) then
      items[1].setRotationSmooth(destinationRotation, false, false)
   end
end

function getCardId(params)
   return getCardProperty({card = params.card, property = "code"})
end

function getCardData(params)
   local card = params.card
   local cardData = ""

   if(type(card) == "table") then
      cardData = card.gm_notes or ""
   else
      cardData = card.getGMNotes() or ""
   end

   if(cardData == "") then return {} end

   return json.decode(cardData)
end

function getCardProperty(params)
   local card = params.card
   local property = params.property

   local cardData = getCardData({card = card})

   return cardData[property]
end

function moveCardFromPosition(params)
   local originPosition = params.origin
   local destination = calculateDestination(params)

   local items = findInRadiusBy(originPosition, 2, isCard)

   if(#items == 1) then
      items[1].setLock(false)
      items[1].setPositionSmooth(destination.position, false, false)
      items[1].setRotationSmooth(destination.rotation, false, false)
   end
end

function moveCardToLocation(params)
   local origin = params.origin
   local destination = params.destination
   local items = findInRadiusBy(origin, 4, isCard, true)

   if(#items == 1) then
      items[1].setLock(false)
      items[1].setPositionSmooth(destination, false, false)
   end
end

function moveCardFromDeckById(params)
   local cardId = params.cardId
   local deckPosition = params.deckPosition
   local destinationPosition = Vector(params.destinationPosition)
   local destinationRotation = params.destinationRotation and Vector(params.destinationRotation) or Vector({0,180,0})
   local destinationScale = params.destinationScale and Vector(params.destinationScale) or nil
   local flipCard = params.flipCard or false
   local settings = params.settings or {}
   local items = findInRadiusBy(deckPosition, 4, isCardOrDeck, false)
   local cardFound = false

   if(flipCard) then destinationRotation["z"] = 180 end

   for i, v in ipairs(items) do
      if(v.tag == "Card") then
         local id = getCardId({card = v})

         if(id == cardId) then
            v.setPositionSmooth(destinationPosition, false, false)
            v.setRotationSmooth(destinationRotation, false, false)
            if(destinationScale) then v.setScale(destinationScale) end
            cardFound = true
         end
      elseif(v.tag == "Deck") then
         for i, card in ipairs(v.getObjects()) do
            local id = getCardId({card = card})
            if(id == cardId) then
               v.takeObject({
                  guid = card.guid,
                  position = destinationPosition,
                  rotation = destinationRotation,
                  smooth = true,
                  callback_function = function(obj)
                     if(destinationScale) then obj.setScale(destinationScale) end

                     if(settings.hideWhenFaceDown ~= nil) then
                        obj.hide_when_face_down = settings.hideWhenFaceDown
                     end
                  end
               })
               cardFound = true
               break
            end
         end
      end
   end

   return cardFound
end

function moveCardFromEncounterDeckById(params)
   local cardId = params.cardId
   local searchInDiscard = params.searchInDiscard or false
   local flipCard = params.flipCard or false
   local destination = calculateDestination(params)
   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)

   if searchInDiscard then
      local discardPosition = Vector(scenarioManager.call('getEncounterDiscardPosition'))

      if moveCardFromDeckById({
         cardId = cardId,
         deckPosition = discardPosition,
         destinationPosition = destination.position,
         destinationRotation = destination.rotation,
         flipCard = flipCard
      }) then
         return
      end
   end

   local deckPosition = Vector(scenarioManager.call('getEncounterDeckPosition'))

   moveCardFromDeckById({
      cardId = cardId,
      deckPosition = deckPosition,
      destinationPosition = destination.position,
      destinationRotation = destination.rotation,
      flipCard = flipCard
   })
end

function ensureMinimumYPosition(params)
   position = Vector(params.position)
   minimumY = params.minimumY

   if(position.y ~= nil) then
      if(position.y < minimumY) then
         position.y = minimumY
      end
   else
      if(position[2] < minimumY) then
         position[2] = minimumY
      end
   end

   return position
end

function onObjectNumberTyped(object, playerColor, number)
   if(object.type ~= "Deck" and object.type ~= "Card") then return false end

   local nearbyObjects = findInRadiusBy(object.getPosition(), 4)
   local playmat = nil

   for _, obj in ipairs(nearbyObjects) do
      if obj.hasTag("playmat") then
         playmat = obj
         break
      end
   end

   if(playmat) then
      playmat.call("drawCards", {objectToDrawFrom = object, numberToDraw = number})
      return true
   end
end

function onObjectEnterZone(zone, card)
   if(supressZoneInteractions) then return end
   if(not isCard(card)) then return end

   local zoneType = zone.getVar("zoneType")
   local zoneIndex = zone.getVar("zoneIndex")

   if(not zoneType) then return end

   local cardData = getCardData({card = card})
   local cardType = cardData.type

   if(cardType == "hero" or ((cardType == "villain" or cardType == "main_scheme") and zoneType ~= "victoryDisplay")) then
      return
   end

   local playerColor = zone.getVar("playerColor")

   if(playerColor) then card.setVar("playerColor", playerColor) end

   Wait.frames(function()
      resizeCardOnEnterZone(card, zoneType)
   end, 
   15)
   
   positionCardOnEnterZone(card, zoneType, zoneIndex)

   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
   scenarioManager.call("onCardEnterZone", {zone=zone, card = card})

   if(zoneType == "victoryDisplay") then
      updateVictoryDisplayDetails()
   end

   --TODO: Refactor these counter placement functions
   Wait.condition(
      function()
         if(card.isDestroyed()) then return end

         if(zoneType == "sideScheme") then
            addThreatCounterToSideScheme(card)
         elseif(zoneType == "minion") then
            addHealthCounterToMinion(card)
            if(card.hasTag("toughness")) then
               addStatusToMinion({card = card, statusType = "tough"})
            end
         end
   
         local counter = cardData.counter
   
         if(counter) then
            if (counter == "general") then
               addGeneralCounterToCard(card, cardData)
            end
         end   
      end,
      function()
         return card.isDestroyed() or card.resting
      end,
      2
   )

end

function resizeCardOnEnterZone(card, zoneType)
   if(card.isDestroyed()) then return end

   local newScale = nil

   if(zoneType == "hero") then
      newScale = CARD_SCALE_PLAYER
   elseif(zoneType == "sideScheme" or zoneType == "encounterDeck" or zoneType == "attachment" or zoneType == "environment" or zoneType == "minion" or zoneType == "victoryDisplay") then
      newScale = CARD_SCALE_ENCOUNTER
   end

   if(newScale) then
      card.setScale(newScale)
   end
end

function positionCardOnEnterZone(card, zoneType, zoneIndex)
   if(zoneType ~= "sideScheme" and zoneType ~= "attachment" and zoneType ~= "environment" and zoneType ~= "minion" and zoneType ~= "victoryDisplay") then
      return
   end

   local cardType = getCardProperty({card = card, property = "type"})
   local newCardPosition = getNewZoneCardPosition({zoneIndex = zoneIndex})
   local originalRotation = card.getRotation()
   local cardRotation = string.sub(cardType, -6, -1) == "scheme" and {0,90,originalRotation[3]} or {0,180,originalRotation[3]}

   card.setPositionSmooth(newCardPosition)
   card.setRotationSmooth(cardRotation)
   card.setScale(ENCOUNTER_DECK_SCALE)
end

function addThreatCounterToSideScheme(card)
   local threatCounterBag = getObjectFromGUID(GUID_THREAT_COUNTER_BAG)
   local cardPosition = card.getPosition()
   local counterPosition = {cardPosition[1] - 0.76, cardPosition[2] + 0.07, cardPosition[3] - 1.08}
   local threatCounter = threatCounterBag.takeObject({position = counterPosition, smooth = false})
   card.setVar("counterGuid", threatCounter.getGUID())
   
   --TODO: Extract this calculation into a function?
   local cardData = getCardData({card = card})
   local baseThreat = cardData.baseThreat and tonumber(cardData.baseThreat) or 0
   local baseThreatIsFixed = cardData.baseThreatIsFixed == "true"
   local hinder = cardData.hinder and tonumber(cardData.hinder) or 0
   local heroManager = getObjectFromGUID(GUID_HERO_MANAGER)
   local heroCount = heroManager.call("getHeroCount")
   local threat = 0

   if baseThreatIsFixed then
      threat = baseThreat + (heroCount * hinder)
   else
      threat = baseThreat * heroCount
   end
 
   Wait.frames(
      function()
         threatCounter.setScale({0.75, 1.00, 0.75})
         threatCounter.call("setValue", {value = threat})
     end,
     1
   ) 
end

function addGeneralCounterToCard(card, cardData)
   if(card.getVar("counterGuid")) then return end
   if (not cardData) then cardData = getCardData({card = card}) end

   local counterBag = getObjectFromGUID(GUID_GENERAL_COUNTER_BAG)
   local cardPosition = card.getPosition()
   local counterPosition = {cardPosition[1] + 1.30, cardPosition[2] + 0.10, cardPosition[3] + 0.70}
   local counter = counterBag.takeObject({position = counterPosition, smooth = false})
   card.setVar("counterGuid", counter.getGUID())
   
   --TODO: Extract this calculation into a function?
   local baseValue = cardData.counterValue and tonumber(cardData.counterValue) or 0
   local valuePerHero = cardData.counterValuePerHero and tonumber(cardData.counterValuePerHero) or 0
   local heroManager = getObjectFromGUID(GUID_HERO_MANAGER)
   local heroCount = heroManager.call("getHeroCount")
   local value = baseValue + (heroCount * valuePerHero)
 
   Wait.frames(
      function()
         counter.setScale({0.45, 1.00, 0.45})
         counter.setName(cardData.counterName or "")
         counter.call("setValue", {value = value})
     end,
     1
   )    
end

function addHealthCounterToMinion(card)
   local healthCounterBag = getObjectFromGUID(GUID_HEALTH_COUNTER_BAG)
   local cardPosition = card.getPosition()
   local counterPosition = {cardPosition[1] + 1.55, cardPosition[2] + 0.07, cardPosition[3] - 0.30}
   local healthCounter = healthCounterBag.takeObject({position = counterPosition, smooth = false})
   card.setVar("counterGuid", healthCounter.getGUID())
   
   --TODO: Extract this calculation into a function?
   local cardData = getCardData({card = card})
   local health = 0

   if(cardData.healthPerHero) then
      local heroManager = getObjectFromGUID(GUID_HERO_MANAGER)
      local heroCount = heroManager.call("getHeroCount")
      health = cardData.health * heroCount
   else
      health = cardData.health
   end
 
   Wait.frames(
      function()
         healthCounter.setScale({0.31, 1.00, 0.31})
         healthCounter.call("setValue", {value = health})
     end,
     1
   ) 
end

function onObjectLeaveZone(zone, card)
   if(supressZoneInteractions) then return end
   if(not isCard(card)) then return end

   local zoneType = zone.getVar("zoneType")
   if(not zoneType) then return end

   local cardData = getCardData({card = card})
   local cardType = cardData.type or ""
   local cardAspect = cardData.aspect or ""

   if(cardType == "hero" or cardType == "villain" or cardType == "main_scheme") then
      return
   end

   card.setVar("playerColor", nil)

   removeCounterFromCard(card)

   Wait.frames(function()
      resizeCardOnLeaveZone(card, cardAspect)
   end,
   15)

   repositionCardsInZone({zone = zone})

   if(zoneType == "victoryDisplay") then
      updateVictoryDisplayDetails()
   end
end

function removeCounterFromCard(card)
   local counterGuid = card.getVar("counterGuid")

   if(counterGuid) then
      local counter = getObjectFromGUID(counterGuid)
      if(counter) then counter.destruct() end
      card.setVar("counterGuid", nil)
   end
end

function resizeCardOnLeaveZone(card, cardAspect)
   if(card.isDestroyed()) then return end

   if(cardAspect == "encounter") then
      card.setScale(CARD_SCALE_ENCOUNTER)
   else
      card.setScale(CARD_SCALE_PLAYER)
   end
end

function repositionCardsInZone(params)
   local zone = params.zone
   local zoneType = zone.getVar("zoneType")
   local zoneIndex = zone.getVar("zoneIndex")

   if(zoneType ~= "sideScheme" and zoneType ~= "attachment" and zoneType ~= "environment" and zoneType ~= "minion" and zoneType ~= "victoryDisplay") then
      return
   end

   local items = zone.getObjects()
   local zoneDef = getZoneDefinitionByIndex({zoneIndex = zoneIndex})
   local cardNumber = 0

   for i, v in ipairs(items) do
      if(v.tag == "Card") then
         cardNumber = cardNumber + 1
         local origCardPosition = Vector(v.getPosition())
         local newCardPosition = Vector(getZoneCardPosition({zoneDef = zoneDef, cardNumber = cardNumber}))

         if(newCardPosition == origCardPosition) then goto continue end

         local itemsOnCard = getItemsOnCard({card = v})
         local itemsToReposition = {}
         local cardGuid = v.getGUID()

         for i, item in ipairs(itemsOnCard) do
            --if(not item.hasTag("immobile")) then
            if(item.interactable) then
               if(item.tag == "Tile" or (item.tag == "Card" and item.getGUID() ~= cardGuid)) then
                  local origItemPosition = item.getPosition()
                  local itemOffset = origCardPosition - origItemPosition
                  local newItemPosition = newCardPosition - itemOffset   
                  table.insert(itemsToReposition, {item = item, newPosition = newItemPosition})
               end
            end
         end

         if(newCardPosition) then
            v.setPositionSmooth(newCardPosition, false, false)

            for i, item in ipairs(itemsToReposition) do
               item.item.setPositionSmooth(item.newPosition, false, false)
            end
         end
      end
      ::continue::
   end
end

function getZoneDefinitionByIndex(params)
   local zoneIndex = params.zoneIndex
   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)

   return scenarioManager.call("getZoneDefinition", {zoneIndex = zoneIndex})
end

function getZoneCardCount(params)
   local zoneIndex = params.zoneIndex
   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
   local zoneGuid = scenarioManager.call("getZoneGuid", {zoneIndex = zoneIndex})
   local zone = getObjectFromGUID(zoneGuid)

   if(not zone) then return nil end

   local items = zone.getObjects()
   local cardCount = 0

   for i, v in ipairs(items) do
      if(v.tag == "Card") then cardCount = cardCount + 1 end
   end
   --TODO: Filter out cards of the wrong type

   return cardCount
end

function getNewZoneCardPosition(params)
   local zoneDef = getZoneDefinitionByIndex({zoneIndex = params.zoneIndex})

   if(not zoneDef) then return nil end
   
   local cardNumber = getZoneCardCount({zoneIndex = params.zoneIndex})

   if(cardNumber == nil) then return nil end

   if(params.forNextCard) then cardNumber = cardNumber + 1 end

   return getZoneCardPosition({zoneDef = zoneDef, cardNumber = cardNumber})
end

function getZoneCardPosition(params)
   local zoneDef = params.zoneDef
   local cardNumber = params.cardNumber

   if(not zoneDef) then return nil end

   local origin = zoneDef.firstCardPosition
   local horizontalGap = zoneDef.horizontalGap
   local verticalGap = zoneDef.verticalGap
   local layoutDirection = zoneDef.layoutDirection
   local width = zoneDef.width
   local height = zoneDef.height

   local column = 0
   local row = 0

   if(layoutDirection == "horizontal") then
      if(cardNumber % width == 0) then
         column = width
         row = cardNumber / width
      else
         column = cardNumber % width
         row = math.floor(cardNumber / width) + 1
      end
   else
      if(cardNumber % height == 0) then
         column = cardNumber / height
         row = height
      else
         column = math.floor(cardNumber / height) + 1
         row = cardNumber % height
      end
   end

   local x = origin[1] + horizontalGap * (column - 1)
   local z = origin[3] - verticalGap * (row - 1)

   return {x, origin[2], z}
end

function updateVictoryDisplayDetails()
   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
   local zoneGuid = scenarioManager.call("getZoneGuid", {zoneIndex = "victoryDisplay"})
   local zone = getObjectFromGUID(zoneGuid)

   if(not zone) then return nil end

   local items = zone.getObjects()
   local cardCount = 0
   local victoryPoints = 0

   for i, v in ipairs(items) do
      if(v.tag == "Card") then 
         cardCount = cardCount + 1

         local cardData = getCardData({card = v})
         victoryPoints = victoryPoints + (cardData.victory or 0)
      end
   end

   local victoryPointsReadout = scenarioManager.call("getItemFromManifest", {key = "victoryPointsReadout"})
   local victoryDisplayItemCountReadout = scenarioManager.call("getItemFromManifest", {key = "victoryDisplayItemCountReadout"})

   victoryPointsReadout.TextTool.setValue("Victory Points: " .. victoryPoints)
   victoryDisplayItemCountReadout.TextTool.setValue("Items: " .. cardCount)
end

function addStatusToVillain(params)
   local villain = params.villain
   local statusType = params.statusType
   local villainCard = getObjectFromGUID(villain.cardGuid)
 
   if not cardCanHaveStatus({card = villainCard, statusType = statusType}) then
     return
   end
 
   placeStatusToken({card = villainCard, statusType = statusType})
 end
 
 function addStatusToMinion(params)
   local minionCard = params.card
   local statusType = params.statusType
 
   if not cardCanHaveStatus({card = minionCard, statusType = statusType}) then
     return
   end
 
   placeStatusToken({card = minionCard, statusType = statusType})
 end

 function addStatusToAllHeroes(params)
   local statusType = params.statusType
   local heroManager = getObjectFromGUID(GUID_HERO_MANAGER)
   local heroes = heroManager.call("getSelectedHeroes")
 
   for color, _ in pairs(heroes) do
     addStatusToHero({playerColor = color, statusType = statusType})
   end
 end
 
 function addStatusToHero(params)
   local playerColor = params.playerColor
   local statusType = params.statusType
   local heroManager = getObjectFromGUID(GUID_HERO_MANAGER)
   local hero = heroManager.call("getHeroByPlayerColor", {playerColor = playerColor})
   local heroCard = getObjectFromGUID(hero.identityGuid)
 
   if not cardCanHaveStatus({card = heroCard, statusType = statusType}) then
     return
   end
 
   placeStatusToken({card = heroCard, statusType = statusType, playerColor = playerColor})
 end
 
 function cardCanHaveStatus(params)
   local card = params.card
   local cardPosition = card.getPosition()
   local cardName = card.getName()
   local targetType = Global.call("getCardProperty", {card = card, property = "type"})
   local statusType = params.statusType
 
   --statusCount = getStatusCount({targetPosition = cardPosition, targetType = targetType, statusType = statusType})
   statusCount = getStatusCount({card = card, statusType = statusType})
 
   local playerColor = card.getVar("playerColor")
   local messageType = playerColor and MESSAGE_TYPE_PLAYER or MESSAGE_TYPE_INFO

   if(statusType == "tough") then
     local maxToughCount = (targetType == "hero" and cardName == "Colossus") and 2 or 1
     if(statusCount >= maxToughCount) then
       displayMessage({message = cardName .. " is already tough.", messageType = messageType, playerColor = playerColor})
       return false
     end
   else
     if(card.hasTag("stalwart")) then
       displayMessage({message = cardName .. " is stalwart and cannot be " .. statusType .. ".", messageType = messageType, playerColor = playerColor})
       return false
     end
     
     local maxStatusCount = card.hasTag("steady") and 2 or 1
 
     if(statusCount >= maxStatusCount) then
       displayMessage({message = cardName .. " is already " .. statusType .. ".\n(If there is an effect in play that makes this character steady, please give them a second " .. statusType .. " card manually.)", messageType = messageType, playerColor = playerColor})
       return false
     end
   end
 
   return true
 end
 
 function getStatusCount(params)
   local card = params.card
   local statusType = params.statusType
   local items = getItemsOnCard({card = card})
   local statusCount = 0

   for _, item in ipairs(items) do
      if item.hasTag(statusType.."-status") then
        statusCount = statusCount + 1
      end
   end

   return statusCount
 end
 
 function placeStatusToken(params)
   local card = params.card
   local statusPosition = Vector(card.getPosition())
   statusPosition.y = statusPosition.y + 1
   local targetType = Global.call("getCardProperty", {card = card, property = "type"})
   local statusType = params.statusType
 
   local statusBagGuid = ""

   --TODO: Use constants for status bag guids
   --TODO: Use one status bag for all target types, but change the scale appropriately
   if(targetType == "villain") then
     statusBagGuid = statusType == "tough" and "35b809"
       or statusType == "stunned" and "882e12"
       or statusType == "confused" and "50c501"
   else
     statusBagGuid = statusType == "tough" and "53a9f2"
       or statusType == "stunned" and "c46ad4"
       or statusType == "confused" and "0b8743"
   end
 
   local statusBag = getObjectFromGUID(statusBagGuid)
   local statusToken = statusBag.takeObject({position = statusPosition, smooth = false})
 
   local message = card.getName() .. " is " .. statusType .. "!"
 
   if(statusType == "stunned" or statusType == "confused") then
     message = message .. "\n(If there is an effect in play that makes this character steady, they may need another status card to actually be " .. statusType .. ".\nIf they are stalwart, you may need to remove this status card.)"
   end
 
   local playerColor = params.playerColor or card.getVar("playerColor")
   local messageType = playerColor and MESSAGE_TYPE_PLAYER or MESSAGE_TYPE_INFO

   displayMessage({message = message, messageType = messageType, playerColor = playerColor})
 end

function getItemsOnCard(params)
   card = params.card
   local cardPosition = card.getPosition()
   local castSize= getCastSizeForCard({card = card})

   local objList = Physics.cast({
      origin       = cardPosition,
      direction    = {0,1,0},
      type         = 3,
      size         = castSize,
      max_distance = 0,
      debug        = false
   })

   local items = {}
   
   for _, obj in ipairs(objList) do
      table.insert(items, obj.hit_object)
   end

   return items
end

function getCastSizeForCard(params)
   local card = params.card
   local cardRotation = card.getRotation()
   local cardScale = card.getScale()
   local y = cardRotation.y
   local orientation = (y >= 0 and y <= 5) or (y >= 355 and y <= 360) or (y >= 175 and y <= 185) and "vertical" or "horizontal"
   local longDimension = cardScale.x * 2.61
   local shortDimension = cardScale.x * 2.06

   return orientation == "vertical" and {shortDimension, 2, longDimension} or {longDimension, 2, shortDimension}
end

function displayMessage(params)
   local message = params.message
   local messageType = params.messageType
   local playerColor = params.playerColor

   if messageType == MESSAGE_TYPE_PLAYER then
      local messageTint = 
         playerColor == PLAYER_COLOR_RED and MESSAGE_TINT_RED
         or playerColor == PLAYER_COLOR_BLUE and MESSAGE_TINT_BLUE
         or playerColor == PLAYER_COLOR_GREEN and MESSAGE_TINT_GREEN
         or playerColor == PLAYER_COLOR_YELLOW and MESSAGE_TINT_YELLOW

      if(Player[playerColor].seated) then
         broadcastToColor(message, playerColor, messageTint)
      else
         broadcastToAll(message, messageTint)
      end

      return
   end

   local messageTint = 
      messageType == MESSAGE_TYPE_FLAVOR_TEXT and MESSAGE_TINT_FLAVOR
      or messageType == MESSAGE_TYPE_INSTRUCTION and MESSAGE_TINT_INSTRUCTION
      or messageType == MESSAGE_TYPE_INFO and MESSAGE_TINT_INFO

   broadcastToAll(message, messageTint)
end

function calculateDestination(params)
   local zoneIndex = params.zoneIndex
   local minimumY = params.minimumY or 3
   local destination = {}

   if(zoneIndex) then
      destination.position = ensureMinimumYPosition({position = getNewZoneCardPosition({zoneIndex = zoneIndex, forNextCard = true}), minimumY = minimumY})
      destination.rotation = zoneIndex == "sideScheme" and {0,90,0} or {0,180,0}
   else
      destination.position = ensureMinimumYPosition({position = params.destinationPosition, minimumY = minimumY})
      destination.rotation = params.destinationRotation and Vector(params.destinationRotation) or {0,180,0}
   end

   return destination
end

function getDeckOrCardAtLocation(params)
   --TODO: this is hacky
   position = Vector(params.position)
   position["y"] = 0

   local objects = findInRadiusBy(position, 3, isCardOrDeck, false)
   for _, object in pairs(objects) do
    if(object.tag == "Deck" or object.tag == "Card") then
     return object
    end
   end
  
   return nil
end

function discardFromEncounterDeck(params)
   local searchFunction = params.searchFunction
   local searchFunctionTarget = params.searchFunctionTarget
   local searchForCards = searchFunction ~= nil
   local cardsToDiscard = params.cardsToDiscard or 0
   local cardsToFind = params.cardsToFind or 0
   local stopWhenCardsFound = params.stopWhenCardsFound
   params.minimumY = 2.5

   local callBackFunction = params.callBackFunction
   local callBackTarget = params.callBackTarget

   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
   local deckPosition = Vector(scenarioManager.call("getEncounterDeckPosition"))
   local discardPosition = Vector(scenarioManager.call("getEncounterDiscardPosition"))

   local destination = calculateDestination(params)
   local deckDepleted = false
   local cardsDiscarded = 0
   local cardsFound = 0
   local stopDiscarding = false

   local deck = getDeckOrCardAtLocation({position=deckPosition})
   local discardPile = getDeckOrCardAtLocation({position=discardPosition})

   if not deck then
      reshuffleEncounterDeck()
   end

   Wait.condition(
      function()
         startLuaCoroutine(self, "discardCoroutine")
      end, 
      function()
         return discardPile == nil or discardPile.isDestroyed() or discardPile.resting
      end, 
      3, 
      function()
         startLuaCoroutine(self, "discardCoroutine")
      end
   )

   function discardCoroutine()
      while not stopDiscarding do
         local card = discardCardFromDeck({
            deckPosition = deckPosition,
            discardPosition = discardPosition,
            discardRotation = destination.rotation
         })

         cardsDiscarded = cardsDiscarded + 1

         if not card then
            deckDepleted = true
            break
         end

         if(searchForCards and cardsFound < cardsToFind) then
            local cardIsMatch = searchFunctionTarget.call(searchFunction, {card = card})
            if (cardIsMatch) then
               card.setPositionSmooth(destination.position, false, false)
               card.setRotationSmooth(destination.rotation, false, false)
               cardsFound = cardsFound + 1
            end
         end

         stopDiscarding = 
            deckDepleted 
            or (stopWhenCardsFound and cardsFound >= cardsToFind )
            or (cardsToDiscard > 0 and cardsDiscarded >= cardsToDiscard)

         if(not stopDiscarding) then
            for i = 1, 40 do
               coroutine.yield(0)
            end
         end
      end

      if callBackFunction then
         callBackTarget.call(callBackFunction)
      end

      if searchForCards and cardsFound < cardsToFind then
         message = params.notFoundMessage
         messageType = params.notFoundMessageType or MESSAGE_TYPE_INFO
         playerColor = params.playerColor

         if(message) then
            displayMessage({message = message, messageType = messageType, playerColor = playerColor})
         end
      end

      Wait.frames(
         function()
            local deck = getDeckOrCardAtLocation({position=deckPosition})
            if(not deck) then
               reshuffleEncounterDeck()
            end      
         end,
         30
      )

      return 1
   end   
end

function discardCard(params)
   local card = params.card
   local discardPosition = ensureMinimumYPosition({position = params.discardPosition, minimumY = 2.5})

   card.setPositionSmooth(encounterDiscardPosition, false, false)
   card.setRotationSmooth({0,180,0}, false, false)
end

function discardCardFromDeck(params)
   local deckPosition = params.deckPosition
   local discardPosition = ensureMinimumYPosition({position = params.discardPosition, minimumY = 2.5})
   local discardRotation = params.discardRotation or {0,180,0}
   local deckOrCard = getDeckOrCardAtLocation({position=deckPosition})

   if not deckOrCard then
      return nil
   end

   local card = nil

   if(deckOrCard.tag == "Deck") then
      card = deckOrCard.takeObject({position = discardPosition, rotation = discardRotation, smooth = true})
   else
      card = deckOrCard
      card.setPositionSmooth(discardPosition, false, false)
      card.setRotationSmooth(discardRotation, false, false)
   end

   return card
end

function cardIsInPlay(params)
   local card = findCard(params)
   if not card then return false end
   return isFaceUp({object = card})
end

function findCard(params)
   local cardId = params.cardId
   local allObjects = getAllObjects()

   for _, object in pairs(allObjects) do
      if object.tag == "Card" then
         local cardData = getCardData({card = object})
         if (cardData.code == cardId) then
            return object
         end
      end
   end

   return nil
end

function discardFromPlayerDeck(params)
   local playerColor = params.playerColor
   local numberOfCards = params.numberOfCards
   local heroManager = getObjectFromGUID(GUID_HERO_MANAGER)
   local playmat = heroManager.call("getPlaymat", {playerColor = playerColor})
   local deckPosition = Vector(playmat.call("getPlayerDeckPosition"))
   local discardPosition = Vector(playmat.call("getPlayerDiscardPosition"))

   local destination = calculateDestination({
      destinationPosition = discardPosition,
      destinationRotation = {0,180,0},
      minimumY = 2.5
   })

   function discardCoroutine()
      for i = 1, numberOfCards do
         local card = discardCardFromDeck({
            deckPosition = deckPosition,
            discardPosition = destination.position,
            discardRotation = destination.rotation
         })

         if(not card) then
            Wait.frames(function()
               refreshDeck({deckPosition = deckPosition, discardPosition = discardPosition})
               displayMessage({message = "You cycled your deck. Time for an encounter card!", messageType = MESSAGE_TYPE_INFO, playerColor = playerColor})
               dealEncounterCardToPlayer({playerColor = playerColor})
            end, 
            30)

            return 1
         end
           
         local count = 0
         while count < 40 do
            count = count + 1
            coroutine.yield(0)
         end   
      end

      return 1
   end
   
   startLuaCoroutine(self, "discardCoroutine") 
end

function discardFromAllPlayerDecks(params)
   local numberOfCards = params.numberOfCards
   local heroManager = getObjectFromGUID(GUID_HERO_MANAGER)
   local selectedHeroes = heroManager.call("getSelectedHeroes")

   for color, _ in pairs(selectedHeroes) do
      discardFromPlayerDeck({playerColor = color, numberOfCards = numberOfCards})
   end
end

function refreshDeck(params)
   local deckPosition = params.deckPosition
   local discardPosition = params.discardPosition
   local deck = getDeckOrCardAtLocation({position=discardPosition})

   if(not deck) then return end

   deck.setPositionSmooth(deckPosition, false, false)
   deck.setRotationSmooth({0,180,180}, false, false)

   Wait.condition(
      function()
         deck.shuffle()
      end,
      function()
         return deck.resting
      end,
      2
   )
end

local MARVEL_CDB_PUBLIC_DECK_URL="https://marvelcdb.com/api/public/decklist/"
local MARVEL_CDB_PRIVATE_DECK_URL="https://marvelcdb.com/api/public/deck/"

function importDeck(params)
   local deckId = params.deckId
   local isPrivateDeck = params.isPrivateDeck
   local callbackFunction = params.callbackFunction
   local callbackTarget = params.callbackTarget

   local apiURL = isPrivateDeck and MARVEL_CDB_PRIVATE_DECK_URL or MARVEL_CDB_PUBLIC_DECK_URL

   WebRequest.get(apiURL .. deckId, function(res) 
     local deckInfo = nil
 
     if res.is_done and not res.is_error then
       if string.find(res.text, "<!DOCTYPE html>") then
         broadcastToAll("Deck "..deckId.." is not shared", {0.5,0.5,0.5})
         return
       end
   
       deckInfo = JSON.decode(res.text)
     else
       print (res.error)
       return
     end
   
     if (deckInfo == nil) then
       broadcastToAll("Deck not found!", {0.5,0.5,0.5})
       return
     else
       print("Found decklist: "..deckInfo.name)
     end
     
     callbackTarget.call(callbackFunction, {deckInfo = deckInfo})
   end)
 end

 function getSortedListOfItems(params)
   local items = params.items
   local itemList = {}
 
   for key, item in pairs(items) do
      item.key = key
      table.insert(itemList, item)
   end
 
   function compareNames(a, b)
       return stripArticles(a.name) < stripArticles(b.name) 
   end
   
   return table.sort(itemList, compareNames)
 end
 
 function stripArticles(orig)
   local lower = string.lower(orig)
 
   if(string.sub(lower, 1, 4) == "the ") then
       return string.sub(orig, 5, -1)
   end
 
   if(string.sub(lower, 1, 2) == "a ") then
       return string.sub(orig, 3, -1)
   end
 
   if(string.sub(lower, 1, 3) == "an ") then
       return string.sub(orig, 4, -1)
   end
 
   return orig
 end
 
 function breakLabel(params)
   local label = params.label
   local maxWidth = params.maxWidth or 10
   local hasSpaces = string.find(label, " ") ~= nil
   local hasHyphens = string.find(label, "-") ~= nil
   local isBreakable = hasSpaces or hasHyphens

   if(string.len(label) <= maxWidth or not isBreakable) then
       return {
           text=label,
           length=string.len(label)
       }
   end

   local breakCharacter = hasSpaces and " " or "-"
   local words = getWords(label, breakCharacter)
   local firstLine = ""
   local secondLine = ""
   local firstLineOffset = 0
   local secondLineOffset = 0

   for i=1, #words do
       if(string.len(firstLine) >= string.len(secondLine)) then
           local index = #words - secondLineOffset
           secondLineOffset = secondLineOffset + 1
           secondLine = words[index] .. " " .. secondLine
       else
           local index = 1 + firstLineOffset
           firstLineOffset = firstLineOffset + 1
           firstLine = firstLine .. " " .. words[index]
       end
   end

   local length = string.len(firstLine) > string.len(secondLine) and string.len(firstLine) or string.len(secondLine)
   local hyphen = breakCharacter == "-" and "-" or ""

   return {
       text = trim(firstLine) .. hyphen .. "\n" .. trim(secondLine),
       length = length
   }
end

function getWords (text, breakCharacter)
   local t={}

   if(breakCharacter == " ") then
      -- for str in string.gmatch(text, "[%w']*[%w]+") do
      --    table.insert(t, str)
      -- end
      for str in string.gmatch(text, "[^%s]+") do
         table.insert(t, str)
      end
   else
      for str in string.gmatch(text, "[^%-]+") do
         table.insert(t, str)
      end      
   end

   return t
end

function trim(s)
   return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end
