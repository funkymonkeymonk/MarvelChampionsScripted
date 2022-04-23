function onload()
  self.shuffle()

  self.createButton({
    label          = "Random",
    click_function = "genRandom",
    function_owner = self,
    position       = {0,4.3,0},
    rotation       = {0,0,0},
    width          = 3000,
    height         = 1000,
    font_size      = 800,
    color          = {0,0,0},
    font_color     = {1,1,1},
    tooltip        = "Generate Mystery Bag"
  })
end

function genRandom()
  self.takeObject({index = 0, position = {93.25, -2.69, -16.25}})
end

