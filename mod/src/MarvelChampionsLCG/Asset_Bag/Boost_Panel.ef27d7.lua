BOOST_POS = {-0.33, 1.8, 8.61}
DISCARD_POS  = {-17.75, 1.4, 22.25}

--TODO: Make this configurable for different scenarios.

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
    local toPosition = BOOST_POS
    Global.call("drawBoostcard", {toPosition, self.getRotation(), isRightClick})
end

function discardBoost(object, player, isRightClick)
    local toPosition = DISCARD_POS
    Global.call("discardBoostcard", {toPosition, self.getRotation(), isRightClick})
end

--position: {0.25, 1.00, 13.40}
