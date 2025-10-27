preventDeletion = true

local encounterDeckPosition = {-12.75, 1.01, 22.25}
local originPosition = {x=60.25, y=0.3, z=-6.25}

local columnGap = 6
local rowGap = 2.5

local columns = 7

local modularSets = {}
local selectedSets = {}

function onLoad()
    createContextMenu()
	--layOutModularSets()
end

function clearData()
    self.script_state = ""
end
  
function createContextMenu()
    self.addContextMenuItem("Lay Out Modular Sets", layOutModularSets)
    self.addContextMenuItem("Delete Modular Sets", deleteModularSets)
end

function getModularSet(params)
    return modularSets[params.modularSetKey]
end

function getSelectedSets(params)
    return deepCopy(selectedSets)
end

function getSelectedSetKeys()
    local keys = {}

    for k,v in pairs(selectedSets) do
        keys[k] = v.required or "recommended"
    end

    return keys
end

function getSelectedSetCount()
    local count = 0

    for k,v in pairs(selectedSets) do
        count = count + 1
    end

    return count
end

function getCardsFromSelectedSets()
    local cards = {}

    for k,v in pairs(selectedSets) do
        for cardId, count in pairs(v.cards) do
            cards[cardId] = count
        end
    end

    return cards
end

function layOutModularSetSelectors(params)
    local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
    local sets = getEncounterSetsByType({modular = params.modular})

    layoutManager.call("layOutSelectorTiles", {
        origin = params.origin,
        center = params.center or {0,0.5,0},
        direction = params.direction or "horizontal",
        maxRowsOrColumns = params.maxRowsOrColumns or 7,
        columnGap = params.columnGap or 6.5,
        rowGap = params.rowGap or 3.5,
        selectorScale = params.selectorScale or {1.33, 1, 1.33},
        items = sets,
        itemType = "modular-set",
        behavior = params.behavior,
        hidden = params.hidden
    }) 
end
  
function layOutModularSets()
    local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))

    layoutManager.call("layOutSelectorTiles", {
        origin = originPosition,
        direction = "horizontal",
        maxRowsOrColumns = columns,
        columnGap = columnGap,
        rowGap = rowGap,
        items = modularSets,
        itemType = "modular-set"
    })
end

function deleteModularSets()
    local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
    layoutManager.call("clearSelectorTiles", {itemType = "modular-set"})
end

function preSelectEncounterSets(params)
    selectedSets = {}
    local sets = params.sets

    for key,required in pairs(sets) do
        set = deepCopy(modularSets[key])
        set.required = required
        selectedSets[key] = set
    end
end

function clearSelectedSets()
    selectedSets = {}
end

function selectModularSet(params)
    addRemoveSelectedSet(params.modularSetKey)
end

function removeModularSet(params)
    selectedSets[params.modularSetKey] = nil
end

function addRemoveSelectedSet(key)
    for k, v in pairs(selectedSets) do
        if(k == key) then
            selectedSets[k] = nil
            return
        end
    end

    selectedSets[key] = deepCopy(modularSets[key])
end

function hideSelectors()
    local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
    layoutManager.call("hideSelectors", {itemType = "modular-set"})
end

function showSelectors()
    local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
    layoutManager.call("showSelectors", {itemType = "modular-set"})
    --layoutManager.call("highlightMultipleSelectorTiles", {itemType = "modular-set", items = selectedSets})
end
  

function addEncounterSetToDeck(params)
    local modularSet = modularSets[params.setKey]
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local position = Vector(scenarioManager.call("getEncounterDeckPosition"))
    local rotation = {0,180,180}
    local scale = {2.12,3,2.12}
    
    local cards = modularSet.cards

    local deckCount = 0
    local cardId = nil

    --TODO: Modify spawnDeck to spawn a single card, if the deck list only contains one card
    for k,v in pairs(cards) do
        if(deckCount > 1) then break end

        deckCount = deckCount + v
        cardId = k
    end     

    if(position.y < 3) then
        position.y = 3
    end

    if(deckCount < 2) then
        Global.call("spawnCard", {
            cardId = cardId, 
            position = position, 
            scale = scale,
            flipped = true})
    else
        Global.call("spawnDeck", {
            cards = modularSet.cards, 
            position = position, 
            rotation = rotation, 
            scale = scale})
    end

    Wait.frames(
        function()
            Global.call("shuffleDeck", {deckPosition = position})
        end,
        30)
end

function getEncounterSetsByType(params)
    modular = params.modular
    local encounterSetList = {}
  
    for key, set in pairs(modularSets) do
      if(set.modular == modular) then
        encounterSetList[key] = set
      end
    end
  
    return encounterSetList
end

function getEncounterSets()
    return modularSets
end

function deepCopy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[deepCopy(k, s)] = deepCopy(v, s) end
    return res
end

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
require('!/modulars/next_evolution')
require('!/modulars/age_of_apocalypse')
require('!/modulars/agents_of_shield')
