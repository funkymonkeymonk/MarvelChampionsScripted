local setupInfo = {}

function onload(saved_data)
    -- self.interactable = false

    createButton()
end

function createButton()
    self.createButton({
        label = "SCENARIO",
        click_function = "displayScenarioUI",
        function_owner = self,
        position = {0, 0.1, 0},
        rotation = {0, 0, 0},
        width = 2470,
        height = 970,
        font_size = 400,
        color = {0, 0, 0, 0},
        font_color = {1, 1, 1, 100}
    })
end

function getScenarioButtons(guid)
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local scenarios = scenarioManager.call("getScenarios", {team=nil})
    
    local orderedList = Global.call("getSortedListOfItems", {
        items = scenarios
    })
    
    local scenarioButtons = {}

    for i, scenario in ipairs(orderedList) do
        local functionName = "selectScenario-" .. scenario.key
        local label = scenario.label and scenario.label or scenario.name
        local maxWidth = 6
        local labelInfo = Global.call("breakLabel", {
            label = label,
            maxWidth = maxWidth
        })
        local fontSize = 35

        if labelInfo.length > maxWidth then
            fontSize = fontSize - ((labelInfo.length - maxWidth) * 2 )
        end

        _G[functionName] = function()
            selectScenario(scenario.key)
            -- scenarioUsesStandardEncounterSets = scenarioManager.call("useStandardEncounterSets")
            -- scenarioUsesModularEncounterSets = scenarioManager.call("useModularEncounterSets")
        
            -- updateSetupButtons()
            -- highlightSelectedScenario()
            -- colorCodeModularSets()
        end

        local scenarioButton = {
            tag = "Panel",
            children = {{
                tag = "Image",
                attributes = {
                    image = scenario.tileImageUrl,
                    raycastTarget = "true"
                }
            }, {
                tag = "Button",
                value = labelInfo.text,
                attributes = {
                    onClick = guid .. "/" .. functionName,
                    height = "140",
                    width = "240",
                    fontSize = tostring(fontSize),
                    textColor = "rgba(0,0,0,1)",
                    color = "rgba(0,0,0,0)",
                    offsetXY = "65 15"
                }
            }}
        }
        table.insert(scenarioButtons, scenarioButton)
    end    

    return scenarioButtons
end

function getEncounterSetButtons(guid)
    local encounterSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))
    local encounterSets = encounterSetManager.call("getEncounterSets")
    
    local orderedList = Global.call("getSortedListOfItems", {
        items = encounterSets
    })
    
    local encounterSetButtons = {}

    for i, encounterSet in ipairs(orderedList) do
        local functionName = "selectEncounterSet-" .. encounterSet.key
        local label = encounterSet.label and encounterSet.label or encounterSet.name
        local maxWidth = 6
        local labelInfo = Global.call("breakLabel", {
            label = label,
            maxWidth = maxWidth
        })
        local fontSize = 25

        if labelInfo.length > maxWidth then
            fontSize = fontSize - ((labelInfo.length - maxWidth) * 2 )
        end

        _G[functionName] = function()
            selectEncounterSet(encounterSet.key)
            -- scenarioUsesStandardEncounterSets = scenarioManager.call("useStandardEncounterSets")
            -- scenarioUsesModularEncounterSets = scenarioManager.call("useModularEncounterSets")
        
            -- updateSetupButtons()
            -- highlightSelectedScenario()
            -- colorCodeModularSets()
        end

        local encounterSetButton = {
            tag = "Panel",
            children = {{
                tag = "Button",
                value = labelInfo.text,
                attributes = {
                    onClick = guid .. "/" .. functionName,
                    height = "85",
                    width = "240",
                    fontSize = tostring(fontSize),
                    textColor = "rgba(0,0,0,1)",
                    color = "rgba(0,0,0,0)"
                }
            }}
        }
        table.insert(encounterSetButtons, encounterSetButton)
    end    

    return encounterSetButtons
end

