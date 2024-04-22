preventDeletion = true

local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
local encounterSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))
local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
local assetBag = getObjectFromGUID("91eba8")

local defaults = {
  villainHpCounter = {
    position = Global.getTable("VILLAIN_HEALTH_COUNTER_POSITION"),
    rotation = Global.getTable("VILLAIN_HEALTH_COUNTER_ROTATION"),
    scale = Global.getTable("VILLAIN_HEALTH_COUNTER_SCALE")
  },
  encounterDeck = {
    position = Global.getTable("ENCOUNTER_DECK_POSITION"),
    rotation = Global.getTable("ENCOUNTER_DECK_ROTATION"),
    scale = Global.getTable("ENCOUNTER_DECK_SCALE"),
    discardPosition = Global.getTable("ENCOUNTER_DECK_DISCARD_POSITION")
  },
  villainDeck = {
    position = Global.getTable("VILLAIN_POSITION"),
    rotation = Global.getTable("VILLAIN_ROTATION"),
    scale = Global.getTable("VILLAIN_SCALE")
  },
  mainSchemeDeck = {
    position = Global.getTable("MAIN_SCHEME_POSITION"),
    rotation = Global.getTable("MAIN_SCHEME_ROTATION"),
    scale = Global.getTable("MAIN_SCHEME_SCALE")
  },
  mainSchemeThreatCounter = {
    position = Global.getTable("MAIN_THREAT_COUNTER_POSITION"),
    rotation = Global.getTable("MAIN_THREAT_COUNTER_ROTATION"),
    scale = Global.getTable("MAIN_THREAT_COUNTER_SCALE")
  },
  blackHole = {
    position = Global.getTable("BLACK_HOLE_POSITION"),
    rotation = Global.getTable("BLACK_HOLE_ROTATION"),
    scale = Global.getTable("BLACK_HOLE_SCALE")
  },
  sideScheme = {
    position = Global.getTable("SIDE_SCHEME_POSITION"),
    rotation = Global.getTable("SIDE_SCHEME_ROTATION")
  }
}

local scenarios = {}
local currentScenario = nil

function onload(saved_data)
  createContextMenu()
  --layOutScenarios()
end

function clearData()
  currentScenario = nil
  self.script_state = ""
end

function loadSavedData(saved_data)
  if saved_data ~= "" then
     local loaded_data = JSON.decode(saved_data)
     currentScenario = loaded_data
  end
end

function saveData()
  local saved_data = JSON.encode(currentScenario)
  self.script_state = saved_data
end

function setMode(params)
  currentScenario.mode = params.mode
  saveData()
end

function setStandardSet(params)
  currentScenario.standardSet = params.set
  saveData()
end

function setExpertSet(params)
  currentScenario.expertSet = params.set
  saveData()
end

function spawnAsset(params)
  params.caller = self
  return assetBag.call("spawnAsset", params)
end

function placeUnscriptedScenario(params)
  placeScenario(params.scenarioKey, "")
end

function placeScenarioInStandardMode(params)
  placeScenario(params.scenarioKey, "standard")
end

function placeScenarioInExpertMode(params)
  placeScenario(params.scenarioKey, "expert")
end

function selectScenario(params)
  currentScenario = deepCopy(scenarios[params.scenarioKey])
  currentScenario.key = params.scenarioKey

  if(currentScenario.villains) then
    for key, villain in pairs(currentScenario.villains) do
      villain.key = key
  
      if(villain.stages) then
        for stageKey, stage in pairs(villain.stages) do
          stage.key = stageKey
        end        
      end
    end  
  end

  if(currentScenario.schemes) then
    for key, scheme in pairs(currentScenario.schemes) do
      scheme.key = key
      
      if(scheme.stages) then
        for stageKey, stage in pairs(scheme.stages) do
          stage.key = stageKey
        end
      end
    end      
  end

  encounterSetManager.call("preSelectEncounterSets", {sets = currentScenario.modularSets or {}})

  saveData()

  --TODO: This might belong in the setup panel
  layoutManager.call("highlightSelectedSelectorTile", {itemType = "scenario", itemKey = params.scenarioKey})
end

function hideSelectors()
  layoutManager.call("hideSelectors", {itemType = "scenario"})
end

function showSelectors()
  selectedScenarioKey = currentScenario and currentScenario.key or nil

  layoutManager.call("showSelectors", {itemType = "scenario"})
  layoutManager.call("highlightSelectedSelectorTile", {itemType = "scenario", itemKey = selectedScenarioKey})
end

