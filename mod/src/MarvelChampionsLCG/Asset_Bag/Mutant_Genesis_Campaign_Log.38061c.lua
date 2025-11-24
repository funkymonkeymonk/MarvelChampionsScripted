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
                fontSize = "24",
                height = "32",
                width = "340",
                offsetXY = "-130 118.35"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "role1",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "150",
                offsetXY = "-153 97.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints1",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "75",
                characterValidation = "Integer",
                offsetXY = "-109 97.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity2",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "334",
                offsetXY = "-42.25 118.35"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "role2",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "150",
                offsetXY = "-65.5 97.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints2",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "75",
                characterValidation = "Integer",
                offsetXY = "-21.5 97.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity3",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "338",
                offsetXY = "44.5 118.35"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "role3",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "150",
                offsetXY = "22 97.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints3",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "75",
                characterValidation = "Integer",
                offsetXY = "66 97.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "playerIdentity4",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "338",
                offsetXY = "132.5 118.35"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "role4",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "150",
                offsetXY = "109.5 97.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "hitPoints4",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "75",
                characterValidation = "Integer",
                offsetXY = "153.5 97.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "frightenedPoliceDefeated",
                class = "campaignLogField",
                toggleWidth = "65",
                toggleHeight = "65",
                offsetXY = "-157 62.75"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "enemyOfMyEnemyDefeated",
                class = "campaignLogField",
                toggleWidth = "65",
                toggleHeight = "65",
                offsetXY = "-69.9 62.75"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "findThePrisonersDefeated",
                class = "campaignLogField",
                toggleWidth = "65",
                toggleHeight = "65",
                offsetXY = "16 62.75"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "surpriseAttackDefeated",
                class = "campaignLogField",
                toggleWidth = "65",
                toggleHeight = "65",
                offsetXY = "102.5 62.75"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "futurePastCardsInVictoryDisplay",
                class = "campaignLogField",
                fontSize = "24",
                height = "60",
                width = "1380",
                textAlignment = "UpperLeft",
                textOffset = "10 10 5 5",
                lineType = "MultiLineNewLine",
                offsetXY = "1.5 29"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "futurePastCardsInEncounterDeck1",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "340",
                offsetXY = "-130 -7.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "futurePastCardsInEncounterDeck2",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "334",
                offsetXY = "-42.25 -7.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "futurePastCardsInEncounterDeck3",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "338",
                offsetXY = "44.5 -7.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "futurePastCardsInEncounterDeck4",
                class = "campaignLogField",
                fontSize = "24",
                height = "32",
                width = "338",
                offsetXY = "132.5 -7.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "roleUpgrades1",
                class = "campaignLogField",
                fontSize = "24",
                height = "150",
                width = "340",
                textAlignment = "UpperLeft",
                textOffset = "10 10 5 5",
                lineType = "MultiLineNewLine",
                offsetXY = "-130 -56"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "roleUpgrades2",
                class = "campaignLogField",
                fontSize = "24",
                height = "150",
                width = "334",
                textAlignment = "UpperLeft",
                textOffset = "10 10 5 5",
                lineType = "MultiLineNewLine",
                offsetXY = "-42.25 -56"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "roleUpgrades3",
                class = "campaignLogField",
                fontSize = "24",
                height = "150",
                width = "338",
                textAlignment = "UpperLeft",
                textOffset = "10 10 5 5",
                lineType = "MultiLineNewLine",
                offsetXY = "44.5 -56"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "roleUpgrades4",
                class = "campaignLogField",
                fontSize = "24",
                height = "150",
                width = "338",
                textAlignment = "UpperLeft",
                textOffset = "10 10 5 5",
                lineType = "MultiLineNewLine",
                offsetXY = "132.5 -56"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "jubileeInPlayScenario2",
                class = "campaignLogField",
                offsetXY = "-141.5 -106.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "jubileeInPlayScenario3",
                class = "campaignLogField",
                offsetXY = "-43.25 -106.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "jubileeRemovedFromCampaignScenario3",
                class = "campaignLogField",
                offsetXY = "-43.25 -116"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "jubileeInPlayScenario4",
                class = "campaignLogField",
                offsetXY = "56.25 -106.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "jubileeRemovedFromCampaignScenario4",
                class = "campaignLogField",
                offsetXY = "56.25 -116"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "alliesFromAbductionProtocols",
                class = "campaignLogField",
                fontSize = "24",
                height = "130",
                width = "685",
                textAlignment = "UpperLeft",
                textOffset = "10 10 5 5",
                lineType = "MultiLineNewLine",
                offsetXY = "-86.2 -154"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "alliesUnderRescueCaptivesOrFindThePrisoners",
                class = "campaignLogField",
                fontSize = "24",
                height = "130",
                width = "685",
                textAlignment = "UpperLeft",
                textOffset = "10 10 5 5",
                lineType = "MultiLineNewLine",
                offsetXY = "88.5 -154"
            }
        }}
    }}

    self.UI.setXmlTable(ui)

    Wait.frames(function()
        populateLog()
    end, 30)
end