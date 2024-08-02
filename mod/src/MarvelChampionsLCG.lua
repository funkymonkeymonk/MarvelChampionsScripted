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

PLAYMAT_POSITION_RED    = {-41.19, 1.04, -17.12}
PLAYMAT_POSITION_BLUE   = {-13.75, 1.04, -17.75}
PLAYMAT_POSITION_GREEN  = {13.74, 1.04, -17.76}
PLAYMAT_POSITION_YELLOW = {41.21, 1.04, -17.08}

PLAYMAT_OFFSET_HEALTH_COUNTER = {-10.42, 0.10, 5.50}
PLAYMAT_OFFSET_IDENTITY       = {-9.89, 3.00, 1.00}
PLAYMAT_OFFSET_DECK           = {-8.40, 3.00, -4.66}
PLAYMAT_OFFSET_DISCARD        = {-11.30, 2.00, -4.66}

SETUP_BUTTON_FONT_SIZE_INACTIVE = 400
SETUP_BUTTON_FONT_SIZE_ACTIVE   = 500

GUID_HERO_MANAGER              = "ff377b"
GUID_SCENARIO_MANAGER          = "06c2fd"
GUID_MODULAR_SET_MANAGER       = "608543"
GUID_LAYOUT_MANAGER            = "0d33cc"
ASSET_BAG_GUID                 = "91eba8"
FIRST_PLAYER_TOKEN_GUID        = "d93792"
GENERAL_COUNTER_BAG_GUID       = "aec1c4"
GUID_LARGE_GENERAL_COUNTER_BAG = "65c1cc"
GUID_THREAT_COUNTER_BAG        = "eb5d6d"
GUID_SELECTOR_TILE             = "c04e76"
GUID_MODULAR_SET_SELECTOR_TILE = "740464"

ASSET_GUID_BLACK_HOLE             = "740595"
ASSET_GUID_PLAYMAT                = "f5701e" 
ASSET_GUID_HERO_HEALTH_COUNTER    = "16b5bd"
ASSET_GUID_VILLAIN_HEALTH_COUNTER = "8cf3d6"
ASSET_GUID_MAIN_THREAT_COUNTER    = "a9f7b8"
ASSET_GUID_BOOST_PANEL            = "ef27d7"

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
   position = {20.75, 1.00, 29.75},
   scale = {15.00, 1.00, 7.00},
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

IS_RESHUFFLING = false

function onLoad()
    -- Create context Menus
    addContextMenuItem("Random First Player", randomFirstPlayer)
    addContextMenuItem("Spawn Card", createUI)
end