function placeScenario(scenarioKey, mode)
  if not confirmNoScenarioIsPlaced() then return end

  local heroCount = heroManager.call("getHeroCount")
  local scenario = scenarios[scenarioKey];
  local delay = 0

  for _, villain in pairs(scenario.villains) do
    Wait.frames(
      function()
        placeVillainHpCounter(villain, heroCount)
        placeVillain(villain)
      end,
      delay
    )

    delay = delay + 10
  end

  for _, deck in pairs(scenario.decks) do
    placeDeck(deck)
  end

  for _, scheme in pairs(scenario.schemes) do
    placeScheme(scheme, heroCount)
  end

  placeBlackHole(scenario)

  placeModularSets(scenario)

  if(scenario.cards ~= nil) then
    for _, card in pairs(scenario.cards) do
      getCardByID(card.cardId, card.position, {scale = card.scale, name = card.name, flipped = card.flipped, landscape = card.landscape})
    end
  end

  if(scenario.counters ~= nil) then
    for _, counter in pairs(scenario.counters) do
      Wait.time(
        function()
          if(counter.type == "threat") then
            placeThreatCounter(counter, 0)
          else
            placeGeneralCounter(counter)
          end
        end,
        1)
    end
  end

  placeExtras(scenarioBag, scenarioDetails.extras)

  placeBoostPanel(scenario)
end

function confirmNoScenarioIsPlaced()
  return true --TODO: Implement this
end

function setUpScenario()
  if(not confirmScenarioInputs(true)) then return end

  --setUpZones()

  local heroCount = heroManager.call("getHeroCount")

  startLuaCoroutine(self, "setUpVillains")
  startLuaCoroutine(self, "setUpSchemes")
  startLuaCoroutine(self, "setUpDecks")

  -- Wait.frames(
  --   function()
  --     initiateFirstStages(heroCount)
  --   end,
  --   30
  -- )
  
  setUpCards()
  setUpCounters(heroCount)

  --placeExtras(scenarioBag, scenarioDetails.extras)
  placeBlackHole(currentScenario)
  placeBoostPanel(currentScenario)
end

function initiateFirstStages(heroCount)
  for _, villain in pairs(currentScenario.villains) do
    advanceVillainStage(villain.key, heroCount)
  end

  for _, scheme in pairs(currentScenario.schemes) do
    if(scheme.stages["stage1"] ~= nil) then
      advanceSchemeStage(scheme.key, heroCount)
    end
  end
end

function setUpZones()
  local environmentZone = spawnObject({
    type = "LayoutZone",
    position = {19.50, 1.50, 30.00},
    scale = {15.00, 3.00, 7.00},
    sound = false,
    callback_function = function(zone)
      zone.LayoutZone.setOptions({
        combine_into_decks = false,
        horizontal_group_padding = 0.5,
        instant_refill = true,
        manual_only = false,
        max_objects_per_group = 1,
        new_object_facing = 0,
        trigger_for_face_down = true,
        trigger_for_face_up = true,
        trigger_for_non_cards = false
      })
    end
  })
end

function confirmScenarioInputs(postMessage)
  local heroCount = heroManager.call("getHeroCount")

  if heroCount == 0 then
    if postMessage then
      broadcastToAll("Please select at least one hero.", {1,1,1})
    end
    return false
  end

  if currentScenario == nil then
    if postMessage then
      broadcastToAll("Please select a scenario.", {1,1,1})
    end
    return false
  end

  local additionalEncounterSets = getRequiredEncounterSetCount() - encounterSetManager.call("getSelectedSetCount")

  if additionalEncounterSets > 0 then
    if postMessage then
      local plural = additionalEncounterSets > 1 and "s" or ""
      broadcastToAll("Please select at least " .. additionalEncounterSets .. " more encounter set" .. plural .. ".", {1,1,1})
    end
    return false
  end

  if currentScenario.mode == nil then
    if postMessage then
      broadcastToAll("Please select a mode.", {1,1,1})
    end
    return false
  end

  if currentScenario.standardSet == nil then
    if postMessage then
      broadcastToAll("Please select a standard encounter set.", {1,1,1})
    end
    return false
  end

  if currentScenario.mode == "expert" and currentScenario.expertSet == nil then
    if postMessage then
      broadcastToAll("Please select an expert encounter set.", {1,1,1})
    end
    return false
  end

  return true
end

function getRequiredEncounterSetCount()
  if (currentScenario == nil or currentScenario.modulaarSets == nil) then 
    return 0 
  end

  local sets = 0

  for _, encounterSet in pairs(currentScenario.modularSets) do
    sets = sets + 1
  end

  return sets
end

function setUpVillains()
  local heroCount = heroManager.call("getHeroCount")

  for key, villain in pairs(currentScenario.villains) do
      villain.key = key
      setUpVillain(villain, heroCount)

      local count = 0
      while count < 5 do
          count = count + 1
          coroutine.yield(0)
      end
  end

  return 1
end

