function onload(saved_data)
    createBoostButton()
end

function createBoostButton()
    self.createButton({
      label = "BOOST",
      click_function = "drawBoost",
      function_owner = self,
      position = {-2,0.1,0},
      rotation = {0,0,0},
      width = 3400,
      height = 1500,
      font_size = 1700,
      color = {1,1,0}
    })
  
    self.createButton({
      label = "X",
      click_function = "discardBoost",
      function_owner = self,
      position = {3,0.1,0},
      rotation = {0,0,0},
      width = 1000,
      height = 1500,
      font_size = 1700,
      color = {1,0,0}
    })
end

function drawBoost(object, player, isRightClick)
    Global.call("drawBoostcard", {self.getRotation()})
end

function discardBoost(object, player, isRightClick)
    Global.call("discardBoostcard", {self.getRotation()})
end
