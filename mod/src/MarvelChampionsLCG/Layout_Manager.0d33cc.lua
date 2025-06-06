preventDeletion = true

local defaultColumnGap = 5
local defaultRowGap = 2.5
local defaultSelectorScale = {1.13, 1.00, 1.13}
local defaultSelectorRotation = {0,180,0}

--local LAYOUT_BUTTON_HEROES = "08c4b0"
local LAYOUT_BUTTON_SCENARIO = "0ea99f"
local LAYOUT_BUTTON_MODULAR_SETS = "6979cc"
local LAYOUT_BUTTON_MODE = "3bcb37"
local LAYOUT_BUTTON_GO = "eb6963"

--local layoutButtonHeroes = getObjectFromGUID(LAYOUT_BUTTON_HEROES)
local layoutButtonScenario = getObjectFromGUID(LAYOUT_BUTTON_SCENARIO)
local layoutButtonModularSets = getObjectFromGUID(LAYOUT_BUTTON_MODULAR_SETS)
local layoutButtonMode = getObjectFromGUID(LAYOUT_BUTTON_MODE)
local layoutButtonGo = getObjectFromGUID(LAYOUT_BUTTON_GO)

local MODE_SELECTOR_STANDARD_GUID = "6dbb09"
local MODE_SELECTOR_EXPERT_GUID = "feda03"
local STANDARD_SET_I_SELECTOR_GUID = "6c0fac"
local STANDARD_SET_II_SELECTOR_GUID = "4a340c"
local STANDARD_SET_III_SELECTOR_GUID = "9e3a14"
local EXPERT_SET_I_SELECTOR_GUID = "f640e3"
local EXPERT_SET_II_SELECTOR_GUID = "e2a916"
local FIRST_PLAYER_PANEL_GUID = "63b27d"

local modeSelectorStandard = getObjectFromGUID(MODE_SELECTOR_STANDARD_GUID)
local modeSelectorExpert = getObjectFromGUID(MODE_SELECTOR_EXPERT_GUID)
local standardSetISelector = getObjectFromGUID(STANDARD_SET_I_SELECTOR_GUID)
local standardSetIISelector = getObjectFromGUID(STANDARD_SET_II_SELECTOR_GUID)
local standardSetIIISelector = getObjectFromGUID(STANDARD_SET_III_SELECTOR_GUID)
local expertSetISelector = getObjectFromGUID(EXPERT_SET_I_SELECTOR_GUID)
local expertSetIISelector = getObjectFromGUID(EXPERT_SET_II_SELECTOR_GUID)
local firstPlayerPanel = getObjectFromGUID(FIRST_PLAYER_PANEL_GUID)

local scenarioUsesStandardEncounterSets
local scenarioUsesModularEncounterSets

local originPosition = {x = 60.17, y = 0.60, z = 26.25}

local rowGap = 5
local columnGap = 9

local columns = 5

local hiddenSelectorOffset = 2

local SELECTOR_TILE_TAG = "selector-tile"

local currentView = "heroes"

function onload(saved_data)
    -- local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
    -- heroManager.call("layOutHeroSelectors", {
    --     team = nil,
    --     origin = originPosition,
    --     maxRowsOrColumns = columns,
    --     columnGap = columnGap,
    --     rowGap = rowGap,
    --     selectorScale = {2, 1, 2}
    -- })
    
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call("layOutScenarioSelectors", {
        origin = originPosition,
        maxRowsOrColumns = columns,
        columnGap = columnGap,
        rowGap = rowGap,
        selectorScale = {2, 1, 2},
        behavior = "select"
    })

    local modularSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))
    modularSetManager.call("layOutModularSetSelectors", {
        origin = {x = 59.50, y = 0.60, z = 26.25},
        maxRowsOrColumns = 6,
        columnGap = 7.5,
        rowGap = 3.5,
        selectorScale = {1.4, 1, 1.4},
        modular = true,
        behavior = "select",
        hidden = true
    })

    Wait.frames(function()
        updateSetupButtons()
    end, 
    10)
end