function setUpVillain(villain, heroCount)
  local setUpFunction = "setUpVillain_" .. villain.key
  if(self.getVar(setUpFunction) ~= nil) then
    self.call(setUpFunction, {villain = villain, heroCount = heroCount})
    return
  end

  placeVillainHpCounter(villain, 0, false)

  Wait.frames(
    function()
      advanceVillainStage(villain.key, heroCount)
    end,
    15
  )
end

function placeVillainHpCounter(villain, hitPoints, showAdvanceButton)
  local counter = villain.hpCounter or {}

  local position = counter.position or defaults.villainHpCounter.position
  local rotation = counter.rotation or defaults.villainHpCounter.rotation
  local scale = counter.scale or defaults.villainHpCounter.scale

  local locked = true;
  if(counter.locked ~= nil) then
    locked = counter.locked
  end

  if(counter.guid ~= nil) then
    -- local villainHpCounterOrig = scenarioBag.takeObject({guid = villain.hpCounter.guid, position = counterPosition})
    -- villainHpCounter = villainHpCounterOrig.clone({position = counterPosition})
    -- scenarioBag.putObject(villainHpCounterOrig)
  else
    local hpCounter = spawnAsset({
      guid = Global.getVar("ASSET_GUID_VILLAIN_HEALTH_COUNTER"),
      position = position,
      rotation = rotation,
      scale = scale,
      imageUrl = villain.hpCounter.imageUrl,
      lock = locked,
      hitPoints = hitPoints,
      showAdvanceButton = showAdvanceButton,
      villain = villain,
      callback = "configureVillainHpCounter"
    })
  end
end

function configureVillainHpCounter(params)
  local counter = params.spawnedObject
  local hitPoints = params.hitPoints or 0
  local villain = params.villain

  counter.setPosition(params.position)
  counter.setName("")
  counter.setDescription("")
  counter.setLock(params.lock)
  counter.setCustomObject({image = params.imageUrl})

  Wait.frames(
    function()
      counter.call("setVillainKey", {villainKey = villain.key})
      local reloadedCounter = counter.reload()
      currentScenario.villains[villain.key].hpCounter.guid = reloadedCounter.getGUID()
    end,
    10
  )
end

function placeMainSchemeThreatCounter(scheme, threat, showAdvanceButton)
  local counter = scheme.threatCounter or {}

  local position = counter.position or defaults.mainSchemeThreatCounter.position
  local rotation = counter.rotation or defaults.mainSchemeThreatCounter.rotation
  local scale = counter.scale or defaults.mainSchemeThreatCounter.scale

  local locked = true;
  if(counter.locked ~= nil) then
    locked = counter.locked
  end

  local threatCounter = spawnAsset({
    guid = Global.getVar("ASSET_GUID_MAIN_THREAT_COUNTER"),
    position = position,
    rotation = rotation,
    scale = scale,
    lock = locked,
    threat = threat,
    showAdvanceButton = showAdvanceButton,
    scheme = scheme,
    callback = "configureMainSchemeThreatCounter"
  })
end

function configureMainSchemeThreatCounter(params)
  local counter = params.spawnedObject
  local threat = params.threat or 0
  local scheme = params.scheme

  counter.setPosition(params.position)
  counter.setRotation(params.rotation)
  counter.setScale(params.scale)
  counter.setName("")
  counter.setDescription("")
  counter.setLock(params.lock)

  Wait.frames(
    function()
      counter.call("setSchemeKey", {schemeKey = scheme.key})
      local threatCounter = currentScenario.schemes[scheme.key].counter or {}
      threatCounter.guid = counter.getGUID()
      currentScenario.schemes[scheme.key].counter = threatCounter
    end,
    10
  )
end

function setUpSchemes()
  local heroCount = heroManager.call("getHeroCount")

  for _, scheme in pairs(currentScenario.schemes) do
      setUpScheme(scheme, heroCount)
      local count = 0
      while count < 5 do
          count = count + 1
          coroutine.yield(0)
      end
  end

  return 1
end

function setUpScheme(scheme, heroCount)
  local setUpFunction = "setUpScheme_" .. scheme.key
  if(self.getVar(setUpFunction) ~= nil) then
    self.call(setUpFunction, {scheme = scheme, heroCount = heroCount})
    return
  end

  local schemePosition = scheme.position or defaults.mainSchemeDeck.position
  local schemeRotation = scheme.rotation or defaults.mainSchemeDeck.rotation
  local schemeScale = scheme.scale or defaults.mainSchemeDeck.scale

  local stage = scheme.stages["stage1"]

  placeMainSchemeThreatCounter(scheme, 0, false)

  Wait.frames(
    function()
      advanceSchemeStage(scheme.key, heroCount)
    end,
    30
  )
end

function setUpDecks()
  for key, deck in pairs(currentScenario.decks) do
      setUpDeck(deck, string.sub(key, 1, 9)=="encounter")
      local count = 0
      while count < 5 do
          count = count + 1
          coroutine.yield(0)
      end
  end

  return 1  
