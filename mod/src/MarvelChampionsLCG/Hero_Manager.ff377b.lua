local playmatBagGuid = "e549db"
local deckImporterGuid = "c7ece0"
local healthCounterOffset = {-10.42, .1, 5.5}
local identityOffset = {-9.89, 3, 1}
local deckOffset = {-8.4, 3, -4.66}

local originPosition = {x=58.25, y=0.50, z=33.75}

local rowGap = -2.5
local columnGap = 5

local rows = 12

function onload(saved_data)
--    self.setInvisibleTo({"Red", "Blue", "Green", "Yellow", "White"})
    createContextMenu()
    layOutHeroes()
end

function placeHeroWithStarterDeck(params)
  placeHero(params.heroBagGuid, params.playerColor, "starter")
end

function placeHeroWithHeroDeck(params)
  placeHero(params.heroBagGuid, params.playerColor, "constructed")
end

function placeHero(heroBagGuid, playerColor, deckType)
  if not confirmPlayerIsSeated(playerColor) then return end
  if not confirmSeatIsAvailable(playerColor) then return end

  --local heroesBag = getObjectFromGUID("22b26a")
  local heroBag = self.takeObject({guid=heroBagGuid})

  Wait.frames(
    function()
      local heroDetails = heroBag.call("getHeroDetails")
      local playmatPosition = getPlaymatPosition(playerColor)
    
      placePlaymat(
        playerColor, 
        playmatPosition, 
        heroDetails["playmatUrl"])
    
      placeHealthCounter(
        playmatPosition,
        heroDetails["counterUrl"],
        heroDetails["hitPoints"])
    
--       placeIdentity(
--         heroBag,
--         heroDetails["identityGuid"],
--         playmatPosition)
--
--       placeDeck(
--         heroBag,
--         deckType,
--         heroDetails["starterDeckId"],
--         heroDetails["heroDeckId"],
--         playmatPosition)
--
--       placeExtras(
--         heroBag,
--         heroDetails["extras"],
--         playmatPosition)
--
--       placeNemesis(
--         heroBag,
--         heroDetails["nemesisGuid"])
--
--       placeObligation(
--         heroBag,
--         heroDetails["obligationGuid"])
    
      self.putObject(heroBag)
      
      local scenarioManager = getObjectFromGUID(Global.getVar("SCENARIO_MANAGER_GUID"))
      scenarioManager.call("updateCounters")
    end, 
    1)
end

function confirmPlayerIsSeated(playerColor)
  if(playerColor ~= "Red" and playerColor ~= "Blue" and playerColor ~= "Green" and playerColor ~= "Yellow") then
    broadcastToAll("Take a seat, hero! (Red, Blue, Green, or Yellow.)", {1,1,1})
    return false
  end
  return true
end

function confirmSeatIsAvailable(playerColor)
  local objects = getAllObjects()
  for _, object in pairs(objects) do
    if(object.hasTag("Playmat") and object.hasTag(playerColor)) then
      broadcastToAll("There is already a hero at this seat.", {1,1,1})
      return false
    end
  end
  return true
end

function getPlaymatPosition(playerColor)
  if(playerColor == 'Red') then
    return {-41.19, 1.04, -17.12}
  end

  if(playerColor == 'Blue') then
    return	{-13.75, 1.04, -17.75}
  end

  if(playerColor == 'Green') then
    return {13.74, 1.04, -17.76}
  end

  if(playerColor == 'Yellow') then
    return {41.21, 1.04, -17.08}
  end

  return nil
end

function placePlaymat(playerColor, playmatPosition, imageUrl)
  local playmatBag = getObjectFromGUID(playmatBagGuid)
  local playmatCopy = playmatBag.takeObject({position=playmatPosition})

  playmatCopy.setName("")
  playmatCopy.setDescription("")
  playmatCopy.setLock(true)
  playmatCopy.setPosition(playmatPosition)
  playmatCopy.addTag("Playmat")
  playmatCopy.addTag(playerColor)
  playmatCopy.setCustomObject({image=imageUrl})
  playmatCopy.reload()
end

function placeHealthCounter(playmatPosition, imageUrl, hitPoints)
  local counterPosition = getOffsetPosition(playmatPosition, healthCounterOffset)
  local counterBag = getObjectFromGUID("ef3f2f")
  local counter = counterBag.takeObject({position=counterPosition})

  counter.setName("")
  counter.setDescription("")
  counter.setScale({1.13, 1, 1.13})
  counter.setRotation({0,180,0})
  counter.setLock(true)
  counter.setPosition(counterPosition)
  counter.setCustomObject({image=imageUrl})
  local reloadedCounter = counter.reload()

  Wait.frames(
    function()
      reloadedCounter.call("setValue", {value=hitPoints})
    end,
    10
  )
