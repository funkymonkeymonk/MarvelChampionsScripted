DRAWN_ENCOUNTER_OFFSET = {-1.275, 0.5, -1.533}
DISCARD_POS            = {-17.75, 1.8, 22.25}
DEBUG             = false
COLLISION_ENABLED = false

function log(message)
   if DEBUG then
      print(message)
   end
end

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
      tooltip        = "Take the lead!"
   })

   self.createButton({
      label          = "U",
      click_function = "untapAll",
      function_owner = self,
      position       = {1.56,0.3,-0.27},
      rotation       = {0,0,0},
      width          = 100,
      height         = 100,
      font_size      = 50,
      color          = {0.3,0.6,1},
      tooltip        = "Ready!"
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
      tooltip        = "I'm hit!"
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
      tooltip        = "Look out!"
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
      color          = {1,0,0}
   })


   COLLISION_ENABLED = true
end

function movePlayerone()
   playerToken   = getObjectFromGUID("d93792")
   boardPosition = self.getPosition()
   playerToken.setPositionSmooth(boardPosition + Vector{11.9, 0.3, 6.3}, false, false)
end

function untapAll()
   untapCards = findObjectsAtPosition()
      for _, obj in ipairs(untapCards) do
      obj.setRotationSmooth({0,180,obj.getRotation().z})
   end
end

function findObjectsAtPosition(obj)
   matPos = self.getPosition()
   local objList = Physics.cast({
      origin       = matPos,
      direction    = {0,1,0},
      type         = 3,
      size         = {26,1,15},
      max_distance = 0,
      debug        = false,
   })
   local tappedCards = {}
      for _, obj in ipairs(objList) do
      if obj.hit_object.tag == "Card" then
         table.insert(tappedCards, obj.hit_object)
      end
   end
   return tappedCards
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



