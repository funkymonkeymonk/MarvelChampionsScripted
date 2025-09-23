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
                toggleWidth = "31",
                toggleHeight = "31",
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
                offsetXY = "-131.5 119",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints1",
                class = "campaignLogField",
                fontSize = "26",
                height = "45",
                width = "75",
                offsetXY = "-128 105"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity2",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "330",
                offsetXY = "-43.5 119",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints2",
                class = "campaignLogField",
                fontSize = "26",
                height = "45",
                width = "75",
                offsetXY = "-38 105"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity3",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "340",
                offsetXY = "43 119.25",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints3",
                class = "campaignLogField",
                fontSize = "26",
                height = "45",
                width = "75",
                offsetXY = "47.5 105"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity4",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "340",
                offsetXY = "132 119",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints4",
                class = "campaignLogField",
                fontSize = "26",
                height = "45",
                width = "75",
                offsetXY = "136.5 105"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "overseerDefeatedMisterSinister",
                class = "campaignLogField",
                offsetXY = "-132.85 -168.65"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "overseerDefeatedShadowKing",
                class = "campaignLogField",
                offsetXY = "-71.25 -168.65"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "overseerDefeatedAbyss",
                class = "campaignLogField",
                offsetXY = "-2.8 -168.65"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "overseerDefeatedSugarMan",
                class = "campaignLogField",
                offsetXY = "30.3 -168.65"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "overseerDefeatedMikhailRasputin",
                class = "campaignLogField",
                offsetXY = "79 -168.65"
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
