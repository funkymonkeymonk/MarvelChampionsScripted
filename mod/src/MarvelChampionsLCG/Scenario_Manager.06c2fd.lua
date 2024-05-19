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
  },
  boostDrawPosition = Global.getTable("BOOST_POS")
}

local scenarios = {}
local currentScenario = nil

function onload(saved_data)
  loadSavedData(saved_data)
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

function getCurrentScenarioKey()
  return currentScenario and currentScenario.key or nil
end

function getMode()
  if(currentScenario == nil) then return nil end

  return currentScenario.mode
end

function getSelectedStandardSet()
  return currentScenario and currentScenario.standardSet or nil
end

function getSelectedExpertSet()
  return currentScenario and currentScenario.expertSet or nil
end

function setMode(params)
  currentScenario.mode = params.mode

  if(params.mode == "standard") then currentScenario.expertSet = nil end

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

function useStandardEncounterSets()
  if(currentScenario == nil) then return false end

  return currentScenario.useStandardEncounterSets == nil or currentScenario.useStandardEncounterSets
end

function useModularEncounterSets()
  if(currentScenario == nil) then return false end

  return currentScenario.useModularEncounterSets == nil or currentScenario.useModularEncounterSets
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

  prepareScenario()

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

  Wait.frames(
    function()
      setUpCounters(heroCount)
    end,
    30
  )

  placeExtras()
  placeBlackHole(currentScenario)
  placeBoostPanel(currentScenario)

  finalizeSetUp(currentScenario)

  saveData()
end

function prepareScenario()
  local functionName = "prepareScenario_" .. currentScenario.key

  if(self.getVar(functionName) ~= nil) then
    self.call(functionName)
  end
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

function heroCountIsValid(params)
  local heroCountIsValid = heroManager.call("getHeroCount") > 0

  if(params and params.postMessage and not heroCountIsValid) then
    broadcastToAll("Please select at least one hero.", {1,1,1})
  end

  return heroCountIsValid
end

function scenarioIsValid(params)
  local scenarioIsValid = currentScenario ~= nil

  if(params and params.postMessage and not scenarioIsValid) then
    broadcastToAll("Please select a scenario.", {1,1,1})
  end

  return scenarioIsValid
end

function modularSetsAreValid(params)
  local requiredEncounterSetCount = getRequiredEncounterSetCount()
  local selectedEncounterSetCount = encounterSetManager.call("getSelectedSetCount")
  local additionalEncounterSets =  requiredEncounterSetCount - selectedEncounterSetCount
  local modularSetsAreValid = additionalEncounterSets <= 0

  if(params and params.postMessage and not modularSetsAreValid) then
    local plural = additionalEncounterSets > 1 and "s" or ""
    broadcastToAll("Please select at least " .. additionalEncounterSets .. " more encounter set" .. plural .. ".", {1,1,1})
  end

  return modularSetsAreValid
end

function modeAndStandardEncounterSetsAreValid(params)
  if(currentScenario == nil) then return false end

  local postMessage = params and params.postMessage
  local modeIsValid = currentScenario.mode ~= nil
  local scenarioUsesStandardEncounterSets = useStandardEncounterSets()
  local standardSetIsValid = currentScenario.standardSet ~= nil or not scenarioUsesStandardEncounterSets
  local expertSetIsValid = currentScenario.expertSet ~= nil or currentScenario.mode ~= "expert" or not scenarioUsesStandardEncounterSets

  if(not modeIsValid) then
    if(postMessage) then
      broadcastToAll("Please select a mode.", {1,1,1})
    end

    return false
  end

  if(not standardSetIsValid) then
    if(postMessage) then
      broadcastToAll("Please select a standard encounter set.", {1,1,1})
    end

    return false
  end

  if(not expertSetIsValid) then
    if(postMessage) then
      broadcastToAll("Please select an expert encounter set.", {1,1,1})
    end

    return false
  end

  return true
end

function confirmScenarioInputs(postMessage)
  if(not heroCountIsValid({postMessage = postMessage})) then return false end
  if(not scenarioIsValid({postMessage = postMessage})) then return false end
  if(not modularSetsAreValid({postMessage = postMessage})) then return false end
  if(not modeAndStandardEncounterSetsAreValid({postMessage = postMessage})) then return false end

  return true
end

function getRequiredEncounterSetCount()
  if (currentScenario == nil) then return 0 end

  if(currentScenario.requiredEncounterSetCount ~= nil) then
    return currentScenario.requiredEncounterSetCount
  end

  if(currentScenario.modularSets == nil) then return 0 end

  local sets = 0

  for _, encounterSet in pairs(currentScenario.modularSets) do
    sets = sets + 1
  end

  return sets
