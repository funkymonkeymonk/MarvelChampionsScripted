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
                position="0 25 -12",
                rotation="0 0 180"
            },
            children={
                {
                    tag="Text",
                    value="6 Cards Remaining",
                    attributes={
                        id="cardCountLabel",
                        fontSize="100",
                        scale="0.25 0.25",
                        width="1000",
                        height="120",
                        rectAlignment="UpperCenter",
                        offsetXY="0 -40",
                        color="rgb(1,1,1)"
                    }
                },
                {
                    tag="Button",
                    value="Investigate",
                    attributes={
                        id="investigateButton",
                        rectAlignment="LowerCenter",
                        offsetXY="0 10",
                        onClick="investigateClicked",
                        textColor="rgb(1,1,1)",
                        color="rgb(0.3,0.6,1)",
                        scale="0.25 0.25",
                        height="200",
                        width="800",
                        fontSize="120",
                        fontStyle="Bold",
                        onMouseEnter="showTooltip",
                        onMouseExit="hideTooltip"                        
                    }
                },
                {
                    tag="Panel",
                    attributes={
                       id="investigateButtonTooltip",
                       scale="0.25 0.25",
                       padding="20 20 10 10",
                       color="rgba(0,0,0,0.75)",
                       contentSizeFitter="both",
                       position="-0 -205 -5",
                       visibility="invisible"
                    },
                    children={
                       {
                          tag="Text",
                          value="Reveal an evidence card",
                          attributes={
                             fontSize="75",
                             color="rgb(1,1,1)",
                             alignment="MiddleLeft"
                          }
                       }
                    }
                }                
            }
        }
    }
 
    self.UI.setXmlTable(ui)   
end

function showTooltip(player, value, id)
    local tooltipId = id .. "Tooltip"
    local playerColor = player.color
    local visibility = self.UI.getAttribute(tooltipId, "visibility")
 
    if string.find(visibility, playerColor) then return end
 
    self.UI.setAttribute(tooltipId, "visibility", visibility.."|"..playerColor)
end
 
function hideTooltip(player, value, id)
    local tooltipId = id .. "Tooltip"
    local playerColor = player.color
    local visibility = self.UI.getAttribute(tooltipId, "visibility")
 
    if not string.find(visibility, playerColor) then return end
 
    self.UI.setAttribute(tooltipId, "visibility", visibility:gsub("|"..playerColor, ""))
end

function investigateClicked(player, value, id)
    local evidenceCards = getValue("evidenceCards", nil)

    if (not evidenceCards) then
        prepareEvidence()
        evidenceCards = getValue("evidenceCards", {})
    end

    if #evidenceCards == 0 then
        return
    end

    local cardToReveal = evidenceCards[1]
    table.remove(evidenceCards, 1)
    setValue("evidenceCards", evidenceCards)

    local envelopePosition = self.getPosition()
    local evidenceStartPosition = {envelopePosition.x, envelopePosition.y - 0.05, envelopePosition.z}
    local evidenceEndPosition = {envelopePosition.x, envelopePosition.y - 0.05, envelopePosition.z + 8}

    local evidenceCard = Global.call("spawnCard", {
        cardId = cardToReveal, 
        position = self.getPosition(), 
        rotation = self.getRotation(), 
        scale=Global.getTable("CARD_SCALE_ENCOUNTER")})

    Wait.condition(
        function()
            evidenceCard.setPositionSmooth(evidenceEndPosition, false, false)
        end,
        function()
            return evidenceCard.resting
        end,
        10
    )

    self.UI.setAttribute("cardCountLabel", "text", #evidenceCards .. " Cards Remaining")
end

function prepareEvidence()
    local means = {}
    local motive = {}
    local oportunity = {}

    table.insert(means, "50185")
    table.insert(means, "50186")
    table.insert(means, "50187")

    table.insert(motive, "50188")
    table.insert(motive, "50189")
    table.insert(motive, "50190")

    table.insert(oportunity, "50191")
    table.insert(oportunity, "50192")
    table.insert(oportunity, "50193")

    means = Global.call("shuffleTable", {table = means})
    motive = Global.call("shuffleTable", {table = motive})
    oportunity = Global.call("shuffleTable", {table = oportunity})

    local aimCards = {}
    local shieldCards = {}

    table.insert(aimCards, means[1])
    table.insert(aimCards, motive[1])
    table.insert(aimCards, oportunity[1])

    for i = 2,3 do
        table.insert(shieldCards, means[i])
        table.insert(shieldCards, motive[i])
        table.insert(shieldCards, oportunity[i])
    end

    shieldCards = Global.call("shuffleTable", {table = shieldCards})
    local mole = identifyMole(means[1], motive[1], oportunity[1])

    setValue("evidenceCards", shieldCards)
    setValue("mole", mole)
end

function identifyMole(meansCardId, motiveCardId, opportunityCardId)
    local combinedKey = meansCardId .. "-" .. motiveCardId .. "-" .. opportunityCardId
    local executiveBoard = getExecutiveBoard()

    for _, officer in ipairs(executiveBoard) do
        for _, combination in ipairs(officer.evidenceCombinations) do
            if(combination == combinedKey) then

                officer.meansCardId = meansCardId
                officer.motiveCardId = motiveCardId
                officer.opportunityCardId = opportunityCardId
                return officer
            end
        end
    end
end

function getMole()
    local mole = getValue("mole", nil)

    if(not mole) then
        prepareEvidence()
        mole = getValue("mole", nil)
    end

    return mole
end

function getExecutiveBoard()
    local board = {}

    table.insert(board,{
        officerName = "Chief Medical Officer",
        officerCardId = "50181",
        evidenceCombinations = {
            "50185-50188-50191",
            "50185-50188-50192",
            "50185-50189-50191",
            "50185-50189-50193",
            "50185-50190-50192",
            "50186-50188-50191",
            "50186-50188-50192",
            "50186-50189-50191",
            "50187-50188-50191"
        }
    })

    table.insert(board,{
        officerName = "Chief Surveillance Officer",
        officerCardId = "50182",
        evidenceCombinations = {
            "50185-50189-50192",
            "50186-50188-50193",
            "50186-50189-50192",
            "50186-50189-50193",
            "50186-50190-50191",
            "50186-50190-50192",
            "50187-50189-50192",
            "50187-50189-50193",
            "50187-50190-50192"
        }
    })

    table.insert(board,{
        officerName = "Chief Tactical Officer",
        officerCardId = "50183",
        evidenceCombinations = {
            "50185-50188-50193",
            "50185-50190-50191",
            "50185-50190-50193",
            "50186-50190-50193",
            "50187-50188-50192",
            "50187-50188-50193",
            "50187-50189-50191",
            "50187-50190-50191",
            "50187-50190-50193"
        }
    })

    return board
end
