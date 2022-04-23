function onload()

   self.createButton({
      label          = "Start",
      click_function = "playerCount",
      function_owner = self,
      position       = {-10.5,0.05,-0.5},
      rotation       = {0,0,0},
      width          = 650,
      height         = 250,
      font_size      = 150,
      color          = {1,1,0},
      tooltip        = "Let's go!"
   })

   self.createButton({
      label          = "Clear",
      click_function = "clearVillain",
      function_owner = self,
      position       = {-10.5,0.05,0},
      rotation       = {0,0,0},
      width          = 650,
      height         = 250,
      font_size      = 150,
      color          = {1,1,1},
      tooltip        = "Next Mission!"
   })

   self.createButton({
      label          = "Boost",
      click_function = "restoreBoost",
      function_owner = self,
      position       = {-10.5,0.05,0.5},
      rotation       = {0,0,0},
      width          = 650,
      height         = 250,
      font_size      = 150,
      color          = {1,1,1},
      tooltip        = "Restore Boost"
   })

end

function playerCount()
getObjectFromGUID('e3b2e1').call('createPlayers')
end

function restoreBoost()
   Global.call("requestBoost")
end

function clearVillain()
   clearCards = findCardsAtPosition()
      for _, obj in ipairs(clearCards) do
      obj.destruct()
   end
   clearCards2 = findCardsAtPosition2()
      for _, obj in ipairs(clearCards2) do
      obj.destruct()
   end
end

function findCardsAtPosition(obj)
   local objList = Physics.cast({
      origin       = {0,1.48,11},
      direction    = {0,1,0},
      type         = 3,
      size         = {108,1,40},
      max_distance = 0,
      debug        = false,
   })
   local villainAssets = {}
      for _, obj in ipairs(objList) do
      table.insert(villainAssets, obj.hit_object)
   end
   return villainAssets
end

function findCardsAtPosition2(obj)
   local objList = Physics.cast({
      origin       = {18.00, 1.48, 33.75},
      direction    = {0,1,0},
      type         = 3,
      size         = {60,1,1},
      max_distance = 0,
      debug        = false,
   })
   local villainAssets2 = {}
      for _, obj in ipairs(objList) do
      table.insert(villainAssets2, obj.hit_object)
   end
   return villainAssets2
end



