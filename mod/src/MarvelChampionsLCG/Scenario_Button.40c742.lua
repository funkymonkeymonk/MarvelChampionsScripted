require('!/lib/json')
local allScenarios = {}
local allEncounterSets = {}
local selectedScenario = {}

local scenarioButtonWidth = 362
local scenarioButtonHeight = 181
local scenarioColumns = 4
local scenarioButtonSpacing = 10

local encounterSetButtonWidth = 245
local encounterSetButtonHeight = 30
local encounterSetColumns = 4
local encounterSetButtonSpacing = 0

function showTile() --TODO: delete
    showUI()
end

function hideTile() -- TODO: delete
    self.UI.setXml("")
end

function onload(saved_data)
    self.interactable = false
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local encounterSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))

    allScenarios = scenarioManager.call("getScenarios", {})
    allEncounterSets = encounterSetManager.call("getEncounterSets", {})

    showUI()
end

function showUI()
    local buttonImageUrl = Global.getVar("CDN_URL") .. "/assets/scenario-setup-button.png"
    
	local ui = 
    {
        {
            tag="Panel",
            attributes= {
                height = "100",
                width = "300",
                position = "0 0 -195",
				color = "rgba(0,0,0,0)",
                rotation = "0 0 180"
            },
            children = {
                {
                    tag = "Image",
                    attributes = {
                        image = buttonImageUrl,
                        raycastTarget = "true",
                        position = "-390 17 0",
                        height = "2654",
                        width = "3030"
                    }
                },
                {
                    tag = "Button",
                    attributes = {
                        rectAlignment = "MiddleCenter",
                        onClick = "displayScenarioSelectionUI",
                        color = "rgba(0,0,0,0)",
                        height = "550",
                        width = "1400",
                        fontSize = "120",
                        fontStyle = "Bold"
                    }
                }
            }
        }
    }

    self.UI.setXmlTable(ui) 
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
                    height = tostring(scenarioButtonHeight * 0.875),
                    width = tostring(scenarioButtonWidth * 0.75),
                    fontSize = tostring(fontSize),
                    textColor = "rgba(0,0,0,1)",
                    color = "rgba(0,0,0,0)",
                    offsetXY = tostring(scenarioButtonWidth * 0.2) .. " " .. tostring(scenarioButtonHeight * 0.09)
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

    local textColorDefault = "rgba(1,1,1,1)"
    local textColorRequired = "rgba(1,0,0,1)"
    local textColorRecommended = "rgba(1,1,0,1)"
    
    local scenarioSets = selectedScenario.modularSets or {}
    local selectedSets = selectedScenario.selectedEncounterSets or {}

    local encounterSetButtons = {}

    for i, encounterSet in ipairs(orderedList) do
        local encounterKey = encounterSet.key
        local setInScenario = scenarioSets[encounterKey] or "no"
        local setIsSelected = selectedSets[encounterKey] ~= nil and "true" or "false"
        local textColor = textColorDefault

        if(setInScenario == "required") then
            textColor = textColorRequired
        elseif(setInScenario == "recommended") then
            textColor = textColorRecommended
        end

        local functionName = "selectEncounterSet-" .. encounterKey
        local label = encounterSet.label or encounterSet.name
        local fontSize = 15

        local encounterSetButton = {
            tag = "Panel",
            attributes = {
                padding = "10 0 0 0"
            },
            children = {{
                tag = "Toggle",
                value = label,
                attributes = {
                    id = encounterKey,
                    onValueChanged = guid .. "/modularEncounterSetToggleChanged",
                    height = tostring(encounterSetButtonHeight),
                    width = tostring(encounterSetButtonWidth),
                    fontSize = tostring(fontSize),
                    textColor = textColor,
                    colors = "rgba(1,1,1,1)|rgba(1,1,1,1)|rgba(1,1,1,1)|rgba(1,1,1,1)",
                    isOn = setIsSelected
                }
            }}
        }
        table.insert(encounterSetButtons, encounterSetButton)
    end    

    return encounterSetButtons
end

