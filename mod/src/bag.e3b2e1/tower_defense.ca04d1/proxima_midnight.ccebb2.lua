CONFIG = {
    MIN_VALUE = -99,
    MAX_VALUE = 999,
    FONT_COLOR = {0,0,0,95},
    FONT_SIZE = 600,
    COLOR_HEX = "#000000",
    TOOLTIP_SHOW = true,
    VALUE = 0
}
INJECTED_COUNTER = true


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
      position={0.8, thickness/2, -0.05},
      height=600,
      width=1000,
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

    setTooltips()

   self.createButton({
      label          = "Advance",
      click_function = "nextPhase",
      function_owner = self,
      position       = {0,0.3,-1.4},
      rotation       = {0,0,0},
      width          = 800,
      height         = 300,
      font_size      = 200,
      color          = {0,0,1},
      font_color     = {1,1,1},
      tooltip        = "Next phase!"
   })
end

function nextPhase()
    self.removeButton(1)
    CONFIG.VALUE = "36"
    updateVal()
    editName()
    villainPhase()
end

function villainPhase(object, player, isRightClick)
   local toPosition = {-9.05,2,28.48}
   Global.call("villainPhasecard", {toPosition, self.getRotation(), isRightClick})
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

