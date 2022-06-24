function onload()

   self.createButton({
      label          = "Clear",
      click_function = "clearInvis",
      function_owner = self,
      position       = {0,0.3,0},
      rotation       = {0,0,0},
      width          = 650,
      height         = 650,
      font_size      = 350,
      color          = {1,1,1},
      tooltip        = "Clear"
   })
end

function clearInvis()
   getObjectFromGUID('71e09c').destroy()
   getObjectFromGUID('cab71a').destroy()
   getObjectFromGUID('5dcfd5').destroy()
   getObjectFromGUID('57ec93').destroy()
   getObjectFromGUID('e6a306').destroy()
   getObjectFromGUID('e8914a').destroy()
   getObjectFromGUID('61e7e8').destroy()
   getObjectFromGUID('dd5292').destroy()
end