function layOutSelectorTiles(params)
    local origin = params.origin
    local center = params.center
    local direction = params.direction
    local maxRowsOrColumns = params.maxRowsOrColumns
    local columnGap = params.columnGap or defaultColumnGap
    local rowGap = params.rowGap or defaultRowGap
    local selectorScale = params.selectorScale or defaultSelectorScale
    local selectorRotation = params.selectorRotation or defaultSelectorRotation
    local items = params.items
    local itemType = params.itemType
    local behavior = params.behavior
    local hidden = params.hidden
    local sortedList = Global.call("getSortedListOfItems", {items = items})
    local itemCount = #sortedList

    if(origin == nil) then
        if(center == nil) then
            broadcastToAll("Must supply either an origin or center position to lay out tiles.", {1,1,1})
            return
        end

        origin = calculateOrigin(center, direction, maxRowsOrColumns, columnGap, rowGap, itemCount)
    end

    if(hidden) then
        origin.y = origin.y - hiddenSelectorOffset
    end

    clearSelectorTiles({itemType = itemType})

    local baseTile = itemType == "modular-set" 
        and getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_SELECTOR_TILE")) 
        or getObjectFromGUID(Global.getVar("GUID_SELECTOR_TILE"))
    local currentRow = 1
    local currentColumn = 1

    for _, item in ipairs(sortedList) do
        local key = item.key
        local position = getCoordinates(origin, currentColumn, currentRow, columnGap, rowGap)

        local tile = baseTile.clone({
            position = position,
            rotation = selectorRotation,
            scale = selectorScale})

        Wait.frames(
            function()
                tile.setLock(true)
                tile.setPosition(position)
                tile.addTag(SELECTOR_TILE_TAG)
        
                tile.call("setUpTile", {
                    itemType = itemType,
                    itemKey = key,
                    itemName = item.name,
                    imageUrl = item.tileImageUrl,
                    behavior = behavior,
                    isVisible = not hidden
                })
            end,
            1
        )

        if(direction == "horizontal") then
            currentColumn = currentColumn + 1

            if (currentColumn > maxRowsOrColumns) then
                currentColumn = 1
                currentRow = currentRow + 1
            end
        else
            currentRow = currentRow + 1

            if(currentRow > maxRowsOrColumns) then
                currentRow = 1
                currentColumn = currentColumn + 1
            end            
        end
    end    
end

function calculateOrigin(center, direction, maxRowsOrColumns, columnGap, rowGap, itemCount)
    local gridDimensions = calculateGridDimensions(direction, maxRowsOrColumns, columnGap, rowGap, itemCount)

    return {
        x = center[1] - gridDimensions.width / 2,
        y = center[2],
        z = center[3] + gridDimensions.height / 2
    }
end

function calculateGridDimensions(direction, maxRowsOrColumns, columnGap, rowGap, itemCount)
    local columns = 0
    local rows = 0

    if(direction == "horizontal") then
        columns = itemCount <= maxRowsOrColumns and itemCount or maxRowsOrColumns
        rows = itemCount <= maxRowsOrColumns and 1 or math.ceil(itemCount / maxRowsOrColumns)
    end

    if(direction == "vertical") then
        columns = itemCount <= maxRowsOrColumns and 1 or math.ceil(itemCount / maxRowsOrColumns)
        rows = itemCount <= maxRowsOrColumns and itemCount or maxRowsOrColumns
    end

    local width = (columns - 1) * columnGap
    local height = (rows - 1) * rowGap

    return {width = width, height = height}
end

function getCoordinates(origin, column, row, columnGap, rowGap)
    local x = origin.x + columnGap * (column - 1)
    local z = origin.z - rowGap * (row - 1)

    return {x, origin.y, z}
end

function clearSelectorTiles(params)
    local allObjects = getAllObjects()
    local itemType = params.itemType

    for k,v in pairs(allObjects) do
        if(v.hasTag(SELECTOR_TILE_TAG)) then
            if(itemType == nil or v.getVar("itemType") == itemType) then
                v.destruct()
            end
        end
    end
end

function highlightSelectedSelectorTile(params)
    local allObjects = getAllObjects()
    local itemType = params.itemType
    local itemKey = params.itemKey

    for k,v in pairs(allObjects) do
        if(v.hasTag(SELECTOR_TILE_TAG)) then
            if( v.getVar("itemType") == itemType) then
                if(v.getVar("itemKey") == itemKey) then
                    v.call("showSelection", {selected = true})
                else
                    v.call("showSelection", {selected = false})
                end
            end
        end
    end
end

