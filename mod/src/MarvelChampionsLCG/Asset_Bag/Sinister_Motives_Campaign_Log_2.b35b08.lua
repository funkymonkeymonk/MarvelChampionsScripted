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
                fontSize = "40",
                height = "60",
                width = "310",
                offsetXY = "-122.4 125.5",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints1",
                class = "campaignLogField",
                fontSize = "40",
                height = "55",
                width = "75",
                characterValidation = "Integer",
                offsetXY = "-122.4 99"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity2",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "310",
                offsetXY = "-40.5 125.5",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints2",
                class = "campaignLogField",
                fontSize = "40",
                height = "55",
                width = "75",
                characterValidation = "Integer",
                offsetXY = "-40.5 99"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity3",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "310",
                offsetXY = "41.4 125.5",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints3",
                class = "campaignLogField",
                fontSize = "40",
                height = "55",
                width = "75",
                characterValidation = "Integer",
                offsetXY = "41.4 99"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity4",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "310",
                offsetXY = "123.35 125.5",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints4",
                class = "campaignLogField",
                fontSize = "40",
                height = "55",
                width = "75",
                characterValidation = "Integer",
                offsetXY = "123.35 99"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "communityService1",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "475",
                offsetXY = "-101.5 60"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "communityService2",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "475",
                offsetXY = "20.5 60"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "communityService3",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "475",
                offsetXY = "-101.5 40"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "communityService4",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "475",
                offsetXY = "20.5 40"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "wakingNightmare",
                class = "campaignLogField",
                fontSize = "130",
                height = "150",
                width = "300",
                characterValidation = "Integer",
                offsetXY = "123.35 50"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "lastOnesStanding1",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "310",
                offsetXY = "-122 -0.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "lastOnesStanding2",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "321",
                offsetXY = "-40 -0.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "lastOnesStanding3",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "305",
                offsetXY = "41.5 -0.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "lastOnesStanding4",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "310",
                offsetXY = "-122 -20"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "lastOnesStanding5",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "321",
                offsetXY = "-40 -20"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "lastOnesStanding6",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "305",
                offsetXY = "41.5 -20"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "finalReputationScore",
                class = "campaignLogField",
                fontSize = "130",
                height = "150",
                width = "300",
                characterValidation = "Integer",
                offsetXY = "123.35 -10"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "shieldTech1",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "377",
                offsetXY = "-104 -62.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "shieldTech2",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "377",
                offsetXY = "-104 -80.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "shieldTech3",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "377",
                offsetXY = "-104 -98.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "shieldTech4",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "377",
                offsetXY = "-104 -116.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "aspectAdvantage1",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "377",
                offsetXY = "5 -62.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "aspectAdvantage2",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "377",
                offsetXY = "5 -80.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "aspectAdvantage3",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "377",
                offsetXY = "5 -98.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "aspectAdvantage4",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "377",
                offsetXY = "5 -116.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "planningAhead1",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "377",
                offsetXY = "114 -62.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "planningAhead2",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "377",
                offsetXY = "114 -80.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "planningAhead3",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "377",
                offsetXY = "114 -98.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "planningAhead4",
                class = "campaignLogField",
                fontSize = "40",
                height = "60",
                width = "377",
                offsetXY = "114 -116.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "osbornTech1",
                class = "campaignLogField",
                fontSize = "40",
                height = "50",
                width = "415",
                offsetXY = "-108 -155"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "osbornTech2",
                class = "campaignLogField",
                fontSize = "40",
                height = "50",
                width = "425",
                offsetXY = "1 -155"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "osbornTech3",
                class = "campaignLogField",
                fontSize = "40",
                height = "50",
                width = "415",
                offsetXY = "109.5 -155"
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