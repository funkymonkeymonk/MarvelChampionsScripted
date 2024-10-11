MIN_VALUE = 0
MAX_VALUE = 30

function updateSave()
    local data_to_save = {value}
    saved_data = JSON.encode(data_to_save)
    self.script_state = saved_data
end

function onload(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        --Set up information off of loaded_data
        value = loaded_data[1]
    else
        --Set up information for if there is no saved saved data
        value = 0
    end

    createBtns()
end


--Beginning Setup


--Make setup button
function createBtns()
	local pos = {0,0.1,0.1}
	local rot = {0,0,0}
	local h = 200
	local w = 200
	local f_size = 400
	local f_color = {1,1,1,255}
	local bg_color = {0,0,0,0}
	local diff = 0.8
	
	--center display
	self.createButton({
  label=tostring(value),
  click_function="add_subtract",
  function_owner=self,
  position=pos,
  rotation=rot,
  height=h,
  width=w,
  font_size=f_size,
  scale={x=3, y=3, z=3},
  color=f_size,
  font_color=f_color, 
  color = bg_color
})
	
end

function add_subtract(_obj, _color, alt_click)
  mod = alt_click and -1 or 1
  new_value = math.min(math.max(value + mod, MIN_VALUE), MAX_VALUE)
  if value ~= new_value then
    value = new_value
    updateDisplay()
    updateSave()
  end
end

function updateDisplay()
  	self.editButton({index = 0, label = tostring(value)})
end

function setValue(params)
  value = params.value
  updateDisplay()
  updateSave()
end
