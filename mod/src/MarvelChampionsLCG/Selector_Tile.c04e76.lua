itemType = ""
itemKey = ""
itemName = ""
local behavior = ""
local isVisible = false

function onload(saved_data)
    self.interactable = false

    if(saved_data ~= "") then
        local loaded_data = JSON.decode(saved_data)
        itemType = loaded_data.itemType
        itemKey = loaded_data.itemKey
        itemName = loaded_data.itemName
        behavior = loaded_data.behavior
        isVisible = loaded_data.isVisible
    end

    if(isVisible) then
        createButton()
    end
end

function setUpTile(params)
    itemType = params.itemType
    itemKey = params.itemKey
    itemName = params.itemName
    behavior = params.behavior or "layOut"
    imageUrl = params.imageUrl
    isVisible = params.isVisible

    local saved_data = JSON.encode({
        itemType = itemType,
        itemKey = itemKey,
        itemName = itemName,
        behavior = behavior,
        isVisible = isVisible
    })
    self.script_state = saved_data

    self.setName(itemName)
    self.setDescription("")

    if(imageUrl ~= nil) then
        self.setCustomObject({
            image = imageUrl
        })
    end
    
    self.reload()
end

function createButton()
    if(itemType == "hero") then
        createHeroButtons()
    end
    if(itemType == "scenario") then
        createScenarioButtons()
    end        
end

function createHeroButtons()
    self.createButton({
      label = "SELECT", click_function = "placeHeroWithStarterDeck", function_owner = self,
      position = {-0.60,0.2,-0.07}, rotation = {0,0,0}, height = 560, width = 550,
      font_size = 250, color = {0,0,0,0}, font_color = {0,0,0,100}, tooltip = "Select "..itemName
    })
    -- self.createButton({
    --   label = "H", click_function = "placeHeroWithHeroDeck", function_owner = self,
    --   position = {-0.19,0.2,-0.07}, rotation = {0,0,0}, height = 560, width = 550, 
    --   font_size = 600, color = {0,0,0,0}, font_color = {0,0,0,100}, tooltip = itemName.."(hero cards only)"
    -- })
end

function createScenarioButtons()
    if(behavior == "layOut") then
        self.createButton({
            label = "GO", click_function = "placeScenario", function_owner = self,
            position = {0.85,0.2,-0.18}, rotation = {0,0,0}, height = 540, width = 875, 
            font_size = 500, color = {0,0,0,0}, font_color = {0,0,0,100}, tooltip = "Set Up "..itemName
        })
        return
    end

    self.createButton({
        label = "SELECT", click_function = "selectScenario", function_owner = self,
        position = {0.85,0.2,-0.18}, rotation = {0,0,0}, height = 540, width = 875, 
        font_size = 250, color = {0,0,0,0}, font_color = {0,0,0,100}, tooltip = "Select "..itemName
    })
end

function placeHeroWithStarterDeck(obj, player_color)
    local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
    layoutManager.call("placeHeroWithStarterDeck", {heroKey = itemKey, playerColor = player_color})
    layoutManager = nil
end
function placeHeroWithHeroDeck(obj, player_color)
    local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
    layoutManager.call("placeHeroWithHeroDeck", {heroKey = itemKey, playerColor = player_color})
    layoutManager = nil
end

function placeScenario(obj, player_color)
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call("placeUnscriptedScenario", {scenarioKey = itemKey})
    scenarioManager = nil
end

function selectScenario(obj, player_color)
    local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
    layoutManager.call("selectScenario", {scenarioKey = itemKey})
    layoutManager = nil
end

function showSelection(params)
    local selected = params.selected

    if(selected) then
        self.highlightOn({0,1,0})
    else
        self.highlightOff()
    end
end

function hideTile()
    self.clearButtons()
    self.highlightOff()
end

function showTile()
    createButton()
end
