local campaigns = {}
local campaignPlaced = false

function onload(saved_data)
    self.interactable = false

    loadSavedData(saved_data)
end

function loadSavedData(saved_data)
    if saved_data ~= "" then
       local loaded_data = JSON.decode(saved_data)
       campaignPlaced = loaded_data.campaignPlaced
    end
end

function saveData()
    local data = {}
    data.campaignPlaced = campaignPlaced

    local saved_data = JSON.encode(data)
    self.script_state = saved_data
end

function getCampaigns()
  return campaigns
end

function placeCampaign(params)
    local campaignId = params.campaignId
    local campaign = campaigns[campaignId]

    if(campaign == nil) then
        return
    end

    placeText(campaign)
    placeCards(campaign)
    placeDecks(campaign)
    placePdfs(campaign)
    placeLogs(campaign)
    placeNotes(campaign)
    placeAssets(campaign)

    campaignPlaced = true
    saveData()
end

function clearCampaign()
    function cardShouldBeDeletedWithCampaign(cardTable)
        if(cardTable.tags) then
            for _, tag in ipairs(cardTable.tags) do
                if(tag == "delete-with-campaign") then
                    return true
                end
            end
        end

        return false
    end

    local objects = getAllObjects()

    for _, object in ipairs(objects) do
        if(object.tag == "Deck") then
            local deckPosition = object.getPosition()
            local extractPosition = {deckPosition[1], deckPosition[2] + 2, deckPosition[3]}
            local cards = object.getObjects()
            local cardGuidsToRemove = {}

            for _, card in ipairs(cards) do
                if(cardShouldBeDeletedWithCampaign(card)) then
                    table.insert(cardGuidsToRemove, card.guid)
                end
            end

            if(#cardGuidsToRemove >= #cards) then
                object.destruct()
            else
                for _, guid in ipairs(cardGuidsToRemove) do
                    local cardObject = object.takeObject({guid=guid, position=extractPosition})
                    cardObject.destruct()
                end
            end
        end

        if object.hasTag("delete-with-campaign") then
            object.destruct()
        end
    end

    campaignPlaced = false
    saveData()
end

function getCampaignPlaced()
    return campaignPlaced
end

function placeText(campaign)
    if(campaign.text == nil) then return end

    for _, text in ipairs(campaign.text) do
        spawnObject({
            type = "3DText",
            position = text.position,
            rotation = text.rotation or {90, 0, 0},
            callback_function = function(spawned_object)
                spawned_object.TextTool.setValue(text.text)
                spawned_object.TextTool.setFontSize(text.fontSize or 100)
                spawned_object.TextTool.setFontColor(text.fontColor or {1,1,1})
                spawned_object.interactable = false
                spawned_object.addTag("delete-with-campaign")
            end
        })
    end
end

function placeCards(campaign)
    if(campaign.cards == nil) then return end

    for _, card in ipairs(campaign.cards) do
        getCardByID(card.cardId, card.position, {scale = card.scale, name = card.name, flipped = card.flipped, landscape = card.landscape, tags = {"delete-with-campaign"}})
    end
end

function placeDecks(campaign)
    if(campaign.decks == nil) then return end

    for _, deck in ipairs(campaign.decks) do
        deck.cardTags = {"delete-with-campaign"}
        createDeck(deck)
    end
end

function placePdfs(campaign)
    if(campaign.pdfs == nil) then return end
    
    for _, pdf in ipairs(campaign.pdfs) do
        local pdfJson = [[
            {
              "Name": "Custom_PDF",
              "Transform": {
                "posX": 0.0,
                "posY": 0.0,
                "posZ": 0.0,
                "rotX": 0.0,
                "rotY": 0.0,
                "rotZ": 0.0,
                "scaleX": 1.0,
                "scaleY": 1.0,
                "scaleZ": 1.0
              },
              "Nickname": "]]..campaign.name..[[ rules",
              "Description": "",
              "GMNotes": "",
              "ColorDiffuse": {
                "r": 1.0,
                "g": 1.0,
                "b": 1.0
              },
              "Locked": true,
              "Grid": true,
              "Snap": true,
              "IgnoreFoW": false,
              "Autoraise": true,
              "Sticky": true,
              "Tooltip": true,
              "GridProjection": false,
              "HideWhenFaceDown": false,
              "Hands": false,
              "CustomPDF": {
                "PDFUrl": "]]..pdf.url..[[",
                "PDFPassword": "",
                "PDFPage": 0,
                "PDFPageOffset": 0
              },
              "XmlUI": "<!-- -->",
              "LuaScript": "--foo",
              "LuaScriptState": "",
              "GUID": "pdf001"
            }]]

        spawnObjectJSON({
            json = pdfJson,
            position = pdf.position,
            rotation = pdf.rotation or {0,180,0},
            scale = pdf.scale or {1,1,1},
            callback_function = function(spawned_object)
                spawned_object.addTag("delete-with-campaign")
            end
        })
    end
end

function placeLogs(campaign)
    if(campaign.logs == nil) then return end
    local assetBag = getObjectFromGUID(Global.getVar("ASSET_BAG_GUID"))

    for _, log in ipairs(campaign.logs) do
        assetBag.call("spawnAsset", {
            guid = log.guid, 
            position = log.position, 
            scale = log.scale,
            rotation = log.rotation or {0,180,0},
            caller = self,
            callback = "configureLog"})
    end
end

function configureLog(params)
    local log = params.spawnedObject
    log.setPosition(params.position)
    log.setScale(params.scale)
    log.setLock(true)
    log.addTag("delete-with-campaign")
end

function placeNotes(campaign)
    if(campaign.notes == nil) then return end
  
    for k, v in pairs(campaign.notes) do
      spawnObject({
        type = "Notecard",
        position = v.position,
        callback_function = function(spawned_object)
          spawned_object.setName(v.title)
          spawned_object.setDescription(v.text)
          spawned_object.addTag("delete-with-campaign")
        end
      })
    end
end

function placeAssets(campaign)
    if(campaign.assets == nil) then return end
        
    for key, asset in pairs(campaign.assets) do
        local assetGuid = asset.guid
        local assetPosition = asset.position
        local assetRotation = asset.rotation
        local assetScale = asset.scale or {1, 1, 1}
        local lockAsset = asset.locked ~= nil and asset.locked or false
        local assetBag = getObjectFromGUID(Global.getVar("ASSET_BAG_GUID"))

        assetBag.call("spawnAsset", {
            guid = assetGuid,
            position = assetPosition,
            scale = assetScale,
            rotation = assetRotation,
            locked = lockAsset,
            caller = self,
            callback = "configureAsset"
        })
    end
end

function configureAsset(params)
    local asset = params.spawnedObject

    asset.setPosition(params.position)
    asset.setScale(params.scale)
    asset.setLock(params.locked)
    asset.addTag("delete-with-campaign")
   
    if(params.rotation ~= nil) then
        asset.setRotation(params.rotation)
    end
end

require('!/Cardplacer')

require('!/campaigns/rise_of_red_skull')
require('!/campaigns/galaxys_most_wanted')
require('!/campaigns/mad_titans_shadow')
require('!/campaigns/sinister_motives')
require('!/campaigns/mutant_genesis')
require('!/campaigns/mojo_mania')
require('!/campaigns/next_evolution')
require('!/campaigns/age_of_apocalypse')
require('!/campaigns/agents_of_shield')
