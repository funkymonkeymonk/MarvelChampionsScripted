preventDeletion = true

local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
local modularSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))

local data = {}

function onload(saved_data)
    self.setName("")
    loadSavedData(saved_data)

    local currentMode = getValue("currentMode", "heroSelection")

    if currentMode == "heroSelection" then
        setUpHeroSelectionMode()
    end
    if currentMode == "scenarioSelection" then
        setUpScenarioSelectionMode()
    end
end

function loadSavedData(saved_data)
    if saved_data ~= "" then
       local loaded_data = JSON.decode(saved_data)
       data = loaded_data
    end
end
 
function setValue(key, value)
    data[key] = value
    local saved_data = JSON.encode(data)
    self.script_state = saved_data
end
 
function getValue(key, default)
    if data[key] == nil then
       return default
    end
 
    return data[key]
end

function setUpHeroSelectionMode()
    self.clearButtons()
    createControlPanelMovementButtons()
    createNextButton("Proceed to Scenario Selection", "switchToScenarioSelectionMode")

    self.createButton({
        label          = "SELECT YOUR HEROES",
        click_function = "null",
        function_owner = self,
        position       = {0,0.25,-0.80},
        rotation       = {0,0,0},
        width          = 0,
        height         = 0,
        font_size      = 150,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })

     self.createButton({
        label          = "AVENGERS",
        click_function = "layOutAvengers",
        function_owner = self,
        position       = {0,0.25,-0.55},
        rotation       = {0,0,0},
        width          = 500,
        height         = 50,
        font_size      = 80,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })

     self.createButton({
        label          = "CHAMPIONS",
        click_function = "layOutChampions",
        function_owner = self,
        position       = {0,0.25,-0.30},
        rotation       = {0,0,0},
        width          = 550,
        height         = 50,
        font_size      = 80,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })

     self.createButton({
        label          = "GUARDIANS OF THE GALAXY",
        click_function = "layOutGuardians",
        function_owner = self,
        position       = {0,0.25,-0.05},
        rotation       = {0,0,0},
        width          = 1300,
        height         = 50,
        font_size      = 80,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })

     self.createButton({
        label          = "MUTANTS",
        click_function = "layOutMutants",
        function_owner = self,
        position       = {0,0.25,0.20},
        rotation       = {0,0,0},
        width          = 550,
        height         = 50,
        font_size      = 80,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })

     self.createButton({
        label          = "SPIDER-VERSE",
        click_function = "layOutSpiders",
        function_owner = self,
        position       = {0,0.25,0.45},
        rotation       = {0,0,0},
        width          = 650,
        height         = 50,
        font_size      = 80,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })

     self.createButton({
        label          = "ALL HEROES",
        click_function = "layOutAllHeroes",
        function_owner = self,
        position       = {0,0.25,0.70},
        rotation       = {0,0,0},
        width          = 650,
        height         = 50,
        font_size      = 80,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })     
end

function createControlPanelMovementButtons()
    self.createButton({
        label          = "<",
        tooltip        = "Move to Left",
        click_function = "moveControlPanelToLeft",
        function_owner = self,
        position       = {0.14,0.25,1.07},
        rotation       = {0,45,0},
        width          = 100,
        height         = 100,
        font_size      = 125,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })

     self.createButton({
        label          = "<",
        tooltip        = "Move to Center",
        click_function = "moveControlPanelToCenter",
        function_owner = self,
        position       = {0.44,0.25,1.07},
        rotation       = {0,-90,0},
        width          = 100,
        height         = 100,
        font_size      = 125,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })

     self.createButton({
        label          = "—",
        tooltip        = "Lie Flat",
        click_function = "moveControlPanelToFlat",
        function_owner = self,
        position       = {0.74,0.25,1.07},
        rotation       = {0,0,0},
        width          = 120,
        height         = 120,
        font_size      = 125,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })    

     self.createButton({
        label          = ">",
        tooltip        = "Move to Right",
        click_function = "moveControlPanelToRight",
        function_owner = self,
        position       = {1.04,0.25,1.07},
        rotation       = {0,-45,0},
        width          = 100,
        height         = 100,
        font_size      = 125,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })    
end

function createNextButton(tooltip, functionName)
    self.createButton({
        label          = ">",
        tooltip        = tooltip,
        click_function = functionName,
        function_owner = self,
        position       = {1.97,0.25,-0.10},
        rotation       = {0,0,0},
        width          = 200,
        height         = 200,
        font_size      = 250,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })    
end

function createBackButton(tooltip, functionName)
    self.createButton({
        label          = "<",
        tooltip        = tooltip,
        click_function = functionName,
        function_owner = self,
        position       = {-1.88,0.25,0.10},
        rotation       = {0,0,0},
        width          = 200,
        height         = 200,
        font_size      = 250,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     }) 
end

function switchToHeroSelectionMode()
    scenarioManager.call("deleteScenarios")
    setUpHeroSelectionMode()

    enablePlaymatRemoval()

    setValue("currentMode", "heroSelection")
end

function switchToScenarioSelectionMode()
    local heroCount = heroManager.call("getHeroCount")

    if heroCount < 1 then
        broadcastToAll("Please select at least one hero before proceeding to scenario selection.", {1,0,0})
        return
    end

    heroManager.call("deleteHeroes")
    modularSetManager.call("deleteModularSets")
    setUpScenarioSelectionMode()

    disablePlaymatRemoval()

    setValue("currentMode", "scenarioSelection")
