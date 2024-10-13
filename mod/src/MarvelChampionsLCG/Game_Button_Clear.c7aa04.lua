local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))

function onload(saved_data)
    self.interactable = false
    createClearButton()
end

function createClearButton()
    self.createButton({
      label = "CLEAR",
      click_function = "clearScenario",
      function_owner = self,
      position = {0,0.1,0},
      rotation = {0,0,0},
      width = 2080,
      height = 970,
      font_size = Global.getVar("SETUP_BUTTON_FONT_SIZE_ACTIVE"),
      color = {0,0,0,0},
      font_color = {1,1,1,100}
    })
end

function clearScenario()
   layoutManager.call("clearScenario")
end

function showTile()
  createClearButton()
end

function hideTile()
  self.clearButtons()
end