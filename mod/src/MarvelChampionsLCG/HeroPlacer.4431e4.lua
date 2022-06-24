local playmatBagGuid = "e549db"
local healthCounterOffset = {-10.42, .1, 5.5}
local identityOffset = {-9.89, 3, 1}
local deckOffset = {-8.4, 3, -4.66}

function onLoad()
  self.setInvisibleTo({"Red", "Blue", "Green", "Yellow", "White"})
end

function placeHero(params)
  local playerColor = params["playerColor"]

  if(playerColor ~= "Red" and playerColor ~= "Blue" and playerColor ~= "Green" and playerColor ~= "Yellow") then
    broadcastToAll("Take a seat, hero! (Red, Blue, Green, or Yellow.)", {1,1,1})
    return
  end

  local heroBag = params["heroBag"]
  local deckType = params["deckType"]
  local heroDetails = heroBag.call("getHeroDetails")
  local playmatPosition = getPlaymatPosition(playerColor)

  placePlaymat(playerColor, playmatPosition, heroDetails["playmatUrl"])
  placeHealthCounter(heroBag, heroDetails["counterGuid"], playmatPosition)
  placeIdentity(heroBag, heroDetails["identityGuid"], playmatPosition)
  placeDeck(heroBag, deckType, heroDetails["starterDeckGuid"], heroDetails["heroDeckGuid"], playmatPosition)
  placeExtras(heroBag, heroDetails["extras"], playmatPosition)
  placeNemesis(heroBag, heroDetails["nemesisGuid"])
  placeObligation(heroBag, heroDetails["obligationGuid"])
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

function placeHealthCounter(heroBag, counterGuid, playmatPosition)
  local counterPosition = getOffsetPosition(playmatPosition, healthCounterOffset)
  local counterOrig = heroBag.takeObject({guid=counterGuid, position=counterPosition})
  local counterCopy = counterOrig.clone({position=counterPosition})
  heroBag.putObject(counterOrig)

  counterCopy.setName("")
  counterCopy.setDescription("")
  counterCopy.setLock(true)
  counterCopy.setScale({1.13, 1, 1.13})
  counterCopy.setPosition(counterPosition)
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

function placeDeck(heroBag, deckType, starterDeckGuid, heroDeckGuid, playmatPosition)
  local deckGuid = (deckType == "starter" and starterDeckGuid or heroDeckGuid)
  local deckPosition = getOffsetPosition(playmatPosition, deckOffset)
  local deckOrig = heroBag.takeObject({guid=deckGuid, position=deckPosition})
  local deckCopy = deckOrig.clone({position=deckPosition})
  heroBag.putObject(deckOrig)

  deckCopy.setName("")
  deckCopy.setDescription("")
  deckCopy.setScale({1.27, 1, 1.27})
  deckCopy.setPosition(deckPosition)
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
