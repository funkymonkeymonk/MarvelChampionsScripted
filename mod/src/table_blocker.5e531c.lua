function onload()

  blockSetter()

end

function blockSetter()

   self.createButton({
      click_function = "blockTable",
      function_owner = self,
      position       = {0,0,0},
      rotation       = {0,0,0},
      width          = 350,
      height         = 350,
      tooltip        = "Block Table Image"
   })

end

function blockTable()
  blockImage = getObjectFromGUID("321cd7")
  blockImage.setPosition{0,0.9,0}
  self.clearButtons()
  restoreSetter()
end

function restoreSetter()

   self.createButton({
      click_function = "restoreTable",
      function_owner = self,
      position       = {0,0,0},
      rotation       = {0,0,0},
      width          = 350,
      height         = 350,
      tooltip        = "Restore Table Image"
   })

end

function restoreTable()
  blockImage = getObjectFromGUID("321cd7")
  blockImage.setPosition{0,0,0}
  self.clearButtons()
  blockSetter()
end




