preventDeletion = true

local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
local encounterSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))
local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))

local defaults = {
  villainHpCounter = {
    position = Global.getTable("VILLAIN_HEALTH_COUNTER_POSITION"),
    rotation = Global.getTable("VILLAIN_HEALTH_COUNTER_ROTATION"),
    scale = Global.getTable("VILLAIN_HEALTH_COUNTER_SCALE")
  },
  encounterDeck = {
    position = Global.getTable("ENCOUNTER_DECK_POSITION"),
    rotation = Global.getTable("ENCOUNTER_DECK_ROTATION"),
    scale = Global.getTable("ENCOUNTER_DECK_SCALE")
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
local scenarioInfo = {}
local selectedMode = nil
local selectedStandardSet = nil
local selectedExpertSet = nil
local counters = {}
local villains = {}

local currentScenario = nil

local assetBag = getObjectFromGUID("91eba8")

function onload(saved_data)
  createContextMenu()
  --layOutScenarios()
end

function clearData()
  self.script_state = ""
end

function setMode(params)
  selectedMode = params.mode
end

function setStandardSet(params)
  selectedStandardSet = params.set
end

function setExpertSet(params)
  selectedExpertSet = params.set
end

function spawnAsset(params)
  params.caller = self
  assetBag.call("spawnAsset", params)
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
  encounterSetManager.call("preSelectEncounterSets", {sets = currentScenario.modularSets or {}})

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

  --placeExtras(scenarioBag, scenarioDetails.extras)

    placeBoostPanel(scenario)
end

function confirmNoScenarioIsPlaced()
  return true --TODO: Implement this
end

function setUpScenario()
  if(not confirmScenarioInputs(true)) then return end

  local heroCount = heroManager.call("getHeroCount")

  startLuaCoroutine(self, "setUpVillains")
  startLuaCoroutine(self, "setUpSchemes")
  startLuaCoroutine(self, "setUpDecks")

  setUpCards()
  setUpCounters(heroCount)

  --placeExtras(scenarioBag, scenarioDetails.extras)
  placeBlackHole(currentScenario)
  placeBoostPanel(currentScenario)
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

  if selectedMode == nil then
    if postMessage then
      broadcastToAll("Please select a mode.", {1,1,1})
    end
    return false
  end

  if selectedStandardSet == nil then
    if postMessage then
      broadcastToAll("Please select a standard encounter set.", {1,1,1})
    end
    return false
  end

  if selectedMode == "expert" and selectedExpertSet == nil then
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

  local villainPosition = villain.deckPosition or defaults.villainDeck.position
  local villainRotation = villain.deckRotation or defaults.villainDeck.rotation
  local villainScale = villain.deckScale or defaults.villainDeck.scale

  local stage = nil

  if(selectedMode == "standard") then
    stage = villain.stage1 or villain.stageA
  elseif(selectedMode == "expert") then
    stage = villain.stage2 or villain.stageB
  end

  getCardByID(
    stage.cardId, 
    villainPosition, 
    {scale = villainScale, name = villain.name, flipped = false, locked=true})

  placeVillainHpCounter(villain, stage.hitPointsPerPlayer * heroCount)
end

function placeVillainHpCounter(villain, hitPoints)
  local position = villain.hpCounter.position or defaults.villainHpCounter.position
  local rotation = villain.hpCounter.rotation or defaults.villainHpCounter.rotation
  local scale = villain.hpCounter.scale or defaults.villainHpCounter.scale

  local counterTemp
  local villainHpCounter
  local lock = true;

  if(villain.hpCounter.locked ~= nil) then
    lock = villain.hpCounter.locked
  end

  if(villain.hpCounter.guid ~= nil) then
    -- local villainHpCounterOrig = scenarioBag.takeObject({guid = villain.hpCounter.guid, position = counterPosition})
    -- villainHpCounter = villainHpCounterOrig.clone({position = counterPosition})
    -- scenarioBag.putObject(villainHpCounterOrig)
  else
    spawnAsset({
      guid = Global.getVar("ASSET_GUID_VILLAIN_HEALTH_COUNTER"),
      position = position,
      rotation = rotation,
      scale = scale,
      imageUrl = villain.hpCounter.imageUrl,
      lock = lock,
      hitPoints = hitPoints,
      callback = "configureVillainHpCounter"
    })
  end
end

function configureVillainHpCounter(params)
  local counter = params.spawnedObject
  local hitPoints = params.hitPoints or 0

  counter.setPosition(params.position)
  counter.setName("")
  counter.setDescription("")
  counter.setLock(params.lock)
  counter.setCustomObject({image = params.imageUrl})

  Wait.frames(
    function()
      counter.call("setAdvanceButtonOptions", {label = "ADVANCE", clickFunction = "advanceVillain"})
      counter.call("setValue", {value = hitPoints})
      counter.reload()
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
  local schemePosition = scheme.position or defaults.mainSchemeDeck.position
  local schemeRotation = scheme.rotation or defaults.mainSchemeDeck.rotation
  local schemeScale = scheme.scale or defaults.mainSchemeDeck.scale

  local stage = scheme.stages["stage1"]

  getCardByID(
    stage.cardId, 
    schemePosition, 
    {scale = schemeScale, name = scheme.name, flipped = false, landscape = true})

  local counter = scheme.counter or {}

  local threat = (stage.startingThreat or 0) + ((stage.startingThreatPerPlayer or 0) * heroCount)

  placeThreatCounter(counter, threat)
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

function setUpDeck(deck, isEncounterDeck)
  if(isEncounterDeck) then
    deck = deepCopy(deck)

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
  if(selectedStandardSet == "i") then
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

  if(selectedExpertSet == "i") then
    deck.cards["01191"]=1
    deck.cards["01192"]=1
    deck.cards["01193"]=1
  elseif(selectedExpertSet == "ii") then
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

  local counter = scheme.counter or {}

  Wait.time(
    function()
      placeThreatCounter(counter, 0)
    end,
    1
  )
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
--TODO: call this when clearing the scenario area
scenarioInfo = {}
mode = ""
counters = {}
vilains = {}
end

function spawnNemesis(params)
  local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
  local hero = heroManager.call("getHeroByPlayerColor", {playerColor = params.playerColor})

  local deck = {
    position = {0,0,0},
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

function createVillainAdvanceButton(counter)
  
end

function createSchemeAdvanceButton()
end

function advanceVillain()
  broadcastToAll("Villain Advances!", {1,0,0})
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
