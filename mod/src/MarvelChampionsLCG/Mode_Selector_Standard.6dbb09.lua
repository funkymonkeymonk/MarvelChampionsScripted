preventDeletion = true

function onload(saved_data)
    self.interactable = false
end

function createButton()
    self.createButton({
        label = "STANDARD",
        click_function = "setMode",
        function_owner = self,
        position = {0,0.1,0},
        rotation = {0,0,0},
        width = 2750,
        height = 1000,
        font_size = 500,
        color = {0,0,0,0},
        font_color = {1,1,1,100}
    })
end

function setMode()
    local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
    layoutManager.call("setMode", {mode = "standard"})
end

function hideTile()
    self.clearButtons()
    self.highlightOff()
end

function showTile()
    createButton()
end