function highlightMultipleSelectorTiles(params)
    local allObjects = getAllObjects()
    local itemType = params.itemType
    local items = params.items
    --local itemKeys = getKeysFromTable(params.items)

    for k,v in pairs(allObjects) do
        if(v.hasTag(SELECTOR_TILE_TAG)) then
            if( v.getVar("itemType") == itemType) then
                --if(itemKeys:find(v.getVar("itemKey")) ~= nil) then
                item = items[v.getVar("itemKey")]
                if(item ~= nil) then
                    v.call("showSelection", {selected = true, required = item.required})
                else
                    v.call("showSelection", {selected = false})
                end
            end
        end
    end
end

function showSelectors(params)
    local allObjects = getAllObjects()
    local itemType = params.itemType

    for k,v in pairs(allObjects) do
        if(v.hasTag(SELECTOR_TILE_TAG)) then
            local currentPos = v.getPosition()

            if(v.getVar("itemType") == itemType and currentPos.y < 0) then
                v.setPosition({x = currentPos.x, y = currentPos.y + hiddenSelectorOffset, z = currentPos.z})
                v.call("showTile")
            end
        end
    end
end

function hideSelectors(params)
    local allObjects = getAllObjects()
    local itemType = params.itemType

    for k,v in pairs(allObjects) do
        if(v.hasTag(SELECTOR_TILE_TAG)) then
            local currentPos = v.getPosition()

            if(v.getVar("itemType") == itemType and currentPos.y >= 0) then
                v.setPosition({x = currentPos.x, y = currentPos.y - hiddenSelectorOffset, z = currentPos.z})
                v.call("hideTile")
            end
        end
    end
end

function showModeButtons()
    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local showStandardSets = scenarioUsesStandardEncounterSets
    local showExpertSets = scenarioUsesStandardEncounterSets and (scenarioManager.call("getMode") == "expert")

    showTile(modeSelectorStandard)
    showTile(modeSelectorExpert)

    if(showStandardSets) then
        showTile(standardSetISelector)
        showTile(standardSetIISelector)
        showTile(standardSetIIISelector)
    end

    if(showExpertSets) then
        showExpertSetButtons()
    end

    if(heroManager.call("getHeroCount") > 1) then
        showTile(firstPlayerPanel, true)
        Wait.frames(
            function()
                local selectedFirstPlayer = scenarioManager.call("getFirstPlayer")
                firstPlayerPanel.call("showSelection", {firstPlayer = selectedFirstPlayer})                
            end,
            10)
    else
        hideTile(firstPlayerPanel)
    end
end

function hideModeButtons()
    hideTile(modeSelectorStandard)
    hideTile(modeSelectorExpert)
    hideTile(standardSetISelector)
    hideTile(standardSetIISelector)
    hideTile(standardSetIIISelector)
    hideTile(expertSetISelector)
    hideTile(expertSetIISelector)
    hideTile(firstPlayerPanel)
end

function showExpertSetButtons()
    showTile(expertSetISelector)
    showTile(expertSetIISelector)
end

function hideExpertSetButtons()
    hideTile(expertSetISelector)
    hideTile(expertSetIISelector)
end

function hideLayoutButtons()
    local allObjects = getAllObjects()

    for k,v in pairs(allObjects) do
        if(v.hasTag("layout-ui")) then
            hideTile(v)
        end
        if(v.hasTag("game-ui")) then
            showTile(v, false)
        end
    end
end

function showLayoutButtons()
    local allObjects = getAllObjects()

    for k,v in pairs(allObjects) do
        if(v.hasTag("game-ui")) then
            hideTile(v)
        end
        if(v.hasTag("layout-ui")) then
            showTile(v, false)
        end
    end
end

function hideSetupUI()
    hideLayoutButtons()
    hideSelectors({itemType = "hero"})
    hideSelectors({itemType = "scenario"})
    hideSelectors({itemType = "modular-set"})
    hideModeButtons()
end

function showTile(tile, sendHeroes)
    local currentPos = tile.getPosition()

    if(currentPos.y < 0) then
        tile.setPosition({x = currentPos.x, y = currentPos.y + hiddenSelectorOffset, z = currentPos.z})

        if(sendHeroes) then
            local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
            local selectedHeroes = heroManager.call("getSelectedHeroes")
            local heroNames = {}

            for color, hero in pairs(selectedHeroes) do
                heroNames[color] = hero.name
            end

            tile.call("showTile", {selectedHeroes = heroNames})
        else
            tile.call("showTile")
        end
    end
end

function hideTile(tile)
    local currentPos = tile.getPosition()

    if(currentPos.y >= 0) then
        tile.setPosition({x = currentPos.x, y = currentPos.y - hiddenSelectorOffset, z = currentPos.z})
        tile.call("hideTile")
    end