end

function placeIdentity(heroBag, identityGuid, playmatPosition)
  local identityPosition = getOffsetPosition(playmatPosition, identityOffset)
  local identityOrig = heroBag.takeObject({guid=identityGuid, position=identityPosition})
  local identityCopy = identityOrig.clone({position=identityPosition})
  heroBag.putObject(identityOrig)

  identityCopy.setName("")
  identityCopy.setDescription("")
  identityCopy.setScale({1.88, 1, 1.88})
  identityCopy.setPosition(identityPosition)
end

function placeDeck(heroBag, deckType, starterDeckId, heroDeckId, playmatPosition)
  local deckPosition = getOffsetPosition(playmatPosition, deckOffset)

  if(deckType == "starter") then
    placeStarterDeck(starterDeckId, deckPosition)
  else
    placeHeroDeck(heroDeckId, deckPosition)
  end
end

function placeStarterDeck(starterDeckId, deckPosition)
  local params = {
    deckId = starterDeckId,
    privateDeck = true,
    deckPosition = deckPosition
  }

  local deckImporter = getObjectFromGUID(deckImporterGuid)

  deckImporter.call("importDeck", params)
end

function placeHeroDeck(heroDeckId, deckPosition)
  local params = {
    deckId = heroDeckId,
    privateDeck = true,
    deckPosition = deckPosition
  }

  local deckImporter = getObjectFromGUID(deckImporterGuid)

  deckImporter.call("importDeck", params)
end

function placeExtras(heroBag, extras, playmatPosition)
  if(extras == nil) then
    return
  end
  
  for _, item in pairs(extras) do
    local objectPosition = getOffsetPosition(playmatPosition, item["offset"])
    local objectOrig = heroBag.takeObject({guid=item["guid"], position=objectPosition})
    local objectCopy = objectOrig.clone({position=objectPosition})
    heroBag.putObject(objectOrig)

    objectCopy.setPosition(objectPosition)

    if(item["locked"]) then
      objectCopy.setLock(true)
    end
  end
end

function placeNemesis(heroBag, nemesisGuid)
  local nemesisPosition = {-21.11, 4, 35.18}
  local nemesisOrig = heroBag.takeObject({guid=nemesisGuid, position=nemesisPosition})
  local nemesisCopy = nemesisOrig.clone({position=nemesisPosition})
  heroBag.putObject(nemesisOrig)

  nemesisCopy.setScale({2.12, 1, 2.12})
end

function placeObligation(heroBag, obligationGuid)
  local encounterDeckPosition = {-12.75, 3, 22.25} --TODO: figure out why this produces an error: Global.getVar("ENCOUNTER_DECK_SPAWN_POS")
  local obligationOrig = heroBag.takeObject({guid=obligationGuid, position=encounterDeckPosition})
  local obligationCopy = obligationOrig.clone({position=encounterDeckPosition})
  heroBag.putObject(obligationOrig)

  obligationCopy.setScale({2.12, 1, 2.12})
end

function getOffsetPosition(origPosition, offset)
  return {origPosition[1] + offset[1], origPosition[2] + offset[2], origPosition[3] + offset[3]}
end




function createContextMenu()
    self.addContextMenuItem("Lay Out Heroes", layOutHeroes)
    self.addContextMenuItem("Delete Heroes", deleteHeroes)
end

function layOutHeroes()
    clearHeroes()
    layOutTiles()
end

function deleteHeroes()
    clearHeroes()
end

function clearHeroes()
    local allObjects = getAllObjects()

    for k,v in pairs(allObjects) do
        if(v.hasTag("hero-selector-tile")) then
            v.destruct()
        end
    end     
end

function layOutTiles()
    local bagList = getSortedListOfHeroes()
    log(bagList)
    local tileBag = getObjectFromGUID("01ad59")

    for bagGuid, tilePosition in pairs(bagList) do
        local tilePosition = tilePosition

        local heroBag = self.takeObject({guid=bagGuid})
        local tile = tileBag.takeObject({position=tilePosition, smooth=false})

        setupTile({
            heroBag=heroBag,
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
            local heroManager = getObjectFromGUID(Global.getVar("HERO_MANAGER_GUID"))
            heroManager.call("placeHeroWithStarterDeck", {heroBagGuid="]]..heroBagGuid..[[", playerColor=player_color})
        end
        function placeHeroWithHeroDeck(obj, player_color)
            local heroManager = getObjectFromGUID(Global.getVar("HERO_MANAGER_GUID"))
            heroManager.call("placeHeroWithHeroDeck", {heroBagGuid="]]..heroBagGuid..[[", playerColor=player_color})
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
