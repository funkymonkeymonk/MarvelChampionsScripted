local itemType = ""
local itemKey = ""
local itemName = ""

function onload(saved_data)
    if(saved_data ~= "") then
        local loaded_data = JSON.decode(saved_data)
        itemType = loaded_data.itemType
        itemKey = loaded_data.itemKey
        itemName = loaded_data.itemName
    end

    if(itemType == "hero") then
        createHeroButtons()
    end
    if(itemType == "scenario") then
        createScenarioButtons()
    end
    if(itemType == "modular-set") then
        createModularSetButton()
    end
end

function setUpTile(params)
    itemType = params.itemType
    itemKey = params.itemKey
    itemName = params.itemName
    imageUrl = params.imageUrl

    local saved_data = JSON.encode({
        itemType = itemType,
        itemKey = itemKey,
        itemName = itemName
    })
    self.script_state = saved_data

    self.setName(itemName)
    self.setDescription("")

    if(imageUrl ~= nil) then
        self.UI.setCustomObject({
            image = imageUrl
        })
    end
    
    self.reload()
end

function createHeroButtons()
    self.createButton({
      label = "S|", click_function = "placeHeroWithStarterDeck", function_owner = self,
      position = {-1,0.2,-0.12}, rotation = {0,0,0}, height = 560, width = 550,
      font_size = 600, color = {1,1,1}, font_color = {0,0,0}, tooltip = "Starter"
    })
    self.createButton({
      label = "C", click_function = "placeHeroWithHeroDeck", function_owner = self,
      position = {-0.24,0.2,-0.12}, rotation = {0,0,0}, height = 560, width = 550, 
      font_size = 600, color = {1,1,1}, font_color = {0,0,0}, tooltip = "Constructed"
    })
end

function createScenarioButtons()
    self.createButton({
      label = "GO", click_function = "placeScenario", function_owner = self,
      position = {0.85,0.2,-0.18}, rotation = {0,0,0}, height = 540, width = 875, 
      font_size = 500, color = {1,1,1}, font_color = {0,0,0}, tooltip = "Set Up Scenario"
    })
  
    -- tile.createButton({
    --   label = "S|", click_function = "placeScenarioInStandardMode", function_owner = tile,
    --   position = {0.47,0.2,-0.15}, rotation = {0,0,0}, height = 540, width = 530,
    --   font_size = 600, color = {1,1,1}, font_color = {0,0,0}, tooltip = "Standard Mode"
    -- })
    -- tile.createButton({
    --   label = "E", click_function = "placeScenarioInExpertMode", function_owner = tile,
    --   position = {1.17,0.2,-0.18}, rotation = {0,0,0}, height = 540, width = 530, 
    --   font_size = 600, color = {1,1,1}, font_color = {0,0,0}, tooltip = "Expert Mode"
    -- })
end

function createModularSetButton()
    local fontSize = 10 / string.len(itemName) * 400

    if(fontSize > 400) then fontSize = 400 end
    if(fontSize < 200) then fontSize = 200 end

    self.createButton({
        label=itemName, click_function="placeModularSet", function_owner=self,
        position={0,0.2,0}, rotation={0,0,0}, height=1000, width=2500,
        font_size=fontSize, color={0,0,0}, font_color={1,1,1}
    })
end

function placeHeroWithStarterDeck(obj, player_color)
    local heroManager = getObjectFromGUID(Global.getVar("HERO_MANAGER_GUID"))
    heroManager.call("placeHeroWithStarterDeck", {heroKey = itemKey, playerColor = player_color})
end
function placeHeroWithHeroDeck(obj, player_color)
    local heroManager = getObjectFromGUID(Global.getVar("HERO_MANAGER_GUID"))
    heroManager.call("placeHeroWithHeroDeck", {heroKey = itemKey, playerColor = player_color})
end

function placeScenario(obj, player_color)
    local scenarioManager = getObjectFromGUID(Global.getVar("SCENARIO_MANAGER_GUID"))
    scenarioManager.call("placeUnscriptedScenario", {scenarioKey = itemKey})
end

  --   function placeScenarioInStandardMode(obj, player_color)
  --     local scenarioPlacer = getObjectFromGUID(Global.getVar("SCENARIO_MANAGER_GUID"))
  --     scenarioPlacer.call("placeScenarioInStandardMode", {scenarioBagGuid = "]]..scenarioBagGuid..[["})
  --   end
  --   function placeScenarioInExpertMode(obj, player_color)
  --     local scenarioPlacer = getObjectFromGUID(Global.getVar("SCENARIO_MANAGER_GUID"))
  --     scenarioPlacer.call("placeScenarioInExpertMode", {scenarioBagGuid = "]]..scenarioBagGuid..[["})
  --   end 

function placeModularSet(obj, player_color)
    local modularSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))
    modularSetManager.call("placeModularSet", {modularSetKey = itemKey})
end