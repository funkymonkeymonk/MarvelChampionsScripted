CONFIG = {
    MIN_VALUE = 0,
    MAX_VALUE = 30,
    FONT_COLOR = {0,0,0,95},
    FONT_SIZE = 600,
    COLOR_HEX = "#000000",
    TOOLTIP_SHOW = false,
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
    local scale = {x=1.5, y=1.5, z=1.5}
    local thickness = self.getBoundsNormalized().size.y
    if self.name == "Custom_Tile" then
        thickness = thickness*2
        scale = {0.75, 0.75, 0.75}
    end
    self.createButton({
      label=tostring(CONFIG.VALUE),
      click_function="add_subtract",
      tooltip=ttText,
      function_owner=self,
      position={0, thickness/2, 0.2},
      height=300,
      width=300,
      alignment = 3,
      scale=scale,
      font_size=CONFIG.FONT_SIZE,
      font_color=CONFIG.FONT_COLOR,
      color={0,0,0,0}
      })

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
end

function setValue(params)
    CONFIG.VALUE = params.value
    updateVal()
    updateSave()
end

function getValue()
    return CONFIG.VALUE
end