function getFirstPlayerToggles(heroes)
    local red = Global.getTable("MESSAGE_TINT_RED")
    local blue = Global.getTable("MESSAGE_TINT_BLUE")
    local green = Global.getTable("MESSAGE_TINT_GREEN")
    local yellow = Global.getTable("MESSAGE_TINT_YELLOW")

    local toggleColors = {
        Red = red,
        Blue = blue,
        Green = green,
        Yellow = yellow
    }

    local toggles = {}

    local heroCount = 0

    for _, hero in pairs(heroes) do
        heroCount = heroCount + 1
    end

    local colors = {"Red", "Blue", "Green", "Yellow"}
    local functionName = self.getGUID() .. "/" .. "firstPlayerToggleClicked"

    for i, color in ipairs(colors) do
        local heroName = heroes[color]

        if heroName then
            local colorString = "rgba(" .. toggleColors[color][1] .. "," .. toggleColors[color][2] .. "," .. toggleColors[color][3] .. ",1)"

            table.insert(toggles, {
                tag = "Panel",
                attributes = {
                    id = "firstPlayerToggle" .. color,
                    preferredHeight = "30",
                    flexibleHeight = "0",
                    color = "rgba(0,0,0,1)",
                    outline = colorString,
                    outlineSize = "1 1",
                    onClick = functionName
                },
                children = {
                    {
                        tag="Text",
                        value = heroName,
                        attributes = {
                            id = "firstPlayerToggle" .. color .. "Label",
                            fontSize = "15",
                            color = colorString
                        }
                    }
                }
            })
        end
    end

    return toggles
end

function displayScenarioUI(headerText, panels)
    local uiPanels = {}
    table.insert(uiPanels, getScenarioUIHeader(headerText))
    
    for i, panel in ipairs(panels) do
        table.insert(uiPanels, panel)
    end

    local scenarioUI = {{
        tag = "Panel",
        attributes = {
            height = "1000",
            width = "1500",
            color = "rgba(0,0,0,1)"
        },
        children = uiPanels
    }}

    Global.UI.setXmlTable(scenarioUI)
end

function getScenarioUIHeader(headerText)
    return {
        tag = "Panel",
        attributes = {
            height = "75",
            rectAlignment = "UpperCenter"
        },
        children = {{
            tag = "Text",
            value = headerText,
            attributes = {
                alignment = "MiddleLeft",
                fontSize = "50",
                color = "rgba(1,1,1,1)",
                offsetXY = "10 0"
            }
        }, 
        {
            tag = "Image",
            attributes = {
                image = Global.getVar("CDN_URL") .. "/assets/ui-close-button.png",
                rectAlignment = "UpperRight",
                offsetXY = "-10 -10",
                height = "50",
                width = "50",
                onClick = self.getGUID() .. "/" .. "hideScenarioUI"
            }
        }}
    }
end

