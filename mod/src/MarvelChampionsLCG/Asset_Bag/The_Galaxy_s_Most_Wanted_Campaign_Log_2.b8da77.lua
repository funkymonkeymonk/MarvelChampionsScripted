require('!/components/campaign_log')

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
        }, {
            tag = "Toggle",
            class = "campaignLogField",
            attributes = {
                toggleWidth = "68",
                toggleHeight = "68",
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
                id = "playerIdentity3",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "650",
                offsetXY = "-100 122.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints3",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "75",
                characterValidation = "Integer",
                offsetXY = "-138 104"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "unspentUnits3",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "75",
                characterValidation = "Integer",
                offsetXY = "-42.5 104.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity4",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "650",
                offsetXY = "79 123"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints4",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "75",
                characterValidation = "Integer",
                offsetXY = "40.5 104"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "unspentUnits4",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "75",
                characterValidation = "Integer",
                offsetXY = "137.5 104"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "marketCards3",
                class = "campaignLogField",
                fontSize = "40",
                height = "200",
                width = "680",
                textOffset = "10 10 5 5",
                offsetXY = "-99 39",
                rotation = "0 0 0.2",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "marketCards4",
                class = "campaignLogField",
                fontSize = "40",
                height = "200",
                width = "690",
                textOffset = "10 10 5 5",
                offsetXY = "79 39.25",
                rotation = "0 0 0.2",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "cardsInCollection3",
                class = "campaignLogField",
                fontSize = "40",
                height = "218",
                width = "680",
                textOffset = "10 10 5 5",
                offsetXY = "-99 -38",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "cardsInCollection4",
                class = "campaignLogField",
                fontSize = "40",
                height = "218",
                width = "690",
                textOffset = "10 10 5 5",
                offsetXY = "79.5 -37",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "powerStoneControl",
                class = "campaignLogField",
                fontSize = "60",
                height = "110",
                width = "550",
                offsetXY = "-116 -105.25"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "evasionCounters",
                class = "campaignLogField",
                fontSize = "60",
                height = "110",
                width = "550",
                characterValidation = "Integer",
                offsetXY = "-116 -158.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "headhunterDefeated1",
                class = "campaignLogField",
                offsetXY = "50.5 -99.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "headhunterDefeated2",
                class = "campaignLogField",
                offsetXY = "156.85 -99"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "headhunterDefeated3",
                class = "campaignLogField",
                offsetXY = "50.5 -143.3"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "headhunterDefeated4",
                class = "campaignLogField",
                offsetXY = "156.85 -143"
            }
        }}
    }}

    self.UI.setXmlTable(ui)

    Wait.frames(function()
        populateLog()
    end, 30)
end