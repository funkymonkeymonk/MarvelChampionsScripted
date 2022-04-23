function onload()

   self.createButton({
      click_function = "changeColor",
      function_owner = self,
      position       = {0,0,0},
      rotation       = {0,0,0},
      width          = 500,
      height         = 500,
      tooltip        = "Sit here"
   })
end

function changeColor(obj, clicker)
    local col = Player[clicker].color
    if col ~= "Blue" then
        if Player["Blue"].seated == false then
            Player[col].changeColor("Blue")
        end
    end
end


