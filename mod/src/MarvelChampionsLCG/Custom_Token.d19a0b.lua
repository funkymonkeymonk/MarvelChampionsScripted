preventDeletion = true
local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))

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
   layoutManager.call("clearScenario")
end
