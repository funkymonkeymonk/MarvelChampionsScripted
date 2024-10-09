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

PLAYMAT_POSITION_RED    = {-41.19, 1.04, -17.12}
PLAYMAT_POSITION_BLUE   = {-13.75, 1.04, -17.75}
PLAYMAT_POSITION_GREEN  = {13.74, 1.04, -17.76}
PLAYMAT_POSITION_YELLOW = {41.21, 1.04, -17.08}

PLAYMAT_OFFSET_HEALTH_COUNTER = {-10.42, 0.10, 5.50}
PLAYMAT_OFFSET_IDENTITY       = {-9.89, 0.15, 1.00}
PLAYMAT_OFFSET_DECK           = {-8.40, 0.30, -4.66}
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
GUID_HEALTH_COUNTER_BAG        = "029e3b"
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

IS_RESHUFFLING = false
supressZoneInteractions = false

local heroManager = nil

function supressZones()
   supressZoneInteractions = true

   Wait.time(function()
      supressZoneInteractions = false
   end, 3)
end

function onLoad()
    -- Create context Menus
    addContextMenuItem("Random First Player", randomFirstPlayer)
    addContextMenuItem("Spawn Card", createUI)

    heroManager = getObjectFromGUID(GUID_HERO_MANAGER)
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

function getCardId(params)
   return getCardProperty({card = params.card, property = "code"})
end

function getCardData(params)
   local card = params.card
   local cardData = ""

   if(type(card) == "table") then
      cardData = card.gm_notes or ""
      --return getPropertyFromCardTable(card, property)
   else
      cardData = card.getGMNotes() or ""
      --return getPropertyFromCardObject(card, property)
   end

   return json.decode(cardData)

   --local cardId = getCardId(params)
   --return getCardFromCardPool(cardId)
end

function getCardProperty(params)
   local card = params.card
   local property = params.property

   local cardData = getCardData({card = card})

   return cardData[property]

   -- local cardData = getCardData(params)
   -- if (not cardData) then return nil end
   -- return cardData[params.property]
end

-- function getPropertyFromCardTable(card, property)
--    local cardData = card.gm_notes or ""
-- end

-- function getPropertyFromCardObject(card, property)
--    local cardId = card.getVar("code")

--    if(not cardId) then
--       local cardData = card.getGMNotes() or ""
--       --Decode data into object, then setVar for all properties
--    end

--    return card.getVar(property)
-- end

function moveCardFromDeckById(params)
   local cardId = params.cardId
   local deckPosition = params.deckPosition
   local destinationPosition = Vector(params.destinationPosition)
   local destinationRotation = params.destinationRotation and Vector(params.destinationRotation) or {0,180,0}
   local items = findInRadiusBy(deckPosition, 4, isCardOrDeck, false)
   local cardFound = false

   for i, v in ipairs(items) do
      if(v.tag == "Card") then
         local id = getCardId({card = v})

         if(id == cardId) then
            v.setPositionSmooth(destinationPosition, false, false)
            v.setRotationSmooth(destinationRotation, false, false)
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
   local zoneIndex = params.zoneIndex

   if(zoneIndex) then
      destinationPosition = ensureMinimumYPosition(getNewZoneCardPosition({zoneIndex = zoneIndex, forNextCard = true}), 3)
      destinationRotation = zoneIndex == "sideScheme" and {0,90,0} or {0,180,0}
   else
      destinationPosition = ensureMinimumYPosition(Vector(params.destinationPosition), 3)
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

function ensureMinimumYPosition(position, minimumY)
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

