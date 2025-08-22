local allScenarios = {}
local allEncounterSets = {}
local selectedScenario = {}
local encounterSetButtonIds = {}

function onload(saved_data)
    self.interactable = false
    -- local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    -- local encounterSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))

    -- allScenarios = scenarioManager.call("getScenarios", {})
    -- allEncounterSets = encounterSetManager.call("getEncounterSets", {})

    -- createButton()
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
    local orderedList = Global.call("getSortedListOfItems", {
        items = allScenarios
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
    local orderedList = Global.call("getSortedListOfItems", {
        items = allEncounterSets
    })
    
    encounterSetButtonIds = {}
    local encounterSetButtons = {}

    for i, encounterSet in ipairs(orderedList) do
        local functionName = "selectEncounterSet-" .. encounterSet.key
        local buttonId = "encounterSetToggle-" .. encounterSet.key
        local label = encounterSet.label or encounterSet.name
        local fontSize = 15

        table.insert(encounterSetButtonIds, buttonId)

        _G[functionName] = function(player, value, id)
            selectEncounterSet(encounterSet.key, value)
            -- scenarioUsesStandardEncounterSets = scenarioManager.call("useStandardEncounterSets")
            -- scenarioUsesModularEncounterSets = scenarioManager.call("useModularEncounterSets")
        
            -- updateSetupButtons()
            -- highlightSelectedScenario()
            -- colorCodeModularSets()
        end

        local encounterSetButton = {
            tag = "Panel",
            children = {{
                tag = "Toggle",
                value = label,
                attributes = {
                    id = buttonId,
                    onValueChanged = guid .. "/" .. functionName,
                    height = "50",
                    width = "240",
                    fontSize = tostring(fontSize),
                    textColor = "rgba(1,1,1,1)",
                    colors = "rgba(1,1,1,1)|rgba(1,1,1,1)|rgba(1,1,1,1)|rgba(1,1,1,1)"
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

    local encounterSetButtonWidth = 327
    local encounterSetButtonHeight = 50
    local encounterSetButtonSpacing = 0
    local encounterSetButtonRowCount = math.ceil(#encounterSetButtons / 3)
    local encounterSetSelectPanelHeight = encounterSetButtonRowCount * (encounterSetButtonHeight + encounterSetButtonSpacing) -
                                    encounterSetButtonSpacing

    local scenarioUI = {{
        tag = "Defaults",
        children = {
            {
                tag = "ToggleButton",
                attributes = {
                    class = "mode",
                    fontSize = "20",
                    textColor = "rgba(1,1,1,1)",
                    colors = "rgba(0,0,1,1)|rgba(0,0,1,1)|rgba(0,0,1,1)|rgba(0,0,1,1)",
                    selectedBackgroundColor = "rgba(0,0,1,1)",
                    deselectedBackgroundColor = "rgba(0,0,0,1)",
                    minimumHeight = "40",
                    preferredHeight = "40",
                    minimumWidth = "150",
                    preferredWidth = "150",
                    contentSizeFitter = "both"
                }
            },
            {
                tag = "Panel",
                attributes = {
                    class = "sectionHeading",
                    preferredHeight = "30",
                    flexibleHeight = "0",
                    contentSizeFitter = "vertical"
                }
            },
            {
                tag = "Text",
                attributes = {
                    class = "sectionHeading",
                    rectAlignment = "UpperLeft",
                    alignment = "UpperLeft",
                    fontSize = "30",
                    color = "rgba(1,1,1,1)",
                    contentSizeFitter = "vertical"
                }
            },
            {
                tag = "Dropdown",
                attributes = {
                    class = "standardEncounterSet",
                    fontSize = "20",
                    minimumHeight = "40",
                    preferredHeight = "40",
                    minimumWidth = "150",
                    preferredWidth = "150",
                    --contentSizeFitter = "both"
                }
            }
        }},
        {
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
                    textColor = "rgba(1,0,0,1)",
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
                id = "setupDetailsPlaceholderPanel",
                height = "925",
                width = "500",
                rectAlignment = "LowerLeft",
                active = "true"
            },
            children = {
                {
                    tag = "Text",
                    value = "Select a Scenario",
                    attributes = {
                        alignment = "UpperCenter",
                        offsetXY = "0 -200",
                        fontSize = "40",
                        color = "rgba(1,1,1,1)"
                    }
                }
            }
        },
        {
            tag = "Panel",
            attributes = {
                id = "setupDetailsPanel",
                height = "925",
                width = "500",
                padding = "10 10 10 10",
                rectAlignment = "LowerLeft",
                active = "false"
            },
            children = {
                {
                    tag="VerticalLayout",
                    attributes = {
                        rectAlignment = "UpperCenter",
                        childAlignment = "UpperCenter",
                        width = "500",
                        height = "925",
                        childForceExpandHeight = "false",
                        spacing = "10",
                        contentSizeFitter = "vertical"
                    },
                    children = {
                        {
                            tag = "Panel",
                            attributes = {
                                preferredHeight = "240",
                                flexibleHeight = "0"
                            },
                            children = {
                                {
                                    tag = "Image",
                                    attributes = {
                                        id = "selectedScenarioImage",
                                        height = "240",
                                        width = "480"
                                    }
                                },
                                {
                                    tag = "Text",
                                    attributes = {
                                        id="selectedScenarioLabel",
                                        height = "130",
                                        width = "220",
                                        alignment = "MiddleCenter",
                                        resizeTextForBestFit = "true",
                                        color = "rgba(0,0,0,1)",
                                        offsetXY = "103 22"
                                    }
                                }
                            }
                        },
                        {
                            tag="Panel",
                            attributes = {
                                class = "sectionHeading"
                            },
                            children = {
                                {
                                    tag="Text",
                                    value = "Encounter Sets:",
                                    attributes = {
                                        class = "sectionHeading"
                                    }
                                }
                            }
                        },
                        {
                            tag = "Panel",
                            attributes = {
                                minimumHeight = "30",
                                flexibleHeight = "0",
                                padding = "20 0 0 0",
                                contentSizeFitter = "vertical"
                            },
                            children = {
                                {
                                    tag = "Text",
                                    attributes = {
                                        id = "selectedEncounterSets",
                                        rectAlignment = "UpperLeft",
                                        alignment = "UpperLeft",
                                        fontSize = "20",
                                        color = "rgba(1,1,1,1)",
                                        contentSizeFitter = "vertical"
                                    }
                                }
                            }
                        },
                        {
                            tag="Panel",
                            attributes = {
                                class = "sectionHeading"
                            },
                            children = {
                                {
                                    tag="Text",
                                    value = "Mode:",
                                    attributes = {
                                        class = "sectionHeading"
                                    }
                                }
                            }
                        },
                        {
                            tag = "ToggleGroup",
                            attributes = {
                                minimumHeight = "40",
                                preferredHeight = "40",
                                contentSizeFitter = "vertical"
                            },
                            children = {
                                {
                                    tag = "HorizontalLayout",
                                    attributes = {
                                        height = "40",
                                        contentSizeFitter = "vertical",
                                        spacing = "5",
                                        childAlignment = "UpperCenter",
                                        childForceExpandHeight = "false",
                                        childForceExpandWidth = "false"
                                    },
                                    children = {
                                        {
                                            tag = "ToggleButton",
                                            value = "Standard",
                                            attributes = {
                                                class = "mode"
                                            }
                                        },
                                        {
                                            tag = "ToggleButton",
                                            value = "Expert",
                                            attributes = {
                                                class = "mode"
                                            }
                                        }
                                    }
                                }
                            }
                        },
                        {
                            tag="Panel",
                            attributes = {
                                class = "sectionHeading"
                            },
                            children = {
                                {
                                    tag="Text",
                                    value = "Standard Encounter Sets:",
                                    attributes = {
                                        class = "sectionHeading"
                                    }
                                }
                            }
                        },
                        {
                            tag = "ToggleGroup",
                            attributes = {
                                minimumHeight = "40",
                                preferredHeight = "40",
                                contentSizeFitter = "vertical"
                            },
                            children = {
                                {
                                    tag = "Panel",
                                    attributes = {
                                        height = "40",
                                        --contentSizeFitter = "vertical",
                                        color = "rgba(0,1,0,1)",
                                        spacing = "5",
                                        childAlignment = "UpperCenter",
                                        childForceExpandHeight = "false",
                                        childForceExpandWidth = "false"
                                    },
                                    children = {
                                        {
                                            tag = "Dropdown",
                                            attributes = {
                                                mode = "standardEncounterSet"
                                            },
                                            children = {
                                                {
                                                    tag = "Option",
                                                    value = "Standard 1",
                                                    attributes = {
                                                        selected = "true"
                                                    }
                                                },
                                                {
                                                    tag = "Option",
                                                    value = "Standard 2"
                                                },
                                                {
                                                    tag = "Option",
                                                    value = "Standard 3"
                                                }
                                            }
                                        },
                                        -- {
                                        --     tag = "Dropdown",
                                        --     attributes = {
                                        --         mode = "standardEncounterSet"
                                        --     },
                                        --     children = {
                                        --         {
                                        --             tag = "Option",
                                        --             value = "Expert 1",
                                        --             attributes = {
                                        --                 selected = "true"
                                        --             }
                                        --         },
                                        --         {
                                        --             tag = "Option",
                                        --             value = "Expert 2"
                                        --         }
                                        --     }
                                        -- }
                                    }
                                }
                            }
                        },
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
        }, 
        {
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
                        height = tostring(encounterSetSelectPanelHeight),
                        spacing = encounterSetButtonSpacing .. " " .. encounterSetButtonSpacing,
                        cellSize = encounterSetButtonWidth .. " " .. encounterSetButtonHeight,
                        startAxis = "Vertical",
                        constraint = "FixedRowCount",
                        constraintCount = tostring(encounterSetButtonRowCount),
                        color = "rgba(0,0,0,1)"
                    },
                    children = encounterSetButtons
                }}
             }}
        }
    }
    }}

    Global.UI.setXmlTable(scenarioUI)
    local xml = Global.UI.getXml()
    log("xml: " .. xml)
end

function selectScenario(scenarioKey)
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local scenario = scenarioManager.call("getScenario", {scenarioKey = scenarioKey})

    selectedScenario = scenario
    preSelectEncounterSets()
    updateEncounterSetButtons()
    updateSelectedEncounterSetList()

    Global.UI.hide("setupDetailsPlaceholderPanel")
    Global.UI.show("setupDetailsPanel")
    Global.UI.setAttribute("selectedScenarioImage", "image", scenario.tileImageUrl)
    Global.UI.setAttribute("selectedScenarioLabel", "text", scenario.label or scenario.name)

    showEncounterSetsPanel()
end

function selectEncounterSet(encounterSetKey, isSelected)
    broadcastToAll("selectEncounterSet: " .. encounterSetKey .. ", isSelected: " .. tostring(isSelected))
    if(not selectedScenario.selectedEncounterSets) then
        selectedScenario.selectedEncounterSets = {}
    end
    local selectedSets = selectedScenario.selectedEncounterSets
    
    if(isSelected == "True") then
        local set = deepCopy(allEncounterSets[encounterSetKey])
        selectedSets[encounterSetKey] = set
    else
        selectedSets[encounterSetKey] = nil
    end

    updateSelectedEncounterSetList()
end

function preSelectEncounterSets()
    local selectedSets = {}
    local scenarioSets = selectedScenario.modularSets or {}

    for key,required in pairs(scenarioSets) do
        local set = deepCopy(allEncounterSets[key])
        set.required = required
        selectedSets[key] = set
    end

    selectedScenario.selectedEncounterSets = selectedSets
end

function updateEncounterSetButtons()
    local textColorDefault = "rgba(1,1,1,1)"
    local textColorRequired = "rgba(1,0,0,1)"
    local textColorRecommended = "rgb(1, 1, 0)"
    local scenarioSets = selectedScenario.modularSets or {}
    local selectedSets = selectedScenario.selectedEncounterSets or {}

    for _, buttonId in ipairs(encounterSetButtonIds) do
        local encounterKey = string.match(buttonId, "%-(.+)")
        local setInScenario = scenarioSets[encounterKey] or "no"
        local setIsSelected = selectedSets[encounterKey] ~= nil and "true" or "false"
        local textColor = textColorDefault

        if(setInScenario == "required") then
            textColor = textColorRequired
        elseif(setInScenario == "recommended") then
            textColor = textColorRecommended
        end

        Global.UI.setAttribute(buttonId, "textColor", textColor)
        Global.UI.setAttribute(buttonId, "isOn", setIsSelected)
    end
end

function updateSelectedEncounterSetList()
    local selectedSets = selectedScenario.selectedEncounterSets or {}
    local sortedList = Global.call("getSortedListOfItems", {
        items = selectedSets
    })
    local setList = ""

    for _, set in ipairs(sortedList) do
        local setName = set.label or set.name
        if(setList ~= "") then
            setList = setList .. "\n"
        end
        setList = setList .. setName
    end

    Global.UI.setAttribute("selectedEncounterSets", "text", setList)
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

function deepCopy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[deepCopy(k, s)] = deepCopy(v, s) end
    return res
end