function getScenarioSelectionPanel(guid)
    local scenarioButtons = getScenarioButtons(guid)
    local scenarioSelectPanelHeight = 
        math.ceil(#scenarioButtons / scenarioColumns) * (scenarioButtonHeight + scenarioButtonSpacing) - scenarioButtonSpacing

    local selectScenarioPanel = {
            tag = "Panel",
            attributes = {
                rectAlignment = "UpperRight",
                offsetXY = "0 -75"
            },
            children = {{
                tag = "VerticalScrollView",
                attributes = {
                    height = "925",
                    width = "1500",
                    rectAlignment = "UpperRight",
                    verticalScrollbarVisibility = "AutoHideAndExpandView",
                    horizontalScrollbarVisibility = "AutoHideAndExpandViewport",
                    scrollSensitivity = "75",
                    raycastTarget = "true",
                    color = "rgba(0,0,0,1)"
                },
                children = {{
                    tag = "GridLayout",
                    attributes = {
                        width = "1475",
                        height = tostring(scenarioSelectPanelHeight),
                        spacing = scenarioButtonSpacing .. " " .. scenarioButtonSpacing,
                        cellSize = scenarioButtonWidth .. " " .. scenarioButtonHeight,
                        constraint = "FixedColumnCount",
                        constraintCount = tostring(scenarioColumns)
                    },
                    children = scenarioButtons
                }}
            }}
        }

    return selectScenarioPanel
end

function getScenarioUIDefaults()
    local defaults = {
        tag = "Defaults",
        children = {
            {
                tag = "Panel",
                attributes = {
                    class = "sectionHeading",
                    preferredHeight = "65",
                    flexibleHeight = "0",
                    padding = "0 0 20 15"
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
                tag = "HorizontalLayout",
                attributes = {
                    class = "togglePanelContainer",
                    preferredHeight = "40",
                    flexibleHeight = "0",
                    padding = "20 20 5 5",
                    spacing = "20",
                    contentSizeFitter = "vertical"
                }
            },
            {
                tag = "Panel",
                attributes = {
                    class = "togglePanel",
                    preferredHeight = "30",
                    flexibleHeight = "0",
                    color = "rgba(0,0,0,1)",
                    outline = "rgba(1,1,1,1)",
                    outlineSize = "1 1"
                }
            },
            {
                tag = "Text",
                attributes = {
                    class = "togglePanelLabel",
                    color = "rgba(1,1,1,1)",
                    fontSize = "15"
                }
            },
            {
                tag = "Panel",
                attributes = {
                    class = "togglePanelSelected",
                    preferredHeight = "40",
                    flexibleHeight = "0",
                    color = "rgba(1,1,1,1)",
                    outline = "rgba(1,1,1,1)",
                    outlineSize = "1 1"
                }
            },
            {
                tag = "Text",
                attributes = {
                    class = "togglePanelLabelSelected",
                    color = "rgba(0,0,0,1)",
                    fontSize = "20",
                    fontStyle = "Bold"
                }
            },
            {
                tag = "Panel",
                attributes = {
                    class = "encounterSetControlPanel",
                    preferredHeight = "50",
                    flexibleHeight = "0",
                    color = "rgba(0,0,0,1)",
                    outline = "rgba(0.5,0.5,0.5,1)",
                    outlineSize = "1 1",
                    padding = "10 10 10 10"
                }
            }
        }}

    return defaults
end

function getScenarioDetailsLeftColumn()
    local guid = self.getGUID()
    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
    local selectedHeroes = heroManager.call("getSelectedHeroes")
    local heroNames = {}
    local heroCount = 0

    for color, hero in pairs(selectedHeroes) do
        heroNames[color] = hero.name
        heroCount = heroCount + 1
    end

    local showFirstPlayerSection = heroCount > 1
    local firstPlayerToggles = getFirstPlayerToggles(heroNames)
    local useStandardEncounterSets = true
    if(selectedScenario.useStandardEncounterSets ~= nil) then useStandardEncounterSets = selectedScenario.useStandardEncounterSets end

    local selectedEncounterSetColumns = getSelectedEncounterSetColumns()

    local leftColumn = 
            {
            tag="VerticalLayout",
            attributes = {
                rectAlignment = "UpperLeft",
                offsetXY = "0 -75",
                height = "825",
                width = "500",
                padding = "10 10 0 10",
                childAlignment = "UpperCenter",
                childForceExpandHeight = "false",
                spacing = "0",
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
                                width = "480",
                                image = selectedScenario.tileImageUrl
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
                                offsetXY = "103 22",
                                text = selectedScenario.label or selectedScenario.name
                            }
                        }
                    }
                },
                {
                    tag="Panel",
                    attributes = {
                        class = "sectionHeading",
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
                    tag = "HorizontalLayout",
                    attributes = {
                        class = "togglePanelContainer"
                    },
                    children = {
                        {
                            tag = "Panel",
                            attributes = {
                                id = "modeToggleStandard",
                                class = "togglePanelSelected",
                                onClick = guid .. "/" .. "modeToggleClicked"
                            },
                            children = {
                                {
                                    tag="Text",
                                    value = "Standard",
                                    attributes = {
                                        id = "modeToggleStandardLabel",
                                        class = "togglePanelLabelSelected"
                                    }
                                }
                            }
                        },
                        {
                            tag = "Panel",
                            attributes = {
                                id = "modeToggleExpert",
                                class = "togglePanel",
                                onClick = guid .. "/" .. "modeToggleClicked"
                            },
                            children = {
                                {
                                    tag="Text",
                                    value = "Expert",
                                    attributes = {
                                        class = "togglePanelLabel",
                                        id = "modeToggleExpertLabel"
                                    }
                                }
                            }
                        }
                    }
                },
                {
                    tag="Panel",
                    attributes = {
                        class = "sectionHeading",
                        active = tostring(useStandardEncounterSets)
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
                    tag = "HorizontalLayout",
                    attributes = {
                        class = "togglePanelContainer",
                        active = tostring(useStandardEncounterSets)
                    },
                    children = {
                        {
                            tag = "Panel",
                            attributes = {
                                id = "standardEncounterSetToggleI",
                                class = "togglePanelSelected",
                                onClick = guid .. "/" .. "standardEncounterSetToggleClicked"
                            },
                            children = {
                                {
                                    tag="Text",
                                    value = "Standard I",
                                    attributes = {
                                        id = "standardEncounterSetToggleILabel",
                                        class = "togglePanelLabelSelected"
                                    }
                                }
                            }
                        },
                        {
                            tag = "Panel",
                            attributes = {
                                id = "standardEncounterSetToggleII",
                                class = "togglePanel",
                                onClick = guid .. "/" .. "standardEncounterSetToggleClicked"
                            },
                            children = {
                                {
                                    tag="Text",
                                    value = "Standard II",
                                    attributes = {
                                        id = "standardEncounterSetToggleIILabel",
                                        class = "togglePanelLabel"
                                    }
                                }
                            }
                        },
                        {
                            tag = "Panel",
                            attributes = {
                                id = "standardEncounterSetToggleIII",
                                class = "togglePanel",
                                onClick = guid .. "/" .. "standardEncounterSetToggleClicked"
                            },
                            children = {
                                {
                                    tag="Text",
                                    value = "Standard III",
                                    attributes = {
                                        id = "standardEncounterSetToggleIIILabel",
                                        class = "togglePanelLabel"
                                    }
                                }
                            }
                        }
                    }
                },
                {
                    tag = "HorizontalLayout",
                    attributes = {
                        id = "expertEncounterSetToggleContainer",
                        class = "togglePanelContainer",
                        active = "false"
                    },
                    children = {
                        {
                            tag = "Panel",
                            attributes = {
                                id = "expertEncounterSetToggleI",
                                class = "togglePanelSelected",
                                onClick = guid .. "/" .. "expertEncounterSetToggleClicked"
                            },
                            children = {
                                {
                                    tag="Text",
                                    value = "Expert I",
                                    attributes = {
                                        id = "expertEncounterSetToggleILabel",
                                        class = "togglePanelLabelSelected"
                                    }
                                }
                            }
                        },
                        {
                            tag = "Panel",
                            attributes = {
                                id = "expertEncounterSetToggleII",
                                class = "togglePanel",
                                onClick = guid .. "/" .. "expertEncounterSetToggleClicked"
                            },
                            children = {
                                {
                                    tag="Text",
                                    value = "Expert II",
                                    attributes = {
                                        id = "expertEncounterSetToggleIILabel",
                                        class = "togglePanelLabel"
                                    }
                                }
                            }
                        },
                        {
                            tag = "Panel",
                            attributes = {}
                        }
                    }
                },
                {
                    tag="Panel",
                    attributes = {
                        class = "sectionHeading",
                        active = tostring(showFirstPlayerSection)
                    },
                    children = {
                        {
                            tag="Text",
                            value = "First Player:",
                            attributes = {
                                class = "sectionHeading"
                            }
                        }
                    }
                },
                {
                    tag = "HorizontalLayout",
                    attributes = {
                        class = "togglePanelContainer",
                        preferredHeight = "30",
                        active = tostring(showFirstPlayerSection)
                    },
                    children = {
                        {
                            tag = "Panel",
                            attributes = {
                                id = "firstPlayerToggleRandom",
                                preferredHeight = "30",
                                flexibleHeight = "0",
                                color = "rgba(1,1,1,1)",
                                outline = "rgba(1,1,1,1)",
                                outlineSize = "1 1",
                                onClick = guid .. "/" .. "firstPlayerToggleClicked"
                            },
                            children = {
                                {
                                    tag = "Text",
                                    value = "Random",
                                    attributes = {
                                        id = "firstPlayerToggleRandomLabel",
                                        color = "rgba(0,0,0,1)",
                                        fontSize = "15",
                                        fontStyle = "Bold"
                                    }
                                }
                            }
                        }
                    }
                },
                {
                    tag = "HorizontalLayout",
                    attributes = {
                        class = "togglePanelContainer",
                        preferredHeight = "30",
                        spacing = "10",
                        active = tostring(showFirstPlayerSection)
                    },
                    children = firstPlayerToggles
                },
                {
                    tag="Panel",
                    attributes = {
                        class = "sectionHeading",
                        active = tostring(useStandardEncounterSets)
                    },
                    children = {
                        {
                            tag="Text",
                            value = "Selected Encounter Sets:",
                            attributes = {
                                class = "sectionHeading"
                            }
                        }
                    }
                },
                {
                    tag = "HorizontalLayout",
                    attributes = {
                        minimumHeight = "30",
                        flexibleHeight = "0",
                        padding = "20 0 0 0",
                        spacing = "10",
                        contentSizeFitter = "vertical",
                        active = tostring(useStandardEncounterSets)
                    },
                    children = {
                        {
                            tag = "Text",
                            attributes = {
                                id = "selectedEncounterSetsColumn1",
                                alignment = "UpperLeft",
                                fontSize = "20",
                                color = "rgba(1,1,1,1)",
                                contentSizeFitter = "vertical",
                                text = selectedEncounterSetColumns[1]
                            }
                        },
                        {
                            tag = "Text",
                            attributes = {
                                id = "selectedEncounterSetsColumn2",
                                alignment = "UpperLeft",
                                fontSize = "20",
                                color = "rgba(1,1,1,1)",
                                minimumHeight = "20",
                                flexibleHeight = "1",
                                text = selectedEncounterSetColumns[2]
                            }
                        }
                    }
                },
                {
                    tag = "Panel",
                    attributes = {
                        preferredHeight = "120",
                        preferredWidth = "480",
                        padding = "0 0 20 0",
                        contentSizeFitter = "Both",
                        onClick = guid .. "/setupScenario"
                    },
                    children = {
                        {
                            tag = "Image",
                            attributes = {
                                image = Global.getVar("CDN_URL") .. "/assets/scenario-launch-button.jpg",
                                height = "100",
                                width = "480"
                            }
                        }
                    }
                }
            }
        }

    return leftColumn
