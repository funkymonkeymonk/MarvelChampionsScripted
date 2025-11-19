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

function onload(saved_data)
    -- self.interactable = false
    -- local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    -- local encounterSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))

    -- allScenarios = scenarioManager.call("getScenarios", {})
    -- allEncounterSets = encounterSetManager.call("getEncounterSets", {})

    -- createButton()
end

function createButton()
    self.createButton({
        label = "SCENARIO",
        click_function = "displayScenarioSelectionUI",
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
        local buttonId = "encounterSetToggle-" .. encounterKey
        local label = encounterSet.label or encounterSet.name
        local fontSize = 15

        _G[functionName] = function(player, value, id)
            selectEncounterSet(encounterKey, value)
        end

        local encounterSetButton = {
            tag = "Panel",
            attributes = {
                padding = "10 0 0 0"
            },
            children = {{
                tag = "Toggle",
                value = label,
                attributes = {
                    id = buttonId,
                    onValueChanged = guid .. "/" .. functionName,
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

function getScenarioUIBase(headerText)
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
        }}
    }}

    return scenarioUI
end

function getUIDefaults()
    local defaults = {
        tag = "Defaults",
        children = {
            {
                tag = "Panel",
                attributes = {
                    class = "sectionHeading",
                    preferredHeight = "65",
                    flexibleHeight = "0",
                    padding = "0 0 20 15",
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
            }
        }}

    return defaults
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

    local scenarioButtons = getScenarioButtons(guid)
    local scenarioSelectPanelHeight = 
        math.ceil(#scenarioButtons / scenarioColumns) * (scenarioButtonHeight + scenarioButtonSpacing) - scenarioButtonSpacing

    local scenarioUI = getScenarioUIBase("SELECT A SCENARIO")
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

    table.insert(scenarioUI[1].children, selectScenarioPanel)

    Global.UI.setXmlTable(scenarioUI)
    local xml = Global.UI.getXml()
end

function displayEncounterSetSelectionUI()
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
    local useStandardEncounterSets = selectedScenario.useStandardEncounterSets ~= null and selectedScenario.useStandardEncounterSets or true
    local useModularEncounterSets = selectedScenario.useModularEncounterSets ~= null and selectedScenario.useModularEncounterSets or true
    local encounterSetButtons = getEncounterSetButtons(guid)
    local selectedEncounterSetColumns = getSelectedEncounterSetColumns()

    local encounterSetButtonRowCount = math.ceil(#encounterSetButtons / encounterSetColumns)
    local encounterSetSelectPanelHeight = encounterSetButtonRowCount * (encounterSetButtonHeight + encounterSetButtonSpacing) -
                                    encounterSetButtonSpacing

    local scenarioUI = getScenarioUIBase("SCENARIO SETUP")
    local defaults = getUIDefaults()
    
    table.insert(scenarioUI, 1, defaults)

    local scenarioSettingsPanels = {{
            tag = "Panel",
            attributes = {
                height = "825",
                width = "500",
                padding = "10 10 0 10",
                rectAlignment = "UpperLeft",
                offsetXY = "0 -75"
            },
            children = {
                {
                    tag="VerticalLayout",
                    attributes = {
                        rectAlignment = "UpperCenter",
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
                                padding = "0 0 10 10",
                                preferredHeight = "50"
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
                            tag = "HorizontalLayout",
                            attributes = {
                                minimumHeight = "30",
                                flexibleHeight = "0",
                                padding = "20 0 0 0",
                                spacing = "10",
                                contentSizeFitter = "vertical"
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
                            tag = "Panel",
                            attributes = {
                                preferredHeight = "120",
                                preferredWidth = "480",
                                padding = "0 0 20 0",
                                contentSizeFitter = "Both",
                                onClick = guid .. "/" .. "setupScenario"
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
            }
        },
        {
            tag = "Panel",
            attributes = {
                id = "encounterSetControlPanel",
                height = "100",
                width = "990",
                rectAlignment = "UpperRight",
                offsetXY = "-10 -75",
                color = "rgba(0,0,0,1)",
                outline = "rgba(0.5,0.5,0.5,1)",
                outlineSize = "1 1",
            },
        },
        {
            tag = "Panel",
            attributes = {
                id = "selectEncounterSetsPanel", 
                rectAlignment = "UpperRight",
                offsetXY = "-10 -185"
            },
            children = {{
                tag = "VerticalScrollView",
                attributes = {
                    height = "805",
                    width = "990",
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
             }}
        }
    }

    for _, panel in ipairs(scenarioSettingsPanels) do
        table.insert(scenarioUI[2].children, panel)
    end

    Global.UI.setXmlTable(scenarioUI)
end

function selectScenario(scenarioKey)
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local scenario = scenarioManager.call("getScenario", {scenarioKey = scenarioKey})

    selectedScenario = deepCopy(scenario)
    selectedScenario.key = scenarioKey

    preSelectEncounterSets()

    displayEncounterSetSelectionUI()
end

function selectEncounterSet(encounterSetKey, isSelected)
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

function modeToggleClicked(player, value, id)
    if(id == "modeToggleStandard") then
        selectedScenario.mode = "standard"
        Global.UI.hide("expertEncounterSetToggleContainer")
        styleTogglePanel("modeToggleStandard", true)
        styleTogglePanel("modeToggleExpert", false)

    elseif(id == "modeToggleExpert") then
        selectedScenario.mode = "expert"
        Global.UI.show("expertEncounterSetToggleContainer")
        styleTogglePanel("modeToggleStandard", false)
        styleTogglePanel("modeToggleExpert", true)
    end
end

function standardEncounterSetToggleClicked(player, value, id)
    if(id == "standardEncounterSetToggleI") then
        selectedScenario.standardEncounterSet = "I"
        styleTogglePanel("standardEncounterSetToggleI", true)
        styleTogglePanel("standardEncounterSetToggleII", false)
        styleTogglePanel("standardEncounterSetToggleIII", false)

    elseif(id == "standardEncounterSetToggleII") then
        selectedScenario.standardEncounterSet = "II"
        styleTogglePanel("standardEncounterSetToggleI", false)
        styleTogglePanel("standardEncounterSetToggleII", true)
        styleTogglePanel("standardEncounterSetToggleIII", false)

    elseif(id == "standardEncounterSetToggleIII") then
        selectedScenario.standardEncounterSet = "III"
        styleTogglePanel("standardEncounterSetToggleI", false)
        styleTogglePanel("standardEncounterSetToggleII", false)
        styleTogglePanel("standardEncounterSetToggleIII", true)
    end
end

function expertEncounterSetToggleClicked(player, value, id)
    if(id == "expertEncounterSetToggleI") then
        selectedScenario.expertEncounterSet = "I"
        styleTogglePanel("expertEncounterSetToggleI", true)
        styleTogglePanel("expertEncounterSetToggleII", false)

    elseif(id == "expertEncounterSetToggleII") then
        selectedScenario.expertEncounterSet = "II"
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
    if(not selectedScenario.mode) then
        selectedScenario.mode = "standard"
    end

    if(not selectedScenario.standardSet) then
        selectedScenario.standardSet = "i"
    end

    if(selectedScenario.mode == "expert" and not selectedScenario.expertSet) then
        selectedScenario.expertSet = "i"
    end

    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    
    scenarioManager.call("setUpConfiguredScenario", {scenario = selectedScenario})
    hideScenarioUI()
end