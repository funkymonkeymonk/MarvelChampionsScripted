local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
local modularSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))

local originPosition = {x = 60.17, y = 0.60, z = 26.25}

local rowGap = 5
local columnGap = 9

local columns = 5

function onload(saved_data)
    createSetupButtons()

    heroManager.call("layOutHeroSelectors", {
      team = nil,
      origin = originPosition,
      maxRowsOrColumns = columns,
      columnGap = columnGap,
      rowGap = rowGap,
      selectorScale = {2, 1, 2}
    })

    scenarioManager.call("layOutScenarioSelectors", {
      origin = originPosition,
      maxRowsOrColumns = columns,
      columnGap = columnGap,
      rowGap = rowGap,
      selectorScale = {2, 1, 2},
      behavior = "select",
      hidden = true
    })

    modularSetManager.call("layOutModularSetSelectors", {
      origin = originPosition,
      maxRowsOrColumns = columns,
      columnGap = 9,
      rowGap = 4,
      selectorScale = {1.6, 1, 1.6},
      modular = true,
      behavior = "select",
      hidden = true
    })  
end

function createSetupButtons()
    self.createButton({
      label = "HEROES",
      click_function = "showHeroSelection",
      function_owner = self,
      position = {-16,0.1,0},
      rotation = {0,0,0},
      width = 3200,
      height = 1500,
      font_size = 1000,
      color = {1,1,0}
    })
  
    self.createButton({
      label = "SCENARIO",
      click_function = "showScenarioSelection",
      function_owner = self,
      position = {-8.25,0.1,0},
      rotation = {0,0,0},
      width = 3750,
      height = 1500,
      font_size = 1000,
      color = {1,1,0}
    })

    self.createButton({
      label = "MODULAR SETS",
      click_function = "showModularSetSelection",
      function_owner = self,
      position = {1.50,0.1,0},
      rotation = {0,0,0},
      width = 5200,
      height = 1500,
      font_size = 700,
      color = {1,1,0}
    })

    self.createButton({
      label = "MODE",
      click_function = "showModeSelection",
      function_owner = self,
      position = {10,0.1,0},
      rotation = {0,0,0},
      width = 2500,
      height = 1500,
      font_size = 1000,
      color = {1,1,0}
    })

    self.createButton({
      label = "GO",
      click_function = "setupScenario",
      function_owner = self,
      position = {15.25,0.1,0},
      rotation = {0,0,0},
      width = 2000,
      height = 1500,
      font_size = 1000,
      color = {1,1,0}
    })    
end

function showHeroSelection()
  scenarioManager.call("hideSelectors")
  modularSetManager.call("hideSelectors")
  deleteModeButtons()

  heroManager.call("showSelectors")
end

function showScenarioSelection()
  modularSetManager.call("hideSelectors")
  heroManager.call("hideSelectors")
  deleteModeButtons()

  scenarioManager.call("showSelectors")
end

function showModularSetSelection()
  heroManager.call("hideSelectors")
  scenarioManager.call("hideSelectors")
  deleteModeButtons()

  modularSetManager.call("showSelectors")
end

function showModeSelection()
  heroManager.call("hideSelectors")
  scenarioManager.call("hideSelectors")
  modularSetManager.call("hideSelectors")

  createInitialModeButtons()
end

function setupScenario()
  scenarioManager.call("setUpScenario")
end

function createInitialModeButtons()
  self.createButton({
    label = "STANDARD",
    click_function = "setStandardMode",
    function_owner = self,
    position = {-10.0,0.1,7},
    rotation = {0,0,0},
    width = 2750,
    height = 1000,
    font_size = 500,
    color = {1,1,0}
  })

  self.createButton({
    label = "EXPERT",
    click_function = "setExpertMode",
    function_owner = self,
    position = {-10.0,0.1,10},
    rotation = {0,0,0},
    width = 2750,
    height = 1000,
    font_size = 500,
    color = {1,1,0}
  })

  self.createButton({
    label = "STANDARD I",
    click_function = "selectStandardSet1",
    function_owner = self,
    position = {0.5,0.1,7},
    rotation = {0,0,0},
    width = 3400,
    height = 1000,
    font_size = 500,
    color = {1,1,0}
  })

  self.createButton({
    label = "STANDARD II",
    click_function = "selectStandardSet2",
    function_owner = self,
    position = {8.5,0.1,7},
    rotation = {0,0,0},
    width = 3400,
    height = 1000,
    font_size = 500,
    color = {1,1,0}
  })
end

function createExpertSetButtons()
  self.createButton({
    label = "EXPERT I",
    click_function = "selectExpertSet1",
    function_owner = self,
    position = {0.5,0.1,10},
    rotation = {0,0,0},
    width = 3400,
    height = 1000,
    font_size = 500,
    color = {1,1,0}
  })

  self.createButton({
    label = "EXPERT II",
    click_function = "selectExpertSet2",
    function_owner = self,
    position = {8.5,0.1,10},
    rotation = {0,0,0},
    width = 3400,
    height = 1000,
    font_size = 500,
    color = {1,1,0}
  })
end

function deleteModeButtons()
  local buttons = self.getButtons()
  local buttonCount = #buttons

  if(buttonCount < 6) then return end

  if(buttonCount > 9) then
    self.removeButton(10)
    self.removeButton(9)
  end

  self.removeButton(8)
  self.removeButton(7)
  self.removeButton(6)
  self.removeButton(5)
end

function deleteExpertSetButtons()
  local buttons = self.getButtons()
  local buttonCount = #buttons

  if(buttonCount < 10) then return end

  self.removeButton(10)
  self.removeButton(9)
end

function setStandardMode()
  self.editButton({index = 5, color = {0,1,0}})
  self.editButton({index = 6, color = {1,1,0}})

  deleteExpertSetButtons()
  scenarioManager.call("setMode", {mode = "standard"})
end

function setExpertMode()
  self.editButton({index = 5, color = {1,1,0}})
  self.editButton({index = 6, color = {0,1,0}})

  createExpertSetButtons()
  scenarioManager.call("setMode", {mode = "expert"})
end

function selectStandardSet1()
  self.editButton({index = 7, color = {0,1,0}})
  self.editButton({index = 8, color = {1,1,0}})
  scenarioManager.call("setStandardSet", {set = "i"})
end

function selectStandardSet2()
  self.editButton({index = 7, color = {1,1,0}})
  self.editButton({index = 8, color = {0,1,0}})
  scenarioManager.call("setStandardSet", {set = "ii"})
end

function selectExpertSet1()
  self.editButton({index = 9, color = {0,1,0}})
  self.editButton({index = 10, color = {1,1,0}})
  scenarioManager.call("setExpertSet", {set = "i"})
end

function selectExpertSet2()
  self.editButton({index = 9, color = {1,1,0}})
  self.editButton({index = 10, color = {0,1,0}})
  scenarioManager.call("setExpertSet", {set = "ii"})
end
