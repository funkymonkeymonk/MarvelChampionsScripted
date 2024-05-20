local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))

function onload()
    self.interactable = false
    createButton()
end

function createButton()
    local button = {
        click_function = "placeApocalypsePrelate",
        function_owner = scenarioManager,
        label = "SUMMON PRELATE",
        position = {0, 0.1, 0.8},
        rotation = {0, 0, 0},
        width = 750,
        height = 100,
        font_size = 80,
        color = {0,0,0,0},
        font_color = {0.165, 0.51, 0.373, 100},
    }
    self.createButton(button)
end