end

function setView(params)
    if(params.view == "modular-sets") then
        local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
        local currentScenarioKey = scenarioManager.call("getCurrentScenarioKey")
        if(currentScenarioKey == nil) then
            broadcastToAll("Please select a scenario.", {1,1,1})
            return
        end
    
        if(not scenarioUsesModularEncounterSets) then
            broadcastToAll("This scenario does not use modular encounter sets.", {1,1,1})
            return
        end        
    end

    currentView = params.view
    showCurrentView()
end

function showCurrentView()
    if(currentView == "heroes") then
        showHeroSelection()
    end
    if(currentView == "scenario") then
        showScenarioSelection()
    end
    if(currentView == "modular-sets") then
        showModularSetSelection()
    end
    if(currentView == "mode") then
        showModeSelection()
    end
end

function showHeroSelection()
    showLayoutButtons()

    hideSelectors({itemType = "scenario"})
    hideSelectors({itemType = "modular-set"})
    hideModeButtons()

    callCustomSetupFunction("hero")
  
    updateSetupButtons()
    showSelectors({itemType = "hero"})
end

function showScenarioSelection()
    showLayoutButtons()

    hideSelectors({itemType = "hero"})
    hideSelectors({itemType = "modular-set"})
    hideModeButtons()

    callCustomSetupFunction("scenario")

    updateSetupButtons()
    showSelectors({itemType = "scenario"})
    highlightSelectedScenario()
end

function showModularSetSelection()
    showLayoutButtons()

    hideSelectors({itemType = "hero"})
    hideSelectors({itemType = "scenario"})
    hideModeButtons()

    callCustomSetupFunction("modular-sets")

    updateSetupButtons()
    showSelectors({itemType = "modular-set"})
    highlightSelectedModularSets()
end

function showModeSelection()
    showLayoutButtons()

    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local currentScenarioKey = scenarioManager.call("getCurrentScenarioKey")
    if(currentScenarioKey == nil) then
        broadcastToAll("Please select a scenario.", {1,1,1})
        return
    end

    hideSelectors({itemType = "hero"})
    hideSelectors({itemType = "scenario"})
    hideSelectors({itemType = "modular-set"})

    callCustomSetupFunction("mode")

    updateSetupButtons()
    showModeButtons()
    highlightSelectedMode()
end

function updateSetupButtons()
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local scenarioUsesModularEncounterSets = scenarioManager.call("useModularEncounterSets")

    local heroesAreValid = scenarioManager.call("heroCountIsValid")
    local scenarioIsValid = scenarioManager.call("scenarioIsValid")
    local encounterSetsAreValid = scenarioManager.call("modularSetsAreValid")
    local modeIsValid = scenarioManager.call("modeAndStandardEncounterSetsAreValid")

    --layoutButtonHeroes.call("updateButton", {isEnabled = true, isActive = currentView == "heroes"})
    layoutButtonScenario.call("updateButton", {isEnabled = true, isActive = currentView == "scenario"})
    layoutButtonModularSets.call("updateButton", {isEnabled = scenarioIsValid and scenarioUsesModularEncounterSets, isActive = currentView == "modular-sets"})
    layoutButtonMode.call("updateButton", {isEnabled = scenarioIsValid, isActive = currentView == "mode"})

    layoutButtonGo.call("updateButton", {isEnabled = heroesAreValid and scenarioIsValid and encounterSetsAreValid and modeIsValid})
end

function highlightSelectedScenario()
    local allObjects = getAllObjects()
    local itemType = "scenario"
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local itemKey = scenarioManager.call("getCurrentScenarioKey")

    for k,v in pairs(allObjects) do
        if(v.hasTag(SELECTOR_TILE_TAG)) then
            if( v.getVar("itemType") == itemType) then
                if(v.getVar("itemKey") == itemKey) then
                    v.highlightOn({0,1,0})
                else
                    v.highlightOff()
                end
            end
        end
    end
end

function highlightSelectedModularSets()
    local allObjects = getAllObjects()
    local itemType = "modular-set"
    local modularSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))
    local items = modularSetManager.call("getSelectedSetKeys")

    for k,v in pairs(allObjects) do
        if(v.hasTag(SELECTOR_TILE_TAG)) then
            if( v.getVar("itemType") == itemType) then
                item = items[v.getVar("itemKey")]
                if(item ~= nil) then
                    v.highlightOn({0.89,0,0.55})
                else
                    v.highlightOff()
                end
            end
        end
    end
