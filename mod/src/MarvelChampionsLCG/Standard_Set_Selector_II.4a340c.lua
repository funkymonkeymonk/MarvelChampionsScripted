preventDeletion = true

local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))

function onload(saved_data)
    self.interactable = false
    
    self.createButton({
        label = "STANDARD II",
        click_function = "setStandardSet",
        function_owner = self,
        position = {0,0.1,0},
        rotation = {0,0,0},
        width = 3400,
        height = 1000,
        font_size = 500,
        color = {0,0,0,0},
        font_color = {1,1,1,100}
      })
end

function setStandardSet()
    layoutManager.call("setStandardSet", {set = "ii"})
end