end

function getEncounterDeckPosition()
  return currentScenario.encounterDeckPosition or defaults.encounterDeck.position
end

function getEncounterDiscardPosition()
  return currentScenario.encounterDiscardPosition or defaults.encounterDeck.discardPosition
end

function setUpDeck(deck, isEncounterDeck)
  if(isEncounterDeck) then
    deck = deepCopy(deck)

    currentScenario.encounterDeckPosition = deck.position or defaults.encounterDeck.position
    currentScenario.encounterDiscardPosition = deck.discardPosition or defaults.encounterDeck.discardPosition

    addEncounterSetsToEncounterDeck(deck)
    addObligationCardsToEncounterDeck(deck)
    addStandardEncounterSetsToEncounterDeck(deck)
  end

  placeDeck(deck)
end

function addEncounterSetsToEncounterDeck(deck)
  local encounterSetCards = encounterSetManager.call("getCardsFromSelectedSets")

  for cardId, count in pairs(encounterSetCards) do
    deck.cards[cardId] = count
  end
end

function addObligationCardsToEncounterDeck(deck)
  local obligationCards = heroManager.call("getObligationCards")

  for cardId, count in pairs(obligationCards) do
    deck.cards[cardId] = count
  end
end

function addStandardEncounterSetsToEncounterDeck(deck)
  if(currentScenario.standardSet == "i") then
    deck.cards["01186"]=2
    deck.cards["01187"]=2
    deck.cards["01188"]=1
    deck.cards["01189"]=1
    deck.cards["01190"]=1
  else
    deck.cards["24050"]=2
    deck.cards["24051"]=1
    deck.cards["24052"]=1
    deck.cards["24053"]=1
    deck.cards["24054"]=2

    --TODO: Place environment card 24049
  end

  if(currentScenario.expertSet == "i") then
    deck.cards["01191"]=1
    deck.cards["01192"]=1
    deck.cards["01193"]=1
  elseif(currentScenario.expertSet == "ii") then
    deck.cards["24029"]=1
    deck.cards["24030"]=1
    deck.cards["24031"]=1
    deck.cards["24032"]=1
  end
end

function setUpCards()
  if(currentScenario.cards == nil) then return end

  for _, card in pairs(currentScenario.cards) do
    getCardByID(card.cardId, card.position, {scale = card.scale, name = card.name, flipped = card.flipped, landscape = card.landscape})
  end
end

function setUpCounters(heroCount)
  if(currentScenario.counters == nil) then return end

  for _, counter in pairs(currentScenario.counters) do
    Wait.time(
      function()
        if(counter.type == "threat") then
          local threat = (counter.threat or 0) + ((counter.threatPerPlayer or 0) * heroCount)
          placeThreatCounter(counter, threat)
        else
          placeGeneralCounter(counter)
        end
      end,
      1)
  end
end

function placeVillain(villain)
  local villainPosition = villain.deckPosition or defaults.villainDeck.position
  local villainRotation = villain.deckRotation or defaults.villainDeck.rotation
  local villainScale = villain.deckScale or defaults.villainDeck.scale

  --TODO: only place the cards that are needed, based on mode
  if(villain.stage7 ~= nil) then --TODO: Remove this after adding scripting to Morlock Siege scenario
    getCardByID(villain.stage4.cardId, villainPosition, {scale = villainScale, name = villain.name, flipped = false})
  end

  if(villain.stage6 ~= nil) then
    getCardByID(villain.stage4.cardId, villainPosition, {scale = villainScale, name = villain.name, flipped = false})
  end

  if(villain.stage5 ~= nil) then
    getCardByID(villain.stage4.cardId, villainPosition, {scale = villainScale, name = villain.name, flipped = false})
  end

  if(villain.stage4 ~= nil) then --TODO: Remove this after adding scripting to Mansion Attack scenario
    getCardByID(villain.stage4.cardId, villainPosition, {scale = villainScale, name = villain.name, flipped = false})
  end

  if(villain.stage3 ~= nil) then
    getCardByID(villain.stage3.cardId, villainPosition, {scale = villainScale, name = villain.name, flipped = false})
  end

  if(villain.stage2 ~= nil) then
    
    Wait.time(
      function()
        getCardByID(
          villain.stage2.cardId, 
          villainPosition, 
          {scale = villainScale, name = villain.name, flipped = false}) 
      end,
      .5)
    
  end
  
  if(villain.stage1 ~= nil) then
    Wait.time(
      function()
        getCardByID(
          villain.stage1.cardId, 
          villainPosition, 
          {scale = villainScale, name = villain.name, flipped = false})
      end,
      1)
  end
end

function placeDeck(deck)
  local deckPosition = deck.position or defaults.encounterDeck.position
  local deckRotation = deck.rotation or defaults.encounterDeck.rotation
  local deckScale = deck.scale or defaults.encounterDeck.scale

  createDeck({cards = deck.cards, position = deckPosition, scale = deckScale, name = deck.name})
