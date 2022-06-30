local playmatBagGuid = "e549db"
local deckImporterGuid = "c7ece0"
local healthCounterOffset = {-10.42, .1, 5.5}
local identityOffset = {-9.89, 3, 1}
local deckOffset = {-8.4, 3, -4.66}

function onLoad()
  self.setInvisibleTo({"Red", "Blue", "Green", "Yellow", "White"})
end

function placeHeroWithStarterDeck(params)
  placeHero(params.heroBagGuid, params.playerColor, "starter")
end

function placeHeroWithHeroDeck(params)
  placeHero(params.heroBagGuid, params.playerColor, "constructed")
end

function placeHero(heroBagGuid, playerColor, deckType)
  if(playerColor ~= "Red" and playerColor ~= "Blue" and playerColor ~= "Green" and playerColor ~= "Yellow") then
    broadcastToAll("Take a seat, hero! (Red, Blue, Green, or Yellow.)", {1,1,1})
    return
  end

  local heroesBag = getObjectFromGUID("22b26a")
  local heroBag = heroesBag.takeObject({guid=heroBagGuid})

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
    
      placeIdentity(
        heroBag, 
        heroDetails["identityGuid"], 
        playmatPosition)
    
      placeDeck(
        heroBag, 
        deckType, 
        heroDetails["starterDeckId"], 
        heroDetails["heroDeckId"], 
        playmatPosition)
    
      placeExtras(
        heroBag, 
        heroDetails["extras"], 
        playmatPosition)
    
      placeNemesis(
        heroBag, 
        heroDetails["nemesisGuid"])
    
      placeObligation(
        heroBag, 
        heroDetails["obligationGuid"])
    
        heroesBag.putObject(heroBag)
        end, 
    1)
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