function displayScenarioUI()
    local guid = self.getGUID()

    local scenarioButtons = getScenarioButtons(guid)
    local encounterSetButtons = getEncounterSetButtons(guid)

    local scenarioButtonWidth = 320
    local scenarioButtonHeight = 160
    local scenarioButtonSpacing = 10
    local scenarioSelectPanelHeight = math.ceil(#scenarioButtons / 3) * (scenarioButtonHeight + scenarioButtonSpacing) -
                                      scenarioButtonSpacing

    local encounterSetButtonWidth = 320
    local encounterSetButtonHeight = 85
    local encounterSetButtonSpacing = 10
    local encounterSetSelectPanelHeight = math.ceil(#encounterSetButtons / 3) * (encounterSetButtonHeight + encounterSetButtonSpacing) -
                                    encounterSetButtonSpacing

    local scenarioUI = {{
        tag = "Panel",
        attributes = {
            height = "1000",
            width = "1500",
            color = "rgba(0,0,0,1)"
        },
        children = {{
            tag = "Panel",
            attributes = {
                id = "scenarioHeaderPanel",
                height = "75",
                rectAlignment = "UpperCenter"
            },
            children = {{
                tag = "Text",
                value = "SCENARIO SETUP",
                attributes = {
                    alignment = "MiddleLeft",
                    fontSize = "50",
                    color = "rgba(255,255,255,1)",
                    offsetXY = "10 0"
                }
            }, {
                tag = "Button",
                value = "X",
                attributes = {
                    rectAlignment = "UpperRight",
                    onClick = guid .. "/" .. "cancel",
                    textColor = "rgba(255,0,0,1)",
                    color = "rgba(0,0,0,0)",
                    fontSize = "50",
                    height = "60",
                    width = "60",
                    offsetXY = "-10 -10"
                }
            }}
        }, {
            tag = "Panel",
            attributes = {
                id = "setupDetailsPanel",
                height = "925",
                width = "500",
                rectAlignment = "UpperLeft",
                offsetXY = "0 -75"
            },
            children = {
                {
                    tag = "Panel",
                    attributes = {
                        id = "scenarioSelectionPanel",
                        rectAlignment = "UpperCenter",
                        height = "250"
                    },
                    children = {
                        {
                            tag = "Text",
                            value = "Select a Scenario",
                            attributes = {
                                id = "selectScenarioLabel",
                                alignment = "MiddleCenter",
                                fontSize = "40",
                                color = "rgba(255,255,255,1)"
                            }
                        },
                        {
                            tag = "Panel",
                            attributes = {
                                id = "selectedScenarioPanel",
                                rectAlignment = "MiddleCenter",
                                active = "false"
                            },
                            children = {
                                {
                                    tag = "Image",
                                    attributes = {
                                        id = "selectedScenarioImage",
                                        height = "240",
                                        width = "480"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }, {
            tag = "Panel",
            attributes = {
                id = "selectScenarioPanel",
                rectAlignment = "UpperRight",
                offsetXY = "0 -75",
                active = "true"
            },
            children = {{
                tag = "VerticalScrollView",
                attributes = {
                    height = "925",
                    width = "1000",
                    rectAlignment = "UpperRight",
                    verticalScrollbarVisibility = "AutoHideAndExpandView",
                    horizontalScrollbarVisibility = "AutoHideAndExpandViewport",
                    scrollSensitivity = "75",
                    raycastTarget = "true"
                },
                children = {{
                    tag = "GridLayout",
                    attributes = {
                        width = "975",
                        height = tostring(scenarioSelectPanelHeight),
                        spacing = scenarioButtonSpacing .. " " .. scenarioButtonSpacing,
                        cellSize = scenarioButtonWidth .. " " .. scenarioButtonHeight,
                        constraint = "FixedColumnCount",
                        constraintCount = "3"
                    },
                    children = scenarioButtons
                }}
            }}
        }, {
            tag = "Panel",
            attributes = {
                id = "selectEncounterSetsPanel", 
                rectAlignment = "UpperRight",
                offsetXY = "0 -75",
                active = "false"
            },
            children = {{
                tag = "VerticalScrollView",
                attributes = {
                    height = "925",
                    width = "1000",
                    rectAlignment = "UpperRight",
                    verticalScrollbarVisibility = "AutoHideAndExpandView",
                    horizontalScrollbarVisibility = "AutoHideAndExpandViewport",
                    scrollSensitivity = "75",
                    raycastTarget = "true"
                },
                children = {{
                    tag = "GridLayout",
                    attributes = {
                        width = "975",
                        height = tostring(encounterSetPanelHeight),
                        spacing = encounterSetButtonSpacing .. " " .. encounterSetButtonSpacing,
                        cellSize = encounterSetButtonWidth .. " " .. encounterSetButtonHeight,
                        constraint = "FixedColumnCount",
                        constraintCount = "3"
                    },
                    --children = encounterSetButtons
                }}
            }}
        }}
    }}

    Global.UI.setXmlTable(scenarioUI)
end

function selectScenario(scenarioKey)
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local scenario = scenarioManager.call("getScenario", {scenarioKey = scenarioKey})

    setupInfo.scenario = scenario

    Global.UI.hide("selectScenarioLabel")
    Global.UI.show("selectedScenarioPanel")
    Global.UI.setAttribute("selectedScenarioImage", "image", scenario.tileImageUrl)

    showEncounterSetsPanel()
end

function showScenarioPanel()
    Global.UI.hide("selectEncounterSetsPanel")
    Global.UI.show("selectScenarioPanel")
end

function showEncounterSetsPanel()
    Global.UI.hide("selectScenarioPanel")
    Global.UI.show("selectEncounterSetsPanel")
end

function showImportDeckPanel()
    Global.UI.hide("selectHeroPanel")
    Global.UI.hide("randomHeroPanel")
    Global.UI.show("importPanel")

    Global.UI.setAttribute("importDeckButton", "fontStyle", "Bold")
    Global.UI.setAttribute("selectHeroButton", "fontStyle", "")
end

function showSelectHeroPanel()
    Global.UI.hide("importPanel")
    Global.UI.hide("randomHeroPanel")
    Global.UI.show("selectHeroPanel")

    Global.UI.setAttribute("importDeckButton", "fontStyle", "")
    Global.UI.setAttribute("selectHeroButton", "fontStyle", "Bold")
end

function placeRandomHero()
    hideHeroUI(false)
    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
    heroManager.call("placeRandomHero", {
        positionColor = positionColor
    })
end

function importDeck()
    local isPrivateDeck = Global.UI.getAttribute("isPrivateDeckToggle", "isOn") == "true"

    if (not importDeckId or importDeckId == "") then
        broadcastToColor("Please enter a valid deck ID", positionColor, tint)
        return
    end

    hideHeroUI(false)

    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))

    local params = {
        deckId = importDeckId,
        isPrivateDeck = isPrivateDeck,
        callbackFunction = "placeHero",
        callbackTarget = self
    }

    Global.call("importDeck", params)
end

function setDeckId(player, value, id)
    importDeckId = value
end

function placeHero(params)
    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
    heroManager.call("placeHeroWithImportedDeck", {
        deckInfo = params.deckInfo,
        positionColor = positionColor
    })
end

function cancel()
    hideHeroUI(true)
end

function hideHeroUI(showSuitUpButton)
    Global.UI.setXml("")
end