end

function placeScheme(scheme, heroCount)
  local schemePosition = scheme.position or defaults.mainSchemeDeck.position
  local schemeRotation = scheme.rotation or defaults.mainSchemeDeck.rotation
  local schemeScale = scheme.scale or defaults.mainSchemeDeck.scale

  --There may be a better way to iterate over the stages backward
  local delay = 0
  for i = 5, 1, -1 do
    if(scheme.stages["stage"..i] ~= nil) then
      Wait.time(
        function()
          getCardByID(scheme.stages["stage"..i].cardId, schemePosition, {scale = schemeScale, name = scheme.name, flipped = false, landscape = true})
        end,
        delay
      )
      delay = delay + 0.5
    end
  end

  -- local counter = scheme.counter or {}

  -- Wait.time(
  --   function()
  --     placeThreatCounter(counter, 0)
  --   end,
  --   1
  -- )
end

function placeThreatCounter(counter, threat)
  local threatCounterPosition = counter.position or defaults.mainSchemeThreatCounter.position
  local threatCounterRotation = counter.rotation or defaults.mainSchemeThreatCounter.rotation
  local threatCounterScale = counter.scale or defaults.mainSchemeThreatCounter.scale

  local threatCounterBag = getObjectFromGUID(Global.getVar("GUID_THREAT_COUNTER_BAG"))
  local threatCounter = threatCounterBag.takeObject({position = threatCounterPosition, smooth = false})

  local locked = true;
  if(counter.locked ~= nil) then
    locked = counter.locked
  end

  Wait.frames(
    function()
      threatCounter.setRotation(threatCounterRotation)
      threatCounter.setScale(threatCounterScale)
      threatCounter.setLock(locked)
      threatCounter.call("setValue", {value = threat})
    end,
    1
  )
end

function placeGeneralCounter(counter)
  local counterPosition = counter.position or defaults.mainSchemeThreatCounter.position
  local counterRotation = counter.rotation or defaults.mainSchemeThreatCounter.rotation
  local counterScale = counter.scale or defaults.mainSchemeThreatCounter.scale

  local counterBag = getObjectFromGUID(Global.getVar("GUID_LARGE_GENERAL_COUNTER_BAG"))
  local generalCounter = counterBag.takeObject({position = counterPosition, smooth = false})

  local locked = true;

  if(counter.locked ~= nil) then
    locked = counter.locked
  end

  Wait.frames(
    function()
      generalCounter.setRotation(counterRotation)
      generalCounter.setScale(counterScale)
      generalCounter.setLock(locked)
      --threatCounter.call("setValue", {value = initialThreat})
    end,
    1
  )
end

function placeExtras(scenarioBag, extras)
  if(extras == nil) then return end

  for _, item in pairs(extras) do
    local objectPosition = Vector(item.position)
    local objectOrig = scenarioBag.takeObject({guid = item.guid, position = objectPosition})
    local objectCopy = objectOrig.clone({position = objectPosition})
    scenarioBag.putObject(objectOrig)
  
    objectCopy.setPosition(objectPosition)

    objectCopy.setName(item.name)
    objectCopy.setDescription(item.description)
  
    if(item["locked"]) then
        objectCopy.setLock(true)
    end  
  end
end

function placeBlackHole(scenario)
  local position = scenario.blackHole and scenario.blackHole.position or defaults.blackHole.position
  local rotation = scenario.blackHole and scenario.blackHole.rotation or defaults.blackHole.rotation
  local scale = scenario.blackHole and scenario.blackHole.scale or defaults.blackHole.scale

  spawnAsset({
    guid = Global.getVar("ASSET_GUID_BLACK_HOLE"),
    position = position,
    rotation = rotation,
    scale = scale,
    callback = "configureBlackHole"
  })
end

function configureBlackHole(params)
  local blackHole = params.spawnedObject
  blackHole.setPosition(params.position)
  blackHole.setScale(params.scale) --Shouldn't have to do this, but the scale wasn't being applied in the takeObject call
  blackHole.setLock(true)
end

