preventDeletion = true

function onload()

    self.createButton({
       label          = "Clear",
       click_function = "clearVillain",
       function_owner = self,
       position       = {0,0.05,0},
       rotation       = {0,0,0},
       width          = 650,
       height         = 250,
       font_size      = 150,
       color          = {0,0,0,0},
       font_color     = {1,1,1,95},
       tooltip        = "Next Mission!"
    })
  
end

function clearVillain()
    clearCards = findCardsAtPosition()
    for _, obj in ipairs(clearCards) do
       if obj.getVar("preventDeletion") ~= true then
          obj.destruct()
       end
    end
    clearCards2 = findCardsAtPosition2()
    for _, obj in ipairs(clearCards2) do
       if obj.getVar("preventDeletion") ~= true then
          obj.destruct()
       end
    end
end
 
function findCardsAtPosition(obj)
    local objList = Physics.cast({
       origin       = {0,1.48,11},
       direction    = {0,1,0},
       type         = 3,
       size         = {108,1,40},
       max_distance = 0,
       debug        = false,
    })
    local villainAssets = {}
    for _, obj in ipairs(objList) do
       table.insert(villainAssets, obj.hit_object)
    end
    return villainAssets
end
 
function findCardsAtPosition2(obj)
    local objList = Physics.cast({
       origin       = {18.00, 1.48, 33.75},
       direction    = {0,1,0},
       type         = 3,
       size         = {60,1,1},
       max_distance = 0,
       debug        = false,
    })
    local villainAssets2 = {}
    for _, obj in ipairs(objList) do
       table.insert(villainAssets2, obj.hit_object)
    end
    return villainAssets2
end 