function onObjectEnterZone(zone, card)
   if(supressZoneInteractions) then return end
   if(not isCard(card)) then return end

   local zoneType = zone.getVar("zoneType")
   local zoneIndex = zone.getVar("zoneIndex")

   if(not zoneType) then return end

   local cardType = getCardProperty({card = card, property = "type"})
   if(cardType == "hero" or cardType == "villain" or cardType == "main_scheme") then
      return
   end

   local playerColor = zone.getVar("playerColor")

   if(playerColor) then card.setVar("playerColor", playerColor) end

   resizeCardOnEnterZone(card, zoneType)
   positionCardOnEnterZone(card, zoneType, zoneIndex)

   scenarioManager = getObjectFromGUID(GUID_SCENARIO_MANAGER)
   scenarioManager.call("onCardEnterZone", {zone=zone, card = card})

   Wait.frames(function()
         if(zoneType == "sideScheme") then
            addThreatCounterToSideScheme(card)
         elseif(zoneType == "minion") then
            addHealthCounterToMinion(card)
            if(card.hasTag("toughness")) then
               addStatusToMinion({card = card, statusType = "tough"})
            end
         end
      end, 
      40)
end

function resizeCardOnEnterZone(card, zoneType)
   local newScale = nil

   if(zoneType == "hero") then
      newScale = CARD_SCALE_PLAYER
   elseif(zoneType == "sideScheme" or zoneType == "encounterDeck" or zoneType == "attachment" or zoneType == "environment" or zoneType == "minion") then
      newScale = CARD_SCALE_ENCOUNTER
   end

   if(newScale) then
      card.setScale(newScale)
   end
end

function positionCardOnEnterZone(card, zoneType, zoneIndex)
   if(zoneType != "sideScheme" and zoneType != "attachment" and zoneType != "environment" and zoneType != "minion") then
      return
   end

   local newCardPosition = getNewZoneCardPosition({zoneIndex = zoneIndex})
   local originalRotation = card.getRotation()
   local cardRotation = zoneType == "sideScheme" and {0,90,originalRotation[3]} or {0,180,originalRotation[3]}

   card.setPositionSmooth(newCardPosition)
   card.setRotationSmooth(cardRotation)
   card.setScale(ENCOUNTER_DECK_SCALE)
end

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
      health = cardData.health * heroManager.call("getHeroCount")
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
   resizeCardOnLeaveZone(card, cardAspect)
   repositionCardsInZone({zone = zone})
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

   if(zoneType != "sideScheme" and zoneType != "attachment" and zoneType != "environment" and zoneType != "minion") then
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
            if(item.tag == "Tile" or (item.tag == "Card" and item.getGUID() ~= cardGuid)) then
               local origItemPosition = item.getPosition()
               local itemOffset = origCardPosition - origItemPosition
               local newItemPosition = newCardPosition - itemOffset   
               table.insert(itemsToReposition, {item = item, newPosition = newItemPosition})
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
   local heroes = heroManager.call("getSelectedHeroes")
 
   for color, _ in pairs(heroes) do
     addStatusToHero({playerColor = color, statusType = statusType})
   end
 end
 
 function addStatusToHero(params)
   local playerColor = params.playerColor
   local statusType = params.statusType
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


PLAYER_COLOR_RED = "Red"
PLAYER_COLOR_BLUE = "Blue"
PLAYER_COLOR_GREEN = "Green"
PLAYER_COLOR_YELLOW = "Yellow"

MESSAGE_TINT_RED = {.7804, .0902, .0824}
MESSAGE_TINT_BLUE = {.1020, .4784, .9098}
MESSAGE_TINT_GREEN = {.1725, .6392, .1490}
MESSAGE_TINT_YELLOW = {.8235, .8157, .1529}
MESSAGE_TINT_FLAVOR = {0.5, 0.5, 0.5}
MESSAGE_TINT_INSTRUCTION = {1, 1, 1}
MESSAGE_TINT_INFO = {1, 1, 1}

MESSAGE_TYPE_FLAVOR_TEXT = "flavor"
MESSAGE_TYPE_INSTRUCTION = "instruction"
MESSAGE_TYPE_INFO = "info"
MESSAGE_TYPE_PLAYER = "player"


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

      broadcastToColor(message, playerColor, messageTint)
      return
   end
   
   local messageTint = 
      messageType == MESSAGE_TYPE_FLAVOR_TEXT and MESSAGE_TINT_FLAVOR
      or messageType == MESSAGE_TYPE_INSTRUCTION and MESSAGE_TINT_INSTRUCTION
      or messageType == MESSAGE_TYPE_INFO and MESSAGE_TINT_INFO
   
   broadcastToAll(message, messageTint)
end