local defaults = {
    villainHpCounter= {
        position= {-0.34, 0.96, 29.15},
        rotation= {0.00, 180, 0.00},
        scale= {2.88, 1.00, 2.88}
    },
    encounterDeck= {
        position= {-12.75, 1.06, 22.25},
        rotation= {0.00, 180.00, 180.00},
        scale= {2.12, 1.00, 2.12}
    },
    villainDeck= {
        position= {-0.34, 2, 20.44},
        rotation= {0.00, 180.00, 0.00},
        scale= {3.64, 1.00, 3.64}
    },
    mainSchemeDeck= {
        position= {8.38, 2, 22.45},
        rotation= {0.00, 90.00, 180.00},
        scale= {2.93, 1.00, 2.93}
    },
    mainSchemeThreatCounter= {
        position= {8.38, 1.01, 28.48},
        rotation= {0.00, 180.00, 0.00},
        scale= {1.61, 1.00, 1.61}
    },
    blackHole= {
        position= {-9.05, 1.13, 28.48},
        rotation= {0.00, 90.00, 0.00},
        scale= {0.55, 0.55, 0.55}
    },
    sideScheme= {
        position= {16.75, 1.00, 21.75},
        rotation= {0.00, 90.00, 0.00}
    }
}

local scenarios = {}
local scenarioBagGuid = ""
local scenarioInfo = {}
local mode = ""
local counters = {}
local villains = {}

local advanceVillainFunction --(villainName, stageNumber)
local advanceSchemeFunction --(schemeName, stageNumber)

local originPosition = {x=83.25, y=0.50, z=33.75}

local rowGap = -2.5
local columnGap = 5

local rows = 12

local assetBag = getObjectFromGUID("91eba8")

function onload(saved_data)
    createContextMenu()
    layOutScenarios()
end

function spawnAsset(params)
    params.caller = self
    assetBag.call("spawnAsset", params)
end

function placeUnscriptedScenario(params)
    placeScenario(params.scenarioKey, "")
    Global.call("requestBoost")
end

function placeScenarioInStandardMode(params)
    placeScenario(params.scenarioKey, "standard")
end

function placeScenarioInExpertMode(params)
    placeScenario(params.scenarioKey, "expert")
end

function placeScenario(scenarioKey, mode)

    if not confirmNoScenarioIsPlaced() then return end

    local heroCount = getHeroCount()
    
    local scenario = scenarios[scenarioKey];

    Wait.frames(
        function()
            for _, villain in pairs(scenario.villains) do
                placeVillainHpCounter(villain, heroCount)
                placeVillain(villain)
            end

            for _, deck in pairs(scenario.decks) do
                placeDeck(deck)
            end

            for _, scheme in pairs(scenario.schemes) do
                placeScheme(scheme)
            end

            placeBlackHole(scenario)

            if(scenario.cards ~= nil) then
                for _, card in pairs(scenario.cards) do
                    getCardByID(card.cardId, card.position, {scale=card.scale, name=card.name, flipped=card.flipped, landscape=card.landscape})
                end
            end

            if(scenario.counters ~= nil) then
                for _, counter in pairs(scenario.counters) do
                    Wait.time(
                        function()
                            if(counter.type=="threat") then
                                placeThreatCounter(counter, nil, heroCount)
                            else
                                placeGeneralCounter(counter)
                            end
                        end,
                        1)
                    
                end
            end

            --placeExtras(scenarioBag, scenarioDetails.extras)
        end, 
        1)
end

function confirmNoScenarioIsPlaced()
    return true --TODO: Implement this
end

function placeVillainHpCounter(villain, heroCount)
    local position = villain.hpCounter.position or defaults.villainHpCounter.position
    local rotation = villain.hpCounter.rotation or defaults.villainHpCounter.rotation
    local scale = villain.hpCounter.scale or defaults.villainHpCounter.scale

    local counterTemp
    local villainHpCounter

    --local hitPoints = villain.hitPointsPerPlayer * heroCount
    local lock = true;

    if(villain.hpCounter.locked ~= nil) then
        lock = villain.hpCounter.locked
    end

    if(villain.hpCounter.guid ~= nil) then
        -- local villainHpCounterOrig = scenarioBag.takeObject({guid=villain.hpCounter.guid, position=counterPosition})
        -- villainHpCounter = villainHpCounterOrig.clone({position=counterPosition})
        -- scenarioBag.putObject(villainHpCounterOrig)
    else
        spawnAsset({
            guid = "8cf3d6",
            position = position,
            rotation = rotation,
            scale = scale,
            imageUrl = villain.hpCounter.imageUrl,
            lock = lock,
            callback="configureVillainHpCounter"
        })
    end
