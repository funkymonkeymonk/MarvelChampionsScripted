preventDeletion = true

local mode = "heroSelection"

function onload(saved_data)
    self.setName("")

    setUpHeroSelectionMode()
end

function setUpHeroSelectionMode()
    self.clearButtons()

    self.createButton({
        label          = "SELECT YOUR HEROES",
        click_function = "null",
        function_owner = self,
        position       = {0,0.25,-0.80},
        rotation       = {0,0,0},
        width          = 0,
        height         = 0,
        font_size      = 150,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })

     self.createButton({
        label          = "AVENGERS",
        click_function = "layOutAvengers",
        function_owner = self,
        position       = {0,0.25,-0.45},
        rotation       = {0,0,0},
        width          = 500,
        height         = 50,
        font_size      = 100,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })

     self.createButton({
        label          = "CHAMPIONS",
        click_function = "layOutChampions",
        function_owner = self,
        position       = {0,0.25,-0.15},
        rotation       = {0,0,0},
        width          = 550,
        height         = 50,
        font_size      = 100,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })

     self.createButton({
        label          = "GUARDIANS OF THE GALAXY",
        click_function = "layOutGuardians",
        function_owner = self,
        position       = {0,0.25,0.15},
        rotation       = {0,0,0},
        width          = 1300,
        height         = 50,
        font_size      = 100,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })

     self.createButton({
        label          = "MUTANTS",
        click_function = "layOutMutants",
        function_owner = self,
        position       = {0,0.25,0.45},
        rotation       = {0,0,0},
        width          = 550,
        height         = 50,
        font_size      = 100,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })

     self.createButton({
        label          = "SPIDER-VERSE",
        click_function = "layOutSpiders",
        function_owner = self,
        position       = {0,0.25,0.75},
        rotation       = {0,0,0},
        width          = 650,
        height         = 50,
        font_size      = 100,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })

     self.createButton({
        label          = "ALL HEROES",
        click_function = "layOutAllHeroes",
        function_owner = self,
        position       = {0,0.25,1.05},
        rotation       = {0,0,0},
        width          = 650,
        height         = 50,
        font_size      = 100,
        color          = {0,0,0,0},
        font_color     = {1,1,1,95}
     })     
end

function setUpScenarioSelectionMode()
end

function setUpScenarioMode()
    self.clearButtons()


    -- self.createButton({
    --     label          = "Clear",
    --     click_function = "clearVillain",
    --     function_owner = self,
    --     position       = {0,0.05,0},
    --     rotation       = {0,0,0},
    --     width          = 650,
    --     height         = 250,
    --     font_size      = 150,
    --     color          = {0,0,0,0},
    --     font_color     = {1,1,1,95},
    --     tooltip        = "Next Mission!"
    --  })
end

function layOutAvengers()
    layOutHeroSelectors("avengers")
end

function layOutChampions()
    layOutHeroSelectors("champions")
end

function layOutGuardians()
    layOutHeroSelectors("gauardians")
end

function layOutMutants()
    layOutHeroSelectors("mutants")
end

function layOutSpiders()
    layOutHeroSelectors("spiders")
end

function layOutAllHeroes()
    layOutHeroSelectors()
end

function layOutHeroSelectors(team)
    moveToCorner()
    blockTable()
    local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))

    heroManager.call("layOutHeroSelectors", {
        team = team,
        center = {0,1,10},
        maxRowsOrColumns = team ~= nil and 6 or 9,
        columnGap = 9,
        rowGap = 6,
        selectorScale = {2, 1, 2}
    })
end

function blockTable()
    local blocker = getObjectFromGUID("5e531c")
    blocker.call("blockTable")
end

function moveToCorner()
    self.setPositionSmooth({-45.00, 10.00, 30.00}, false, false)
    self.setRotationSmooth({70.00, 135.00, 0.00}, false, false)
    self.setLock(true)
end

function moveToCenter()
    self.setPositionSmooth({0.00, 10.00, 0.00}, false, false)
    self.setRotationSmooth({45.00, 180.00, 0.00}, false, false)
    self.setLock(true)
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
