function onload(saved_data)
    local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))

    self.createButton({
      label = "MODE",
      click_function = "showModeSelection",
      function_owner = layoutManager,
      position = {0,0.1,0},
      rotation = {0,0,0},
      width = 1610,
      height = 970,
      font_size = 500,
      color = {0,0,0,0},
      font_color = {1,1,1,100}
    })
end