end

function switchToModularSetSelectionMode()
    --TODO: ensure that a scenario has been selected

    setUpModularSetSelectionMode()

    setValue("currentMode", "modularSetSelection")
end

function setUpScenarioSelectionMode()
    self.clearButtons()

    local modeXPosition = -0.85
    local encounterSetsXPosition = 0.75
    local subTitleZPosition = -0.40

    self.createButton({
        label          = "SELECT A SCENARIO",
        click_function = "null",
        function_owner = self,
        position       = {0,0.25,-0.80},
        rotation       = {0,0,0},
        width          = 0,
        height         = 0,
        font_size      = 150,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
    })

    self.createButton({
        label          = "MODE",
        click_function = "null",
        function_owner = self,
        position       = {modeXPosition,0.25,subTitleZPosition},
        rotation       = {0,0,0},
        width          = 0,
        height         = 0,
        font_size      = 110,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
    })

    self.createButton({
        label          = "ROOKIE",
        click_function = "null",
        function_owner = self,
        position       = {modeXPosition,0.25,-0.10},
        rotation       = {0,0,0},
        width          = 0,
        height         = 0,
        font_size      = 80,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
    })

    self.createButton({
        label          = "STANDARD",
        click_function = "null",
        function_owner = self,
        position       = {modeXPosition,0.25,0.15},
        rotation       = {0,0,0},
        width          = 0,
        height         = 0,
        font_size      = 80,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
    })

    self.createButton({
        label          = "EXPERT",
        click_function = "null",
        function_owner = self,
        position       = {modeXPosition,0.25,0.40},
        rotation       = {0,0,0},
        width          = 0,
        height         = 0,
        font_size      = 80,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
    })

    self.createButton({
        label          = "ENCOUNTER SETS",
        click_function = "null",
        function_owner = self,
        position       = {encounterSetsXPosition,0.25,subTitleZPosition},
        rotation       = {0,0,0},
        width          = 0,
        height         = 0,
        font_size      = 110,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
    })

    self.createButton({
        label          = "STANDARD",
        click_function = "null",
        function_owner = self,
        position       = {encounterSetsXPosition,0.25,-0.10},
        rotation       = {0,0,0},
        width          = 0,
        height         = 0,
        font_size      = 80,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
    })

    self.createButton({
        label          = "EXPERT",
        click_function = "null",
        function_owner = self,
        position       = {encounterSetsXPosition,0.25,0.15},
        rotation       = {0,0,0},
        width          = 0,
        height         = 0,
        font_size      = 80,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
    })

    createControlPanelMovementButtons()
    createBackButton("Return to Hero Selection", "switchToHeroSelectionMode")
    createNextButton("Proceed to Modular Set Selection", "switchToModularSetSelectionMode")

    layOutScenarioSelectors()
end

function disablePlaymatRemoval()
    local allObjects = getAllObjects()
   
    for _, obj in pairs(allObjects) do
        if(obj.hasTag("Playmat")) then
            obj.call("removeSelfDestructButtons")
        end
    end
end

function enablePlaymatRemoval()
    local allObjects = getAllObjects()
   
    for _, obj in pairs(allObjects) do
        if(obj.hasTag("Playmat")) then
            obj.call("createSelfDestructButton")
        end
    end
end

function setUpModularSetMode()
end

function layOutAvengers()
    layOutHeroSelectors("avengers")
end

function layOutChampions()
    layOutHeroSelectors("champions")
end

function layOutGuardians()
    layOutHeroSelectors("guardians")
end

function layOutMutants()
    layOutHeroSelectors("mutants")
end

function layOutSpiders()
    layOutHeroSelectors("spiders")
end

function layOutAllHeroes()
    layOutHeroSelectors()
end

function layOutHeroSelectors(team)
    moveControlPanelToLeft()
    blockTable()

    heroManager.call("layOutHeroSelectors", {
        team = team,
        center = {0,1,10},
        maxRowsOrColumns = team ~= nil and 6 or 9,
        columnGap = 9,
        rowGap = 6,
        selectorScale = {2, 1, 2}
    })
end

function layOutScenarioSelectors()
    scenarioManager.call("layOutScenarioSelectors", {
        center = {0,1,10},
        maxRowsOrColumns = 9,
        columnGap = 9,
        rowGap = 6,
        selectorScale = {2, 1, 2},
        behavior = "select"
    })
end

function blockTable()
    local blocker = getObjectFromGUID("5e531c")
    blocker.call("blockTable")
end

function moveControlPanelToFlat()
    self.setPositionSmooth({-25.25, 1.01, 32.75}, false, false)
    self.setRotationSmooth({0.00, 180.00, 0.00}, false, false)
    self.setLock(true)
end

function moveControlPanelToRight()
    self.setPositionSmooth({45.00, 10.00, 30.00}, false, false)
    self.setRotationSmooth({70.00, -135.00, 0.00}, false, false)
    self.setLock(true)
end

function moveControlPanelToLeft()
    self.setPositionSmooth({-45.00, 10.00, 30.00}, false, false)
    self.setRotationSmooth({70.00, 135.00, 0.00}, false, false)
    self.setLock(true)
end

function moveControlPanelToCenter()
    self.setPositionSmooth({0.00, 10.00, 0.00}, false, false)
    self.setRotationSmooth({45.00, 180.00, 0.00}, false, false)
    self.setLock(true)
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