function randomFirstPlayer()
    local sittingPlayers = {}
    for k,v in pairs({'White','Brown','Red','Orange','Yellow','Green','Teal','Blue','Purple','Pink','Black'}) do
        if Player[v].seated then
            table.insert(sittingPlayers,v)
        end
    end

    local pickedColor = sittingPlayers[math.random(#sittingPlayers)]
    broadcastToAll('The first player is ' .. Player[pickedColor].steam_name .. ' (' ..  pickedColor ..')')
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

function drawEncountercard(params)
   local drawToPosition = params[1]
   local isFaceUp = params[2]
   local drawToRotation = isFaceUp and {0, 180, 0} or {0, 180, 180}

   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
   local encounterDeckPosition = Vector(scenarioManager.call('getEncounterDeckPosition'))

   local items = findInRadiusBy(encounterDeckPosition, 4, isCardOrDeck)
   if #items > 0 then
      for i, v in ipairs(items) do
         if v.tag == 'Deck' then
            v.takeObject({index = 0, position = drawToPosition, rotation = drawToRotation})
            return
         end
      end
      items[1].setPositionSmooth(drawToPosition, false, false)
      items[1].setRotationSmooth(drawToRotation, false, false)
      return
   end

   reshuffleEncounterDeck(drawToPosition, drawToRotation)
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
            v.takeObject({index = 0, position = drawToPosition, rotation = drawToRotation})
            return
         end
      end

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
      
      Wait.time(function()
         deck.takeObject({index = 0, position = drawToPosition, rotation = drawToRotation})
         IS_RESHUFFLING = false 
      end,
      1)
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
   else
      printToAll("Couldn't find encounter discard pile to reshuffle", {1,0,0})
   end
end

function shuffleDeck(params)
   local items = findInRadiusBy(params.deckPosition, 4, isDeck)

   if (not items) then
      log("no deck found at position " .. params.deckPosition)
      return
   end

   local deck = items[1]
   deck.shuffle()
end

function isFaceUp(params)
   local object = params.object
   local z = object.getRotation()["z"]

   return z > -5 and z < 5
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

function onPlayerAction(player, action, targets)
   if(action == Player.Action.Delete) then
      for _, target in ipairs(targets) do
         if not target.getVar("preventDeletion") then
            target.destroy()
         end
      end

      return false
   end

   -- if(action == Player.Action.PickUp) then
   --    if(#targets > 1) then return true end
   --    local card = targets[1]

   --    if(not isCard(card)) then return true end

   --    if(not isFaceUp({object = card})) then return true end

   --    local zones = card.getZones()
   --    if #zones > 0 then return true end

   --    local cardType = getCardProperty({card = card, property = "type"})
   --    local zoneType = nil

   --    if(string.sub(cardType, -11) == "side_scheme") then
   --       zoneType = "sideScheme"
   --    elseif(cardType == "attachment") then
   --       zoneType = "attachment"
   --    elseif(cardType == "environment") then
   --       zoneType = "environment"
   --    end

   --    if(not zoneType) then return true end

   --    local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
   --    pingPosition = getNewZoneCardPosition({zoneType = zoneType, forNextCard = true})

   --    if(pingPosition) then
   --       player.pingTable(pingPosition)
   --    end
   -- end

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
   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
   local position = params.position
   local discardPosition = Vector(scenarioManager.call('getEncounterDiscardPosition'))
   local items = findInRadiusBy(position, 3, isCard, false)

   if #items > 0 then
     items[1].setPositionSmooth(discardPosition, false, false)
     items[1].setRotationSmooth({0,180,0}, false, false)
   end
end

function moveDeck(params)
   local originPosition = params.origin
   local destinationPosition = params.destination

   local items = findInRadiusBy(originPosition, 4, isCardOrDeck)

   if #items == 0 then return end

   items[1].setPositionSmooth(destinationPosition, false, false)
end

function getCardData(params)
   local card = params.card
   local cardId = type(card) == "table" and card.gm_notes or card.getGMNotes()
   local cardData = getCardFromCardPool(cardId)
   --local cardData = JSON.decode(gmNotes)
   return cardData
end

function getCardProperty(params)
   local cardData = getCardData(params)
   return cardData[params.property]
end

function moveCardFromDeckById(params)
   local cardId = params.cardId
   local deckPosition = params.deckPosition
   local destinationPosition = Vector(params.destinationPosition)
   local destinationRotation = params.destinationRotation and Vector(params.destinationRotation) or {0,180,0}
   local items = findInRadiusBy(deckPosition, 4, isCardOrDeck, false)
   local cardFound = false

   for i, v in ipairs(items) do
      if(v.tag == "Card") then
         local code = getCardProperty({card = v, property = "code"})

         if(code == cardId) then
            v.setPositionSmooth(destinationPosition, false, false)
            v.setRotationSmooth(destinationRotation, false, false)
            cardFound = true
         end
      elseif(v.tag == "Deck") then
         for i, card in ipairs(v.getObjects()) do
            local code = getCardProperty({card = card, property = "code"})

            if(code == cardId) then
               v.takeObject({
                  guid = card.guid,
                  position = destinationPosition,
                  rotation = destinationRotation,
                  smooth = true
               })
               cardFound = true
            end
         end
      end
   end

   return cardFound
 end

 function moveCardFromEncounterDeckById(params)
   local cardId = params.cardId
   local searchInDiscard = params.searchInDiscard or false
   local destinationPosition = nil
   local destinationRotation = nil
   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)

   if(params.zoneType) then
      destinationPosition = getNewZoneCardPosition({zoneType = params.zoneType, forNextCard = true})
      destinationRotation = params.zoneType == "sideScheme" and {0,90,0} or {0,180,0}
   else
      destinationPosition = Vector(params.destinationPosition)
      destinationRotation = params.destinationRotation and Vector(params.destinationRotation) or {0,180,0}
   end

   if searchInDiscard then
      local discardPosition = Vector(scenarioManager.call('getEncounterDiscardPosition'))

      if moveCardFromDeckById({
         cardId = cardId,
         deckPosition = discardPosition,
         destinationPosition = destinationPosition,
         destinationRotation = destinationRotation
      }) then
         return
      end
   end

   local deckPosition = Vector(scenarioManager.call('getEncounterDeckPosition'))

   moveCardFromDeckById({
      cardId = cardId,
      deckPosition = deckPosition,
      destinationPosition = destinationPosition,
      destinationRotation = destinationRotation
   })

 end

-- function onObjectEnterZone(zone, card)
--    if(not isCard(card)) then return end

--    local cardType = getCardProperty({card = card, property = "type"})
--    local zoneType = zone.getVar("zoneType")
--    local newCardPosition = getNewZoneCardPosition({zoneType = zoneType})
--    local originalRotation = card.getRotation()
--    local cardRotation = zoneType == "sideScheme" and {0,90,originalRotation[3]} or {0,180,originalRotation[3]}

--    card.setPositionSmooth(newCardPosition)
--    card.setRotationSmooth(cardRotation)
--    card.setScale(ENCOUNTER_DECK_SCALE)

--    if(zoneType == "sideScheme") then
--       Wait.frames(function()
--          addThreatCounterToSideScheme(card)
--       end, 
--       40)      
--    end
-- end

function addThreatCounterToSideScheme(card)
   local threatCounterBag = getObjectFromGUID(GUID_THREAT_COUNTER_BAG)
   local cardPosition = card.getPosition()
   local counterPosition = {cardPosition[1] - 0.38, cardPosition[2] + 0.07, cardPosition[3] - 1.45}
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
         threatCounter.setScale({0.48, 1.00, 0.48})
         threatCounter.call("setValue", {value = threat})
     end,
     1
   ) 
end

-- function onObjectLeaveZone(zone, card)
--    if(not isCard(card)) then return end
--    local counterGuid = card.getVar("counterGuid")

--    if(counterGuid) then
--       local counter = getObjectFromGUID(counterGuid)
--       if(counter) then counter.destruct() end
--       card.setVar("counterGuid", nil)
--    end

--    local cardType = getCardProperty({card = card, property = "type"})
--    if(cardType == "player_side_scheme") then
--       card.setScale(CARD_SCALE_PLAYER)
--    end

--    repositionCardsInZone({zone = zone})
-- end

function repositionCardsInZone(params)
   local zone = params.zone
   local zoneType = zone.getVar("zoneType")
   local items = zone.getObjects()
   local zoneDef = getZoneDefinitionByType({zoneType = zoneType})
   local cardNumber = 0

   for i, v in ipairs(items) do
      if(v.tag == "Card") then
         cardNumber = cardNumber + 1
         local newPosition = getZoneCardPosition({zoneDef = zoneDef, cardNumber = cardNumber})
         local counterPosition = {newPosition[1] - 0.38, newPosition[2] + 0.07, newPosition[3] - 1.45}
         local counter = getObjectFromGUID(v.getVar("counterGuid"))

         v.setPositionSmooth(newPosition, false, false)
         if(counter) then 
            counter.setPositionSmooth(counterPosition, false, false)
         end
      end
   end
end

function getZoneDefinitionByType(params)
   local zoneType = params.zoneType
   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)

   return scenarioManager.call("getZoneDefinition", {zoneType = zoneType})
end

function getZoneCardCount(params)
   local zoneType = params.zoneType
   local scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
   local zoneGuid = scenarioManager.call("getZoneGuid", {zoneType = zoneType})
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
   local zoneDef = getZoneDefinitionByType({zoneType = params.zoneType})

   if(not zoneDef) then return nil end
   
   local cardNumber = getZoneCardCount({zoneType = params.zoneType})

   if(cardNumber == nil) then return nil end

   if(params.forNextCard) then cardNumber = cardNumber + 1 end

   return getZoneCardPosition({zoneDef = zoneDef, cardNumber = cardNumber})
end

function getZoneCardPosition(params)
   local zoneDef = params.zoneDef
   local cardNumber = params.cardNumber

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

require('!/Cardplacer')
