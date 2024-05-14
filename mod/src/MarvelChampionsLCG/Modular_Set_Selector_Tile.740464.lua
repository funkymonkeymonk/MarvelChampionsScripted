itemType = ""
itemKey = ""
itemName = ""
local behavior = ""

local modularSetManager = getObjectFromGUID(Global.getVar("GUID_MODULAR_SET_MANAGER"))
local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))

function onload(saved_data)
    if(saved_data ~= "") then
        local loaded_data = JSON.decode(saved_data)
        itemType = loaded_data.itemType
        itemKey = loaded_data.itemKey
        itemName = loaded_data.itemName
        behavior = loaded_data.behavior
    end

    createModularSetButton()
end

function setUpTile(params)
    itemType = params.itemType
    itemKey = params.itemKey
    itemName = params.itemName
    behavior = params.behavior or "layOut"
    imageUrl = params.imageUrl

    local saved_data = JSON.encode({
        itemType = itemType,
        itemKey = itemKey,
        itemName = itemName,
        behavior = behavior
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

function createModularSetButton()
    if(itemKey == "") then return end
    
    local fontSize = 10 / string.len(itemName) * 400

    if(fontSize > 400) then fontSize = 400 end
    if(fontSize < 200) then fontSize = 200 end

    self.setName("")

    if(behavior == "layout") then
        self.createButton({
            label=itemName, click_function="placeModularSet", function_owner=self,
            position={0,0.2,0}, rotation={0,0,0}, height=1000, width=2500,
            font_size=fontSize, color={0,0,0}, font_color={1,1,1}, hover_color={0,0,0}
        })

        return
    end

    self.createButton({
        label=itemName, 
        click_function="selectModularSet", 
        function_owner=self,
        position={0,0.1,0}, 
        rotation={0,0,0}, 
        height=1000, 
        width=2500,
        font_size=fontSize, 
        color={0,0,0,0}, 
        font_color={1,1,1,100}
    })
end

function setButtonColor(params)
    local required = params.required
    local color

    if(required == "none") then
        color = {1,1,1,100}
    elseif(required == "required") then
        color = {1,0,0,100}
    else 
        color={0,0,1,100}
    end

    self.editButton({index=0, font_color=color})
end

function placeModularSet(obj, player_color)
    layoutManager.call("placeModularSet", {modularSetKey = itemKey})
end

function selectModularSet(obj, player_color)
    layoutManager.call("selectModularSet", {modularSetKey = itemKey})
end

function showSelection(params)
    local selected = params.selected
    -- if(selected) then
    --     self.highlightOn({0,1,0})
    -- else
    --     self.highlightOff()
    -- end
end