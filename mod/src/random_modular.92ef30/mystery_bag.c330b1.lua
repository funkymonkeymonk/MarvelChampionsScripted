function onload(saved_data)
    self.createButton({
        label="Add", click_function="buttonPlace", function_owner=self,
        position={3.5,0.5,0}, rotation={0,0,0}, height=1000, width=1500,
        font_size=700, color={0,0,0}, font_color={1,1,1}, tooltip="Add Modular"
    })
end

function buttonPlace()
  self.takeObject({index = 0, position = {-12.75, 1.01, 22.25}, rotation = {0,180,180}})
  self.takeObject({index = 0, position = {-13.00, 2.97, -35.00}, rotation = {0,180,0}})
  self.destruct()
end


