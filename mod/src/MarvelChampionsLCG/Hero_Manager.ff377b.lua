local deckImporterGuid = "c7ece0"
local healthCounterOffset = {-10.42, .1, 5.5}
local identityOffset = {-9.89, 3, 1}
local deckOffset = {-8.4, 3.0, -4.66}
local discardOffset = {-11.3, 2.0, -4.66}

local originPosition = {x=58.25, y=0.50, z=33.75}

local rowGap = -2.5
local columnGap = 5

local rows = 12

local heroes = {}
local selectedHeroes = {}

local assetBag = getObjectFromGUID("91eba8")

function onload(saved_data)
  if(saved_data ~= "") then
      local loaded_data = JSON.decode(saved_data)
      selectedHeroes = loaded_data.selectedHeroes
  end
  
  createContextMenu()
  layOutHeroes()
end

function spawnAsset(params)
  params.caller = self
  assetBag.call("spawnAsset", params)
end

function placeHeroWithStarterDeck(params)
  placeHero(params.heroKey, params.playerColor, "starter")
end

function placeHeroWithHeroDeck(params)
  placeHero(params.heroKey, params.playerColor, "constructed")
end

function placeHero(heroKey, playerColor, deckType)
  if not confirmPlayerIsSeated(playerColor) then return end
  if not confirmSeatIsAvailable(playerColor) then return end

  local hero = deepCopy(heroes[heroKey])
  local playmatPosition = getPlaymatPosition(playerColor)
  
  placePlaymat(
    playerColor, 
    playmatPosition, 
    hero.playmatImageUrl
  )
    
  placeHealthCounter(
    playmatPosition,
    hero.counterImageUrl,
    hero.hitPoints
  )

  placeIdentity(
    hero,
    playmatPosition
  )

  placeDeck(
    hero,
    deckType,
    playmatPosition
  )

  Wait.frames(
    function()
      placeCards(
        hero,
        playerColor,
        playmatPosition
      )
    end,
    30
  )

  Wait.frames(
    function()
      placeExtras(
        hero,
        playmatPosition
      )
    end,
    120
  )

  --placeNemesis(hero)

  placeObligation(hero)
    
  selectedHeroes[playerColor] = hero

  local saved_data = JSON.encode({selectedHeroes = selectedHeroes})
  self.script_state = saved_data
end

function physicsTest(params)
  local playerColor = "Blue"
  local hero = getHeroByPlayerColor({playerColor = playerColor})
  local playmatPosition = getPlaymatPosition(playerColor)

  placeCards(
    hero,
    playerColor,
    playmatPosition
  )
end

function getHeroByPlayerColor(params)
  return selectedHeroes[params.playerColor]
end

function getPlayerDeckPositions(params)
  local includeDiscard = params.includeDiscard or false
  local hero = params.hero

  local deckPositions = {}
  local deckPosition = hero.deckPosition
  deckPosition[2] = -0.5

  table.insert(deckPositions, deckPosition)

  if(includeDiscard) then
    local discardPosition = hero.discardPosition
    discardPosition[2] = -0.5
    table.insert(deckPositions, discardPosition)
  end

  return deckPositions
end

function deepCopy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[deepCopy(k, s)] = deepCopy(v, s) end
  return res
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
  local reloadedPlaymat = playmat.reload()

  Wait.frames(
    function()
      reloadedPlaymat.call("setPlayerColor", {color = params.playerColor})
    end,
  30)
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
    60
  )
end

function placeIdentity(hero, playmatPosition)
  local position = getOffsetPosition(playmatPosition, identityOffset)
  local scale = Global.getTable("CARD_SCALE_IDENTITY")
  if(hero.identityAssetGuid ~= nil) then
    log(hero.identityAssetGuid)
    spawnAsset({
      guid = hero.identityAssetGuid,
      position = position,
      rotation = {0, 180, 0},
      scale = scale,
      callback = "configureIdentity"
    })
    return
  end
  
  getCardByID(hero.identityCardId, position, {scale = scale})
end

function configureIdentity(params)
  log("configureIdentity")
  log(params)
  local identity = params.spawnedObject
  identity.setPosition(params.position)
end