end

function configureVillainHpCounter(params)
    local counter = params.spawnedObject

    counter.setPosition(params.position)
    counter.setName("")
    counter.setDescription("")
    counter.setLock(params.lock)
    counter.setCustomObject({image = params.imageUrl})
    counter.reload()

    --counter.call("setValue", {value=hitPoints})
    --counter.call("createAdvanceButton", {villainKey=villain.name}) --TODO: make this more dynamic, use villainKey instead of name

    -- counters[counter.getGUID()] = {
    --     base=0,
    --     multiplier=villain.hitPointsPerPlayer
    -- }
end

function placeVillain(villain)
    local villainPosition = villain.deckPosition or defaults.villainDeck.position
    local villainRotation = villain.deckRotation or defaults.villainDeck.rotation
    local villainScale = villain.deckScale or defaults.villainDeck.scale

    --TODO: only place the cards that are needed, based on mode
    if(villain.stage4 ~= nil) then --TODO: Remove this after adding scripting to Mansion Attack scenario
        getCardByID(villain.stage4.cardId, villainPosition, {scale=villainScale, name=villain.name, flipped=false})
    end

    if(villain.stage3 ~= nil) then
        getCardByID(villain.stage3.cardId, villainPosition, {scale=villainScale, name=villain.name, flipped=false})
    end

    if(villain.stage2 ~= nil) then
        
        Wait.time(
            function()
                getCardByID(
                    villain.stage2.cardId, 
                    villainPosition, 
                    {scale=villainScale, name=villain.name, flipped=false}) 
            end,
            .5)
        
    end
    
    if(villain.stage1 ~= nil) then
        Wait.time(
            function()
                getCardByID(
                    villain.stage1.cardId, 
                    villainPosition, 
                    {scale=villainScale, name=villain.name, flipped=false})
            end,
            1)
    end
end

function placeDeck(deck)
    local deckPosition = deck.position or defaults.encounterDeck.position
    local deckRotation = deck.rotation or defaults.encounterDeck.rotation
    local deckScale = deck.scale or defaults.encounterDeck.scale

    createDeck({cards=deck.cards, position=deckPosition, scale=deckScale, name=deck.name})
end

function placeScheme(scheme)
    local schemePosition = scheme.position or defaults.mainSchemeDeck.position
    local schemeRotation = scheme.rotation or defaults.mainSchemeDeck.rotation
    local schemeScale = scheme.scale or defaults.mainSchemeDeck.scale

    --There may be a better way to iterate over the stages backward
    local delay = 0
    for i = 5, 1, -1 do
        if(scheme.stages["stage"..i] ~= nil) then
            Wait.time(
                function()
                    getCardByID(scheme.stages["stage"..i].cardId, schemePosition, {scale=schemeScale, name=scheme.name, flipped=false, landscape=true})
                end,
                delay
            )
            delay = delay + 0.5
        end
    end

    local counter = scheme.counter or {}

    Wait.time(
        function()
            placeThreatCounter(counter, nil, getHeroCount())
        end,
        1
    )
end

function placeThreatCounter(counter, stageNumber, heroCount)
    local threatCounterPosition = counter.position or defaults.mainSchemeThreatCounter.position
    local threatCounterRotation = counter.rotation or defaults.mainSchemeThreatCounter.rotation
    local threatCounterScale = counter.scale or defaults.mainSchemeThreatCounter.scale

    -- local threatBase
    -- local threatMultiplier
    -- local initialThreat

    -- if(stageNumber ~= nil) then
    --     threatBase = scheme.stages[stageNumber].threatBase
    --     threatMultiplier = scheme.stages[stageNumber].threatMultiplier
    -- else
    --     threatBase = scheme.threatBase
    --     threatMultiplier = scheme.threatMultiplier
    -- end

    -- initialThreat = threatBase + (threatMultiplier * heroCount)

    local threatCounterBag = getObjectFromGUID("eb5d6d")
    local threatCounter = threatCounterBag.takeObject({position=threatCounterPosition, smooth=false})

    local locked = true;
    if(counter.locked ~= nil) then
        locked = counter.locked
    end

    Wait.frames(
        function()
            threatCounter.setRotation(threatCounterRotation)
            threatCounter.setScale(threatCounterScale)
            threatCounter.setLock(locked)
            --threatCounter.call("setValue", {value=initialThreat})
        end,
        1
    )

    -- counters[threatCounter.getGUID()] = {
    --     base=threatBase,
    --     multiplier=threatMultiplier
    -- }
