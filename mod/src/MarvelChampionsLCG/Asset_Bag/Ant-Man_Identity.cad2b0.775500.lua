function onload()

   self.createButton({
      label          = "︿",
      click_function = "giantForm",
      function_owner = self,
      position       = {0.85,0.3,-0.9},
      rotation       = {0,0,0},
      width          = 130,
      height         = 120,
      font_size      = 100,
      color          = {1,0,0},
      tooltip        = "Giant Form"
   })

   self.createButton({
      label          = "︿",
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

function giantForm()
 self.setState(3)
 --setGiantPlaymatImage()
end

function normalForm()
   self.setState(2)
   --setNormalPlaymatImage()
end

function tinyForm()
 self.setState(1)
 --setTinyPlaymatImage()
end

function setGiantPlaymatImage()
   local playmat = findPlaymatAtLocation()
   if(playmat == nil) then return end
   playmat.setCustomObject({image="https://steamusercontent-a.akamaihd.net/ugc/1861691360008104730/B3D1957D7E9DEC6AD24E02A356ECB5D17FB07505/"})
   playmat.reload()
end

function setNormalPlaymatImage()
   local playmat = findPlaymatAtLocation()
   if(playmat == nil) then return end
   playmat.setCustomObject({image="https://steamusercontent-a.akamaihd.net/ugc/2294085177765822128/384297FEC9158D71F8A6AA8F0E14B0E06ADB43C8/"})
   playmat.reload()
end

function setTinyPlaymatImage()
   local playmat = findPlaymatAtLocation()
   if(playmat == nil) then return end
   playmat.setCustomObject({image="https://steamusercontent-a.akamaihd.net/ugc/1861691360008104803/C12E71E7CB737BADA41097F594BA71181CBB1E67/"})
   playmat.reload()
end

function findPlaymatAtLocation()
   cardPos = self.getPosition()
   local objList = Physics.cast({
      origin       = cardPos,
      direction    = {0,1,0},
      type         = 3,
      size         = {26,1,15},
      max_distance = 0,
      debug        = false,
   })

   for _, obj in ipairs(objList) do
      if(obj.hit_object.hasTag("Playmat")) then
         return obj.hit_object
      end
   end

   return nil
end