function placeModularSets(scenario)
  if(scenario.modularSets == nil) then return end

  local modularSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))
  local cards = {}
  local addedSetCount = 0
  local recommendedSetCount = 0
  local addedSetList = ""
  local recommendedSetList = ""
  local cardCount = 0

  for key, value in pairs(scenario.modularSets) do
    local modularSet = modularSetManager.call("getModularSet", {modularSetKey = key})

    if(value == "required") then
      for cardId, count in pairs(modularSet.cards) do
        cards[cardId] = count
        cardCount = cardCount + count
      end

      addedSetCount = addedSetCount + 1
      addedSetList = addedSetList .. modularSet.name .. ", "
    else
      recommendedSetCount = recommendedSetCount + 1
      recommendedSetList = recommendedSetList .. modularSet.name .. ", "
    end
  end

  --TODO: make these values dynamic
  local deckPosition = defaults.encounterDeck.position
  local deckRotation = defaults.encounterDeck.rotation
  local deckScale = defaults.encounterDeck.scale

  if(cardCount == 1) then
    --TODO: place single card
  elseif(cardCount > 1) then
    createDeck({cards = cards, position = deckPosition, rotation = deckRotation, scale = deckScale})
  end

  local message = ""

  if(addedSetCount > 0) then
    local plural = addedSetCount > 1 and "s" or ""
    message = "Added " .. addedSetCount .. " modular set" .. plural .. ": " .. addedSetList:sub(1, -3) .. "\n"
  end

  if(recommendedSetCount> 0) then
    local plural = recommendedSetCount > 1 and "s" or ""
    local modular = addedSetCount > 0 and " more " or " modular "
    message = message .. "Add ".. recommendedSetCount .. modular .. "set" .. plural .. " (recommended: " .. recommendedSetList:sub(1, -3) .. ")."
  end

  broadcastToAll(message)
end

function placeBoostPanel(scenario)
  local placeBoostPanel = scenario.placeBoostPanel == nil or scenario.placeBoostPanel

  if(placeBoostPanel == false) then return end

  local position = Global.getTable("BOOST_PANEL_POSITION")

  spawnAsset({
    guid = Global.getVar("ASSET_GUID_BOOST_PANEL"),
    position = position,
    rotation = Global.getTable("DEFAULT_ROTATION"),
    callback = "configureBoostPanel"
  })
end

function configureBoostPanel(params)
  local boostPanel = params.spawnedObject
  boostPanel.setPosition(params.position)
  boostPanel.setLock(true)
end

function clearScenario()
  clearData()
end

function spawnNemesis(params)
  local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
  local hero = heroManager.call("getHeroByPlayerColor", {playerColor = params.playerColor})

  local deck = {
    position = {0,1,0},
    scale = Global.getTable("CARD_SCALE_ENCOUNTER"),
    cards = hero.decks.nemesis
  }

  createDeck(deck)
end

function createContextMenu()
  self.addContextMenuItem("Lay Out Scenarios", layOutScenarios)
  self.addContextMenuItem("Delete Scenarios", deleteScenarios)
  self.addContextMenuItem("Delete Everything", deleteEverything)
end


--Layout functions - move to central layout manager

local originPosition = {x = 83.25, y = 0.50, z = 33.75}

local rowGap = 2.5
local columnGap = 5

local rows = 12

function layOutScenarios()
  layoutManager.call("layOutSelectorTiles", {
      origin = originPosition,
      direction = "vertical",
      maxRowsOrColumns = rows,
      columnGap = columnGap,
      rowGap = rowGap,
      items = scenarios,
      itemType = "scenario",
      behavior = "layOut"
  }) 
end

function layOutScenarioSelectors(params)
  layoutManager.call("layOutSelectorTiles", {
      origin = params.origin,
      center = params.center or {0,0.5,0},
      direction = params.direction or "horizontal",
      maxRowsOrColumns = params.maxRowsOrColumns or 6,
      columnGap = params.columnGap or 6.5,
      rowGap = params.rowGap or 3.5,
      selectorScale = params.selectorScale or {1.33, 1, 1.33},
      items = scenarios,
      itemType = "scenario",
      behavior = params.behavior,
      hidden = params.hidden
  }) 
end

function deleteScenarios()
  layoutManager.call("clearSelectorTiles", {itemType = "scenario"})
end

function deleteEverything()
  layoutManager.call("clearSelectorTiles", {itemType = "hero"})
  layoutManager.call("clearSelectorTiles", {itemType = "scenario"})
  layoutManager.call("clearSelectorTiles", {itemType = "modular-set"})

  clearData()
  heroManager.call("clearData")
  encounterSetManager.call("clearData")
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

function advanceVillain(params)
  local heroCount = heroManager.call("getHeroCount")
  advanceVillainStage(params.villainKey, heroCount)
end

function advanceVillainStage(villainKey, heroCount)
  local villain = currentScenario.villains[villainKey]
  local nextStage = getNextVillainStage(villain)

  if(nextStage == nil) then return end

  villain.currentStageNumber = string.sub(nextStage.key, -1)

  placeVillainStage(villain, nextStage, heroCount)

  setUpVillainStage(villain, nextStage, heroCount)
end

