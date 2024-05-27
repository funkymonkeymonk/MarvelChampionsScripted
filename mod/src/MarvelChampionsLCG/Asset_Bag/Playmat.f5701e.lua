DRAWN_ENCOUNTER_OFFSET = {-1.275, 0.5, -1.533}

local data = {}

function onload(saved_data)
   loadSavedData(saved_data)

   createButtons()

   if(getValue("showSelfDestruct", true)) then
      createSelfDestructButton()
   end
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

function createButtons()
   self.createButton({
      label          = "1",
      click_function = "movePlayerOne",
      function_owner = self,
      position       = {1.56,0.3,-0.52},
      rotation       = {0,0,0},
      width          = 100,
      height         = 100,
      font_size      = 50,
      color          = {0,1,0},
      tooltip        = "Take First Player"
   })

   self.createButton({
      label          = "R",
      click_function = "untapAll",
      function_owner = self,
      position       = {1.56,0.3,-0.27},
      rotation       = {0,0,0},
      width          = 100,
      height         = 100,
      font_size      = 50,
      color          = {0.3,0.6,1},
      tooltip        = "Ready All Cards"
   })

   self.createButton({
      label          = "D",
      click_function = "discardRandom",
      function_owner = self,
      position       = {1.56,0.3,-0.02},
      rotation       = {0,0,0},
      width          = 100,
      height         = 100,
      font_size      = 50,
      color          = {1,0.5,1},
      tooltip        = "Discard a Random Card"
   })

   self.createButton({
      label          = "!!",
      click_function = "drawEncounter",
      function_owner = self,
      position       = {1.56,0.3,0.23},
      rotation       = {0,0,0},
      width          = 100,
      height         = 100,
      font_size      = 50,
      color          = {1,1,0},
      tooltip        = "Draw an Encounter Card"
   })

   self.createButton({
      label          = "X",
      click_function = "discardEncounter",
      function_owner = self,
      position       = {1.56,0.3,0.48},
      rotation       = {0,0,0},
      width          = 100,
      height         = 100,
      font_size      = 50,
      color          = {1,0,0},
      tooltip        = "Discard Encounter Card"
   })

   self.createButton({
      label          = "N",
      click_function = "spawnNemesis",
      function_owner = self,
      position       = {1.56,0.3,0.78},
      rotation       = {0,0,0},
      width          = 100,
      height         = 100,
      font_size      = 50,
      font_color     = {1,1,1},
      color          = {0,0,0},
      tooltip        = "Summon Your Nemesis!"
   })
end

function setPlayerColor(params)
   setValue("playerColor", params.color)
end

function movePlayerOne()
   playerToken   = getObjectFromGUID(Global.getVar("FIRST_PLAYER_TOKEN_GUID"))
   boardPosition = self.getPosition()
   playerToken.setPositionSmooth(boardPosition + Vector{11.9, 0.3, 6.3}, false, false)
   local turn_counter = getObjectFromGUID("turncounter")
   turn_counter.call('add_subtract')
end

function untapAll()
   untapCards = findCardsAtPosition()
      for _, obj in ipairs(untapCards) do
      obj.setRotationSmooth({0,180,obj.getRotation().z})
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

function drawEncounter(object, player, isRightClick)
   local toPosition = self.positionToWorld(DRAWN_ENCOUNTER_OFFSET)
   Global.call("drawEncountercard", {toPosition, isRightClick})
end

function discardEncounter(object, player_color, isRightClick)
   Global.call("discardEncounterCard", {playerColor = getValue("playerColor")})
end

function discardRandom(object, player)
   numCardsToDiscard = 1
   if player == "Red" then
    pos = {-52.50, 2, -21.72}
   end
   if player == "Blue" then
    pos = {-25.03, 2, -22.40}
   end
   if player == "Green" then
    pos = {2.44, 2, -22.40}
   end
   if player == "Yellow" then
    pos = {29.92, 2, -21.73}
   end
   if #Player[player].getHandObjects() >= numCardsToDiscard then
    count = #Player[player].getHandObjects()
    rand = math.random(count)
    Player[player].getHandObjects()[rand].setPosition(pos)
   end
end

function createSelfDestructButton()
   removeButtonByLabel("CANCEL")
   removeButtonByLabel("CONFIRM")

   self.createButton({
      label          = "REMOVE",
      click_function = "createConfirmAndCancelButtons",
      function_owner = self,
      position       = {1.3,0.1,1.05},
      rotation       = {0,0,0},
      width          = 150,
      height         = 50,
      font_size      = 30,
      font_color     = {1,0,0},
      color          = {0,0,0},
      tooltip        = "Clear Playmat"
   })

   setValue("showSelfDestruct", true)
end

function createConfirmAndCancelButtons()
   removeButtonByLabel("REMOVE")

   self.createButton({
      label          = "CANCEL",
      click_function = "createSelfDestructButton",
      function_owner = self,
      position       = {1.3,0.1,1.05},
      rotation       = {0,0,0},
      width          = 150,
      height         = 50,
      font_size      = 30,
      font_color     = {0,0,0},
      color          = {0,1,0}
   })

   self.createButton({
      label          = "CONFIRM",
      click_function = "clearPlaymat",
      function_owner = self,
      position       = {1.6,0.1,1.05},
      rotation       = {0,0,0},
      width          = 150,
      height         = 50,
      font_size      = 30,
      font_color     = {0,0,0},
      color          = {1,0,0}
   })

end

function removeButtonByLabel(buttonLabel)
   for k, button in ipairs(self.getButtons()) do
      if(button.label == buttonLabel) then
          self.removeButton(button.index)
      end
  end
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

function removeSelfDestructButtons()
   removeButtonByLabel("REMOVE")
   removeButtonByLabel("CANCEL")
   removeButtonByLabel("CONFIRM")

   setValue("showSelfDestruct", false)
end
