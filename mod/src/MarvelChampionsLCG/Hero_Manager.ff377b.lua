local deckImporterGuid = "c7ece0"
local healthCounterOffset = {-10.42, .1, 5.5}
local identityOffset = {-9.89, 3, 1}
local deckOffset = {-8.4, 3, -4.66}

local originPosition = {x=58.25, y=0.50, z=33.75}

local rowGap = -2.5
local columnGap = 5

local rows = 12

local assetBag = getObjectFromGUID("91eba8")

function onload(saved_data)
    createContextMenu()
    layOutHeroes()
end

function spawnAsset(params)
  params.caller = self
  assetBag.call("spawnAsset", params)
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
    
      if (heroDetails.identityGuid ~= nil) then
        placeIdentityOld(
          heroBag,
          heroDetails["identityGuid"],
          playmatPosition)
      else
        placeIdentity(
          heroDetails["identity"],
          playmatPosition
        )
      end

      if (heroDetails.starterDeckId ~= nil) then
        placeDeckOld(
          heroBag,
          deckType,
          heroDetails["starterDeckId"],
          heroDetails["heroDeckId"],
          playmatPosition
        )
      else
        placeDeck(
          deckType,
          heroDetails["starterDeck"],
          heroDetails["heroDeck"],
          playmatPosition
        )
      end

      placeExtras(
        heroBag,
        heroDetails["extras"],
        playmatPosition)

      if (heroDetails.nemesisGuid ~= nil) then
        placeNemesisOld(
          heroBag,
          heroDetails["nemesisGuid"])
      else
        placeNemesis(heroDetails["nemesis"])
      end

      if (heroDetails.obligationGuid ~= nil) then
        placeObligationOld(
          heroBag,
          heroDetails["obligationGuid"])
      else
        placeObligation(heroDetails["obligation"])
      end

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

function placePlaymat(playerColor, position, imageUrl)
  spawnAsset({
    guid="f5701e",
    playerColor=playerColor,
    position=position,
    rotation={0, 180, 0},
    playmatUrl=imageUrl,
    callback="configurePlaymat"
  })
end

function configurePlaymat(params)
  local playmat = params.spawnedObject
  local playmatUrl = params.playmatUrl

  playmat.setName("")
  playmat.setDescription("")
  playmat.setLock(true)
  playmat.addTag("Playmat")
  playmat.addTag(params.playerColor)
  playmat.setPosition(params.position)
  playmat.setCustomObject({image=playmatUrl})
  playmat.reload()
end

function placeHealthCounter(playmatPosition, imageUrl, hitPoints)
  spawnAsset({
    guid="16b5bd",
    position=getOffsetPosition(playmatPosition, healthCounterOffset),
    rotation={0, 180, 0},
    scale={1.13, 1, 1.13},
    imageUrl=imageUrl,
    hitPoints=hitPoints,
    callback="configureHealthCounter"
  })
end

function configureHealthCounter(params)
  local counter = params.spawnedObject
  local imageUrl = params.imageUrl
  local hitPoints = params.hitPoints
  
  counter.setName("")
  counter.setDescription("")
  counter.setLock(true)
  counter.setPosition(params.position)
  counter.setCustomObject({image=imageUrl})

  local reloadedCounter = counter.reload()

  Wait.frames(
    function()
      reloadedCounter.call("setValue", {value=hitPoints})
    end,
    10
  )
end

function placeIdentityOld(heroBag, identityGuid, playmatPosition)
  local identityPosition = getOffsetPosition(playmatPosition, identityOffset)
  local identityOrig = heroBag.takeObject({guid=identityGuid, position=identityPosition})
  local identityCopy = identityOrig.clone({position=identityPosition})
  heroBag.putObject(identityOrig)

  identityCopy.setName("")
  identityCopy.setDescription("")
  identityCopy.setScale({1.88, 1, 1.88})
  identityCopy.setPosition(identityPosition)
end

function placeIdentity(identity, playmatPosition)
  local identityPosition = getOffsetPosition(playmatPosition, identityOffset)
  getCardByID(identity, identityPosition, {scale = Global.getTable("CARD_SCALE_IDENTITY")})
end

function placeDeckOld(heroBag, deckType, starterDeckId, heroDeckId, playmatPosition)
  local deckPosition = getOffsetPosition(playmatPosition, deckOffset)

  if(deckType == "starter") then
    placeStarterDeck(starterDeckId, deckPosition)
  else
    placeHeroDeck(heroDeckId, deckPosition)
  end
end

function placeDeck(deckType, starterDeck, heroDeck, playmatPosition)
  local deckPosition = getOffsetPosition(playmatPosition, deckOffset)

  local deck = {
    position = deckPosition,
    scale = Global.getTable("CARD_SCALE_PLAYER")
  }

  if (deckType == "starter") then
    deck.cards = JSON.decode(starterDeck)
  else
    deck.cards = JSON.decode(heroDeck)
  end

  --TODO: Fix sizes for cards
  createDeck(deck)
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
  
  for key, item in pairs(extras) do
    local objectPosition = getOffsetPosition(playmatPosition, item["offset"])

    if (item.guid ~= nil) then
        local objectOrig = heroBag.takeObject({guid=item["guid"], position=objectPosition})
        local objectCopy = objectOrig.clone({position=objectPosition})
        heroBag.putObject(objectOrig)

        objectCopy.setPosition(objectPosition)

        if(item["locked"]) then
          objectCopy.setLock(true)
        end
    else
        -- This will need to grow but let's do it as port the heroes over to this approach.
        if (item.type == 'card') then
          getCardByID(item.id, objectPosition, {scale = Global.getTable("CARD_SCALE_PLAYER")})
        else
          log('Unable to spawn extra ' .. key)
        end
    end
  end