end

function setUpVillains()
  --log(currentScenario.villains)
  local heroCount = heroManager.call("getHeroCount")

  for key, villain in pairs(currentScenario.villains) do
      villain.key = key
      setUpVillain(villain.key, heroCount)

      local count = 0
      while count < 5 do
          count = count + 1
          coroutine.yield(0)
      end
  end

  return 1
end

function setUpVillain(villainKey, heroCount)
  local setUpFunction = "setUpVillain_" .. currentScenario.key
  if(self.getVar(setUpFunction) ~= nil) then
    self.call(setUpFunction, {villainKey = villainKey, heroCount = heroCount})
    return
  end

  local villain = currentScenario.villains[villainKey]

  placeVillainHpCounter(villainKey, 0, false)

  Wait.frames(
    function()
      advanceVillainStage(villain.key, heroCount)
    end,
    15
  )
end

function placeVillainHpCounter(villainKey, hitPoints, showAdvanceButton)
  local villain = currentScenario.villains[villainKey]
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
      villainKey = villain.key,
      callback = "configureVillainHpCounter"
    })
  end
end

function configureVillainHpCounter(params)
  local counter = params.spawnedObject
  local hitPoints = params.hitPoints or 0
  local villainKey = params.villainKey

  counter.setPosition(params.position)
  counter.setName("")
  counter.setDescription("")
  counter.setLock(params.lock)
  counter.setCustomObject({image = params.imageUrl})

  Wait.frames(
    function()
      counter.call("setVillainKey", {villainKey = villainKey})
      if(hitPoints > 0) then
        counter.call("setValue", {value = hitPoints})
      end
      local reloadedCounter = counter.reload()
      currentScenario.villains[villainKey].hpCounter.guid = reloadedCounter.getGUID()
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

function getBoostDrawPosition()
  return currentScenario.boostDrawPosition or defaults.boostDrawPosition
end

function getScenarioModularSets()
  if(currentScenario == nil) then return {} end

  return currentScenario.modularSets or {}
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
  elseif(currentScenario.standardSet == "ii") then
    deck.cards["24049"]=1 --TODO: Place environment card 24049
    deck.cards["24050"]=2
    deck.cards["24051"]=1
    deck.cards["24052"]=1
    deck.cards["24053"]=1
    deck.cards["24054"]=2
  elseif(currentScenario.standardSet == "iii") then
    deck.cards["45075"]=1 --TODO: Place environment card 45075
    deck.cards["45076"]=2
    deck.cards["45077"]=2
    deck.cards["45078"]=1
    deck.cards["45079"]=1
    deck.cards["45080"]=1
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

  local locked = true
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

  local locked = true

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

function placeExtras()
  local extras = currentScenario.extras
  if(extras == nil) then return end

  for key, item in pairs(extras) do
    local position = item.position or {0, 0, 0}
    local rotation = item.rotation or {0, 0, 0}
    local scale = item.scale or {1, 1, 1}
    local locked = item.locked == nil or item.locked

    spawnAsset({
      key = key,
      guid = item.guid,
      position = position,
      rotation = rotation,
      scale = scale,
      locked = locked,
      callback = "configureExtra"
    })
  end
end

function configureExtra(params)
  local extra = params.spawnedObject
  extra.setPosition(params.position)
  extra.setRotation(params.rotation)
  extra.setScale(params.scale)
  extra.setLock(params.locked)
  addItemToManifest(params.key, extra)
end

function addItemToManifest(key, item)
  if(not currentScenario.manifest) then currentScenario.manifest = {} end
  currentScenario.manifest[key] = item.getGUID()

  saveData()
end

function getItemFromManifest(params)
  if(not currentScenario.manifest) then return nil end

  local itemGuid = currentScenario.manifest[params.key]

  return getObjectFromGUID(itemGuid)
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

  if(not placeBoostPanel) then return end

  local position = scenario.boostPanelPosition or Global.getTable("BOOST_PANEL_POSITION")

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

function finalizeSetUp(scenario)
  local functionName = "finalizeSetup_" .. scenario.key

  if(self.getVar(functionName) ~= nil) then
    Wait.frames(
      function()
        return self.call(functionName)
      end, 
      15)
  end
end

function clearScenario()
  local clearCards = findCardsAtPosition()

  for _, obj in ipairs(clearCards) do
     if obj.getVar("preventDeletion") ~= true then
        obj.destruct()
     end
  end

  local clearCards2 = findCardsAtPosition2()

  for _, obj in ipairs(clearCards2) do
     if obj.getVar("preventDeletion") ~= true then
        obj.destruct()
     end
  end

  local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))

  clearData()
