local fontSizeInactive = Global.getVar("SETUP_BUTTON_FONT_SIZE_INACTIVE")
local fontSizeActive = Global.getVar("SETUP_BUTTON_FONT_SIZE_ACTIVE") - 50

function onload(saved_data)
  self.interactable = false

  createButton()
end

function buttonClick()
  local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
  layoutManager.call("setView", {view = "modular-sets"})
end

function updateButton(params)
  local isEnabled = params.isEnabled == nil and true or params.isEnabled
  local isActive = params.isActive

  local fontColor = isEnabled and {1,1,1,100} or {1,1,1,70}
  local fontSize = isActive and fontSizeActive or fontSizeInactive

  self.editButton({
    index = 0,
    font_color = fontColor,
    font_size = fontSize
  })
end

function createButton()
  self.createButton({
    label = "MODULAR SETS",
    click_function = "buttonClick",
    function_owner = self,
    position = {0,0.1,0},
    rotation = {0,0,0},
    width = 3350,
    height = 970,
    font_size = fontSizeInactive,
    color = {0,0,0,0},
    font_color = {1,1,1,100}
  })
end

function showTile()
  createButton()
end

function hideTile()
  self.clearButtons()
end