function getNextVillainStage(villain)
  local functionName = "getNextVillainStage_" .. villain.key

  if(self.getVar(functionName) ~= nil) then
    return self.call(functionName, {villain = villain})
  end

  local currentStageNumber = villain.currentStageNumber
  local mode = currentScenario.mode
  local nextStage = nil

  if(currentStageNumber == nil) then
    if(mode == "standard") then
      nextStage = villain.stages.stage1 or villain.stages.stageA
    elseif(mode == "expert") then
      nextStage = villain.stages.stage2 or villain.stages.stageB
    end
  elseif(currentStageNumber == "1") then
    nextStage = villain.stages.stage2
  elseif(currentStageNumber == "2") then
    nextStage = villain.stages.stage3
  end

  local showAdvanceButton = villain.currentStageNumber == "1" or 
    (villain.currentStageNumber == "2" and currentScenario.mode == "expert")
  
  nextStage.showAdvanceButton = showAdvanceButton
  return nextStage
end

function placeVillainStage(villain, stage, heroCount)
  local functionName = "placeVillainStage_" .. villain.key

  if(self.getVar(functionName) ~= nil) then
    self.call(functionName, {villain=villain, stage=stage, heroCount=heroCount})
    return
  end

  local villainPosition = villain.deckPosition or defaults.villainDeck.position
  local villainRotation = villain.deckRotation or defaults.villainDeck.rotation
  local villainScale = villain.deckScale or defaults.villainDeck.scale

  --TODO: delete existing card, if necessary

  local locked = true;
  if(villain.locked ~= nil) then
    locked = stage.locked
  end

  local flipped = stage.flipCard or false

  getCardByID(
    stage.cardId, 
    villainPosition, 
    {scale = villainScale, name = villain.name, flipped = flipped, locked=locked})
  
  local hitPoints = (stage.hitPoints or 0) + ((stage.hitPointsPerPlayer or 0) * heroCount)
  local villainHpCounter = getObjectFromGUID(villain.hpCounter.guid)

  Wait.frames(
    function()
      villainHpCounter.call("setValue", {value = hitPoints}) 
      configureAdvanceVillainButton(villainHpCounter, stage.showAdvanceButton)
    end,
    20
  )
end

function setUpVillainStage(villain, stage, heroCount)
  local functionName = "setUpVillainStage_" .. villain.key

  if(self.getVar(functionName) ~= nil) then
    self.call(functionName, {villain=villain, stage=stage, heroCount=heroCount})
    return
  end
end

function advanceScheme(params)
  local heroCount = heroManager.call("getHeroCount")
  advanceSchemeStage(params.schemeKey, heroCount)
end

function advanceSchemeStage(schemeKey, heroCount)
  local scheme = currentScenario.schemes[schemeKey]
  local nextStage = getNextSchemeStage(scheme)

  if(nextStage == nil) then return end

  scheme.currentStageNumber = string.sub(nextStage.key, -1)

  placeSchemeStage(scheme, nextStage, heroCount)

  setUpSchemeStage(scheme, nextStage, heroCount)

end

function getNextSchemeStage(scheme)
  local functionName = "getNextSchemeStage_" .. currentScenario.key .. "_" .. scheme.key

  if(self.getVar(functionName) ~= nil) then
    return self.call(functionName, {scheme = scheme})
  end

  local currentStageNumber = scheme.currentStageNumber or 0
  local nextStageKey = "stage" .. (tonumber(currentStageNumber) + 1)
  local nextStage = scheme.stages[nextStageKey]

  return nextStage
end

function placeSchemeStage(scheme, stage, heroCount)
  local functionName = "placeSchemeStage_" .. scheme.key

  if(self.getVar(functionName) ~= nil) then
    self.call(functionName, {scheme = scheme, stage=stage, heroCount=heroCount})
    return
  end

  local schemePosition = scheme.position or defaults.mainSchemeDeck.position
  local schemeRotation = scheme.rotation or defaults.mainSchemeDeck.rotation
  local schemeScale = scheme.scale or defaults.mainSchemeDeck.scale

  --TODO: delete existing card, if necessary
  
  getCardByID(
    stage.cardId, 
    schemePosition, 
    {scale = schemeScale, name = scheme.name, flipped = false, landscape = true})

  local counter = scheme.counter or {}

  local threat = (stage.startingThreat or 0) + ((stage.startingThreatPerPlayer or 0) * heroCount)
  local schemeThreatCounter = getObjectFromGUID(counter.guid)

  Wait.frames(
    function()
      schemeThreatCounter.call("setValue", {value = threat})
      configureAdvanceSchemeButton(schemeThreatCounter, stage.showAdvanceButton)
    end,
    20
  )
end

function setUpSchemeStage(scheme, stage, heroCount)
  local functionName = "setUpSchemeStage_" .. scheme.key

  if(self.getVar(functionName) ~= nil) then
    self.call(functionName, {scheme = scheme, stage=stage, heroCount=heroCount})
    return
  end
end