function placeDeck(hero, deckType, playmatPosition)
  local deckPosition = getOffsetPosition(playmatPosition, deckOffset)
  local discardPostition = getOffsetPosition(playmatPosition, discardOffset)

  hero.deckPosition = deckPosition
  hero.discardPosition = discardPostition

  local deck = {
    cards = {},
    position = deckPosition,
    scale = Global.getTable("CARD_SCALE_PLAYER")
  }

  for k, v in pairs(hero.decks.hero) do
    deck.cards[k] = v
  end

  if (deckType == "starter") then
    for k, v in pairs(hero.decks.starter) do
      deck.cards[k] = v
    end
  end

  createDeck(deck)
end

function placeCards(hero, playerColor, playmatPosition)
  if(hero.cards == nil) then
    return
  end

  for key, card in pairs(hero.cards) do
    local cardPosition = getOffsetPosition(playmatPosition, card["offset"])

    findAndPlacePlayerCard({
      hero = hero,
      cardName = card["name"],
      position = cardPosition,
      scale = card["scale"],
      rotation = card["rotation"],
      flipped = card["flipped"]
    })
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

function placeExtras(hero, playmatPosition)
  if(hero.extras == nil) then
    return
  end
  
  for key, item in pairs(hero.extras) do
    local itemPosition = getOffsetPosition(playmatPosition, item["offset"])
    local lockItem = false

    if(item.locked ~= nil) then
      lockItem = item.locked
    end

    if(item.type == "counter") then
      local counterBag

      if(item.counterType == "general") then
        counterBag = getObjectFromGUID("aec1c4")
      end
      --get a different counter bag for other types

      counterBag.takeObject({
        position = itemPosition,
        smooth = false,
        callback_function = function(counter) 
          counter.setPosition(itemPosition)
          counter.setLock(lockItem)
          counter.setName(item.name)

          Wait.frames(
            function()
              counter.call("setValue", {value = item.value or 0})
            end,
            1)
        end
      })

    end

    if(item.type == "status") then
    end

    if(item.type == "deck") then
      local deck = {
        cards = item.cards,
        position = itemPosition,
        scale = Global.getTable("CARD_SCALE_PLAYER")
      }

      createDeck(deck)
    end

    if(item.type == "asset") then
      spawnAsset({
        guid = item.assetGuid,
        position = itemPosition,
        rotation = item.rotation,
        callback = "configureAsset"
      })
    end
  end
end

function configureAsset(params)
  local asset = params.spawnedObject
  asset.setPosition(params.position)

  if(params.rotation ~= nil) then
    asset.setRotation(params.rotation)
  end
end

function placeObligation(hero)
  local encounterDeckPosition = Vector(Global.getVar("ENCOUNTER_DECK_SPAWN_POS"))
  getCardByID(hero.obligationCardId, encounterDeckPosition, {scale = Global.getTable("CARD_SCALE_ENCOUNTER"), flipped=true})
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

function layOutHeroTiles()
  local baseTile=getObjectFromGUID("c04e76")
  local heroList = getSortedListOfHeroes()

  local row = 1
  local column = 1
  local orderedList = {}

  for _, v in ipairs(heroList) do
    local hero = v.hero
    local heroKey = v.heroKey
    local position = getTilePosition(column, row)

    tile = baseTile.clone({
      position=position,
      rotation={0,180,0},
      scale={1.13, 1, 1.13}})

    tile.setName(hero.name)
    tile.setDescription("")
    tile.setLock(true)
    tile.setPosition(position)
    tile.addTag("hero-selector-tile")
    tile.setCustomObject({image=hero.counterImageUrl})
    reloadedTile = tile.reload()
  
    setTileFunctions(reloadedTile, heroKey)
    createTileButtons(reloadedTile) 

    row = row + 1
    if row > rows then
        row = 1
        column = column + 1
    end
  end
end

function getSortedListOfHeroes()
    local heroList = {}

    for k, v in pairs(heroes) do
      table.insert (heroList, {heroKey = k, hero = v})
    end

    local compareHeroNames = function(a,b)
      return a.hero.name < b.hero.name
    end

    return table.sort(heroList, compareHeroNames)
end

function getTilePosition(column, row)
    return {
        originPosition.x + columnGap * (column - 1), 
        originPosition.y, 
        originPosition.z + rowGap * (row - 1)}
end

