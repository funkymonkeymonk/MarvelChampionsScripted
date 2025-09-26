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
                onValueChanged = "textValueChanged"
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
                width = "650",
                offsetXY = "-81 124",
                rotation = "0 0 -0.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints1",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "75",
                characterValidation = "Integer",
                offsetXY = "-118 105"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "unspentUnits1",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "75",
                characterValidation = "Integer",
                offsetXY = "-23.5 105"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity2",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "650",
                offsetXY = "100 122.5",
                rotation = "0 0 -0.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints2",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "75",
                offsetXY = "62.5 104",
                characterValidation = "Integer"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "unspentUnits2",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "75",
                offsetXY = "158 104",
                characterValidation = "Integer"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "marketCards1",
                class = "campaignLogField",
                fontSize = "40",
                height = "200",
                width = "700",
                textOffset = "10 10 5 5",
                offsetXY = "-80 40",
                rotation = "0 0 -0.5",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "marketCards2",
                class = "campaignLogField",
                fontSize = "40",
                height = "200",
                width = "690",
                textOffset = "10 10 5 5",
                offsetXY = "98.5 39",
                rotation = "0 0 -0.5",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "cardsInCollection1",
                class = "campaignLogField",
                fontSize = "40",
                height = "218",
                width = "700",
                textOffset = "10 10 5 5",
                offsetXY = "-80 -36",
                rotation = "0 0 -0.5",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "cardsInCollection2",
                class = "campaignLogField",
                fontSize = "40",
                height = "218",
                width = "690",
                textOffset = "10 10 5 5",
                offsetXY = "98.5 -37",
                rotation = "0 0 -0.5",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "galacticArtifactsInVictoryDisplay1",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "1270",
                offsetXY = "12 -99",
                rotation = "0 0 -0.45"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "galacticArtifactsInVictoryDisplay2",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "1270",
                offsetXY = "12 -120.15",
                rotation = "0 0 -0.45"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "galacticArtifactsInVictoryDisplay3",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "1270",
                offsetXY = "12 -141.3",
                rotation = "0 0 -0.45"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "galacticArtifactsInVictoryDisplay4",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "1270",
                offsetXY = "12 -162.5",
                rotation = "0 0 -0.45"
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
end

function textValueChanged(player, value, id)
    if (not logData.textValues) then
        logData.textValues = {}
    end

    logData.textValues[id] = value
    saveData()
end