end

function getScenarioDetailsRightColumn()
    local guid = self.getGUID()
    local encounterSetButtons = getEncounterSetButtons(guid)

    local useModularEncounterSets = true
    if(selectedScenario.useModularEncounterSets ~= nil) then useModularEncounterSets = selectedScenario.useModularEncounterSets end


    local encounterSetButtonRowCount = math.ceil(#encounterSetButtons / encounterSetColumns)
    local encounterSetSelectPanelHeight = encounterSetButtonRowCount * (encounterSetButtonHeight + encounterSetButtonSpacing) -
                                     encounterSetButtonSpacing

    local encounterSetControlPanelFunction = "getEncounterSetControlPanel_" .. selectedScenario.key
    local encounterSetControlPanel = {
            tag = "Panel",
            attributes = {
                active = "false"
            }
        }

    if (self.getVar(encounterSetControlPanelFunction) ~= nil) then
        encounterSetControlPanel = self.call(encounterSetControlPanelFunction)
        if(encounterSetControlPanel.attributes == nil) then
            encounterSetControlPanel.attributes = {}
        end
        encounterSetControlPanel.attributes.class = "encounterSetControlPanel"
    end

    local rightColumn =
        {
            tag = "VerticalLayout",
            attributes = {
                rectAlignment = "UpperRight",
                offsetXY = "0 -75",
                height = "925",
                width = "1000",
                childAlignment = "UpperCenter",
                childForceExpandHeight = "false",
                spacing = "10"
            },
            children = {
                {
                    tag="Panel",
                    attributes = {
                        class = "sectionHeading",
                        padding = "0 0 0 0",
                        preferredHeight = "35"
                    },
                    children = {
                        {
                            tag="Text",
                            value = "Modular Encounter Sets:",
                            attributes = {
                                class = "sectionHeading"
                            }
                        }
                    }
                },
                encounterSetControlPanel,
                {
                    tag = "VerticalScrollView",
                    attributes = {
                        preferredHeight = "100",
                        flexibleHeight = "1",
                        verticalScrollbarVisibility = "AutoHideAndExpandView",
                        horizontalScrollbarVisibility = "AutoHideAndExpandViewport",
                        scrollSensitivity = "75",
                        raycastTarget = "true",
                        color = "rgba(0,0,0,1)",
                        active = tostring(useModularEncounterSets)
                    },
                    children = {{
                        tag = "GridLayout",
                        attributes = {
                            width = "955",
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
                }
            }
        }
    
    return rightColumn
end

function displayScenarioSelectionUI()
    local guid = self.getGUID()
    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
    local heroCount = heroManager.call("getHeroCount")

    if(heroCount < 1) then
        Global.call("displayMessage", {
            message = "Please select at least one hero before selecting a scenario.",
            messageType = Global.getVar("MESSAGE_TYPE_INSTRUCTION")
        })

        return
    end

    local uiPanels = {}
    table.insert(uiPanels, getScenarioSelectionPanel(guid))
    displayScenarioUI("SELECT SCENARIO", uiPanels)
end

function displayScenarioDetailsUI()
    local uiPanels = {}
    table.insert(uiPanels, getScenarioUIDefaults())
    table.insert(uiPanels, getScenarioDetailsLeftColumn())
    table.insert(uiPanels, getScenarioDetailsRightColumn())

    displayScenarioUI("SCENARIO SETUP", uiPanels)
end

function selectScenario(scenarioKey)
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local scenario = scenarioManager.call("getScenario", {scenarioKey = scenarioKey})

    selectedScenario = deepCopy(scenario)
    selectedScenario.key = scenarioKey

    local preselectModularSets = true

    if(selectedScenario.preselectModularEncounterSets ~= nil ) then
        preselectModularSets = selectedScenario.preselectModularEncounterSets
    end

    if(preselectModularSets) then
        preSelectEncounterSets()
    end

    displayScenarioDetailsUI()
end

function clearSelectedModularEncounterSets()
    for k,v in pairs(selectedScenario.selectedEncounterSets or {}) do
        Global.UI.setAttribute(k, "isOn", "False")
    end

    selectedScenario.selectedEncounterSets = {}
    updateSelectedEncounterSetList()
end

function selectEncounterSet(encounterSetKey, isSelected)
    if(isSelected == nil) then
        isSelected = "True"
    end
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

    Global.UI.setAttribute(encounterSetKey, "isOn", isSelected)

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

function updateSelectedEncounterSetList()
    local columns = getSelectedEncounterSetColumns()

    Global.UI.setAttribute("selectedEncounterSetsColumn1", "text", columns[1])
    Global.UI.setAttribute("selectedEncounterSetsColumn2", "text", columns[2])
end

function getSelectedEncounterSetColumns()
    local selectedSets = selectedScenario.selectedEncounterSets or {}
    local sortedList = Global.call("getSortedListOfItems", {
        items = selectedSets
    })
    local setsPerColumn = math.ceil(#sortedList / 2)
    local columns = {"", ""}

    if(#sortedList == 0) then
        columns[1] = "(none selected)"
        return columns
    end

    for i, set in ipairs(sortedList) do
        local setName = set.label or set.name
        local columnIndex = i <= setsPerColumn and 1 or 2
        if(columns[columnIndex] ~= "") then
            columns[columnIndex] = columns[columnIndex] .. "\n"
        end
        columns[columnIndex] = columns[columnIndex] .. setName
    end
    return columns
end

function hideScenarioUI()
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

function modularEncounterSetToggleChanged(player, value, id)
    selectEncounterSet(id, value)
end

function modeToggleClicked(player, value, id)
    if(id == "modeToggleStandard") then
        selectedScenario.mode = "standard"
        styleTogglePanel("modeToggleStandard", true)
        styleTogglePanel("modeToggleExpert", false)
        Global.UI.hide("expertEncounterSetToggleContainer")

    elseif(id == "modeToggleExpert") then
        selectedScenario.mode = "expert"
        styleTogglePanel("modeToggleStandard", false)
        styleTogglePanel("modeToggleExpert", true)

        local useStandardEncounterSets = true
        if(selectedScenario.useStandardEncounterSets ~= nil) then useStandardEncounterSets = selectedScenario.useStandardEncounterSets end

        if(useStandardEncounterSets) then
            Global.UI.show("expertEncounterSetToggleContainer")
        end
    end
end

function standardEncounterSetToggleClicked(player, value, id)
    if(id == "standardEncounterSetToggleI") then
        selectedScenario.standardSet = "i"
        styleTogglePanel("standardEncounterSetToggleI", true)
        styleTogglePanel("standardEncounterSetToggleII", false)
        styleTogglePanel("standardEncounterSetToggleIII", false)

    elseif(id == "standardEncounterSetToggleII") then
        selectedScenario.standardSet = "ii"
        styleTogglePanel("standardEncounterSetToggleI", false)
        styleTogglePanel("standardEncounterSetToggleII", true)
        styleTogglePanel("standardEncounterSetToggleIII", false)

    elseif(id == "standardEncounterSetToggleIII") then
        selectedScenario.standardSet = "iii"
        styleTogglePanel("standardEncounterSetToggleI", false)
        styleTogglePanel("standardEncounterSetToggleII", false)
        styleTogglePanel("standardEncounterSetToggleIII", true)
    end
end

function expertEncounterSetToggleClicked(player, value, id)
    if(id == "expertEncounterSetToggleI") then
        selectedScenario.expertSet = "i"
        styleTogglePanel("expertEncounterSetToggleI", true)
        styleTogglePanel("expertEncounterSetToggleII", false)

    elseif(id == "expertEncounterSetToggleII") then
        selectedScenario.expertSet = "ii"
        styleTogglePanel("expertEncounterSetToggleI", false)
        styleTogglePanel("expertEncounterSetToggleII", true)
    end
end

function firstPlayerToggleClicked(player, value, id)
    selectedScenario.firstPlayer = id:gsub("firstPlayerToggle", "")
    local firstPlayerToggleIds = {
        "firstPlayerToggleRandom",
        "firstPlayerToggleRed",
        "firstPlayerToggleBlue",
        "firstPlayerToggleGreen",
        "firstPlayerToggleYellow"
    }
    for _, toggleId in ipairs(firstPlayerToggleIds) do
        styleTogglePanel(toggleId, toggleId == id)
    end
end

function styleTogglePanel(panelId, isSelected)
    local highlightColor = Global.UI.getAttribute(panelId, "outline")
    local backgroundColor = "rgba(0,0,0,1)"
    local labelId = panelId .. "Label"

    if(isSelected) then
        Global.UI.setAttribute(panelId, "color", highlightColor)
        Global.UI.setAttribute(labelId, "color", backgroundColor)
        Global.UI.setAttribute(labelId, "fontStyle", "Bold")
    else
        Global.UI.setAttribute(panelId, "color", backgroundColor)
        Global.UI.setAttribute(labelId, "color", highlightColor)
        Global.UI.setAttribute(labelId, "fontStyle", "Normal")
    end
end

function setupScenario()
    hideScenarioUI()

    if(not selectedScenario.mode) then
        selectedScenario.mode = "standard"
    end

    if(not selectedScenario.standardSet) then
        selectedScenario.standardSet = "i"
    end

    if(selectedScenario.mode == "expert" and not selectedScenario.expertSet) then
        selectedScenario.expertSet = "i"
    end

    if(selectedScenario.selectedEncounterSets == nil) then
        selectedScenario.selectedEncounterSets = {}
    end

    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))

    scenarioManager.call("setUpConfiguredScenario", {scenario = selectedScenario})
end


function getEncounterSetControlPanel_hood()
    local guid = self.getGUID()
    local encounterSetControlPanel = {
        tag = "Panel",
        attributes = {
            preferredHeight = "100",
        },
        children = {
            {
                tag = "VerticalLayout",
                attributes = {
                    rectAlignment = "UpperLeft",
                    childAlignment = "UpperCenter",
                    childForceExpandHeight = "false",
                    spacing = "10",
                    contentSizeFitter = "vertical"
                },
                children = {
            {
                tag = "Text",
                value = "Select at least seven modular encounter sets. Click the Easy, Medium, or Hard buttons for preselected combinations, use the Random button for a completely random selection, or choose whatever sets you'd like.",
                attributes = {
                    rectAlignment = "UpperLeft",
                    alignment = "UpperLeft",
                    color = "rgba(1,1,1,1)"
                }
            },
            {
                tag = "HorizontalLayout",
                attributes = {
                    class = "togglePanelContainer"
                },
                children = {
                    {
                        tag = "Panel",
                        attributes = {
                            class = "togglePanel",
                            onClick = guid .. "/selectHoodEasyModularSets"
                        },
                        children = {
                            {
                                tag="Text",
                                value = "Easy",
                                attributes = {
                                    class = "togglePanelLabel"
                                }
                            }
                        }
                    },
                    {
                        tag = "Panel",
                        attributes = {
                            class = "togglePanel",
                            onClick = guid .. "/selectHoodMediumModularSets"
                        },
                        children = {
                            {
                                tag="Text",
                                value = "Medium",
                                attributes = {
                                    class = "togglePanelLabel"
                                }
                            }
                        }
                    },
                    {
                        tag = "Panel",
                        attributes = {
                            class = "togglePanel",
                            onClick = guid .. "/selectHoodHardModularSets"
                        },
                        children = {
                            {
                                tag="Text",
                                value = "Hard",
                                attributes = {
                                    class = "togglePanelLabel"
                                }
                            }
                        }
                    },
                    {
                        tag = "Panel",
                        attributes = {
                            class = "togglePanel",
                            onClick = guid .. "/selectHoodRandomModularSets"
                        },
                        children = {
                            {
                                tag="Text",
                                value = "Random",
                                attributes = {
                                    class = "togglePanelLabel"
                                }
                            }
                        }
                    }
                }
            }
                }
            }
        }
    }

    return encounterSetControlPanel
end

function selectHoodEasyModularSets()
    clearSelectedModularEncounterSets()

    selectEncounterSet("streetsOfMayhem")
    selectEncounterSet("brothersGrimm")
    selectEncounterSet("ransackedArmory")
    selectEncounterSet("stateOfEmergency")
    selectEncounterSet("beastyBoys")
    selectEncounterSet("misterHyde")
    selectEncounterSet("sinisterSyndicate")
end

function selectHoodMediumModularSets()
    clearSelectedModularEncounterSets()

    selectEncounterSet("brothersGrimm")
    selectEncounterSet("ransackedArmory")
    selectEncounterSet("stateOfEmergency")
    selectEncounterSet("beastyBoys")
    selectEncounterSet("misterHyde")
    selectEncounterSet("sinisterSyndicate")
    selectEncounterSet("crossfiresCrew")
end

function selectHoodHardModularSets()
    clearSelectedModularEncounterSets()

    selectEncounterSet("ransackedArmory")
    selectEncounterSet("stateOfEmergency")
    selectEncounterSet("beastyBoys")
    selectEncounterSet("misterHyde")
    selectEncounterSet("sinisterSyndicate")
    selectEncounterSet("crossfiresCrew")
    selectEncounterSet("wreckingCrew")
end

function selectHoodRandomModularSets()
  clearSelectedModularEncounterSets()
  math.randomseed(os.time())

  local encounterSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))
  local encounterSets = encounterSetManager.call("getEncounterSetsByType", {modular = true})
  local selectedSets = {}

  for i = 1, 7, 1 do
    local unselectedSets = {}

    for k, v in pairs(encounterSets) do
      if(not v.selected) then
        table.insert(unselectedSets, k)
      end
    end  
  
    local randomSetKey = unselectedSets[math.random(#unselectedSets)]
    selectEncounterSet(randomSetKey)
  end
end


function getEncounterSetControlPanel_wreckingCrew()
    local encounterSetControlPanel = {
        tag = "Panel",
        attributes = {
            flexibleHeight = "1"
        },
        children = {{
            tag="Text",
            value = "This scenario does not use modular encounter sets.",
            attributes = {
                rectAlignment = "MiddleCenter",
                alignment = "MiddleCenter",
                color = "rgba(1,1,1,1)",
                fontSize = "50"
            }
        }}
    }

    return encounterSetControlPanel
end

function getEncounterSetControlPanel_thunderbolts()
    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
    local heroCount = heroManager.call("getHeroCount")
    local encounterSetControlPanel = {
        tag = "Panel",
        attributes = {
            
        },
        children = {
            {
                tag = "Text",
                value = "Select at least " .. (heroCount + 1) .. " Thunderbolt modular encounter sets (highlighted in yellow).",
                attributes = {
                    rectAlignment = "UpperLeft",
                    alignment = "UpperLeft",
                    color = "rgba(1,1,1,1)"
                }
            }
        }
    }

    return encounterSetControlPanel
end