function setTileFunctions(tile, heroKey)
    local tileScript = [[
        function placeHeroWithStarterDeck(obj, player_color)
            local heroManager = getObjectFromGUID(Global.getVar("HERO_MANAGER_GUID"))
            heroManager.call("placeHeroWithStarterDeck", {heroKey="]]..heroKey..[[", playerColor=player_color})
        end
        function placeHeroWithHeroDeck(obj, player_color)
            local heroManager = getObjectFromGUID(Global.getVar("HERO_MANAGER_GUID"))
            heroManager.call("placeHeroWithHeroDeck", {heroKey="]]..heroKey..[[", playerColor=player_color})
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

function findAndPlacePlayerCard(params)
  local hero = params.hero
  local cardName = params.cardName
  local position = params.position
  local scale = params.scale or Global.getTable("CARD_SCALE_PLAYER")
  local deckPositions = getPlayerDeckPositions({hero = hero, includeDiscard = true})
  local decks = {}

  for _, deckPosition in pairs(deckPositions) do
    local deckOrCard = getDeckOrCardAtLocation(deckPosition)
    if(deckOrCard ~= nil) then
      if(deckOrCard.tag == "Deck") then
        table.insert(decks, deckOrCard)
      else
        if(deckOrCard.getName() == cardName) then
          rotation = params.rotation or {0, 180, 180}

          if(params.flipped) then
            rotation = {rotation[1], rotation[2], 0}
          end

          deckOrCard.setPositionSmooth(position)
          deckOrCard.setRotationSmooth(rotation)
          deckOrCard.setScale(scale)
          return
        end
      end
    end
  end

  local cardInDeck = findCardInDecks(decks, cardName)
  
  if(cardInDeck ~= nil) then
    placeCardFromDeck(cardInDeck.deck, cardInDeck.cardGuid, position, scale, params.rotation, params.flipped)
    return
  end

end

function findCardInDecks(decks, cardName)
  for _, deck in pairs(decks) do
    for _, card in pairs(deck.getObjects()) do
      if(card.name == cardName) then
        return {
          deck = deck,
          cardGuid = card.guid
        }
      end
    end
  end
end

function placeCardFromDeck(deck, cardGuid, position, scale, rotation, flipped)
  local cardScale = scale or deck.getScale()
  local cardRotation = rotation or deck.getRotation()

  if(flipped) then
    cardRotation = {cardRotation[1], cardRotation[2], 0}
  end

  deck.takeObject(
    {
      guid = cardGuid,
      position = position,
      scale = cardScale,
      rotation = cardRotation,
      smooth = true,
      callback_function = function(card)
        card.setScale(cardScale)
      end
    }
  )
end

function getDeckOrCardAtLocation(position)
  local objects = findObjectsAtPosition(position)
  for _, object in pairs(objects) do
    if(object.tag == "Deck" or object.tag == "Card") then
      return object
    end
  end

  return nil
end

function findObjectsAtPosition(position)
  local objList = Physics.cast({
     origin       = position,
     direction    = {0,1,0},
     type         = 3,
     size         = {0.5,10,0.5},
     max_distance = 0,
     debug        = false,
  })
  local objects = {}
  for _, obj in ipairs(objList) do
     table.insert(objects, obj.hit_object)
  end
  return objects
end


require('!/Cardplacer')

require('!/heroes/adam_warlock')
require('!/heroes/wolverine')
require('!/heroes/colossus')
require('!/heroes/cyclops')
require('!/heroes/black_panther')
require('!/heroes/black_widow')
require('!/heroes/hawkeye')
require('!/heroes/cable')
require('!/heroes/domino')
require('!/heroes/captain_america')
require('!/heroes/captain_marvel')
require('!/heroes/she_hulk')
require('!/heroes/spider_man_peter')
require('!/heroes/iron_man')
require('!/heroes/drax')
require('!/heroes/gambit')
require('!/heroes/gamora')
require('!/heroes/ghost_spider')
require('!/heroes/spider_man_miles')
require('!/heroes/hulk')
require('!/heroes/rocket_raccoon')
require('!/heroes/groot')
require('!/heroes/ms_marvel')
require('!/heroes/nebula')
require('!/heroes/nova')
require('!/heroes/quicksilver')
require('!/heroes/scarlet_witch')
require('!/heroes/spider_ham')
require('!/heroes/spider_woman')
require('!/heroes/star_lord')
require('!/heroes/thor')
require('!/heroes/valkyrie')
require('!/heroes/venom')
require('!/heroes/vision')
require('!/heroes/war_machine')
require('!/heroes/phoenix')
require('!/heroes/rogue')
require('!/heroes/shadowcat')
require('!/heroes/sp_dr')
require('!/heroes/doctor_strange')
require('!/heroes/storm')
require('!/heroes/ant_man')
require('!/heroes/wasp')
require('!/heroes/ironheart')
require('!/heroes/spectrum')