end

--TODO: These functions should be moved to global
function findCardsAtPosition(obj)
  local objList = Physics.cast({
     origin       = {0,1.48,11},
     direction    = {0,1,0},
     type         = 3,
     size         = {108,1,40},
     max_distance = 0,
     debug        = false,
  })
  local villainAssets = {}
  for _, obj in ipairs(objList) do
     table.insert(villainAssets, obj.hit_object)
  end
  return villainAssets
end

function findCardsAtPosition2(obj)
  local objList = Physics.cast({
     origin       = {18.00, 1.48, 33.75},
     direction    = {0,1,0},
     type         = 3,
     size         = {60,1,1},
     max_distance = 0,
     debug        = false,
  })
  local villainAssets2 = {}
  for _, obj in ipairs(objList) do
     table.insert(villainAssets2, obj.hit_object)
  end
  return villainAssets2
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

  saveData()
end

function getNextVillainStage(villain)
  local functionName = "getNextVillainStage_" .. currentScenario.key .. "_" .. villain.key

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

  local nextStageNumber = string.sub(nextStage.key, -1)
  local showAdvanceButton = nextStageNumber == "1" or 
    (nextStageNumber == "2" and mode == "expert")

  nextStage.showAdvanceButton = showAdvanceButton
  return nextStage
end

function placeVillainStage(villain, stage, heroCount)
  local functionName = "placeVillainStage_" .. currentScenario.key .. "_" .. villain.key

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
      configureSecondaryVillainButton(villainHpCounter, villain.hpCounter.secondaryButton)
      configureAdvanceVillainButton(villainHpCounter, stage.showAdvanceButton)
    end,
    20
  )
end

function setUpVillainStage(villain, stage, heroCount)
  local functionName = "setUpVillainStage_" .. currentScenario.key .. "_" .. villain.key

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

  saveData()
end

function getNextSchemeStage(scheme)
  local functionName = "getNextSchemeStage_" .. currentScenario.key .. "_" .. scheme.key

  if(self.getVar(functionName) ~= nil) then
    return self.call(functionName, {scheme = scheme})
  end

  local currentStageNumber = scheme.currentStageNumber or 0
  local nextStageKey = "stage" .. (tonumber(currentStageNumber) + 1)
  local nextStage = scheme.stages[nextStageKey]

  local nextNextStageKey = "stage" .. (tonumber(currentStageNumber) + 2)
  local showAdvanceButton = scheme.stages[nextNextStageKey] ~= nil

  nextStage.showAdvanceButton = showAdvanceButton

  return nextStage
end

function placeSchemeStage(scheme, stage, heroCount)
  local functionName = "placeSchemeStage_" .. currentScenario.key .. "_" .. scheme.key

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
  local functionName = "setUpSchemeStage_" .. currentScenario.key .. "_" .. scheme.key

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

function configureSecondaryVillainButton(villainHpCounter, secondaryButton)
  if(secondaryButton) then
    villainHpCounter.call("setSecondaryButtonOptions", secondaryButton)
    villainHpCounter.call("showSecondaryButton")
  else
    villainHpCounter.call("hideSecondaryButton")
  end
end

function configureAdvanceSchemeButton(schemeHpCounter, showAdvanceButton)
  if(showAdvanceButton) then
    schemeHpCounter.call("showAdvanceButton")
  else
    schemeHpCounter.call("hideAdvanceButton")
  end
end



function setUpVillain_kang(params)
  local heroCount = heroManager.call("getHeroCount")

  Wait.frames(
    function()
      advanceVillainStage(params.villainKey, heroCount)
    end,
    15
  )
end

function getNextVillainStage_kang_kang(params)
  local villain = currentScenario.villains.kang
  local currentStageNumber = villain.currentStageNumber or 0
  local mode = currentScenario.mode

  if(currentStageNumber == 0) then
    villain.stages = getKangStages(mode)
  end

  local nextStageNumber = currentStageNumber + 1

  if(nextStageNumber == 2) then
    return {key="stage2"}
  end

  local nextStage = villain.stages["stage" .. nextStageNumber]
  nextStage.showAdvanceButton = nextStageNumber < 3

  return nextStage
end

