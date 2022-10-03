function onload()
  self.shuffle()

  self.createButton({
    label          = "Find Loki",
    click_function = "genRandom",
    function_owner = self,
    position       = {23,1,25},
    rotation       = {0,0,0},
    width          = 5000,
    height         = 2000,
    font_size      = 1500,
    color          = {0.15,0.5,0.15},
    font_color     = {1,1,1},
    tooltip        = "The King is here!"
  })
end

function genRandom()
  self.takeObject({index = 0, position = {-0.34, 0.97, 20.44}})
  self.clearButtons()
  self.Shuffle()
  createSwap()
end

function createSwap()
  self.createButton({
    label          = "Swap",
    click_function = "genLoki",
    function_owner = self,
    position       = {0,0.7,5.5},
    rotation       = {0,0,0},
    width          = 3000,
    height         = 1000,
    font_size      = 1500,
    color          = {0.15,0.5,0.15},
    font_color     = {1,1,1},
    tooltip        = "He's over there!"
  })
end

function genLoki()
  self.Shuffle()
  local toPosition = {-13.25, 3, 35.25}
  Global.call("villainPhaseloki", {toPosition, self.getRotation(), isRightClick})
  self.takeObject({index = 0, position = {-0.34, 0.97, 20.44}})
  self.Shuffle()
end



