local encounterDeckPosition = {-12.75, 1.01, 22.25}
local originPosition = {x=60.25, y=0.3, z=-6.25}

local columnGap = 6
local rowGap = -2.5

local columns = 7

local modularSets = {}

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
    layOutModularSetTiles()
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

function layOutModularSetTiles()
    baseTile = getObjectFromGUID("c04e76")

    local currentRow = 1
    local currentColumn = 1

    local sortedList = getSortedListOfMods()	

    for _, listItem in ipairs(sortedList) do
        local modularSetKey = listItem[1]
        local modularSet = listItem[2]
        local position = getCoordinates(currentColumn, currentRow)
        
        tile = baseTile.clone({
            position=position,
            rotation={0,180,0},
            scale={1.13, 1, 1.13}})

        tile.setName("")
        tile.setDescription("")
        tile.setLock(true)
        tile.setPosition(position)
        tile.addTag("modular-set-selector-tile")

        setTileFunctions(tile, modularSetKey)
        createTileButton(tile, modularSet.name)

        currentColumn = currentColumn + 1

        if currentColumn > columns then
            currentColumn = 1
            currentRow = currentRow + 1
        end
    end
end

function getSortedListOfMods()
    local modList = {}
    local index = 1

    for k, v in pairs(modularSets) do
        modList[index] = {k, v}
        index = index + 1
    end

    function compareModularNames(a,b)
        return stripArticles(a[2].name) < stripArticles(b[2].name) 
    end
    
    return table.sort(modList, compareModularNames)
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

function setTileFunctions(tile, modularSetKey)
    local tileScript = [[
        function placeModularSet(obj, player_color)
            local modularSetsBag = getObjectFromGUID("]]..self.guid..[[")
            modularSetsBag.call("placeModularSet", {modularSetKey="]]..modularSetKey..[["})
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
    local modularSet = modularSets[params.modularSetKey]
    local position = encounterDeckPosition
    local rotation = {0,180,180}
    local scale = {2.12,3,2.12}
    
    local cards = modularSet.cards

    local deckCount = 0
    local cardId = nil

    --Oh god, this is hacky. The createDeck function only works with two or more cards, so
    --we have to use getCardByID for single-card sets. But there doesn't seem to be a way to 
    --get the length of a table in Lua, so we have to iterate through the table to determine
    --which function to use.
    for k,v in pairs(cards) do
        if(deckCount > 1) then break end

        deckCount = deckCount + v
        cardId = k
    end     

    if(deckCount < 2) then
        getCardByID(
            cardId,
            position, 
            {scale=scale, flipped=true})
    else
        createDeck({cards=modularSet.cards, position=position, rotation=rotation, scale=scale})
    end
end

require('!/Cardplacer')

require('!/modulars/kang')
require('!/modulars/mutant_genesis')
require('!/modulars/misc')
require('!/modulars/hood')
require('!/modulars/green_goblin')
require('!/modulars/sinister_motives')
require('!/modulars/galaxys_most_wanted')
require('!/modulars/core')
require('!/modulars/rise_of_the_red_skull')
require('!/modulars/mad_titans_shadow')
require('!/modulars/mojo_mania')
