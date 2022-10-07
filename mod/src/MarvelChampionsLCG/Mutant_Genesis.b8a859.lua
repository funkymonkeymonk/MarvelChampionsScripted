require('!/Cardplacer')

function layoutCampaignCards()
    log("Laying out the cards")
    local campaignCardsJSON = [[
{
    "32171a": 1,
    "32172a": 1,
    "32173a": 1,
    "32174a": 1,
    "32175a": 1
}]]

    local brawlerCardsJSON = [[
{
    "32176": 1,
    "32177": 1,
    "32178": 1,
    "32179": 1,
    "32180": 1
}]]

    local commanderCardsJSON = [[
{
    "32181": 1,
    "32182": 1,
    "32183": 1,
    "32184": 1,
    "32185": 1
}]]

    local defenderCardsJSON = [[
{
    "32186": 1,
    "32187": 1,
    "32188": 1,
    "32189": 1,
    "32190": 1
}]]

    local peacekeeperCardsJSON = [[
{
    "32191": 1,
    "32192": 1,
    "32193": 1,
    "32194": 1,
    "32195": 1
}]]

    --[[
    Lots of cleanup to do here.
    The scale is wrong for the encounter cards.
    Cards that have both a vertical and horizontal component are messed up bad.
    These cards should be laid out in a meaningful way not just piled in a deck.
    Cards should be spread by a function for easy reuse.CAMPAIGN_STARTING_POSITION
    Campaign data should be separated from campaign box functionality, probably through an import
    This whole process needs to be evaluated, but this is a kinda crappy but reasonable first pass.
    ]]

    local CAMPAIGN_STARTING_POSITION = { x=-94.75, y=0.51, z=13.75 }
    local CARD_SCALE_PLAYER = Global.getTable("CARD_SCALE_PLAYER")

    local campaignDeck = {
        cards = JSON.decode(campaignCardsJSON),
        position = {CAMPAIGN_STARTING_POSITION.x, CAMPAIGN_STARTING_POSITION.y, CAMPAIGN_STARTING_POSITION.z},
        scale = Global.getTable("CARD_SCALE_ENCOUNTER")
    }
    createDeck(campaignDeck)

    local roles = {"BRAWLER", "COMMANDER", "DEFENDER", "PEACEKEEPER"}
    local roleCards = { brawlerCardsJSON, commanderCardsJSON, defenderCardsJSON, peacekeeperCardsJSON }
    local offset = -6.0

    for i, cards in ipairs(roleCards) do
        -- Add a lable to make it look pretty and easy to use

        local deck = {
            cards = JSON.decode(cards),
            position = {CAMPAIGN_STARTING_POSITION.x, CAMPAIGN_STARTING_POSITION.y, CAMPAIGN_STARTING_POSITION.z + i * offset},
            scale = CARD_SCALE_PLAYER,
            name = roles[i],
            flipped = true
        }
        createDeck(deck)
    end
end










-- TODO: How much of this can be deleted and everything still work?
function onload(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        --Set up information off of loaded_data
        memoryList = loaded_data.ml
    else
        --Set up information for if there is no saved saved data
        memoryList = {}
    end
    createMemoryActionButtons()
end

--Creates recall and place buttons
function createMemoryActionButtons()
    self.createButton({
        label="Begin", click_function="buttonClick_place", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}, tooltip="Start Campaign"
    })
end

--Sends objects from bag/table to their saved position/rotation
function buttonClick_place()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList) do
        local obj = getObjectFromGUID(guid)
        --If obj is out on the table, move it to the saved pos/rot
        if obj ~= nil then
            obj.setPositionSmooth(entry.pos)
            obj.setRotationSmooth(entry.rot)
            obj.setLock(entry.lock)
        else
            --If obj is inside of the bag
            for _, bagObj in ipairs(bagObjList) do
                if bagObj.guid == guid then
                    local item = self.takeObject({
                        guid=guid, position=entry.pos, rotation=entry.rot, smooth=false
                    })
                    item.setLock(entry.lock)
                    break
                end
            end
        end
    end

    layoutCampaignCards()
    broadcastToAll("Objects Placed", {1,1,1})
    self.clearButtons()
end

--Find delta (difference) between 2 x/y/z coordinates
function findOffsetDistance(p1, p2, obj)
    local deltaPos = {}
    local bounds = obj.getBounds()
    deltaPos.x = (p2.x-p1.x)
    deltaPos.y = (p2.y-p1.y) + (bounds.size.y - bounds.offset.y)
    deltaPos.z = (p2.z-p1.z)
    return deltaPos
end

--Used to rotate a set of coordinates by an angle
function rotateLocalCoordinates(desiredPos, obj)
	local objPos, objRot = obj.getPosition(), obj.getRotation()
    local angle = math.rad(objRot.y)
	local x = desiredPos.x * math.cos(angle) - desiredPos.z * math.sin(angle)
	local z = desiredPos.x * math.sin(angle) + desiredPos.z * math.cos(angle)
	--return {x=objPos.x+x, y=objPos.y+desiredPos.y, z=objPos.z+z}
    return {x=x, y=desiredPos.y, z=z}
end

--Coroutine delay, in seconds
function wait(time)
    local start = os.time()
    repeat coroutine.yield(0) until os.time() > start + time
end

--Duplicates a table (needed to prevent it making reference to the same objects)
function duplicateTable(oldTable)
    local newTable = {}
    for k, v in pairs(oldTable) do
        newTable[k] = v
    end
    return newTable
end

--Moves scripted highlight from all objects
function removeAllHighlights()
    for _, obj in ipairs(getAllObjects()) do
        obj.highlightOff()
    end
end

--Round number (num) to the Nth decimal (dec)
function round(num, dec)
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end
