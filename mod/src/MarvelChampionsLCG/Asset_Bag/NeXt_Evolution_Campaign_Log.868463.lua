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
                characterValidation = "Integer",
                onValueChanged = "textValueChanged"
            }
        }, {
            tag = "Toggle",
            class = "campaignLogField",
            attributes = {
                toggleWidth = "75",
                toggleHeight = "75",
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
            tag = "InputField",
            attributes = {
                id = "marauderDefeated1",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "360",
                offsetXY = "-112 60",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "marauderDefeated2",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "360",
                offsetXY = "-112 41.5",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "marauderDefeated3",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "360",
                offsetXY = "-112 23",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "morlocksSaved",
                class = "campaignLogField",
                fontSize = "140",
                height = "220",
                width = "440",
                offsetXY = "0 45"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hopeSummersDamageScenario3",
                class = "campaignLogField",
                fontSize = "26",
                height = "45",
                width = "75",
                offsetXY = "115 60"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hopeSummersDamageScenario4",
                class = "campaignLogField",
                fontSize = "26",
                height = "45",
                width = "75",
                offsetXY = "115 41.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "scenarioChosenAssembleTheTeam",
                class = "campaignLogField",
                fontSize = "40",
                height = "75",
                width = "285",
                offsetXY = "-61.25 -40.5",
				characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "scenarioChosenEstablishSafehouse",
                class = "campaignLogField",
                fontSize = "40",
                height = "75",
                width = "285",
                offsetXY = "-61.25 -65.2",
				characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "scenarioChosenGearUp",
                class = "campaignLogField",
                fontSize = "40",
                height = "75",
                width = "285",
                offsetXY = "-61.25 -89.9",
				characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "scenarioChosenMissionPrep",
                class = "campaignLogField",
                fontSize = "40",
                height = "75",
                width = "285",
                offsetXY = "-61.25 -114.6",
				characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "scenarioChosenPracticeManeuvers",
                class = "campaignLogField",
                fontSize = "40",
                height = "75",
                width = "285",
                offsetXY = "-61.25 -139.3",
				characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "scenarioChosenPrepareDefenses",
                class = "campaignLogField",
                fontSize = "40",
                height = "75",
                width = "285",
                offsetXY = "-61.25 -164",
				characterValidation = "None"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "environmentEarnedAssembleTheTeam",
                class = "campaignLogField",
                offsetXY = "152.75 -40.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "environmentEarnedEstablishSafehouse",
                class = "campaignLogField",
                offsetXY = "152.75 -65.2"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "environmentEarnedGearUp",
                class = "campaignLogField",
                offsetXY = "152.75 -89.9"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "environmentEarnedMissionPrep",
                class = "campaignLogField",
                offsetXY = "152.75 -114.6"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "environmentEarnedPracticeManeuvers",
                class = "campaignLogField",
                offsetXY = "152.75 -139.3"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "environmentEarnedPrepareDefenses",
                class = "campaignLogField",
                offsetXY = "152.75 -164"
            }
        }}
    }}

    self.UI.setXmlTable(ui)

    Wait.frames(function()
        populateLog()
    end, 30)
end