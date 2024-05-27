local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))

function onload()
    self.interactable = false
    createButton()
end

function createButton()
    local button = {
        click_function = "placeDarkBeastEnvironment",
        function_owner = scenarioManager,
        label = "JOURNEY THROUGH TIME AND SPACE!",
        position = {0, 0.1, 0.8},
        rotation = {0, 0, 0},
        width = 1700,
        height = 100,
        font_size = 100,
        color = {0,0,0,0},
        font_color = {1, 0.859, 0, 100},
    }
    self.createButton(button)
end
