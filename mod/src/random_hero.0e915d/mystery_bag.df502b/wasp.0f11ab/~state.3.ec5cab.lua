function onload()

   self.createButton({
      label          = "︿",
      click_function = "alterEgo",
      function_owner = self,
      position       = {0.85,0.3,-0.9},
      rotation       = {0,180,0},
      width          = 130,
      height         = 120,
      font_size      = 100,
      color          = {1,0,0},
      tooltip        = "Alter-Ego"
   })

   self.createButton({
      label          = "︽",
      click_function = "tinyForm",
      function_owner = self,
      position       = {0.85,0.3,-0.6},
      rotation       = {0,180,0},
      width          = 130,
      height         = 120,
      font_size      = 100,
      color          = {1,0,0},
      tooltip        = "Tiny Form"
   })

end

function alterEgo()
 self.setState(2)
end

function tinyForm()
 self.setState(1)
end


