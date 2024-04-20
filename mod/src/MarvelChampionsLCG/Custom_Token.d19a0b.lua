preventDeletion = true

function onload(saved_data)
  self.setName("")
  createClearButton()
end

function createClearButton()
    self.createButton({
      label = "CLEAR",
      click_function = "clearScenario",
      function_owner = self,
      position = {0,0.1,0},
      rotation = {0,0,0},
      width = 3400,
      height = 1500,
      font_size = 1700,
      color = {1,1,0},
      tooltip = "Next!",
    })
end

function clearScenario()
   local clearCards = findCardsAtPosition()

   for _, obj in ipairs(clearCards) do
      if obj.getVar("preventDeletion") ~= true then
         obj.destruct()
      end
   end

   local clearCards2 = findCardsAtPosition2()

   for _, obj in ipairs(clearCards2) do
      if obj.getVar("preventDeletion") ~= true then
         obj.destruct()
      end
   end

   local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
   scenarioManager.call("clearScenario")
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