end

function placeGeneralCounter(counter)
    local counterPosition = counter.position or defaults.mainSchemeThreatCounter.position
    local counterRotation = counter.rotation or defaults.mainSchemeThreatCounter.rotation
    local counterScale = counter.scale or defaults.mainSchemeThreatCounter.scale

    local counterBag = getObjectFromGUID("65c1cc")
    local generalCounter = counterBag.takeObject({position=counterPosition, smooth=false})

    local locked = true;
    log (counter)

    if(counter.locked ~= nil) then
        locked = counter.locked
    end

    Wait.frames(
        function()
            generalCounter.setRotation(counterRotation)
            generalCounter.setScale(counterScale)
            generalCounter.setLock(locked)
            --threatCounter.call("setValue", {value=initialThreat})
        end,
        1
    )
end

function placeExtras(scenarioBag, extras)
    if(extras == nil) then return end

    for _, item in pairs(extras) do
        local objectPosition = Vector(item.position)
        local objectOrig = scenarioBag.takeObject({guid=item.guid, position=objectPosition})
        local objectCopy = objectOrig.clone({position=objectPosition})
        scenarioBag.putObject(objectOrig)
    
        objectCopy.setPosition(objectPosition)

        objectCopy.setName(item.name)
        objectCopy.setDescription(item.description)
    
        if(item["locked"]) then
          objectCopy.setLock(true)
        end    
    end
end

function placeBlackHole(scenario)
    local position = scenario.blackHole and scenario.blackHole.position or defaults.blackHole.position
    local rotation = scenario.blackHole and scenario.blackHole.rotation or defaults.blackHole.rotation
    local scale = scenario.blackHole and scenario.blackHole.scale or defaults.blackHole.scale

    spawnAsset({
        guid = "740595",
        position = position,
        rotation = rotation,
        scale = scale,
        callback = "configureBlackHole"
    })
end

function configureBlackHole(params)
    local blackHole = params.spawnedObject
    blackHole.setPosition(params.position)
    blackHole.setScale(params.scale) --Shouldn't have to do this, but the scale wasn't being applied in the takeObject call
    blackHole.setLock(true)
end

function getHeroCount()
    local allObjects = getAllObjects()
    local playmatCount = 0
 
    for _, obj in pairs(allObjects) do
       if(obj.hasTag("Playmat")) then
          playmatCount = playmatCount + 1
       end
    end
 
    return playmatCount
 end

 function updateCounters()
    local heroCount = getHeroCount()

    for guid, calc in pairs(counters) do
        local counter = getObjectFromGUID(guid)
        newValue = calc.base + (calc.multiplier * heroCount)
        counter.call("setValue", {value=newValue})
    end
 end

 function clearScenario()
    --TODO: call this when clearing the scenario area
    scenarioBagGuid = ""
    scenarioInfo = {}
    mode = ""
    counters = {}
    vilains = {}
 end

 function advanceVillain(params)
    broadcastToAll("Advance clicked for "..params.villainKey, {1,1,1})
 end

 function advanceScheme()
 end






function createContextMenu()
    self.addContextMenuItem("Lay Out Scenarios", layOutScenarios)
    self.addContextMenuItem("Delete Scenarios", deleteScenarios)
end

function layOutScenarios()
    clearScenarios()
    layOutScenarioTiles()
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

function layOutScenarioTiles()
    baseTile = getObjectFromGUID("c04e76")
    local scenarioList = getSortedListOfScenarios()

    for k, v in ipairs(scenarioList) do
        local position = v.tilePosition

        tile = baseTile.clone({
            position=position,
            rotation={0,180,0},
            scale={1.13, 1, 1.13}})

        local scenarioDetails = scenarios[v.scenarioKey]
        local imageUrl = scenarioDetails["selectorImageUrl"]
    
        tile.setName(scenarioDetails.name)
        tile.setLock(true)
        tile.setPosition(position)
        tile.addTag("Scenario-selector-tile")
        tile.setCustomObject({image=imageUrl})
        reloadedTile = tile.reload()
    
        setTileFunctions(reloadedTile, v.scenarioKey)
        createTileButtons(reloadedTile)
    end