function configureAdvanceVillainButton(villainHpCounter, showAdvanceButton)
  local villain = currentScenario.villains[villainHpCounter.call("getVillainKey")]

  if(showAdvanceButton) then
    villainHpCounter.call("setAdvanceButtonOptions", {label = villain.hpCounter.primaryButtonLabel or "ADVANCE"})
    villainHpCounter.call("showAdvanceButton")
  else
    villainHpCounter.call("hideAdvanceButton")
  end
end

function configureAdvanceSchemeButton(schemeHpCounter, showAdvanceButton)
  --local scheme = currentScenario.schemes[schemeHpCounter.call("getSchemeKey")]
  --local nextStageKey = "stage" .. (tonumber(scheme.currentStageNumber) + 1)

  --if(scheme.stages[nextStageKey]) then
  if(showAdvanceButton) then
    schemeHpCounter.call("showAdvanceButton")
  else
    schemeHpCounter.call("hideAdvanceButton")
  end
end

function getNextVillainStage_brotherhood(params)
  local villain = currentScenario.villains[params.villain.key]
  local villainPosition = villain.deckPosition or defaults.villainDeck.position
  local remainingStages = {}

  for key, stage in pairs(villain.stages) do
    if(not stage.defeated) then
        table.insert(remainingStages, key)
    end
  end

  if(villain.currentStageNumber ~= nil) then
    local defeatedStages = 3 - #remainingStages
    local x = -12.75 + (defeatedStages * 10)
    Global.call("moveCardToLocation", {origin = villainPosition, destination = vector(x, 1.50, 54.25)}) --TODO: create victory display layout region
  end

  local newStageKey = nil
  local lastStage = false

  if(#remainingStages == 1) then
      newStageKey = remainingStages[1]
      lastStage = true
  else
      math.randomseed(os.time())
      newStageKey = remainingStages[math.random(#remainingStages)]
  end

  local newStage = villain.stages[newStageKey]
  newStage.showAdvanceButton = not lastStage
  newStage.flipCard = (currentScenario.mode == "expert")
  newStage.defeated = true

  return newStage
end

function getNextSchemeStage_mansionAttack_main(params)
  local scheme = currentScenario.schemes[params.scheme.key]
  local schemePosition = scheme.position or defaults.mainSchemeDeck.position
  local remainingStages = {}

  if(scheme.currentStageNumber == nil) then
    local newStage = scheme.stages["stage1"]
    newStage.showAdvanceButton = true
    newStage.completed = true
    return newStage
  end

  for key, stage in pairs(scheme.stages) do
    if(not stage.completed) then
        table.insert(remainingStages, key)
    end
  end

  local completedStages = 4 - #remainingStages
  local x = -12.75 + (completedStages * 10)
  Global.call("moveCardToLocation", {origin = schemePosition, destination = vector(x, 1.50 , 43.75)}) --TODO: create victory display layout region

  local newStageKey = nil
  local lastStage = false

  if(#remainingStages == 1) then
      newStageKey = remainingStages[1]
      lastStage = true
  else
      math.randomseed(os.time())
      newStageKey = remainingStages[math.random(#remainingStages)]
  end

  local newStage = scheme.stages[newStageKey]
  newStage.showAdvanceButton = not lastStage
  newStage.completed = true

  return newStage
end

require('!/Cardplacer')

require('!/scenarios/rhino')
require('!/scenarios/klaw')
require('!/scenarios/ultron')
require('!/scenarios/mysterio')
require('!/scenarios/sandman')
require('!/scenarios/wrecking_crew')
require('!/scenarios/loki')
require('!/scenarios/hela')
require('!/scenarios/thanos')
require('!/scenarios/tower_defense')
require('!/scenarios/ebony_maw')
require('!/scenarios/ronan_the_accuser')
require('!/scenarios/nebula')
require('!/scenarios/escape_the_museum')
require('!/scenarios/infiltrate_the_museum')
require('!/scenarios/brotherhood_of_badoon')
require('!/scenarios/once_and_future_kang')
require('!/scenarios/red_skull')
require('!/scenarios/zola')
require('!/scenarios/taskmaster')
require('!/scenarios/absorbing_man')
require('!/scenarios/crossbones')
require('!/scenarios/mutagen_formula')
require('!/scenarios/risky_business')
require('!/scenarios/magog')
require('!/scenarios/spiral')
require('!/scenarios/mojo')
require('!/scenarios/magneto')
require('!/scenarios/mansion_attack')
require('!/scenarios/master_mold')
require('!/scenarios/project_wideawake')
require('!/scenarios/sabretooth')
require('!/scenarios/hood')
require('!/scenarios/sinister_six')
require('!/scenarios/venom')
require('!/scenarios/venom_goblin')
require('!/scenarios/morlock_siege')
require('!/scenarios/on_the_run')
require('!/scenarios/juggernaut')
require('!/scenarios/mister_sinister')
require('!/scenarios/stryfe')
