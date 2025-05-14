preventDeletion = true
local data = {}

function onload(saved_data)
    loadSavedData(saved_data)
    setUpUI()
end

function loadSavedData(saved_data)
    if saved_data ~= "" then
       local loaded_data = JSON.decode(saved_data)
       data = loaded_data
    end
end
 
function setValue(key, value)
    data[key] = value
    local saved_data = JSON.encode(data)
    self.script_state = saved_data
end
 
function getValue(key, default)
    if data[key] == nil then
       return default
    end
 
    return data[key]
end

function setUpUI()
    local ui = 
    {
        {
            tag="Panel",
            attributes={            
                height="400",
                width="310",
                color="rgba(0,0,0,0)",
                position="0 25 -30",
                rotation="0 0 180"
            },
            children={
                {
                    tag="Text",
                    value="",
                    attributes={
                        id="moleLabel",
                        fontSize="90",
                        fontStyle="Bold",
                        scale="0.25 0.25",
                        width="2000",
                        height="240",
                        rectAlignment="UpperCenter",
                        offsetXY="0 -32",
                        color="rgb(0.7804,0.0902,0.0824)"
                    }
                },                
                {
                    tag="Button",
                    value="Reveal the Mole!",
                    attributes={
                        id="revealMoleButton",
                        rectAlignment="LowerCenter",
                        offsetXY="0 10",
                        onClick="revealMoleClicked",
                        textColor="rgb(1,1,1)",
                        color="rgb(0.7804,0.0902,0.0824)",
                        scale="0.25 0.25",
                        height="200",
                        width="1100",
                        fontSize="120",
                        fontStyle="Bold"
                    }
                }
            }
        }
    }
 
    self.UI.setXmlTable(ui)   
end

function revealMoleClicked(player, value, id)
    local mole = getValue("mole", nil)
    if(mole) then return end

    local shieldEnvelope = Global.call("findObjectByTag", {tag = "shield-envelope"})
    mole = shieldEnvelope.call("getMole")

    local moleCopy = {
        officerName = mole.officerName,
        meansCardId = mole.meansCardId,
        meansCard = mole.meansCard,
        motiveCardId = mole.motiveCardId,
        opportunityCardId = mole.opportunityCardId
    }

    setValue("mole", moleCopy)

    local envelopePosition = self.getPosition()
    local evidenceStartPosition = Vector({envelopePosition.x, envelopePosition.y - 0.05, envelopePosition.z})
    local evidenceSecondPosition = Vector({envelopePosition.x, envelopePosition.y - 0.05, envelopePosition.z + 8})
    local meansEndPosition = Vector({evidenceSecondPosition.x - 5.5, evidenceSecondPosition.y, evidenceSecondPosition.z})
    local opportunityEndPosition = Vector({evidenceSecondPosition.x + 5.5, evidenceSecondPosition.y, evidenceSecondPosition.z})

    local evidenceDeckList = {}
    evidenceDeckList[mole.meansCardId] = 1
    evidenceDeckList[mole.motiveCardId] = 1
    evidenceDeckList[mole.opportunityCardId] = 1

    local evidenceDeck = Global.call("createDeck", {
        cards = evidenceDeckList, 
        position = evidenceStartPosition, 
        scale = Global.getTable("CARD_SCALE_ENCOUNTER"), 
        flipped = true})

    Wait.condition(
        function()
            evidenceDeck.setPositionSmooth(evidenceSecondPosition, false, false)
            
            Wait.frames(
                function() 
                    Wait.condition(
                        function()
                            local found = Global.call("moveCardFromDeckById", {
                                cardId = mole.meansCardId,
                                deckPosition = evidenceSecondPosition,
                                destinationPosition = meansEndPosition,
                            })

                            local found2 = Global.call("moveCardFromDeckById", {
                                cardId = mole.opportunityCardId,
                                deckPosition = evidenceSecondPosition,
                                destinationPosition = opportunityEndPosition,
                            })

                            self.UI.setAttribute("moleLabel", "text", "The mole is the\n" .. mole.officerName .. "!")
                        end,
                        function()
                            return evidenceDeck.resting
                        end, 
                        10
                    )
                end,
                10
            )
        end,
        function()
            return evidenceDeck.resting
        end,
        10
    )
end

