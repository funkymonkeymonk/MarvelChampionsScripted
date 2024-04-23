DEFAULT_ROTATION = {0.00, 180.00, 0.00}

VILLAIN_HEALTH_COUNTER_POSITION = {-0.34, 0.96, 29.15}
VILLAIN_HEALTH_COUNTER_ROTATION = {0.00, 180, 0.00}
VILLAIN_HEALTH_COUNTER_SCALE    = {2.88, 1.00, 2.88}

ENCOUNTER_DECK_POSITION = {-12.75, 1.06, 22.25}
ENCOUNTER_DECK_ROTATION = {0.00, 180.00, 180.00}
ENCOUNTER_DECK_SCALE    = {2.12, 1.00, 2.12}

VILLAIN_POSITION = {-0.34, 2.00, 20.44}
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

ASSET_GUID_BLACK_HOLE             = "740595"
ASSET_GUID_PLAYMAT                = "f5701e"
ASSET_GUID_HERO_HEALTH_COUNTER    = "16b5bd"
ASSET_GUID_VILLAIN_HEALTH_COUNTER = "8cf3d6"
ASSET_GUID_MAIN_THREAT_COUNTER    = "a9f7b8"
ASSET_GUID_BOOST_PANEL            = "ef27d7"

IS_RESHUFFLING = false

require('!/Cardplacer')

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

function requestBoost()
   getObjectFromGUID('e3b2e1').call('createBoostButton')
end

function isFaceup(params)
   if params.getRotation()[3] > -5 and params.getRotation()[3] < 5 then
      return true
   else
      return false
   end
end

function moveCardToLocation(params)
   local origin = params.origin
   local destination = params.destination
   local items = findInRadiusBy(origin, 3, isCard, true)

   if(#items == 1) then
      items[1].setLock(false)
      items[1].setPositionSmooth(destination, false, false)
   end
end

function onPlayerAction(player, action, targets)
   if action == Player.Action.Delete then
      for _, target in ipairs(targets) do
         if not target.getVar("preventDeletion") then
            target.destroy()
         end
      end

      return false
   end

   return true
end
