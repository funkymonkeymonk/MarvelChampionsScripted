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
   getObjectFromGUID('e3b2e1').clearButtons()

   clearCards = findCardsAtPosition()
   for _, obj in ipairs(clearCards) do
      if obj.getGUID() ~= 'e3b2e1' then
         obj.destruct()
      end
   end
   clearCards2 = findCardsAtPosition2()
   for _, obj in ipairs(clearCards2) do
      if obj.getGUID() ~= 'e3b2e1' then
         obj.destruct()
      end
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

function createBoostButton()
   self.createButton({
     label = "BOOST",
     click_function = "drawBoost",
     function_owner = self,
     position = {10.0,1.13,10.0},
     scale = {0.33, 1, 0.33},
     rotation = {0,0,0},
     width = 3400,
     height = 1500,
     font_size = 1700,
     color = {1,1,0}
   })
 
   self.createButton({
     label = "X",
     click_function = "discardBoost",
     function_owner = self,
     position = {14.8,1.13,10.0},
     scale = {0.33, 1, 0.33},
     rotation = {0,0,0},
     width = 1000,
     height = 1500,
     font_size = 1700,
     color = {1,0,0}
   })
end

function drawBoost(object, player, isRightClick)
   local toPosition = BOOST_POS
   Global.call("drawBoostcard", {toPosition, self.getRotation(), isRightClick})
   end
   
   function discardBoost(object, player, isRightClick)
   local toPosition = DISCARD_POS
   Global.call("discardBoostcard", {toPosition, self.getRotation(), isRightClick})
   end
