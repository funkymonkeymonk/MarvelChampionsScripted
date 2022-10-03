local encounterDeckPosition = {-12.75, 1.01, 22.25}
local originPosition = {x=60.25, y=0.3, z=-6.25}

local columnGap = 6
local rowGap = -2.5

local columns = 7

function onLoad()
    createContextMenu()
	layOutModularSets()
end

function createContextMenu()
    self.addContextMenuItem("Lay Out Modular Sets", layOutModularSets)
    self.addContextMenuItem("Delete Modular Sets", deleteModularSets)
end

function layOutModularSets()
    clearModularSetTiles()
    layOutTiles()
end

function deleteModularSets()
    clearModularSetTiles()
end

function clearModularSetTiles()
    local allObjects = getAllObjects()

    for k,v in pairs(allObjects) do
        if(v.hasTag("modular-set-selector-tile")) then
            v.destruct()
        end
    end     
end

function layOutTiles()
    local currentRow = 1
    local currentColumn = 1

    local tileBag = getObjectFromGUID("01ad59")
    local sortedList = getSortedListOfMods()	

    for _, listItem in ipairs(sortedList) do
        local tilePosition = getCoordinates(currentColumn, currentRow)
        local tile = tileBag.takeObject({position = tilePosition, locked = true, smooth=false})

        setupTile({
            tile = tile,
            tilePosition = tilePosition,
            modularSetGuid = listItem[1],
            modularSetName = listItem[2]
        })

        currentColumn = currentColumn + 1

        if currentColumn > columns then
            currentColumn = 1
            currentRow = currentRow + 1
        end
    end
end

function getSortedListOfMods()
    modList = {}

    for _, modularSet in ipairs(self.getObjects()) do
        table.insert (modList, {modularSet.guid, modularSet.name})
    end

    return table.sort(modList, compareModularNames)
end

function compareModularNames(a,b)
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

function getWords (orig)
    local words = {}

    for str in string.gmatch(orig, "([^%s]+)") do
        table.insert(words, str)
    end

    return words
end

function getCoordinates(column, row)
    x = originPosition.x + columnGap * (column - 1)
    z = originPosition.z + rowGap * (row - 1)

    return {x, originPosition.y, z}
end

function setupTile(params)
    Wait.frames(
        function()
            local tile = params.tile
            local tilePosition = params.tilePosition
            tile.setName("")
            tile.setDescription("")
            tile.setScale({1.13, 1, 1.13})
            tile.setRotation({0,180,0})
            tile.setLock(true)
            tile.setPosition(tilePosition)
            tile.addTag("modular-set-selector-tile")

            setTileFunctions(tile, params.modularSetGuid)
            createTileButton(tile, string.gsub(params.modularSetName, " Modular Set", ""))
        end,
        30)
end

function setTileFunctions(tile, modularSetGuid)
    local tileScript = [[
        function placeModularSet(obj, player_color)
            local modularSetsBag = getObjectFromGUID("]]..self.guid..[[")
            modularSetsBag.call("placeModularSet", {modularSetGuid="]]..modularSetGuid..[["})
        end
    ]]
    tile.setLuaScript(tileScript)
end

function createTileButton(tile, modularSetName)
    local fontSize = 10 / string.len(modularSetName) * 400

    if(fontSize > 400) then fontSize = 400 end
    if(fontSize < 200) then fontSize = 200 end

    tile.createButton({
        label=modularSetName, click_function="placeModularSet", function_owner=tile,
        position={0,0.2,0}, rotation={0,0,0}, height=1000, width=2500,
        font_size=fontSize, color={0,0,0}, font_color={1,1,1}
    })
end

function placeModularSet(params)
    local modularSetOrig = self.takeObject({guid=params.modularSetGuid, position = encounterDeckPosition, rotation = {0,180,180}})
    local modularSetCopy = modularSetOrig.clone({position=encounterDeckPosition})

    modularSetCopy.setName("")
    modularSetCopy.setDescription("")
    modularSetCopy.setScale({2.12,3,2.12})

    self.putObject(modularSetOrig)  
end
