preventDeletion = true

local encounterDeckPosition = {-12.75, 1.01, 22.25}
local originPosition = {x=60.25, y=0.3, z=-6.25}

local columnGap = 6
local rowGap = 2.5

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
require('!/modulars/next_evolution')
