local originPosition = {x=88.25, y=0.50, z=33.75}

local rowGap = -2.5
local columnGap = 5

local rows = 12

function onload(saved_data)
    self.setInvisibleTo({"Red", "Blue", "Green", "Yellow", "White"})
    createContextMenu()
    layOutScenarios()
end

function createContextMenu()
    self.addContextMenuItem("Lay Out Scenarios", layOutScenarios)
    self.addContextMenuItem("Delete Scenarios", deleteScenarios)
end

function layOutScenarios()
    clearScenarios()
    layOutTiles()
end

function deleteScenarios()
    clearScenarios()
end

function clearScenarios()
    local allObjects = getAllObjects()

    for k,v in pairs(allObjects) do
        if(v.hasTag("scenario-selector-tile")) then
            v.destruct()
        end
    end     
end

function layOutTiles()
    local bagList = getSortedListOfScenarios()
    local tileBag = getObjectFromGUID("01ad59")

    for bagGuid, tilePosition in pairs(bagList) do
        local tilePosition = tilePosition

        local scenarioBag = self.takeObject({guid=bagGuid, smooth=false})
        local tile = tileBag.takeObject({position=tilePosition, smooth=false})

        setupTile({
            scenarioBag=scenarioBag,
            tile=tile,
            tilePosition=tilePosition
        })
    end
end

function getSortedListOfScenarios()
    local scenarioList = {}

    for _, scenarioBag in ipairs(self.getObjects()) do
        table.insert (scenarioList, {scenarioBag.guid, scenarioBag.name})
    end

    local sortedList = table.sort(scenarioList, compareScenarioNames)

    local row = 1
    local column = 1
    local orderedList = {}

    for _,v in ipairs(sortedList) do
        orderedList[v[1]] = getTilePosition(column, row)

        row = row + 1
        if row > rows then
            row = 1
            column = column + 1
        end
    end

    return orderedList
end

function compareScenarioNames(a,b)
    return stripArticles(a[2]) < stripArticles(b[2]) 
end

function stripArticles(orig)
    local lower = string.lower(orig)

    if(string.sub(lower, 1, 4) == "the ") then
        return string.sub(orig, 5, -1)
    end

    if(string.sub(lower, 1, 2) == "a ") then
        return string.sub(orig, 3, -1)
    end

    if(string.sub(lower, 1, 3) == "an ") then
        return string.sub(orig, 4, -1)
    end

    return orig
end

function getTilePosition(column, row)
    return {
        originPosition.x + columnGap * (column - 1), 
        originPosition.y, 
        originPosition.z + rowGap * (row - 1)}
end

function setupTile(params)
    Wait.frames(
        function()
            local scenarioBag=params.scenarioBag
            local scenarioDetails = scenarioBag.call("getScenarioDetails")
            local imageUrl = scenarioDetails["selectorImageUrl"]
            self.putObject(scenarioBag)

            local tile = params.tile
            local tilePosition = params.tilePosition
            tile.setName(string.gsub(scenarioBag.getName(), " Scenario Bag", ""))
            tile.setDescription(scenarioBag.getDescription())
            tile.setScale({1.13, 1, 1.13})
            tile.setRotation({0,180,0})
            tile.setLock(true)
            tile.setPosition(tilePosition)
            tile.addTag("Scenario-selector-tile")
            tile.setCustomObject({image=imageUrl})
            reloadedTile = tile.reload()

            setTileFunctions(reloadedTile, scenarioBag.getGUID())
            createTileButtons(reloadedTile)
        end,
        30)
end

function setTileFunctions(tile, scenarioBagGuid)
    local tileScript = [[
        function placeScenarioInStandardMode(obj, player_color)
            local scenarioPlacer = getObjectFromGUID(Global.getVar("SCENARIO_MANAGER_GUID"))
            scenarioPlacer.call("placeScenarioInStandardMode", {scenarioBagGuid="]]..scenarioBagGuid..[["})
        end
        function placeScenarioInExpertMode(obj, player_color)
            local scenarioPlacer = getObjectFromGUID(Global.getVar("SCENARIO_MANAGER_GUID"))
            scenarioPlacer.call("placeScenarioInExpertMode", {scenarioBagGuid="]]..scenarioBagGuid..[["})
        end    
    ]]
    tile.setLuaScript(tileScript)
end

function createTileButtons(tile)
    tile.createButton({
        label="S|", click_function="placeScenarioInStandardMode", function_owner=tile,
        position={0.47,0.2,-0.15}, rotation={0,0,0}, height=540, width=530,
        font_size=600, color={1,1,1}, font_color={0,0,0}, tooltip="Standard Mode"
    })
    tile.createButton({
        label="E", click_function="placeScenarioInExpertMode", function_owner=tile,
        position={1.17,0.2,-0.18}, rotation={0,0,0}, height=540, width=530, 
        font_size=600, color={1,1,1}, font_color={0,0,0}, tooltip="Expert Mode"
    })
end
