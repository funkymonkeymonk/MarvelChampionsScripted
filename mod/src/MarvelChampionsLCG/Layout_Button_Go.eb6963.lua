function onload(saved_data)
  self.interactable = false
  
  createButton()
end

function updateButton(params)
  local isEnabled = params.isEnabled
  local fontColor = isEnabled and {1,1,1,100} or {1,1,1,70}

  self.editButton({
    index = 0,
    font_color = fontColor
  })
end

function createButton()
  local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
  self.createButton({
    label = "GO",
    click_function = "setUpScenario",
    function_owner = scenarioManager,
    position = {0,0.1,0},
    rotation = {0,0,0},
    width = 1300,
    height = 970,
    font_size = 500,
    color = {0,0,0,0},
    font_color = {1,1,1,70}
  })
end

function showTile()
  createButton()
end

function hideTile()
  self.clearButtons()
end