end

function highlightSelectedMode()
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local selectedMode = scenarioManager.call("getMode")
    local selectedStandardSet = scenarioManager.call("getSelectedStandardSet")
    local selectedExpertSet = scenarioManager.call("getSelectedExpertSet")

    if(selectedMode == "standard") then
        modeSelectorStandard.highlightOn({0,1,0})
        modeSelectorExpert.highlightOff()
    end
    if(selectedMode == "expert") then
        modeSelectorStandard.highlightOff()
        modeSelectorExpert.highlightOn({0,1,0})
    end

    if(selectedStandardSet == "i") then
        standardSetISelector.highlightOn({0,1,0})
        standardSetIISelector.highlightOff()
        standardSetIIISelector.highlightOff()
    end
    if(selectedStandardSet == "ii") then
        standardSetISelector.highlightOff()
        standardSetIISelector.highlightOn({0,1,0})
        standardSetIIISelector.highlightOff()
    end
    if(selectedStandardSet == "iii") then
        standardSetISelector.highlightOff()
        standardSetIISelector.highlightOff()
        standardSetIIISelector.highlightOn({0,1,0})
    end

    if(selectedExpertSet == "i") then
        expertSetISelector.highlightOn({0,1,0})
        expertSetIISelector.highlightOff()
    end
    if(selectedExpertSet == "ii") then
        expertSetISelector.highlightOff()
        expertSetIISelector.highlightOn({0,1,0})
    end
end

function setupScenario()
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call("setUpScenario")
end

function placeHeroWithStarterDeck(params)
    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
    heroManager.call("placeHeroWithStarterDeck", {heroKey = params.heroKey, playerColor = params.playerColor})
    updateSetupButtons()
end

function placeHeroWithHeroDeck(params)
    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
    heroManager.call("placeHeroWithHeroDeck", {heroKey = params.heroKey, playerColor = params.playerColor})
    updateSetupButtons()
end

function selectScenario(params)
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call("selectScenario", {scenarioKey = params.scenarioKey})
    scenarioUsesStandardEncounterSets = scenarioManager.call("useStandardEncounterSets")
    scenarioUsesModularEncounterSets = scenarioManager.call("useModularEncounterSets")

    updateSetupButtons()
    highlightSelectedScenario()
    colorCodeModularSets()
end

function selectModularSet(params)
    local modularSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))
    modularSetManager.call("selectModularSet", {modularSetKey = params.modularSetKey})

    updateSetupButtons()
    highlightSelectedModularSets()
end

function setMode(params)
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call("setMode", {mode = params.mode})

    if(params.mode == "expert" and scenarioUsesStandardEncounterSets) then
        showExpertSetButtons()
    else
        hideExpertSetButtons()
    end

    updateSetupButtons()
    highlightSelectedMode()
end

function setStandardSet(params)
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call("setStandardSet", {set = params.set})
    updateSetupButtons()
    highlightSelectedMode()
end

function setExpertSet(params)
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call("setExpertSet", {set = params.set})
    updateSetupButtons()
    highlightSelectedMode()
end

function setFirstPlayer(params)
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local firstPlayer = params.firstPlayer

    scenarioManager.call("setFirstPlayer", {firstPlayer = firstPlayer})
    firstPlayerPanel.call("showSelection", {firstPlayer = firstPlayer or "Random"})
end

function clearScenario()
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))

    scenarioManager.call("clearScenario")
    showScenarioSelection()
end

function colorCodeModularSets(params)
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local allObjects = getAllObjects()
    local itemType = "modular-set"
    local scenarioModularSets = params and params.sets or scenarioManager.call("getScenarioModularSets")

    for k,v in pairs(allObjects) do
        if(v.hasTag(SELECTOR_TILE_TAG)) then
            if( v.getVar("itemType") == itemType) then
                local required = scenarioModularSets[v.getVar("itemKey")] or "none"

                v.call("setButtonColor", {required = required})
            end
        end
    end
end

function callCustomSetupFunction(setupStep)
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local scenarioKey = scenarioManager.call("getCurrentScenarioKey")
    if(not scenarioKey) then return end

    local functionName = "customSetup_" .. scenarioKey

    if(scenarioManager.getVar(functionName) ~= nil) then
      return scenarioManager.call(functionName, {setupStep = setupStep})
    end
end
