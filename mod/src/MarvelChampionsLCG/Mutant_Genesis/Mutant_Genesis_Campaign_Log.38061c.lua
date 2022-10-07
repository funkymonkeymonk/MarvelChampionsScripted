--[[
    {0,0,0} is the center of the character sheet
    {1,0,0} is right, {-1,0,0} is left
    {0,0,-1} is up, {0,0,1} is down
    0.1 for Y is the height off of the page.
        If it was 0, it would be down inside the model of the sheet
]]

-- TODO: make grid in game toggleable
-- grid = true

function newCheckBox(pos, size, state)
    return  { pos = pos, size = size, state = state}
end

function newCounter(pos, size, value, hideBG)
    return  { pos = pos, size = size, value = value, hideBG = hideBG}
end

function newTextbox(pos, rows, width, height, font_size, label, value, alignment)
    return {
        pos = pos,
        rows = rows,
        width = width,
        height = height,
        font_size = font_size,
        label = label,
        value = value,
        alignment = alignment
    }
end

function table.merge(t1, t2)
   for k,v in ipairs(t2) do
      table.insert(t1, v)
   end

   return t1
end

--This is the button placement information
defaultButtonData = {
    checkbox = {},
    counter = {},
    textbox = {}
}

-- Player Information
for i=0,3 do
    local offset = 0.871
    table.insert(defaultButtonData.textbox, newTextbox({-1.3+(offset*i),0.2,-1.185}, 1,  3500, 1000, 400, "", "", 3))
    table.insert(defaultButtonData.textbox, newTextbox({-1.53+(offset*i),0.2,-0.975}, 1,  1800, 1000, 400, "", "", 3))
    table.insert(defaultButtonData.counter, newCounter({-1.1 + offset * i,0.2,-0.975}, 500, 0, true))
end

-- Scenarios
for i=0,3 do
    local offset = 0.871
    table.insert(defaultButtonData.checkbox, newCheckBox({-1.57 + offset * i,0.2,-0.64}, 500, 0, true))
end

-- Future Past Cards in Victory Display
table.insert(defaultButtonData.textbox, newTextbox({0.0,0.2,-0.3}, 1,  15000, 1000, 400, "", "", 3))

-- Future Past Cards in Encounter Deck
for i=0,3 do
    local offset = 0.871
    table.insert(defaultButtonData.textbox, newTextbox({-1.3+(offset*i),0.2,0.075}, 1,  3000, 1000, 400, "", "", 3))
end

-- Role upgrades in play
for i=0,3 do
    local offset = 0.871
    table.insert(defaultButtonData.textbox, newTextbox({-1.3+(offset*i),0.2,0.55}, 3,  3000, 1000, 400, "", "", 3))
end

-- Jubilee
for i=0,2 do
    local offset = 1.0
    table.insert(defaultButtonData.checkbox, newCheckBox({-1.425 + offset * i,0.2,1.075}, 400, 0, true))
end

for i=0,1 do
    local offset = 1.0
    table.insert(defaultButtonData.checkbox, newCheckBox({-0.425 + offset * i,0.2,1.175}, 400, 0, true))
end

-- Allies
for i=0,1 do
    local offset = 1.8
    table.insert(defaultButtonData.textbox, newTextbox({-0.9+(offset*i),0.2,1.55}, 3,  6000, 1000, 400, "", "", 3))
end


--Library Code
disableSave = false
--Color information for button text (r,g,b, values of 0-1)
buttonFontColor = {0,0,0}
--Color information for button background
buttonColor = {1,1,1}
--Change scale of button (Avoid changing if possible)
buttonScale = {0.1,0.1,0.1}

--Save function
function updateSave()
    saved_data = JSON.encode(ref_buttonData)
    if disableSave==true then saved_data="" end
    self.script_state = saved_data
end

--Startup procedure
function onload(saved_data)
    if disableSave==true then saved_data="" end
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        ref_buttonData = loaded_data
    else
        ref_buttonData = defaultButtonData
    end

    spawnedButtonCount = 0
    createCheckbox()
    createCounter()
    createTextbox()
    if grid then drawLayoutGrid() end
end



--Click functions for buttons



--Checks or unchecks the given box
function click_checkbox(tableIndex, buttonIndex)
    if ref_buttonData.checkbox[tableIndex].state == true then
        ref_buttonData.checkbox[tableIndex].state = false
        self.editButton({index=buttonIndex, label=""})
    else
        ref_buttonData.checkbox[tableIndex].state = true
        self.editButton({index=buttonIndex, label=string.char(10008)})
    end
    updateSave()
end

--Applies value to given counter display
function click_counter(tableIndex, buttonIndex, amount)
    ref_buttonData.counter[tableIndex].value = ref_buttonData.counter[tableIndex].value + amount
    self.editButton({index=buttonIndex, label=ref_buttonData.counter[tableIndex].value})
    updateSave()
