require('!/components/campaign_log')

function setUpUI()
    local ui = {{
        tag = "Defaults",
        children = {{
            tag = "InputField",
            class = "campaignLogField",
            attributes = {
                navigation = "None",
                fontSize = "40",
                height = "50",
                width = "600",
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
                toggleWidth = "72",
                toggleHeight = "68",
                scale = "0.25 0.25",
                colors = "rgba(1,1,1,0.35)|rgba(1,1,1,0.35)|rgba(1,1,1,0.35)|rgba(1,1,1,0.35)",
                onValueChanged = "toggleValueChanged"
            }
        }}
    }, {
        tag = "Panel",
        attributes = {
            height = "410",
            width = "340",
            color = "rgba(0,0,0,0)",
            position = "0 0 -6",
            rotation = "0 0 180"
        },
        children = {{
            tag = "InputField",
            attributes = {
                id = "playerIdentity1",
                class = "campaignLogField",
                offsetXY = "-78.5 146.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints1",
                class = "campaignLogField",
				characterValidation = "Integer",
                offsetXY = "-78.5 120"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "supportUpgrade1_1",
                class = "campaignLogField",
                offsetXY = "-78.5 90"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "supportUpgrade2_1",
                class = "campaignLogField",
                offsetXY = "-78.5 60"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity2",
                class = "campaignLogField",
                offsetXY = "80 146.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints2",
                class = "campaignLogField",
				characterValidation = "Integer",
                offsetXY = "80 120"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "supportUpgrade1_2",
                class = "campaignLogField",
                offsetXY = "80 90"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "supportUpgrade2_2",
                class = "campaignLogField",
                offsetXY = "80 60"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity3",
                class = "campaignLogField",
                offsetXY = "-78.5 25.25"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints3",
                class = "campaignLogField",
				characterValidation = "Integer",
                offsetXY = "-78.5 -1.25"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "supportUpgrade1_3",
                class = "campaignLogField",
                offsetXY = "-78.5 -31.25"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "supportUpgrade2_3",
                class = "campaignLogField",
                offsetXY = "-78.5 -61.25"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity4",
                class = "campaignLogField",
                offsetXY = "80 25.25"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints4",
                class = "campaignLogField",
				characterValidation = "Integer",
                offsetXY = "80 -1.25"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "supportUpgrade1_4",
                class = "campaignLogField",
                offsetXY = "80 -31.25"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "supportUpgrade2_4",
                class = "campaignLogField",
                offsetXY = "80 -61.25"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "longshotInPlayScenario1",
                class = "campaignLogField",
                offsetXY = "-138 -129"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "longshotInPlayScenario2",
                class = "campaignLogField",
                offsetXY = "-138 -158"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "genreEnvironmentCrime",
                class = "campaignLogField",
                offsetXY = "22 -119"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "genreEnvironmentSciFi",
                class = "campaignLogField",
                offsetXY = "95.8 -119"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "genreEnvironmentFantasy",
                class = "campaignLogField",
                offsetXY = "22 -145"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "genreEnvironmentSitcom",
                class = "campaignLogField",
                offsetXY = "95.8 -145"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "genreEnvironmentHorror",
                class = "campaignLogField",
                offsetXY = "22 -171.6"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "genreEnvironmentWestern",
                class = "campaignLogField",
                offsetXY = "95.8 -171.6"
            }
        }}
    }}

    self.UI.setXmlTable(ui)

    Wait.frames(function()
        populateLog()
    end, 30)
end