function placeVillainStage_kang_kang(params)
  local villain = currentScenario.villains.kang
  local stage = params.stage
  local heroCount = params.heroCount

  if(stage.key == "stage2") then
    placeKangStage2()
    return
  end

  placeKangHpCounter(defaults.villainHpCounter.position, defaults.villainHpCounter.scale, stage.key, 0, false)

  Wait.frames(
    function()
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
      local villainHpCounter = getObjectFromGUID(currentScenario.villains.kang.stages[stage.key].hpCounter.guid)

      villainHpCounter.call("setValue", {value = hitPoints}) 
      configureSecondaryVillainButton(villainHpCounter, villain.hpCounter.secondaryButton)
      configureAdvanceVillainButton(villainHpCounter, stage.showAdvanceButton)
    end,
    20
  )
end

function placeKangStage2()
  local mode = currentScenario.mode
  local villain = currentScenario.villains.kang
  local stages = {}

  for key, villain in pairs(currentScenario.villains) do
    if(string.sub(key, 1, 6) == "stage2") then
      table.insert(stages, villain)
    end
  end

  math.randomseed(os.time())

  local playerColors = {"Red", "Blue", "Green", "Yellow"}

  for _, playerColor in pairs(playerColors) do
    local hero = getHeroByPlayerColor({playerColor = playerColor})

    if(hero) then
      local stage = getRandomKangStage2(stages)    
      local layout = kangStage2Layout[playerColor]
    
      getCardByID(
        stage.cardId, 
        layout.villainPosition, 
        {scale = layout.villainScale, name=stage.villainName, flipped=false, locked=true})
      
      -- local hitPoints = stage.hitPoints)
      -- local villainHpCounter = getObjectFromGUID(villain.hpCounter.guid)
    
      -- Wait.frames(
      --   function()
      --     villainHpCounter.call("setValue", {value = hitPoints}) 
      --     configureSecondaryVillainButton(villainHpCounter, villain.hpCounter.secondaryButton)
      --     configureAdvanceVillainButton(villainHpCounter, stage.showAdvanceButton)
      --   end,
      --   20
      -- )      
    end
  end
end

function getKangStages(mode)
  if(mode == "standard") then
    return {
      stage1 = {cardId = "11001", hitPointsPerPlayer = 12, key="stage1"},
      stage2a = {cardId = "11002", hitPoints = 18, key="stage2a", villainName="Immortus", schemeCardId="11002"},
      stage2b = {cardId = "11003", hitPoints = 18, key="stage2b", villainName="Iron Lad", schemeCardId="11003"},
      stage2c = {cardId = "11004", hitPoints = 18, key="stage2c", villainName="Rama-Tut", schemeCardId="11004"},
      stage2d = {cardId = "11005", hitPoints = 18, key="stage2d", villainName="ScarletCenturion", schemeCardId="11005"},
      stage3 = {cardId = "11006", hitPointsPerPlayer = 20, key="stage3"}
    }
  end

  return {
    stage1 = {cardId = "11034", hitPointsPerPlayer = 12, key="stage1"},
    stage2a = {cardId = "11035", hitPoints = 22, key="stage2a", villainName="Immortus", schemeCardId="11035"},
    stage2b = {cardId = "11036", hitPoints = 22, key="stage2b", villainName="Iron Lad", schemeCardId="11036"},
    stage2c = {cardId = "11037", hitPoints = 22, key="stage2c", villainName="Rama-Tut", schemeCardId="11037"},
    stage2d = {cardId = "11038", hitPoints = 22, key="stage2d", villainName="Scarlet Centurion", schemeCardId="11038"},
    stage3 = {cardId = "11039", hitPointsPerPlayer = 20, key="stage3"}
  }
end

local kangStage2Layout = {
  Red={
    villainPosition={-30, 1,00, 20.44},
    villainScale={3.64, 1.00, 3.64},
    hpCounterPosition={-30, 0.96, 29.15},
    hpCounterScale={2.01, 1.00, 2.01},
    schemePosition={-21.25, 0.97, 22.45},
    schemeScale={2.93, 1.00, 2.93}
  }, 
  Blue={
    villainPosition={-15, 1,00, 20.44},
    villainScale={3.64, 1.00, 3.64},
    hpCounterPosition={-15, 0.96, 29.15},
    hpCounterScale={2.01, 1.00, 2.01},
    schemePosition={-6.25, 0.97, 22.45},
    schemeScale={2.93, 1.00, 2.93}
  }, 
  Green={
    villainPosition={15, 1,00, 20.44},
    villainScale={3.64, 1.00, 3.64},
    hpCounterPosition={15, 0.96, 29.15},
    hpCounterScale={2.01, 1.00, 2.01},
    schemePosition={23.75, 0.97, 22.45},
    schemeScale={2.93, 1.00, 2.93}
  }, 
  Yellow={
    villainPosition={30, 1,00, 20.44},
    villainScale={3.64, 1.00, 3.64},
    hpCounterPosition={30, 0.96, 29.15},
    hpCounterScale={2.01, 1.00, 2.01},
    schemePosition={38.75, 0.97, 22.45},
    schemeScale={2.93, 1.00, 2.93}
  }
}

