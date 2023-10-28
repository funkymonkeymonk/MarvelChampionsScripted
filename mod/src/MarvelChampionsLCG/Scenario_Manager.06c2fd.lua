preventDeletion = true

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
local mode = ""
local counters = {}
local villains = {}

local assetBag = getObjectFromGUID("91eba8")

function onload(saved_data)
  createContextMenu()
  layOutScenarios()
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

function placeScenario(scenarioKey, mode)
  if not confirmNoScenarioIsPlaced() then return end

  local heroCount = getHeroCount()
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
    placeScheme(scheme)
  end

  placeBlackHole(scenario)

  placeModularSets(scenario)

  -- if(scenario.cards ~= nil) then
  --   for _, card in pairs(scenario.cards) do
  --     getCardByID(card.cardId, card.position, {scale = card.scale, name = card.name, flipped = card.flipped, landscape = card.landscape})
  --   end
  -- end

  -- if(scenario.counters ~= nil) then
  --   for _, counter in pairs(scenario.counters) do
  --     Wait.time(
  --       function()
  --         if(counter.type == "threat") then
  --           placeThreatCounter(counter, nil, heroCount)
  --         else
  --           placeGeneralCounter(counter)
  --         end
  --       end,
  --       1)
  --   end
  -- end

  --placeExtras(scenarioBag, scenarioDetails.extras)

    placeBoostPanel(scenario)
end

function confirmNoScenarioIsPlaced()
  return true --TODO: Implement this
end

function placeVillainHpCounter(villain, heroCount)
  local position = villain.hpCounter.position or defaults.villainHpCounter.position
  local rotation = villain.hpCounter.rotation or defaults.villainHpCounter.rotation
  local scale = villain.hpCounter.scale or defaults.villainHpCounter.scale

  local counterTemp
  local villainHpCounter

  --local hitPoints = villain.hitPointsPerPlayer * heroCount
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
      callback = "configureVillainHpCounter"
    })
  end
end

function configureVillainHpCounter(params)
  local counter = params.spawnedObject

  counter.setPosition(params.position)
  counter.setName("")
  counter.setDescription("")
  counter.setLock(params.lock)
  counter.setCustomObject({image = params.imageUrl})

  Wait.frames(
    function()
      counter.reload()
    end,
    10
  )

  --counter.call("setValue", {value = hitPoints})
  --counter.call("createAdvanceButton", {villainKey = villain.name}) --TODO: make this more dynamic, use villainKey instead of name

  -- counters[counter.getGUID()] = {
  --   base = 0,
  --   multiplier = villain.hitPointsPerPlayer
  -- }
end

function placeVillain(villain)
  local villainPosition = villain.deckPosition or defaults.villainDeck.position
  local villainRotation = villain.deckRotation or defaults.villainDeck.rotation
  local villainScale = villain.deckScale or defaults.villainDeck.scale

  --TODO: only place the cards that are needed, based on mode
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

function placeScheme(scheme)
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
      placeThreatCounter(counter, nil, getHeroCount())
    end,
    1
  )
end

function placeThreatCounter(counter, stageNumber, heroCount)
  local threatCounterPosition = counter.position or defaults.mainSchemeThreatCounter.position
  local threatCounterRotation = counter.rotation or defaults.mainSchemeThreatCounter.rotation
  local threatCounterScale = counter.scale or defaults.mainSchemeThreatCounter.scale

  -- local threatBase
  -- local threatMultiplier
  -- local initialThreat

  -- if(stageNumber ~= nil) then
  --   threatBase = scheme.stages[stageNumber].threatBase
  --   threatMultiplier = scheme.stages[stageNumber].threatMultiplier
  -- else
  --   threatBase = scheme.threatBase
  --   threatMultiplier = scheme.threatMultiplier
  -- end

  -- initialThreat = threatBase + (threatMultiplier * heroCount)

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
      --threatCounter.call("setValue", {value = initialThreat})
    end,
    1
  )

  -- counters[threatCounter.getGUID()] = {
  --   base = threatBase,
  --   multiplier = threatMultiplier
  -- }
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

function getHeroCount()
  local allObjects = getAllObjects()
  local playmatCount = 0
 
  for _, obj in pairs(allObjects) do
    if(obj.hasTag("Playmat")) then
     playmatCount = playmatCount + 1
    end
  end
 
  return playmatCount
 end

 function updateCounters()
  local heroCount = getHeroCount()

  for guid, calc in pairs(counters) do
    local counter = getObjectFromGUID(guid)
    newValue = calc.base + (calc.multiplier * heroCount)
    counter.call("setValue", {value = newValue})
  end
 end

 function clearScenario()
  --TODO: call this when clearing the scenario area
  scenarioInfo = {}
  mode = ""
  counters = {}
  vilains = {}
 end

function spawnNemesis(params)
  local heroManager = getObjectFromGUID(Global.getVar("HERO_MANAGER_GUID"))
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
end


--Layout functions - move to central layout manager

local originPosition = {x = 83.25, y = 0.50, z = 33.75}

local rowGap = 2.5
local columnGap = 5

local rows = 12

function layOutScenarios()
  local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))

  layoutManager.call("layOutSelectorTiles", {
      origin = originPosition,
      direction = "vertical",
      maxRowsOrColumns = rows,
      columnGap = columnGap,
      rowGap = rowGap,
      items = scenarios,
      itemType = "scenario"
  }) 
end

function deleteScenarios()
  local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
  layoutManager.call("clearSelectorTiles", {itemType = "scenario"})
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
