local logData = {}

function onload(saved_data)
    self.interactable = false

    loadSavedData(saved_data)
    setUpUI()
end

function loadSavedData(saved_data)
    if saved_data ~= "" then
        logData = JSON.decode(saved_data)
    end
end

function saveData()
    local saved_data = JSON.encode(logData)
    self.script_state = saved_data
end

function setUpUI()
    local ui = {{
        tag = "Defaults",
        children = {{
            tag = "InputField",
            class = "campaignLogField",
            attributes = {
                navigation = "None",
                textOffset = "2 2 2 2",
                color = "rgba(1,1,1,0.35)",
                scale = "0.25 0.25",
                placeholder = " ",
                textAlignment = "MiddleCenter",
                characterValidation = "Integer",
                onValueChanged = "textValueChanged"
            }
        }, {
            tag = "Toggle",
            class = "campaignLogField",
            attributes = {
                toggleWidth = "65",
                toggleHeight = "65",
                scale = "0.25 0.25",
                colors = "rgba(1,1,1,0.35)|rgba(1,1,1,0.35)|rgba(1,1,1,0.35)|rgba(1,1,1,0.35)",
                onValueChanged = "toggleValueChanged"
            }
        }}
    }, {
        tag = "Panel",
        attributes = {
            height = "370",
            width = "370",
            color = "rgba(0,0,0,0)",
            position = "0 0 -6",
            rotation = "0 0 180"
        },
        children = {{
            tag = "InputField",
            attributes = {
                id = "playerIdentity1",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "340",
                offsetXY = "-130.15 118",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints1",
                class = "campaignLogField",
                fontSize = "26",
                height = "45",
                width = "74.5",
                offsetXY = "-97 105"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity2",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "330",
                offsetXY = "-42.54 118",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints2",
                class = "campaignLogField",
                fontSize = "26",
                height = "45",
                width = "65",
                offsetXY = "-9.25 105"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity3",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "335",
                offsetXY = "44.5 118",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints3",
                class = "campaignLogField",
                fontSize = "26",
                height = "45",
                width = "65",
                offsetXY = "78.15 105"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity4",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "340",
                offsetXY = "132.7 118",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints4",
                class = "campaignLogField",
                fontSize = "26",
                height = "45",
                width = "74.5",
                offsetXY = "166.1 105"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "cosmoAddedToCampaign",
                class = "campaignLogField",
                offsetXY = "-159 47.35"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "securityBreachToCampaign",
                class = "campaignLogField",
                offsetXY = "-159 16"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "shawarmaAddedToCampaign",
                class = "campaignLogField",
                offsetXY = "-71 47.35"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "blackSwanAddedToCampaign",
                class = "campaignLogField",
                offsetXY = "-71 7.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "avengersTowerDamaged",
                class = "campaignLogField",
                offsetXY = "-71 -23.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "systemShockAddedToCampaign",
                class = "campaignLogField",
                offsetXY = "15.9 47.35"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "infinityStonesSchemeCompleted",
                class = "campaignLogField",
                offsetXY = "15.9 -0.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "nornStoneAddedToCampaign",
                class = "campaignLogField",
                offsetXY = "103.5 47.35"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "odinAddedToCampaign",
                class = "campaignLogField",
                offsetXY = "103.5 16"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "notes",
                class = "campaignLogField",
                fontSize = "44",
                height = "350",
                width = "1375",
                offsetXY = "1.5 -125",
                textOffset = "10 10 5 5",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft",
                characterValidation = "None"
            }
        }}
    }}

    self.UI.setXmlTable(ui)

    Wait.frames(function()
        populateLog()
    end, 30)
end

function populateLog()
    if (logData.textValues) then
        for id, value in pairs(logData.textValues) do
            self.UI.setAttribute(id, "text", value)
        end
    end

    if (logData.toggleValues) then
        for id, value in pairs(logData.toggleValues) do
            self.UI.setAttribute(id, "isOn", tostring(value))
        end
    end
end

function textValueChanged(player, value, id)
    if (not logData.textValues) then
        logData.textValues = {}
    end

    logData.textValues[id] = value
    saveData()
end

function toggleValueChanged(player, value, id)
    if (not logData.toggleValues) then
        logData.toggleValues = {}
    end

    logData.toggleValues[id] = value
    saveData()
end