function placeKangHpCounter(position, scale, stageKey, hitPoints, showAdvanceButton)
  local hpCounter = spawnAsset({
    guid = Global.getVar("ASSET_GUID_VILLAIN_HEALTH_COUNTER"),
    position = position,
    rotation = defaults.villainHpCounter.rotation,
    scale = scale,
    imageUrl = currentScenario.villains.kang.hpCounter.imageUrl,
    lock = true,
    hitPoints = hitPoints,
    showAdvanceButton = showAdvanceButton,
    stageKey = stageKey,
    callback = "configureKangHpCounter"
  })
end

function configureKangHpCounter(params)
  local counter = params.spawnedObject
  local hitPoints = params.hitPoints or 0
  local stageKey = params.stageKey

  counter.setPosition(params.position)
  counter.setName("")
  counter.setDescription("")
  counter.setLock(params.lock)
  counter.setCustomObject({image = params.imageUrl})

  Wait.frames(
    function()
      counter.call("setVillainKey", {villainKey = villainKey})
      counter.call("setValue", {value = hitPoints})
      local reloadedCounter = counter.reload()
      currentScenario.villains.kang.stages[stageKey].hpCounter = {guid = reloadedCounter.getGUID()}
    end,
    10
  )
end

function getRandomKangStage2(stages)
  local unplacedStages = {}

  for key, stage in pairs(stages) do
    if(not stage.placed) then
      table.insert(unplacedStages, stage)
    end
  end

  local stage = stages[math.random(#unplacedStages)]
  stage.placed = true

  return stage
end

function getNextSchemeStage_kang_main(params)
  local scheme = currentScenario.schemes.main
  local currentStageNumber = scheme.currentStageNumber or 0
  local nextStageKey = "stage" .. (tonumber(currentStageNumber) + 1)
  local nextStage = scheme.stages[nextStageKey]

  local nextNextStageKey = "stage" .. (tonumber(currentStageNumber) + 2)
  local showAdvanceButton = scheme.stages[nextNextStageKey] ~= nil

  nextStage.showAdvanceButton = false

  return nextStage
end

function prepareScenario_fourHorsemen()
  currentScenario.horsemenQueue = randomizeFourHorsemen()
  currentScenario.activeHorsemanNumber = 1

  local villains = currentScenario.villains
  log (currentScenario.horsemenQueue)

  for i = 1, 4, 1 do
    local horsemanKey = currentScenario.horsemenQueue[i]
    local x = -15 + (10 * (i - 1))
    
    local horseman = villains[horsemanKey]
    horseman.deckPosition = {x, 1.00, 20.44}
    horseman.hpCounter.position = {x, 0.96, 29.15}
  end
end

function randomizeFourHorsemen()
  local horsemenQueue = {}

  for k, v in pairs(currentScenario.villains) do
    table.insert(horsemenQueue, k)
  end

  shuffle(horsemenQueue)

  return horsemenQueue
end

function finalizeSetup_fourHorsemen()
  --TODO: Refactor setUpScenario with coroutines to prevent having to use Wait.frames here
  Wait.frames(
    function()
      updateActiveHorsemanHighlight()
    end,
    60
  )
end

function advanceHorsemenQueue()
  currentScenario.activeHorsemanNumber = currentScenario.activeHorsemanNumber + 1
  if(currentScenario.activeHorsemanNumber > 4) then
    currentScenario.activeHorsemanNumber = 1
  end

  updateActiveHorsemanHighlight()
end

function updateActiveHorsemanHighlight()
  for i = 1, 4, 1 do
    local horsemanKey = currentScenario.horsemenQueue[i]
    local villain = currentScenario.villains[horsemanKey]
    local hpCounter = getObjectFromGUID(villain.hpCounter.guid)

    if(i == currentScenario.activeHorsemanNumber) then
      hpCounter.highlightOn({1,1,0})
      hpCounter.call("showSecondaryButton")
    else
      hpCounter.highlightOff()
      hpCounter.call("hideSecondaryButton")
    end
  end
end

function shuffle(tbl)
  math.randomseed(os.time())

  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end

  return tbl
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
require('!/scenarios/unus')
require('!/scenarios/four_horsemen')
require('!/scenarios/apocalypse')
require('!/scenarios/dark_beast')
require('!/scenarios/en_sabah_nur')
