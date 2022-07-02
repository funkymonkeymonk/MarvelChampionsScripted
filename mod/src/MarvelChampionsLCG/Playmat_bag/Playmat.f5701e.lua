DRAWN_ENCOUNTER_OFFSET = {-1.275, 0.5, -1.533}
DISCARD_POS            = {-17.75, 1.8, 22.25}
COLLISION_ENABLED = false

function onload()

   self.createButton({
      label          = "1",
      click_function = "movePlayerone",
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

   createSelfDestructButton()

   COLLISION_ENABLED = true
end

function movePlayerone()
   playerToken   = getObjectFromGUID("d93792")
   boardPosition = self.getPosition()
   playerToken.setPositionSmooth(boardPosition + Vector{11.9, 0.3, 6.3}, false, false)
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
   Global.call("drawEncountercard", {toPosition, self.getRotation(), isRightClick})
end

function discardEncounter(object, player_color, isRightClick)
   if player_color == "Red" then
      local toPosition = DISCARD_POS
      Global.call("discardEncounterRed", {toPosition, self.getRotation(), isRightClick})
   end
   if player_color == "Blue" then
      local toPosition = DISCARD_POS
      Global.call("discardEncounterBlue", {toPosition, self.getRotation(), isRightClick})
   end
   if player_color == "Green" then
      local toPosition = DISCARD_POS
      Global.call("discardEncounterGreen", {toPosition, self.getRotation(), isRightClick})
   end
   if player_color == "Yellow" then
      local toPosition = DISCARD_POS
      Global.call("discardEncounterYellow", {toPosition, self.getRotation(), isRightClick})
   end
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
   broadcastToAll("Please delete your obligation card and nemesis set manually.", {1,1,1})
   local objects = findObjectsAtPosition()

   for _, obj in ipairs(objects) do
      if(obj.tag ~= "Surface") then
         obj.destruct()
      end
   end

   self.destruct()
end
