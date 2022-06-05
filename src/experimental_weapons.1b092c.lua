function onLoad()
    self.createButton({
        label="Experimental Weapons", click_function="buttonPlace", function_owner=self,
        position={0,4.3,0}, rotation={0,0,0}, height=1000, width=3000,
        font_size=300, color={0,0,0}, font_color={1,1,1}, tooltip="Add Modular"
    })
end

function buttonPlace()
  self.takeObject({index = 0, position = {-12.75, 1.01, 22.25}, rotation = {0,180,180}})
end

function onObjectLeaveContainer(container, obj)
    if container == self then
        local objClone = obj.clone({position = self.getPosition()})
        self.putObject(objClone)
    end
end





