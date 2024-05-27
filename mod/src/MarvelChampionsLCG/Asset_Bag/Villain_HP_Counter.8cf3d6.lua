CONFIG = {
    MIN_VALUE = -99,
    MAX_VALUE = 999,
    FONT_COLOR = {0,0,0,95},
    FONT_SIZE = 600,
    COLOR_HEX = "#000000",
    TOOLTIP_SHOW = true,
    VALUE = 0
}
--INJECTED_COUNTER = true


function onload(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        CONFIG = loaded_data
    end
    createAll()
end

function updateSave()
    saved_data = JSON.encode(CONFIG)
    self.script_state = saved_data
end

function createAll()
    if CONFIG.TOOLTIP_SHOW then
        ttText = self.getName().. ": " .. CONFIG.VALUE
    else
        ttText = self.getName()
    end
    local scale = {x=1.5, y=1.5, z=1.5}
    local thickness = self.getBoundsNormalized().size.y
    if self.name == "Custom_Tile" then
        thickness = thickness*2
        scale = {1.35, 1.35, 1.35}
    end
    self.createButton({
      label=tostring(CONFIG.VALUE),
      click_function="add_subtract",
      tooltip=ttText,
      function_owner=self,
      position={0.85, thickness/2, -0.1},
      height=440,
      width=740,
      alignment = 3,
      scale=scale,
      font_size=CONFIG.FONT_SIZE,
      font_color=CONFIG.FONT_COLOR,
      color={0,0,0,0}
      })

    self.createInput({
        value = self.getName(),
        input_function = "editName",
        tooltip=ttText,
        label = "",
        function_owner = self,
        alignment = 3,
        position = {0,thickness/2,0},
        width = 1,
        height = 1,
        font_size = CONFIG.FONT_SIZE/3,
        scale={x=1, y=1, z=1},
        font_color= CONFIG.FONT_COLOR,
        color = {0,0,0,0}
        })

    if(CONFIG.SHOW_ADVANCE_BUTTON) then
        createAdvanceButton()
    end

    setTooltips()
end

function createAdvanceButton()
    self.createButton({
        label = CONFIG.ADVANCE_BUTTON_LABEL or "ADVANCE",
        click_function = "primaryButtonClick",
        function_owner = self,
        position = {0,0.1,-1.8},
        rotation = {0,0,0},
        width = 2000,
        height = 500,
        font_size = 400,
        font_color = {1,1,1},
        color = {0,0,1}
    })    
end

function createSecondaryButton()
    self.createButton({
        label = CONFIG.SECONDARY_BUTTON_LABEL,
        click_function = "secondaryButtonClick",
        function_owner = self,
        position = {0.87,0.2,0.75},
        rotation = {0,0,0},
        width = 1000,
        height = 250,
        font_size = 175,
        font_color = {1,1,0,100},
        color = {0,0,0,0}
    })    
end

function getVillainKey()
    return CONFIG.VILLAIN_KEY
end

function setVillainKey(params)
    CONFIG.VILLAIN_KEY = params.villainKey
    updateSave()
end

function setAdvanceButtonOptions(params)
    CONFIG.ADVANCE_BUTTON_LABEL = params.label
    CONFIG.ADVANCE_BUTTON_FUNCTION = params.clickFunction
    CONFIG.ADVANCE_BUTTON_PARAMS = params.params

    updateSave()
end

function setSecondaryButtonOptions(params)
    CONFIG.SECONDARY_BUTTON_LABEL = params.label
    CONFIG.SECONDARY_BUTTON_FUNCTION = params.clickFunction
    CONFIG.SECONDARY_BUTTON_PARAMS = params.params

    updateSave()
end

function editName(_obj, _string, value)
    self.setName(value)
    setTooltips()
end

function add_subtract(_obj, _color, alt_click)
    mod = alt_click and -1 or 1
    new_value = math.min(math.max(CONFIG.VALUE + mod, CONFIG.MIN_VALUE), CONFIG.MAX_VALUE)
    if CONFIG.VALUE ~= new_value then
        CONFIG.VALUE = new_value
        updateVal()
        updateSave()
    end
end

function updateVal()
    self.editButton({
        index = 0,
        label = tostring(CONFIG.VALUE)
        })
    setTooltips()
end

function setTooltips()
    if CONFIG.TOOLTIP_SHOW then
        ttText = self.getName().. ": " .. CONFIG.VALUE
    else
        ttText = self.getName()
    end

    self.editInput({
        index = 0,
        value = self.getName(),
        tooltip = ttText
        })
    self.editButton({
        index = 0,
        value = tostring(CONFIG.VALUE),
        tooltip = ttText
        })
end

function setValue(params)
    CONFIG.VALUE = params.value
    updateVal()
    updateSave()
end

function primaryButtonClick()
    local functionName = CONFIG.ADVANCE_BUTTON_FUNCTION or "advanceVillain"
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call(functionName, {
        villainKey = CONFIG.VILLAIN_KEY
    })
end

function secondaryButtonClick()
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call(CONFIG.SECONDARY_BUTTON_FUNCTION, {
        villainKey = CONFIG.VILLAIN_KEY
    })
end

function showAdvanceButton()
    if(CONFIG.SHOW_ADVANCE_BUTTON) then return end

    CONFIG.SHOW_ADVANCE_BUTTON = true
    updateSave()

    createAdvanceButton()
end

function hideAdvanceButton()
    if(not CONFIG.SHOW_ADVANCE_BUTTON) then return end

    CONFIG.SHOW_ADVANCE_BUTTON = false
    updateSave()

    removeButtonByLabel(CONFIG.ADVANCE_BUTTON_LABEL or "ADVANCE")
end

function showSecondaryButton()
    if(CONFIG.SHOW_SECONDARY_BUTTON) then return end

    CONFIG.SHOW_SECONDARY_BUTTON = true
    updateSave()

    createSecondaryButton()
end

function hideSecondaryButton()
    if(not CONFIG.SHOW_SECONDARY_BUTTON) then return end

    CONFIG.SHOW_SECONDARY_BUTTON = false
    updateSave()

    removeButtonByLabel(CONFIG.SECONDARY_BUTTON_LABEL)
end

function removeButtonByLabel(buttonLabel)
    for k, button in ipairs(self.getButtons()) do
       if(button.label == buttonLabel) then
           self.removeButton(button.index)
       end
   end
 end
