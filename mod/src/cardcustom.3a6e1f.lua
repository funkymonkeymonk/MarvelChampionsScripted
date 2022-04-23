function onload()

   self.createButton({
      label          = "Start",
      click_function = "playerCount",
      function_owner = self,
      position       = {0,0.3,0},
      rotation       = {0,90,0},
      width          = 2000,
      height         = 1000,
      font_size      = 500,
      color          = {1,1,0},
      tooltip        = "Let's go!"
   })

end

function playerCount()
getObjectFromGUID('e3b2e1').call('createPlayers')
self.destruct()
end


