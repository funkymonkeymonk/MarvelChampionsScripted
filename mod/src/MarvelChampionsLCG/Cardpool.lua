require('!/Decker')

function buildCardPool(packID)
    local cardpool = {}
    local CARDPOOL_OBJ = getObjectFromGUID('537ca3')
    local CARDPOOL_JSON = CARDPOOL_OBJ.getVar('PACK_' .. packID)
    local CARDPOOL_DATA = JSON.decode(CARDPOOL_JSON)

    for _, cardData in pairs(CARDPOOL_DATA) do
        local cardFace = cardData.FrontURL
        local cardBack = cardData.BackURL
        local cardAsset = Decker.Asset(cardFace, cardBack)
        local card = Decker.Card(cardAsset, 1, 1, { name=cardData.name, tags={type_code=cardData.type_code, code=cardData.code, subname=cardData.subname, faction_code=cardData.faction_code}})
        cardpool[cardData.code] = card
    end
    return cardpool
end

function getCardFromCardPool(cardID)
    local packID = string.sub(cardID, 1,2)
    local cardpool = buildCardPool(packID)
    return cardpool[cardID]
end

function getCard(args)
    cardID = args.cardID
    position = args.position
    local FACE_UP_ROTATION = {0, 180, 0}
    local FACE_DOWN_ROTATION = {0, 180, 180}
    local card = getCardFromCardPool(cardID)
    card:spawn({position = position, rotation = FACE_UP_ROTATION})
end

function createUI(_, menu_position)
    local xml = [[
<Panel width="250" height="150">
    <VerticalLayout childAlignment="UpperCenter" color="#CCCCCC" outline="#000000">
        <Text>Type in a card id</Text>
        <Text color="#444444">ex 01006 will spawn Aunt May.</Text>
        <InputField id="INPUT_CARD_ID" onValueChanged="setCardID"></InputField>
        <Button onClick="getCard">Spawn Card</Button>
    </VerticalLayout>
</Panel>
]]
    UI.setXml(xml)
end

function clearUI()
    UI.setXml("")
end

function onLoad()
     addContextMenuItem("Spawn Card", createUI)
end