end

--Updates saved value for given text box
function click_textbox(i, value, selected)
    if selected == false then
        ref_buttonData.textbox[i].value = value
        updateSave()
    end
end

--Dud function for if you have a background on a counter
function click_none() end



--Button creation



--Makes checkboxes
function createCheckbox()
    for i, data in ipairs(ref_buttonData.checkbox) do
        --Sets up reference function
        local buttonNumber = spawnedButtonCount
        local funcName = "checkbox"..i
        local func = function() click_checkbox(i, buttonNumber) end
        self.setVar(funcName, func)
        --Sets up label
        local label = ""
        if data.state==true then label=string.char(10008) end
        --Creates button and counts it
        self.createButton({
            label=label, click_function=funcName, function_owner=self,
            position=data.pos, height=data.size, width=data.size,
            font_size=data.size, scale=buttonScale,
            color=buttonColor, font_color=buttonFontColor
        })
        spawnedButtonCount = spawnedButtonCount + 1
    end
end

--Makes counters
function createCounter()
    for i, data in ipairs(ref_buttonData.counter) do
        --Sets up display
        local displayNumber = spawnedButtonCount
        --Sets up label
        local label = data.value
        --Sets height/width for display
        local size = data.size
        if data.hideBG == true then size = 0 end
        --Creates button and counts it
        self.createButton({
            label=label, click_function="click_none", function_owner=self,
            position=data.pos, height=size, width=size,
            font_size=data.size, scale=buttonScale,
            color=buttonColor, font_color=buttonFontColor
        })
        spawnedButtonCount = spawnedButtonCount + 1

        --Sets up add 1
        local funcName = "counterAdd"..i
        local func = function() click_counter(i, displayNumber, 1) end
        self.setVar(funcName, func)
        --Sets up label
        local label = "+"
        --Sets up position
        local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
        local offsetHeight = 0.03
        local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3] - offsetHeight}
        --Sets up size
        local size = data.size / 2
        --Creates button and counts it
        self.createButton({
            label=label, click_function=funcName, function_owner=self,
            position=pos, height=size, width=size,
            font_size=size, scale=buttonScale,
            color=buttonColor, font_color=buttonFontColor
        })
        spawnedButtonCount = spawnedButtonCount + 1

        --Sets up subtract 1
        local funcName = "counterSub"..i
        local func = function() click_counter(i, displayNumber, -1) end
        self.setVar(funcName, func)
        --Sets up label
        local label = "-"
        --Set up position
        local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3] + offsetHeight}
        --Creates button and counts it
        self.createButton({
            label=label, click_function=funcName, function_owner=self,
            position=pos, height=size, width=size,
            font_size=size, scale=buttonScale,
            color=buttonColor, font_color=buttonFontColor
        })
        spawnedButtonCount = spawnedButtonCount + 1
    end
end

function createTextbox()
    for i, data in ipairs(ref_buttonData.textbox) do
        --Sets up reference function
        local funcName = "textbox"..i
        local func = function(_,_,val,sel) click_textbox(i,val,sel) end
        self.setVar(funcName, func)

        self.createInput({
            input_function = funcName,
            function_owner = self,
            label          = data.label,
            alignment      = data.alignment,
            position       = data.pos,
            scale          = buttonScale,
            width          = data.width,
            height         = (data.font_size*data.rows)+24,
            font_size      = data.font_size,
            color          = buttonColor,
            font_color     = buttonFontColor,
            value          = data.value,
        })
    end
end

-- Custom tools for easier creation
WHITE={1,1,1}
BLACK={0,0,0}
GREY={0.5,0.5,0.5}

function line(p1, p2, color)
    return {
        points    = { p1, p2 },
        color     = color,
        thickness = 0.01,
        rotation  = {0,0,0},
    }
end

function drawLayoutGrid()
    lines = {}
    for i=-20,20 do
        local cord = i/10
        if i == 0 then
            table.insert(lines, line({cord,1,-2}, {cord,1,2}, WHITE))
            table.insert(lines, line({-2,1,cord}, {2,1,cord}, WHITE))
        else
            table.insert(lines, line({cord,1,-2}, {cord,1,2}, GREY))
            table.insert(lines, line({-2,1,cord}, {2,1,cord}, GREY))
        end

        if i%5 == 0 then
            table.insert(lines, line({cord,1,-0.1}, {cord,1,0.1}, BLACK))
            table.insert(lines, line({-0.1,1,cord}, {0.1,1,cord}, BLACK))
        end
    end
    self.setVectorLines(lines)
end

function table.merge(t1, t2)
   for k,v in ipairs(t2) do
      table.insert(t1, v)
   end

   return t1
end

