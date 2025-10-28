local positionColor = "Red"
local tint = Global.getTable("MESSAGE_TINT_RED")
local importDeckId = ""

function onload()
    self.createButton({
        click_function = "changeColor",
        function_owner = self,
        position       = {0,0,0},
        rotation       = {0,0,0},
        width          = 500,
        height         = 500,
        tooltip        = "Sit here"
    })

    createSuitUpButton()
end

function createSuitUpButton()
    local buttons = self.getButtons()
    if(#buttons > 1) then return end

    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))

    if(heroManager.call("getSelectedHero", {positionColor=positionColor})) then
        return
    end

    if(scenarioManager.call("isScenarioInProgress")) then
        return
    end

    self.createButton({
        click_function = "displayHeroUI",
        function_owner = self,
        position       = {0,0.5,1.5},
        rotation       = {0,180,0},
        width          = 1700,
        height         = 450,
        label          = "SUIT UP!",
        tooltip        = "Click to set up your hero",
        color          = {0,0,0,0},
        font_size      = 450,
        font_color     = tint
    })
end

function hideSuitUpButton()
    local buttons = self.getButtons()
    if(#buttons == 1) then return end
    self.removeButton(1)
end

function changeColor(obj, playerColor)
    if playerColor ~= positionColor then
        if (not Player[positionColor].seated) then
            Player[playerColor].changeColor(positionColor)
        end
    end
end

function displayHeroUI(obj, playerColor)
    hideSuitUpButton()

    local rgbaTint = "rgba(" .. tint[1] .. "," .. tint[2] .. "," .. tint[3] .. "," .. tint[4] .. ")"

    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
    local heroes = heroManager.call("getHeroesByTeam", {team=nil})
    local orderedList = Global.call("getSortedListOfItems", {items = heroes})
    local heroButtons = {}

    for i, hero in ipairs(orderedList) do
        local functionName = "selectHero-" .. hero.key
        local label = hero.label and hero.label or hero.name
        local maxWidth = 8
        local labelInfo = Global.call("breakLabel", {label=label, maxWidth=maxWidth})
        local fontSize = 50

        if labelInfo.length > maxWidth then
            fontSize = 50 - ((labelInfo.length - maxWidth) * 4)
        end

        _G[functionName] = function()
            hideHeroUI(false)
            local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
            heroManager.call("placeHeroWithStarterDeck", {heroKey=hero.key, playerColor=positionColor})
        end

        local heroButton = {
            tag="Panel",
            children={
                {
                    tag="Image",
                    attributes={
                        image=hero.tileImageUrl,
                        raycastTarget="true"
                    }
                },
                {
                    tag="Button",
                    value=labelInfo.text,
                    attributes={
                        onClick=functionName,
                        height="140",
                        width="240",
                        fontSize=tostring(fontSize),
                        textColor="rgba(0,0,0,1)",
                        color="rgba(0,0,0,0)",
                        offsetXY="-75 15"
                    }
                }
            }
        }
        table.insert(heroButtons, heroButton)
    end

    local heroButtonWidth = 480
    local heroButtonHeight = 240
    local heroButtonSpacing = 17
    local heroSelectPanelHeight = math.ceil(#heroButtons / 3) * (heroButtonHeight + heroButtonSpacing) - heroButtonSpacing

    local heroUI = 
    {
        {
            tag="Panel",
            attributes={
                height="1000",
                width="1500",
                color="rgba(0,0,0,1)",
                position="0 1000 -1000",
                rotation="-45 0 0",
                visibility=playerColor
            },
            children={
                {
                    tag="Panel",
                    attributes={
                        height="75",
                        rectAlignment="UpperCenter"
                    },
                    children={
                        {
                            tag="Text",
                            value="HERO SETUP",
                            attributes={
                                alignment="MiddleLeft",
                                fontSize="50",
                                color=rgbaTint,
                                offsetXY="10 0"
                            }
                        },
                        {
                            tag="Button",
                            value="X",
                            attributes={
                                rectAlignment="UpperRight",
                                onClick="cancel",
                                textColor="rgba(255,0,0,1)",
                                color="rgba(0,0,0,0)",
                                fontSize="50",
                                height="60",
                                width="60",
                                offsetXY="-10 -10"
                            }
                        }
                    }
                },
                {
                    tag="HorizontalLayout",
                    attributes={
                        height="100",
                        rectAlignment="UpperCenter",
                        offsetXY="0 -75"
                    },
                    children={
                        {
                            tag="Button",
                            value="IMPORT DECK",
                            attributes={
                                id="importDeckButton",
                                onClick="showImportDeckPanel",
                                fontSize="50",
                                fontStyle="Bold"
                            }
                        },
                        {
                            tag="Button",
                            value="SELECT HERO",
                            attributes={
                                id="selectHeroButton",
                                onClick="showSelectHeroPanel",
                                fontSize="50"
                            }
                        },
                        {
                            tag="Button",
                            value="RANDOM HERO",
                            attributes={
                                onClick="placeRandomHero",
                                fontSize="50"
                            }
                        }
                    }
                },
                {
                    tag="Panel",
                    attributes={
                        height="825",
                        rectAlignment="LowerCenter"
                    },
                    children={
                        {
                            tag="Panel",
                            attributes={
                                id="importPanel",
                                color="rgba(0,0,0,1)",
                            },
                            children={
                                {
                                    tag="Image",
                                    attributes={
                                        image="https://steamusercontent-a.akamaihd.net/ugc/6286202998660654/28215DE2218D5A378D536EA7A4BB2B53A50ECB3D/",
                                        width="1500",
                                        height="825"
                                    }
                                },
                                {
                                    tag="InputField",
                                    attributes={
                                        id="deckIdInput",
                                        fontSize="70",
                                        height="100",
                                        width="300",
                                        placeholder="Deck ID",
                                        characterValidation="Integer",
                                        offsetXY="-400 200",                                   
                                        onValueChanged="setDeckId"
                                    }
                                },
                                {
                                    tag="Text",
                                    attributes={
                                        text="DECK IS PRIVATE",
                                        fontSize="50",
                                        color="#ffffff",
                                        offsetXY="-440 0"
                                    }
                                },
                                {
                                    tag="Toggle",
                                    attributes={
                                        id="isPrivateDeckToggle",
                                        isOn="true",
                                        toggleWidth="60",
                                        toggleHeight="60",
                                        offsetXY="-140 0"
                                    }
                                },
                                {
                                    tag="Button",
                                    value="IMPORT",
                                    attributes={
                                        onClick="importDeck",
                                        fontSize="70",
                                        height="125",
                                        width="330",
                                        offsetXY="-400 -200"
                                    }
                                }
                            }
                        },
                        {
                            tag="Panel",
                            attributes={
                                id="selectHeroPanel",
                                active="false"
                            },
                            children={
                                {
                                    tag="VerticalScrollView",
                                    attributes={
                                        height="825",
                                        width="1500",
                                        rectAlignment="UpperCenter",
                                        verticalScrollbarVisibility="AutoHideAndExpandView",                                        
                                        horizontalScrollbarVisibility="AutoHideAndExpandViewport",
                                        scrollSensitivity="75",
                                        raycastTarget = "true"
                                    },
                                    children={
                                        {
                                            tag="GridLayout",
                                            attributes={
                                                width="1475",
                                                height=tostring(heroSelectPanelHeight),
                                                spacing=heroButtonSpacing .. " " .. heroButtonSpacing,
                                                cellSize=heroButtonWidth .. " " .. heroButtonHeight,
                                                constraint="FixedColumnCount",
                                                constraintCount="3"
                                            },
                                            children=heroButtons
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

    self.UI.setXmlTable(heroUI)
end

function showImportDeckPanel()
    self.UI.hide("selectHeroPanel")
    self.UI.hide("randomHeroPanel")
    self.UI.show("importPanel")

    self.UI.setAttribute("importDeckButton", "fontStyle", "Bold")
    self.UI.setAttribute("selectHeroButton", "fontStyle", "")
end

function showSelectHeroPanel()
    self.UI.hide("importPanel")
    self.UI.hide("randomHeroPanel")
    self.UI.show("selectHeroPanel")

    self.UI.setAttribute("importDeckButton", "fontStyle", "")
    self.UI.setAttribute("selectHeroButton", "fontStyle", "Bold")
end

function placeRandomHero()
    hideHeroUI(false)
    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
    heroManager.call("placeRandomHero", {positionColor=positionColor})
end

function importDeck()
    local isPrivateDeck = self.UI.getAttribute("isPrivateDeckToggle", "isOn") == "true"

    if(not importDeckId or importDeckId == "") then
        broadcastToColor("Please enter a valid deck ID", positionColor, tint)
        return
    end

    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))

    local params = {
        deckId = importDeckId,
        isPrivateDeck = isPrivateDeck,
        callbackFunction = "importDeckCallback",
        callbackTarget = self
    }

    Global.call("importDeck", params)
end

function setDeckId(player, value, id)
    importDeckId = value
end

function importDeckCallback(params)
    if(not params.deckInfo) then
        hideHeroUI(true)
        return
    end

    hideHeroUI(false)
    
    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
    heroManager.call("placeHeroWithImportedDeck", {deckInfo = params.deckInfo, positionColor=positionColor})
end

function cancel()
    hideHeroUI(true)
end

function hideHeroUI(showSuitUpButton)
    self.UI.setXml("")

    if(showSuitUpButton) then
        createSuitUpButton()
    end
end
