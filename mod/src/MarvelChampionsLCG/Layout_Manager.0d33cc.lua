preventDeletion = true

local zones = {}
local cards = {}

function onload(saved_data)
    self.interactable = false
    loadSavedData(saved_data)
end

function loadSavedData(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        currentView = loaded_data.currentView or "scenario"
        zones = loaded_data.zones or {}
        cards = loaded_data.cards or {}
    end
end

function saveData()
    local saved_data = JSON.encode({currentView = currentView, zones = zones, cards = cards})
    self.script_state = saved_data
end

function hideLayoutButtons()
    local allObjects = getAllObjects()

    for k,v in pairs(allObjects) do
        if(v.hasTag("layout-ui")) then
            hideTile(v)
        end
        if(v.hasTag("game-ui")) then
            showTile(v, false)
        end
    end
end

function showLayoutButtons()
    local allObjects = getAllObjects()

    for k,v in pairs(allObjects) do
        if(v.hasTag("game-ui")) then
            hideTile(v)
        end
        if(v.hasTag("layout-ui")) then
            showTile(v, false)
        end
    end
end

function hideSetupUI()
    hideLayoutButtons()
end

function showTile(tile, sendHeroes)
    tile.call("showTile")
end

function hideTile(tile)
    tile.call("hideTile")
end

function clearScenario()
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))

    scenarioManager.call("clearScenario")

    local firstPlayerToken = getObjectFromGUID(Global.getVar("FIRST_PLAYER_TOKEN_GUID"))
    local firstPlayerTokenPosition = Global.getTable("FIRST_PLAYER_TOKEN_POSITION")
    if(firstPlayerToken) then
        firstPlayerToken.setPositionSmooth(firstPlayerTokenPosition)
    end

    saveData()
    showLayoutButtons()
end

function createZone(params)
    local zoneDef = params.zoneDef

    if(zoneDef.supressCreation) then
        return nil
    end

    return spawnObject({
        type = "ScriptingTrigger",
        position = zoneDef.position,
        scale = zoneDef.scale,
        sound = false,
        callback_function = function(zone)
            for _, tag in pairs(zoneDef.tags or {}) do
                zone.addTag(tag)
            end
            
            local zoneGuid = zone.getGUID()
            zoneDef.guid = zoneGuid
            zones[zoneGuid] = zoneDef
            saveData()
        end
    })
end

function deleteZone(params)
    local zone = params.zone

    if(not zone) then
        local zoneDef = getZoneDefinition(params)
        zone = zoneDef and getObjectFromGUID(zoneDef.guid) or nil
    end
    if(not zone) then return end

    local zoneGuid = zone.getGUID()

    zones[zoneGuid] = nil
    zone.destruct()

    saveData()
end

function deleteZoneGroup(params)
    local deleteGroup = params.group

    for guid, zoneDef in pairs(zones) do
        if(zoneDef.group == deleteGroup) then
            zones[guid] = nil
            local zone = getObjectFromGUID(guid)
            if(zone) then zone.destruct() end
        end
    end

    saveData()
end

function getZoneDefinitionsByType(params)
    local zoneType = params.zoneType
    local zoneDefs = {}

    for key, zoneDef in pairs(zones) do
        local zoneDefType = zoneDef.zoneType or zoneDef.zoneIndex

        if (zoneDefType == zoneType) then
            table.insert(zoneDefs, zoneDef)
        end
    end

    return zoneDefs
end

function getZoneDefinition(params)
   local zone = params.zone
   local zoneGuid = zone and zone.getGUID() or params.zoneGuid
   local zoneIndex = params.zoneIndex

    if(zoneGuid) then
        return zones[zoneGuid]
    end

    for _, zoneDef in pairs(zones) do
        if(zoneDef.zoneIndex == zoneIndex) then
            return zoneDef
        end
    end

    return nil
end

function updateZoneDefinitions(params)
    local zoneDefs = params.zoneDefinitions
    for _, zoneDef in pairs(zoneDefs) do
        zones[zoneDef.guid] = zoneDef
    end
    saveData()
end

function setCardValue(params)
    local cardGuid = params.cardGuid
    local property = params.property
    local value = params.value

    local card = cards[cardGuid] or {}
    card[property] = value
    cards[cardGuid] = card

    saveData()
end

function getCardValue(params)
    local cardGuid = params.cardGuid
    local property = params.property

    local card = cards[cardGuid]

    if(not card) then
        return nil
    end

    return card[property]
end

function getAllCardValues(params)
    local cardGuid = params.cardGuid

    return cards[cardGuid]
end

function getCardRegistry()
    return cards
end

function deleteCardFromRegistry(params)
    local cardGuid = params.cardGuid

    cards[cardGuid] = nil

    scrubCardRegistry()
    saveData()
end

function scrubCardRegistry()
    local scrubbedCards = {}
    for guid, cardData in pairs(cards) do
        if(cardData ~= nil) then
            scrubbedCards[guid] = cardData
        end
    end

    cards = scrubbedCards
end