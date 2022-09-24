--[[
    {0,0,0} is the center of the character sheet
    {1,0,0} is right, {-1,0,0} is left
    {0,0,-1} is up, {0,0,1} is down
    0.1 for Y is the height off of the page.
        If it was 0, it would be down inside the model of the sheet
]]

--This is the button placement information
defaultButtonData = {
    --Add checkboxes
    checkbox = {
        --[[
        {
            pos   = {0,0.2,0}, -- the position (pasted from the helper tool)
            size  = 800,     -- height/width/font_size for checkbox
            state = false    -- default starting value for checkbox (true=checked, false=not)
        },
        ]]
        {
            pos = {0.0,0.2,0.0},
            size  = 800,
            state = true},
        },
    --Add counters that have a + and - button
    counter = {
        --[[
        {
            pos    = {0,0,0}, -- the position (pasted from the helper tool)
            size   = 500,     -- height/width/font_size for counter
            value  = 0,       -- default starting value for counter
            hideBG = true     -- if background of counter is hidden (true=hidden, false=not)
        },
        ]]
    },
    --Add editable text boxes
    textbox = {
        --[[
        {
            pos       = {-0.0,0.1,0.0}, -- the position (pasted from the helper tool)
            rows      = 1,              -- how many lines of text you want for this box
            width     = 7000,           -- how wide the text box is
	        height    = 1000,           -- how tall the text box is
            font_size = 400,            -- size of text. This and "rows" effect overall height
            label     = "",             -- what is shown when there is no text. "" = nothing
            value     = "",             -- text entered into box. "" = nothing
            alignment = 3               -- Number to indicate how you want text aligned (1=Automatic, 2=Left, 3=Center, 4=Right, 5=Justified)
        },
        ]]
    }
}

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



