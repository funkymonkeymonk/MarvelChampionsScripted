function onload(saved_data)
  self.interactable = false

  self.createButton({
    label = "SCENARIO",
    click_function = "buttonClick",
    function_owner = self,
    position = {0,0.1,0},
    rotation = {0,0,0},
    width = 2470,
    height = 970,
    font_size = 500,
    color = {0,0,0,0},
    font_color = {1,1,1,100}
  })
end

function buttonClick()
  local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
  layoutManager.call("setView", {view = "scenario"})
end
