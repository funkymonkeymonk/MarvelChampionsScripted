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
        position= {-0.34, 0.99, 20.44},
        rotation= {0.00, 180.00, 0.00},
        scale= {3.64, 1.00, 3.64}
    },
    mainSchemeDeck= {
        position= {8.38, 0.97, 22.45},
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

local scenarioBagGuid = ""
local scenarioInfo = {}
local mode = ""
local counters = {}
local villains = {}

local advanceVillainFunction --(villainName, stageNumber)
local advanceSchemeFunction --(schemeName, stageNumber)

function onLoad()
    --self.setInvisibleTo({"Red", "Blue", "Green", "Yellow", "White"})
end

function placeScenarioInStandardMode(params)
    placeScenario(params.scenarioBagGuid, "standard")
end

function placeScenarioInExpertMode(params)
    placeScenario(params.scenarioBagGuid, "expert")
end

function placeScenario(scenarioBagGuid, mode)

    if not confirmNoScenarioIsPlaced() then return end

    local heroCount = getHeroCount()
    
    local scenariosBag = getObjectFromGUID("a8cf98")
    local scenarioBag = scenariosBag.takeObject({guid=scenarioBagGuid})

    Wait.frames(
        function()
            local scenarioDetails = scenarioBag.call("getScenarioDetails")

            for _, villain in pairs(scenarioDetails.villains) do
                placeVillainHpCounter(scenarioBag, villain, heroCount)
                placeVillainDeck(scenarioBag, villain)
                placeEncounterDeck(scenarioBag, villain)
            end

            placeMainScheme(scenarioBag, scenarioDetails)
            placeThreatCounter(scenarioDetails.mainScheme, 1, heroCount)
            placeBlackHole(scenarioDetails)
            placeExtras(scenarioBag, scenarioDetails.extras)
        
            scenariosBag.putObject(scenarioBag)
        end, 
        1)
end

function confirmNoScenarioIsPlaced()
    return true --TODO: Implement this
end

function placeVillainHpCounter(scenarioBag, villain, heroCount)
    local counterPosition = villain.hpCounter.position or defaults.villainHpCounter.position
    local counterRotation = villain.hpCounter.rotation or defaults.villainHpCounter.rotation
    local counterScale = villain.hpCounter.scale or defaults.villainHpCounter.scale

    local villainHpCounter

    if(villain.hpCounter.guid ~= nil) then
        local villainHpCounterOrig = scenarioBag.takeObject({guid=villain.hpCounter.guid, position=counterPosition})
        villainHpCounter = villainHpCounterOrig.clone({position=counterPosition})
        scenarioBag.putObject(villainHpCounterOrig)
    else
        local villainHpCounterBag = getObjectFromGUID("c95452")
        local counterTemp = villainHpCounterBag.takeObject({position=counterPosition})
        counterTemp.setCustomObject({image=villain.hpCounter.imageUrl})
        villainHpCounter = counterTemp.reload()
    end

    local hitPoints = villain.hpMultiplier * heroCount

    Wait.frames(
        function()
            villainHpCounter.setPosition(counterPosition)
            villainHpCounter.setRotation(counterRotation)
            villainHpCounter.setScale(counterScale)
            villainHpCounter.setName("")
            villainHpCounter.setDescription("")
            villainHpCounter.setLock(true)
            villainHpCounter.call("setValue", {value=hitPoints})
            --villainHpCounter.call("createAdvanceButton", {villainKey=villain.name}) --TODO: make this more dynamic, use villainKey instead of name
        end,
        10
    )

    counters[villainHpCounter.getGUID()] = {
        base=0,
        multiplier=villain.hpMultiplier
    }
end

function placeVillainDeck(scenarioBag, villain)
    local villainPosition = villain.villainDeck.position or defaults.villainDeck.position
    local villainRotation = villain.villainDeck.rotation or defaults.villainDeck.rotation
    local villainScale = villain.villainDeck.scale or defaults.villainDeck.scale

    local villainDeckOrig = scenarioBag.takeObject({guid=villain.villainDeck.guid, position=villainPosition})
    local villainDeckCopy = villainDeckOrig.clone({position=villainPosition})
    scenarioBag.putObject(villainDeckOrig)

    villainDeckCopy.setPosition(villainPosition)
    villainDeckCopy.setRotation(villainRotation)
    villainDeckCopy.setScale(villainScale)
    villainDeckCopy.setName("")
    villainDeckCopy.setDescription("")
end

function placeEncounterDeck(scenarioBag, villain)
    local encounterDeckPosition = villain.encounterDeck.position or defaults.encounterDeck.position
    local encounterDeckRotation = villain.encounterDeck.rotation or defaults.encounterDeck.rotation
    local encounterDeckScale = villain.encounterDeck.scale or defaults.encounterDeck.scale

    local encounterDeckOrig = scenarioBag.takeObject({guid=villain.encounterDeck.guid, position=encounterDeckPosition})
    local encounterDeckCopy = encounterDeckOrig.clone({position=encounterDeckPosition})
    scenarioBag.putObject(encounterDeckOrig)

    encounterDeckCopy.setPosition(encounterDeckPosition)
    encounterDeckCopy.setRotation(encounterDeckRotation)
    encounterDeckCopy.setScale(encounterDeckScale)
    encounterDeckCopy.setName("")
    encounterDeckCopy.setDescription("")
end

function placeMainScheme(scenarioBag, scenarioDetails)
    local mainSchemeDeckPosition = scenarioDetails.mainScheme.deckPosition or defaults.mainSchemeDeck.position
    local mainSchemeDeckRotation = scenarioDetails.mainScheme.deckRotation or defaults.mainSchemeDeck.rotation
    local mainSchemeDeckScale = scenarioDetails.mainScheme.deckScale or defaults.mainSchemeDeck.scale

    local mainSchemeDeckOrig = scenarioBag.takeObject({guid=scenarioDetails.mainScheme.deckGuid, position=mainSchemeDeckPosition})
    local mainSchemeDeckCopy = mainSchemeDeckOrig.clone({position=mainSchemeDeckPosition})
    scenarioBag.putObject(mainSchemeDeckOrig)

    mainSchemeDeckCopy.setPosition(mainSchemeDeckPosition)
    mainSchemeDeckCopy.setRotation(mainSchemeDeckRotation)
    mainSchemeDeckCopy.setScale(mainSchemeDeckScale)
    mainSchemeDeckCopy.setName("")
    mainSchemeDeckCopy.setDescription("")
end

function placeThreatCounter(scheme, stageNumber, heroCount)
    local threatCounterPosition = scheme.counterPosition or defaults.mainSchemeThreatCounter.position
    local threatCounterRotation = scheme.counterRotation or defaults.mainSchemeThreatCounter.rotation
    local threatCounterScale = scheme.counterScale or defaults.mainSchemeThreatCounter.scale

    local threatBase
    local threatMultiplier
    local initialThreat

    if(stageNumber ~= nil) then
        threatBase = scheme.stages[stageNumber].threatBase
        threatMultiplier = scheme.stages[stageNumber].threatMultiplier
    else
        threatBase = scheme.threatBase
        threatMultiplier = scheme.threatMultiplier
    end

    initialThreat = threatBase + (threatMultiplier * heroCount)

    local threatCounterBag = getObjectFromGUID("eb5d6d")
    local threatCounter = threatCounterBag.takeObject({position=threatCounterPosition, smooth=false})

    Wait.frames(
        function()
            threatCounter.setRotation(threatCounterRotation)
            threatCounter.setScale(threatCounterScale)
            threatCounter.setLock(true)
            threatCounter.call("setValue", {value=initialThreat})
        end,
        1
    )

    counters[threatCounter.getGUID()] = {
        base=threatBase,
        multiplier=threatMultiplier
    }
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

function placeBlackHole(scenarioDetails)
    local blackHolePosition = scenarioDetails.blackHole and scenarioDetails.blackHole.position or defaults.blackHole.position
    local blackHoleRotation = scenarioDetails.blackHole and scenarioDetails.blackHole.rotation or defaults.blackHole.rotation
    local blackHoleScale = scenarioDetails.blackHole and scenarioDetails.blackHole.scale or defaults.blackHole.scale

    local blackHoleBag = getObjectFromGUID("e334c1")
    local blackHole = blackHoleBag.takeObject({position=blackHolePosition, rotation=blackHoleRotation, scale=blackHoleScale, smooth=false})
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