end

function placeNemesisOld(heroBag, nemesisGuid)
  local nemesisPosition = {-21.11, 4, 35.18}
  local nemesisOrig = heroBag.takeObject({guid=nemesisGuid, position=nemesisPosition})
  local nemesisCopy = nemesisOrig.clone({position=nemesisPosition})
  heroBag.putObject(nemesisOrig)

  nemesisCopy.setScale({2.12, 1, 2.12})
end

function placeNemesis(nemesis)
  local nemesisPosition = {-21.11, 4, 35.18}
  local deck = {
    cards = JSON.decode(nemesis),
    position = nemesisPosition,
    scale = Global.getTable("CARD_SCALE_ENCOUNTER")
  }
  --TODO: Fix sizes for cards
  createDeck(deck)
end

function placeObligationOld(heroBag, obligationGuid)
  local encounterDeckPosition = Vector(Global.getVar("ENCOUNTER_DECK_SPAWN_POS"))
  local obligationOrig = heroBag.takeObject({guid=obligationGuid, position=encounterDeckPosition})
  local obligationCopy = obligationOrig.clone({position=encounterDeckPosition})
  heroBag.putObject(obligationOrig)

  obligationCopy.setScale({2.12, 1, 2.12})
end

function placeObligation(obligation)
  local encounterDeckPosition = Vector(Global.getVar("ENCOUNTER_DECK_SPAWN_POS"))
  getCardByID(obligation, encounterDeckPosition, {scale = Global.getTable("CARD_SCALE_ENCOUNTER"), flipped=true})
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
    layOutHeroTiles()
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

-- function spawnHeroSelectors()
--   spawnAsset({
--     guid="c04e76",
--     position={70.25, -9.69, 7.25},
--     rotation={0, 180, 0},
--     scale={1.13, 1, 1.13},
--     callback="layOutHeroTiles"
--   })
-- end

function layOutHeroTiles()
  baseTile=getObjectFromGUID("c04e76")
  local bagList = getSortedListOfHeroes()

  for bagGuid, tilePosition in pairs(bagList) do
      local position = tilePosition

      local heroBag = self.takeObject({guid=bagGuid})

      Wait.frames(
        function()
          local heroDetails = heroBag.call("getHeroDetails")
          local imageUrl = heroDetails["counterUrl"]
          local heroName = string.gsub(heroBag.getName(), " Hero Bag", "")
          self.putObject(heroBag)
    
          tile = baseTile.clone({
            position=position,
            rotation={0,180,0},
            scale={1.13, 1, 1.13}})
    
          tile.setName(heroName)
          tile.setLock(true)
          tile.setPosition(position)
          tile.addTag("hero-selector-tile")
          tile.setCustomObject({image=imageUrl})
          reloadedTile = tile.reload()
        
          setTileFunctions(reloadedTile, bagGuid)
          createTileButtons(reloadedTile)
            
        end, 
        10)
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

local heroes = {}

function constructHeroList()

  heroes["adamWarlock"] = {
    name = "Adam Warlock",
    hitPoints = 11,
    counterUrl = "http://cloud-3.steamusercontent.com/ugc/1833524420371050034/61A7EE53D4D7DE302E99B49594CCBA6D4075BE91/",
    playmatUrl = "http://cloud-3.steamusercontent.com/ugc/1861691130254391544/53968F7E3F8F28287E82D74297D2B820CFDA630F/",
    identityCardId = 0,
    obligationCardId = 0,
    heroDeck = {
      cards = {
        ["21032"] =	1,
        ["21033"] =	1,
        ["21034"] =	1,
        ["21035"] =	1,
        ["21036"] =	2,
        ["21037"] =	2,
        ["21038"] =	3,
        ["21039"] =	2,
        ["21040"] =	2
      }
    },
    starterDeck = {
      cards = {
        ["21041"] =	1,
        ["21042"] =	1,
        ["21043"] =	1,
        ["21044"] =	1,
        ["21046"] =	1,
        ["21047"] =	1,
        ["21048"] =	1,
        ["21049"] =	1,
        ["21050"] =	1,
        ["21052"] =	1,
        ["21053"] =	1,
        ["21054"] =	1,
        ["21055"] =	1,
        ["21057"] =	1,
        ["21058"] =	1,
        ["21059"] =	1,
        ["21060"] =	1,
        ["21061"] =	1,
        ["21062"] =	1,
        ["21063"] =	1,
        ["21064"] =	1,
        ["21065"] =	1,
        ["22019"] =	1,
        ["23020"] =	1,
        ["25017"] =	1
      }
    },
    nemesis = {
      cards = {

      }
    }
  }
end

require('!/Cardplacer')
