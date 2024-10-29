itemType = ""
itemKey = ""
itemName = ""
local behavior = ""
local required = false
local isVisible = false
local label = ""
local fontSize = 0
local fontColor = {1,1,1,100}

function onload(saved_data)
    self.interactable = false

    if(saved_data ~= "") then
        local loaded_data = JSON.decode(saved_data)
        itemType = loaded_data.itemType
        itemKey = loaded_data.itemKey
        itemName = loaded_data.itemName
        behavior = loaded_data.behavior
        isVisible = loaded_data.isVisible
        label = loaded_data.label
        fontSize = loaded_data.fontSize
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

    local labelInfo = formatLabel()

    label = labelInfo.text

    if(labelInfo.length <= 10) then
        fontSize = 400
    else
        fontSize = 400 - (labelInfo.length - 10) * 20
    end

    local saved_data = JSON.encode({
        itemType = itemType,
        itemKey = itemKey,
        itemName = itemName,
        behavior = behavior,
        isVisible = isVisible,
        label = label,
        fontSize = fontSize
    })
    self.script_state = saved_data

    if(imageUrl ~= nil) then
        self.setCustomObject({
            image = imageUrl
        })
    end
    
    self.reload()
end

function createButton()
    self.createButton({
        label=label, 
        click_function="selectModularSet", 
        function_owner=self,
        position={0,0.1,0}, 
        rotation={0,0,0}, 
        height=1000, 
        width=2500,
        font_size=fontSize, 
        color={0,0,0,0}, 
        font_color=fontColor
    })
end

function formatLabel()
    if(string.len(itemName) <= 10 or string.find(itemName, " ") == nil) then
        return {
            text=itemName,
            length=string.len(itemName)
        }
    end

    local words = getItemNameWords()
    local firstLine = ""
    local secondLine = ""
    local firstLineOffset = 0
    local secondLineOffset = 0

    for i=1, #words do
        if(string.len(firstLine) >= string.len(secondLine)) then
            local index = #words - secondLineOffset
            secondLineOffset = secondLineOffset + 1
            secondLine = words[index] .. " " .. secondLine
        else
            local index = 1 + firstLineOffset
            firstLineOffset = firstLineOffset + 1
            firstLine = firstLine .. " " .. words[index]
        end
    end

    local length = string.len(firstLine) > string.len(secondLine) and string.len(firstLine) or string.len(secondLine)

    return {
        text = trim(firstLine) .. "\n" .. trim(secondLine),
        length = length
    }
end

function getItemNameWords ()
    local t={}

    for str in string.gmatch(itemName, "[%w']*[%w]+") do
        table.insert(t, str)
    end

    return t
end

function trim(s)
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function setButtonColor(params)
    local requirement = params.required

    if(requirement == "none") then
        fontColor = {1,1,1,100}
        required = false
    elseif(requirement == "required") then
        fontColor = {0.89,0,0.55,100}
        required = true
    else 
        fontColor={1,0.886,0,100}
        required = false
    end

    if(isVisible) then
        self.editButton({index=0, font_color=color})
    end
end

function placeModularSet(obj, player_color)
    local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
    layoutManager.call("placeModularSet", {modularSetKey = itemKey})
    layoutManager = nil
end

function selectModularSet(obj, player_color)
    if(required) then
        broadcastToAll("This modular set is required for the selected scenario.", {1,1,1})
        return
    end

    local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
    layoutManager.call("selectModularSet", {modularSetKey = itemKey})
    layoutManager = nil
end

function showSelection(params)
    local selected = params.selected
end

function hideTile()
    self.clearButtons()
    self.highlightOff()
end

function showTile()
    createButton()
end