end

function getSortedListOfScenarios()
    local scenarioList = {}

    local index = 1

    --This may be a hack; I couldn't figure out how to get numeric keys
    for k, v in pairs(scenarios) do
        scenarioList[index] = {k, v.name}
        index = index + 1
    end

    local sortedList = table.sort(scenarioList, compareScenarioNames)

    local row = 1
    local column = 1
    local orderedList = {}

    for i, v in ipairs(sortedList) do
        orderedList[i] = {
            scenarioKey=v[1],
            tilePosition=getTilePosition(column, row)
        }

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

function setTileFunctions(tile, scenarioKey)
    local tileScript = [[
        function placeScenario(obj, player_color)
            local scenarioPlacer = getObjectFromGUID(Global.getVar("SCENARIO_MANAGER_GUID"))
            scenarioPlacer.call("placeUnscriptedScenario", {scenarioKey="]]..scenarioKey..[["})
        end
    ]]

    -- local tileScript = [[
    --     function placeScenarioInStandardMode(obj, player_color)
    --         local scenarioPlacer = getObjectFromGUID(Global.getVar("SCENARIO_MANAGER_GUID"))
    --         scenarioPlacer.call("placeScenarioInStandardMode", {scenarioBagGuid="]]..scenarioBagGuid..[["})
    --     end
    --     function placeScenarioInExpertMode(obj, player_color)
    --         local scenarioPlacer = getObjectFromGUID(Global.getVar("SCENARIO_MANAGER_GUID"))
    --         scenarioPlacer.call("placeScenarioInExpertMode", {scenarioBagGuid="]]..scenarioBagGuid..[["})
    --     end    
    -- ]]
    tile.setLuaScript(tileScript)
end

function createTileButtons(tile)
    tile.createButton({
        label="GO", click_function="placeScenario", function_owner=tile,
        position={0.85,0.2,-0.18}, rotation={0,0,0}, height=540, width=875, 
        font_size=500, color={1,1,1}, font_color={0,0,0}, tooltip="Set Up Scenario"
    })

    -- tile.createButton({
    --     label="S|", click_function="placeScenarioInStandardMode", function_owner=tile,
    --     position={0.47,0.2,-0.15}, rotation={0,0,0}, height=540, width=530,
    --     font_size=600, color={1,1,1}, font_color={0,0,0}, tooltip="Standard Mode"
    -- })
    -- tile.createButton({
    --     label="E", click_function="placeScenarioInExpertMode", function_owner=tile,
    --     position={1.17,0.2,-0.18}, rotation={0,0,0}, height=540, width=530, 
    --     font_size=600, color={1,1,1}, font_color={0,0,0}, tooltip="Expert Mode"
    -- })
end


require('!/Cardplacer')

require('!/scenarios/rhino')
require('!/scenarios/klaw')
require('!/scenarios/ultron')
require('!/scenarios/mysterio')
require('!/scenarios/sandman')
require('!/scenarios/wrecking_crew')
require('!/scenarios/loki')
require('!/scenarios/hela')
require('!/scenarios/thanos')
require('!/scenarios/tower_defense')
require('!/scenarios/ebony_maw')
require('!/scenarios/ronan_the_accuser')
require('!/scenarios/nebula')
require('!/scenarios/escape_the_museum')
require('!/scenarios/infiltrate_the_museum')
require('!/scenarios/brotherhood_of_badoon')
require('!/scenarios/once_and_future_kang')
require('!/scenarios/red_skull')
require('!/scenarios/zola')
require('!/scenarios/taskmaster')
require('!/scenarios/absorbing_man')
require('!/scenarios/crossbones')
require('!/scenarios/mutagen_formula')
require('!/scenarios/risky_business')
require('!/scenarios/mojo_mania')
require('!/scenarios/magneto')
require('!/scenarios/mansion_attack')
require('!/scenarios/master_mold')
require('!/scenarios/operation_wideawake')
require('!/scenarios/sabretooth')
require('!/scenarios/hood')
require('!/scenarios/sinister_six')
require('!/scenarios/venom')
require('!/scenarios/venom_goblin')
