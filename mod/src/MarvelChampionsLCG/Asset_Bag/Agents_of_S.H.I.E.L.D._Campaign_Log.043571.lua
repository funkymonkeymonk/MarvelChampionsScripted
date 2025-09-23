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
                toggleWidth = "36",
                toggleHeight = "36",
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
                height = "64",
                width = "340",
                offsetXY = "-130 123",
				characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints1",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "75",
                offsetXY = "-97 110"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity2",
                class = "campaignLogField",
                fontSize = "44",
                height = "64",
                width = "340",
                offsetXY = "-42 123",
				characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints2",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "75",
                offsetXY = "-9 110"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity3",
                class = "campaignLogField",
                fontSize = "44",
                height = "64",
                width = "340",
                offsetXY = "46 123",
				characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints3",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "75",
                offsetXY = "79 110"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity4",
                class = "campaignLogField",
                fontSize = "44",
                height = "64",
                width = "340",
                offsetXY = "134 123",
				characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints4",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "75",
                offsetXY = "167 110"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "cmoSecrets1",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "120",
                offsetXY = "-76 67"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "csoSecrets1",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "120",
                offsetXY = "-76 55"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "ctoSecrets1",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "120",
                offsetXY = "-76 43"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "cmoSecrets2",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "120",
                offsetXY = "-44.25 67"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "csoSecrets2",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "120",
                offsetXY = "-44.25 55"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "ctoSecrets2",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "120",
                offsetXY = "-44.25 43"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "cmoSecrets3",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "120",
                offsetXY = "-12.5 67"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "csoSecrets3",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "120",
                offsetXY = "-12.5 55"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "ctoSecrets3",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "120",
                offsetXY = "-12.5 43"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "cmoSecrets4",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "120",
                offsetXY = "19.25 67"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "csoSecrets4",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "120",
                offsetXY = "19.25 55"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "ctoSecrets4",
                class = "campaignLogField",
                fontSize = "26",
                height = "36",
                width = "120",
                offsetXY = "19.25 43"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "minionAndSideSchemeCount",
                class = "campaignLogField",
                fontSize = "90",
                height = "120",
                width = "240",
                offsetXY = "76.5 49"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "rescuedCaptiveCount",
                class = "campaignLogField",
                fontSize = "90",
                height = "120",
                width = "240",
                offsetXY = "144.5 49"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "adaptoidEnvironmentFlying",
				class = "campaignLogField",
                offsetXY = "-91.9 18"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "adaptoidEnvironmentSarahGarza",
				class = "campaignLogField",
                offsetXY = "-28.8 18"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "adaptoidEnvironmentPsionic",
				class = "campaignLogField",
                offsetXY = "-91.9 3.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "adaptoidEnvironmentStrong",
				class = "campaignLogField",
                offsetXY = "-28.8 3.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "survivingThunderbolts",
                class = "campaignLogField",
                fontSize = "26",
                height = "75",
                width = "500",
                offsetXY = "110.5 4",
                textAlignment = "UpperLeft",
				textOffset = "10 10 6 6",
                lineType = "MultiLineNewLine",
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
