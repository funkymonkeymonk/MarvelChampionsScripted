require('!/Cardplacer')

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

local scenarios = {}
local scenarioBagGuid = ""
local scenarioInfo = {}
local mode = ""
local counters = {}
local villains = {}

local advanceVillainFunction --(villainName, stageNumber)
local advanceSchemeFunction --(schemeName, stageNumber)

local originPosition = {x=88.25, y=0.50, z=33.75}

local rowGap = -2.5
local columnGap = 5

local rows = 12

function onload(saved_data)
    constructScenarioList()
    createContextMenu()
    layOutScenarios()
end

function placeUnscriptedScenario(params)
    placeScenario(params.scenarioKey, "")
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

            --placeBlackHole(scenarioDetails)
            --placeExtras(scenarioBag, scenarioDetails.extras)
        end, 
        1)
end

function confirmNoScenarioIsPlaced()
    return true --TODO: Implement this
end

function placeVillainHpCounter(villain, heroCount)
    local counterPosition = villain.hpCounter.position or defaults.villainHpCounter.position
    local counterRotation = villain.hpCounter.rotation or defaults.villainHpCounter.rotation
    local counterScale = villain.hpCounter.scale or defaults.villainHpCounter.scale

    local villainHpCounter

    if(villain.hpCounter.guid ~= nil) then
        -- local villainHpCounterOrig = scenarioBag.takeObject({guid=villain.hpCounter.guid, position=counterPosition})
        -- villainHpCounter = villainHpCounterOrig.clone({position=counterPosition})
        -- scenarioBag.putObject(villainHpCounterOrig)
    else
        local villainHpCounterBag = getObjectFromGUID("d8fbff")
        local counterTemp = villainHpCounterBag.takeObject({position=counterPosition})
        counterTemp.setCustomObject({image=villain.hpCounter.imageUrl})
        villainHpCounter = counterTemp.reload()
    end

    --local hitPoints = villain.hpMultiplier * heroCount

    Wait.frames(
        function()
            villainHpCounter.setPosition(counterPosition)
            villainHpCounter.setRotation(counterRotation)
            villainHpCounter.setScale(counterScale)
            villainHpCounter.setName("")
            villainHpCounter.setDescription("")
            villainHpCounter.setLock(true)
            --villainHpCounter.call("setValue", {value=hitPoints})
            --villainHpCounter.call("createAdvanceButton", {villainKey=villain.name}) --TODO: make this more dynamic, use villainKey instead of name
        end,
        10
    )

    counters[villainHpCounter.getGUID()] = {
        base=0,
        multiplier=villain.hpMultiplier
    }
end

function placeVillain(villain)
    local villainPosition = villain.deckPosition or defaults.villainDeck.position
    local villainRotation = villain.deckRotation or defaults.villainDeck.rotation
    local villainScale = villain.deckScale or defaults.villainDeck.scale

    --TODO: only place the cards that are needed, based on mode
    if(villain.stage3 ~= nil) then
        getCardByID(villain.stage3.cardId, villainPosition, {scale=villainScale, name=villain.name, flipped=false})
    end

    if(villain.stage2 ~= nil) then
        getCardByID(villain.stage2.cardId, villainPosition, {scale=villainScale, name=villain.name, flipped=false})
    end
    
    if(villain.stage1 ~= nil) then
        getCardByID(villain.stage1.cardId, villainPosition, {scale=villainScale, name=villain.name, flipped=false})
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

    --Skipping the placement of the cards, pending a fix for the scheme image issue
    -- --There may be a better way to iterate over the stages backward
    -- for i = 5, 1, -1 do
    --     if(scheme.stages["stage"..i] ~= nil) then
    --         getCardByID(scheme.stages["stage"..i].cardId, schemePosition, {scale=schemeScale, name=scheme.name, flipped=true})
    --     end
    -- end

    local counter = scheme.counter or {}

    placeThreatCounter(counter, nil, getHeroCount())
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

    Wait.frames(
        function()
            threatCounter.setRotation(threatCounterRotation)
            threatCounter.setScale(threatCounterScale)
            threatCounter.setLock(true)
            --threatCounter.call("setValue", {value=initialThreat})
        end,
        1
    )

    -- counters[threatCounter.getGUID()] = {
    --     base=threatBase,
    --     multiplier=threatMultiplier
    -- }
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
    local scenarioList = getSortedListOfScenarios()
    local tileBag = getObjectFromGUID("01ad59")

    for k, v in ipairs(scenarioList) do
        local tilePosition = v.tilePosition
        local tile = tileBag.takeObject({position=tilePosition, smooth=false})

        setupTile({
            scenarioKey=v.scenarioKey,
            tile=tile,
            tilePosition=tilePosition
        })
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

