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
                fontSize = "35",
                height = "45",
                width = "325",
                offsetXY = "-131.5 122"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints1",
                class = "campaignLogField",
                fontSize = "20",
                height = "30",
                width = "50",
                offsetXY = "-97 111.75",
                characterValidation = "Integer"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "obligations1",
                class = "campaignLogField",
                fontSize = "35",
                height = "210",
                width = "325",
                textOffset = "10 10 5 5",
                offsetXY = "-131.5 71",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "techUpgrade1",
                class = "campaignLogField",
                fontSize = "35",
                height = "45",
                width = "325",
                offsetXY = "-131.5 30"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "basicUpgrade1",
                class = "campaignLogField",
                fontSize = "35",
                height = "45",
                width = "325",
                offsetXY = "-131.5 10.5"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "rescuedAllies1",
                class = "campaignLogField",
                fontSize = "35",
                height = "210",
                width = "325",
                textOffset = "10 10 5 5",
                offsetXY = "-131.5 -28.5",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity2",
                class = "campaignLogField",
                fontSize = "35",
                height = "45",
                width = "340",
                offsetXY = "-44.25 122"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints2",
                class = "campaignLogField",
                fontSize = "20",
                height = "30",
                width = "50",
                offsetXY = "-8.25 111.75",
                characterValidation = "Integer"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "obligations2",
                class = "campaignLogField",
                fontSize = "35",
                height = "210",
                width = "340",
                textOffset = "10 10 5 5",
                offsetXY = "-44.25 71",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "techUpgrade2",
                class = "campaignLogField",
                fontSize = "35",
                height = "45",
                width = "340",
                offsetXY = "-44.25 30"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "basicUpgrade2",
                class = "campaignLogField",
                fontSize = "35",
                height = "45",
                width = "340",
                offsetXY = "-44.25 10.5"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "rescuedAllies2",
                class = "campaignLogField",
                fontSize = "35",
                height = "210",
                width = "340",
                textOffset = "10 10 5 5",
                offsetXY = "-44.25 -28.5",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity3",
                class = "campaignLogField",
                fontSize = "35",
                height = "45",
                width = "340",
                offsetXY = "44.9 122"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints3",
                class = "campaignLogField",
                fontSize = "20",
                height = "30",
                width = "50",
                offsetXY = "80.9 111.75",
                characterValidation = "Integer"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "obligations3",
                class = "campaignLogField",
                fontSize = "35",
                height = "210",
                width = "340",
                textOffset = "10 10 5 5",
                offsetXY = "44.9 71",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "techUpgrade3",
                class = "campaignLogField",
                fontSize = "35",
                height = "45",
                width = "340",
                offsetXY = "44.9 30"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "basicUpgrade3",
                class = "campaignLogField",
                fontSize = "35",
                height = "45",
                width = "340",
                offsetXY = "44.9 10.5"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "rescuedAllies3",
                class = "campaignLogField",
                fontSize = "35",
                height = "210",
                width = "340",
                textOffset = "10 10 5 5",
                offsetXY = "44.9 -28.5",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity4",
                class = "campaignLogField",
                fontSize = "35",
                height = "45",
                width = "340",
                offsetXY = "134 122"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints4",
                class = "campaignLogField",
                fontSize = "20",
                height = "30",
                width = "50",
                offsetXY = "170 111.75",
                characterValidation = "Integer"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "obligations4",
                class = "campaignLogField",
                fontSize = "35",
                height = "210",
                width = "340",
                textOffset = "10 10 5 5",
                offsetXY = "134 71",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "techUpgrade4",
                class = "campaignLogField",
                fontSize = "35",
                height = "45",
                width = "340",
                offsetXY = "134 30"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "basicUpgrade4",
                class = "campaignLogField",
                fontSize = "35",
                height = "45",
                width = "340",
                offsetXY = "134 10.5"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "rescuedAllies4",
                class = "campaignLogField",
                fontSize = "35",
                height = "210",
                width = "340",
                textOffset = "10 10 5 5",
                offsetXY = "134 -28.5",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "experimentalWeapons",
                class = "campaignLogField",
                fontSize = "35",
                height = "275",
                width = "455",
                textOffset = "10 10 5 5",
                offsetXY = "-116 -135",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "delayCounterCount",
                class = "campaignLogField",
                fontSize = "35",
                height = "275",
                width = "455",
                textOffset = "10 10 5 5",
                offsetXY = "1.75 -135",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "playersEngagedWithMinions",
                class = "campaignLogField",
                fontSize = "35",
                height = "95",
                width = "455",
                textOffset = "10 10 5 5",
                offsetXY = "119.5 -106",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        },{
            tag = "InputField",
            attributes = {
                id = "alliesRemovedFromCampaign",
                class = "campaignLogField",
                fontSize = "35",
                height = "150",
                width = "455",
                textOffset = "10 10 5 5",
                offsetXY = "119.5 -150.15",
                lineType = "MultiLineNewLine",
                textAlignment = "UpperLeft"
            }
        }}
    }}

    self.UI.setXmlTable(ui)

    Wait.frames(function()
        populateLog()
    end, 30)
end