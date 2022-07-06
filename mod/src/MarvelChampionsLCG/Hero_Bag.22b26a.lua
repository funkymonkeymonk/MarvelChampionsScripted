local originPosition = {x=58.25, y=0.50, z=33.75}

local rowGap = -2.5
local columnGap = 5

local rows = 12

function onload(saved_data)
    self.setInvisibleTo({"Red", "Blue", "Green", "Yellow", "White"})
    createContextMenu()
    layOutHeroes()
end

function createContextMenu()
    self.addContextMenuItem("Lay Out Heroes", layOutHeroes)
    self.addContextMenuItem("Delete Heroes", deleteHeroes)
end

function layOutHeroes()
    local heroZone = getObjectFromGUID("210c2b")
    clearHeroZone(heroZone)
    layOutTiles(heroZone)
end

function deleteHeroes()
    local heroZone = getObjectFromGUID("210c2b")
    clearHeroZone(heroZone)
end

function clearHeroZone(zone)
    local objectsInZone = zone.getObjects()

    for k,v in pairs(objectsInZone) do
        if(v.hasTag("hero-selector-tile")) then
            v.destruct()
        end
    end     
end

function layOutTiles(zone)
    local bagList = getSortedListOfHeroes()
    local tileBag = getObjectFromGUID("01ad59")

    for bagGuid, tilePosition in pairs(bagList) do
        local tilePosition = tilePosition

        local heroBag = self.takeObject({guid=bagGuid})
        local tile = tileBag.takeObject(tilePosition)

        setupTile({
            heroBag=heroBag,
            zone=zone,
            tile=tile,
            tilePosition=tilePosition
        })
    end
end

function getSortedListOfHeroes()
    local heroList = {}

    for _, heroBag in ipairs(self.getObjects()) do
        table.insert (heroList, {heroBag.guid, heroBag.name})
    end

    local compareHeroNames = function(a,b)
            return a[2] < b[2]
    end

    local sortedList = table.sort(heroList, compareHeroNames)

    local row = 1
    local column = 1
    local orderedList = {}

    for _,v in ipairs(sortedList) do
        orderedList[v[1]] = getTilePosition(column, row)

        row = row + 1
        if row > rows then
            row = 1
            column = column + 1
        end
    end

    return orderedList
end

function getTilePosition(column, row)
    return {
        originPosition.x + columnGap * (column - 1), 
        originPosition.y, 
        originPosition.z + rowGap * (row - 1)}
end

function setupTile(params)
    Wait.frames(
        function()
            local heroBag=params.heroBag
            local heroDetails = heroBag.call("getHeroDetails")
            local imageUrl = heroDetails["counterUrl"]
            self.putObject(heroBag)

            local tile = params.tile
            local tilePosition = params.tilePosition
            tile.setName(string.    gsub(heroBag.getName(), " Hero Bag", ""))
            tile.setDescription("")
            tile.setScale({1.13, 1, 1.13})
            tile.setRotation({0,180,0})
            tile.setLock(true)
            tile.setPosition(tilePosition)
            tile.addTag("hero-selector-tile")
            tile.setCustomObject({image=imageUrl})
            reloadedTile = tile.reload()

            setTileFunctions(reloadedTile, heroBag.getGUID())
            createTileButtons(reloadedTile)
        end,
        30)
end

function setTileFunctions(tile, heroBagGuid)
    local tileScript = [[
        function placeHeroWithStarterDeck(obj, player_color)
            local heroPlacer = getObjectFromGUID(Global.getVar("HERO_MANAGER_GUID"))
            heroPlacer.call("placeHeroWithStarterDeck", {heroBagGuid="]]..heroBagGuid..[[", playerColor=player_color})
        end
        function placeHeroWithHeroDeck(obj, player_color)
            local heroPlacer = getObjectFromGUID(Global.getVar("HERO_MANAGER_GUID"))
            heroPlacer.call("placeHeroWithHeroDeck", {heroBagGuid="]]..heroBagGuid..[[", playerColor=player_color})
        end    
    ]]
    tile.setLuaScript(tileScript)
end

function createTileButtons(tile)
    tile.createButton({
        label="S|", click_function="placeHeroWithStarterDeck", function_owner=tile,
        position={-1,0.2,-0.12}, rotation={0,0,0}, height=560, width=550,
        font_size=600, color={1,1,1}, font_color={0,0,0}, tooltip="Starter"
    })
    tile.createButton({
        label="C", click_function="placeHeroWithHeroDeck", function_owner=tile,
        position={-0.24,0.2,-0.12}, rotation={0,0,0}, height=560, width=550, 
        font_size=600, color={1,1,1}, font_color={0,0,0}, tooltip="Constructed"
    })
end