function setupTile(params)

    Wait.frames(
        function()
            local scenarioDetails = scenarios[params.scenarioKey]
            local imageUrl = scenarioDetails["selectorImageUrl"]

            local tile = params.tile
            local tilePosition = params.tilePosition

            tile.setName(scenarioDetails.name)
            --tile.setDescription(scenarioBag.getDescription())
            tile.setScale({1.13, 1, 1.13})
            tile.setRotation({0,180,0})
            tile.setLock(true)
            tile.setPosition(tilePosition)
            tile.addTag("Scenario-selector-tile")
            tile.setCustomObject({image=imageUrl})
            reloadedTile = tile.reload()

            setTileFunctions(reloadedTile, params.scenarioKey)
            createTileButtons(reloadedTile)
        end,
        30)
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
        position={1.17,0.2,-0.18}, rotation={0,0,0}, height=540, width=530, 
        font_size=600, color={1,1,1}, font_color={0,0,0}, tooltip="Set Up Scenario"
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

function constructScenarioList()
    scenarios["rhino"] =
        {
            name="Rhino",
            selectorImageUrl="http://cloud-3.steamusercontent.com/ugc/1849305905150139401/E2896A47115742CDF42EE2F473039970D5D27329/",
            villains={
                rhino={
                    name="Rhino",
                    hpCounter={
                        imageUrl="http://cloud-3.steamusercontent.com/ugc/1849305905150139401/E2896A47115742CDF42EE2F473039970D5D27329/",
                    },
                    stage1={
                        cardId="01094",
                        hpMultiplier=14
                    },
                    stage2={
                        cardId="01095",
                        hpMultiplier=15
                    },
                    stage3={
                        cardId="01096",
                        hpMultiplier=16
                    }
                }
            },
            schemes={
                main={
                    stages={
                        stage1={
                            cardId="01097",
                            threatBase=0,
                            threatMultiplier=7
                        }
                    }
                }
            },
            decks={
                encounterDeck={
                    name="Rhino's Encounter Deck",
                    cards={
                        ["01098"]=1,
                        ["01099"]=2,
                        ["01100"]=1,
                        ["01101"]=2,
                        ["01102"]=1,
                        ["01103"]=1,
                        ["01104"]=2,
                        ["01105"]=2,
                        ["01106"]=3,
                        ["01107"]=1,
                        ["01108"]=1
                    }
                }
            }
        }

        scenarios["klaw"] =
        {
            name="Klaw",
            selectorImageUrl="http://cloud-3.steamusercontent.com/ugc/1849305905150131516/7DC18F8C2BEC0AFE2B74AA31695A21E7B34621F1/",
            villains={
                klaw={
                    name="Klaw",
                    hpCounter={
                        imageUrl="http://cloud-3.steamusercontent.com/ugc/1849305905150131516/7DC18F8C2BEC0AFE2B74AA31695A21E7B34621F1/",
                    },
                    stage1={
                        cardId="01113",
                        hpMultiplier=12
                    },
                    stage2={
                        cardId="01114",
                        hpMultiplier=18
                    },
                    stage3={
                        cardId="01115",
                        hpMultiplier=22
                    }
                }
            },
            schemes={
                main={
                    stages={
                        stage1={
                            cardId="01116",
                            threatBase=0,
                            threatMultiplier=6
                        },
                        stage2={
                            cardId="01117",
                            threatBase=0,
                            threatMultiplier=8
                        }
                    }
                }
            },
            decks={
                encounterDeck={
                    name="Klaw's Encounter Deck",
                    cards={
                        ["01118"]=1,
                        ["01119"]=1,
                        ["01120"]=3,
                        ["01121"]=2,
                        ["01122"]=2,
                        ["01123"]=2,
                        ["01124"]=2,
                        ["01125"]=1,
                        ["01126"]=1,
                        ["01127"]=1
                    }
                }
            }
        }

        scenarios["ultron"] =
        {
            name="Ultron",
            selectorImageUrl="http://cloud-3.steamusercontent.com/ugc/1849305905150147610/D43024CA72F4372B28AF86672D67286730C6CE72/",
            villains={
                ultron={
                    name="Ultron",
                    hpCounter={
                        imageUrl="http://cloud-3.steamusercontent.com/ugc/1849305905150147610/D43024CA72F4372B28AF86672D67286730C6CE72/",
                    },
                    stage1={
                        cardId="01134",
                        hpMultiplier=17
                    },
                    stage2={
                        cardId="01135",
                        hpMultiplier=22
                    },
                    stage3={
                        cardId="01136",
                        hpMultiplier=27
                    }
                }
            },
            schemes={
                main={
                    stages={
                        stage1={
                            cardId="01137",
                            threatBase=0,
                            threatMultiplier=3
                        },
                        stage2={
                            cardId="01138",
                            threatBase=0,
                            threatMultiplier=10
                        },
                        stage3={
                            cardId="01139",
                            threatBase=0,
                            threatMultiplier=5
                        }
                    }
                }
            },
            decks={
                encounterDeck={
                    name="Ultron's Encounter Deck",
                    cards={
                        ["01140"]=1,
                        ["01141"]=1,
                        ["01142"]=2,
                        ["01143"]=3,
                        ["01144"]=3,
                        ["01145"]=2,
                        ["01146"]=3,
                        ["01147"]=4,
                        ["01148"]=1,
                        ["01149"]=1,
                        ["01150"]=1
                    }
                }
            }
        }

        scenarios["wreckingCrew"] =
        {
            name="The Wrecking Crew",
            selectorImageUrl="http://cloud-3.steamusercontent.com/ugc/1849305905150148690/BBFD396544E7663BE7F363242AA077FAE4D5FA53/",
            villains={
                wrecker={
                    name="Wrecker",
                    hpCounter={
                        imageUrl="http://cloud-3.steamusercontent.com/ugc/1849305905150148690/BBFD396544E7663BE7F363242AA077FAE4D5FA53/",
                        position={-32.25, 0.96, 29.25},
                        scale={2.88, 1.00, 2.88}
                    },
                    stage1={
                        cardId="07002",
                        hpMultiplier=14
                    },
                    stage3={
                        cardId="07003",
                        hpMultiplier=18
                    },
                    deckPosition={-34.25, 0.97, 20.25},
                    deckScale={3.64, 1.00, 3.64}
                },
                thunderball={
                    name="ThunderBall",
                    hpCounter={
                        imageUrl="http://cloud-3.steamusercontent.com/ugc/1849305905150146633/81635C26BBCDF2281C945515041D9BF8B3E46CD9/",
                        position={-10.25, 0.96, 29.25},
                        scale={2.88, 1.00, 2.88}
                    },
                    stage1={
                        cardId="07017",
                        hpMultiplier=13
                    },
                    stage3={
                        cardId="07018",
                        hpMultiplier=16
                    },
                    deckPosition={-12.25, 0.97, 20.25},
                    deckScale={3.64, 1.00, 3.64}
                },
                piledriver={
                    name="Piledriver",
                    hpCounter={
                        imageUrl="http://cloud-3.steamusercontent.com/ugc/1849305905150134663/393C22936C553E34C89EE38AD8582B33B005558B/",
                        position={11.75, 0.96, 29.25},
                        scale={2.88, 1.00, 2.88}
                    },
                    stage1={
                        cardId="07032",
                        hpMultiplier=11
                    },
                    stage3={
                        cardId="07033",
                        hpMultiplier=14
                    },
                    deckPosition={9.75, 0.97, 20.25},
                    deckScale={3.64, 1.00, 3.64}
                },
                bulldozer={
                    name="Bulldozer",
                    hpCounter={
                        imageUrl="http://cloud-3.steamusercontent.com/ugc/1849305905150122545/0C0159E3C74BD9B5BA30D62D9DCB9B5BDF6859FD/",
                        position={33.75, 0.96, 29.25},
                        scale={2.88, 1.00, 2.88}
                    },
                    stage1={
                        cardId="07046",
                        hpMultiplier=12
                    },
                    stage3={
                        cardId="07047",
                        hpMultiplier=15
                    },
                    deckPosition={31.75, 0.97, 20.25},
                    deckScale={3.64, 1.00, 3.64}
                }
            },
            schemes={
                main={
                    stages={
                        stage1={
                            cardId="07001",
                            threatBase=0,
                            threatMultiplier=6
                        }
                    },
                    position={49.25, 0.97, 23.25},
                    scale={2.93, 1.00, 2.93},
                    counter={
                        position={48.75, 1.01, 29.25},
                        scale={1.61, 1.00, 1.61}
                    }
                },
                wreckerScheme={
                    stages={
                        stage1={
                            cardId="07004",
                            threatBase=6,
                            threatMultiplier=0
                        }
                    },
                    position={-26.27, 0.97, 22.79},
                    scale={2.42, 1.00, 2.42},
                    counter={
                        position={-26.82, 1.04, 20.95},
                        scale={0.48, 1.00, 0.48}
                    }
                },
                thunderballScheme={
                    stages={
                        stage1={
                            cardId="07019",
                            threatBase=5,
                            threatMultiplier=0
                        }
                    },
                    position={-4.25, 0.97, 22.78},
                    scale={2.42, 1.00, 2.42},
                    counter={
                        position={-4.79, 1.04, 20.94},
                        scale={0.48, 1.00, 0.48}
                    }
                },
                piledriverScheme={
                    stages={
                        stage1={
                            cardId="07034",
                            threatBase=3,
                            threatMultiplier=0
                        }
                    },
                    position={17.75, 0.97, 22.79},
                    scale={2.42, 1.00, 2.42},
                    counter={
                        position={17.15, 1.04, 20.97},
                        scale={0.48, 1.00, 0.48}
                    }
                },
                bulldozerScheme={
                    stages={
                        stage1={
                            cardId="07048",
                            threatBase=4,
                            threatMultiplier=0
                        }
                    },
                    position={39.75, 0.97, 22.73},
                    scale={2.42, 1.00, 2.42},
                    counter={
                        position={39.20, 1.04, 20.90},
                        scale={0.48, 1.00, 0.48}
                    }
                }
            },
            decks={
                wreckerDeck={
                    name="Wrecker's Encounter Deck",
                    cards={
                        ["07005"]=1,
                        ["07006"]=1,
                        ["07007"]=1,
                        ["07008"]=1,
                        ["07009"]=1,
                        ["07010"]=1,
                        ["07011"]=1,
                        ["07012"]=2,
                        ["07013"]=1,
                        ["07014"]=1,
                        ["07015"]=2,
                        ["07016"]=2
                    },
                    position={-40.75, 1.05, 22.25},
                    scale={2.12, 1.00, 2.12}
                },
                thunderballDeck={
                    name="Thunderball's Encounter Deck",
                    cards={
                        ["07020"]=1,
                        ["07021"]=1,
                        ["07022"]=1,
                        ["07023"]=1,
                        ["07024"]=1,
                        ["07025"]=1,
                        ["07026"]=1,
                        ["07027"]=1,
                        ["07028"]=1,
                        ["07029"]=1,
                        ["07030"]=2,
                        ["07031"]=2
                    },
                    position={-18.75, 1.05, 22.25},
                    scale={2.12, 1.00, 2.12}
                },
                piledriverDeck={
                    name="Piledriver's Encounter Deck",
                    cards={
                        ["07035"]=2,
                        ["07036"]=1,
                        ["07037"]=1,
                        ["07038"]=1,
                        ["07039"]=1,
                        ["07040"]=1,
                        ["07041"]=1,
                        ["07042"]=2,
                        ["07043"]=2,
                        ["07044"]=2,
                        ["07045"]=1
                    },
                    position={3.25, 1.05, 22.25},
                    scale={2.12, 1.00, 2.12}
                },
                bulldozerDeck={
                    name="Bulldozer's Encounter Deck",
                    cards={
                        ["07049"]=1,
                        ["07050"]=1,
                        ["07051"]=2,
                        ["07052"]=1,
                        ["07053"]=1,
                        ["07054"]=1,
                        ["07055"]=2,
                        ["07056"]=1,
                        ["07057"]=1,
                        ["07058"]=2,
                        ["07059"]=2
                    },
                    position={25.25, 1.05, 22.25},
                    scale={2.12, 1.00, 2.12}
                }
            }
        }

end
