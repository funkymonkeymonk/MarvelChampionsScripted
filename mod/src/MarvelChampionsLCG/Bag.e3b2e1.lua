BOOST_POS = {-0.33, 1.8, 8.61}
DISCARD_POS  = {-17.75, 1.4, 22.25}

function updateSave()
    local data_to_save = {["ml"]=memoryList, ["ml2"]=memoryList2, ["ml3"]=memoryList3, ["ml4"]=memoryList4}
    saved_data = JSON.encode(data_to_save)
    self.script_state = saved_data
end

function onload(saved_data)
    --self.setInvisibleTo({"Red", "Blue", "Green", "Yellow", "White"})

    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        --Set up information off of loaded_data
        memoryList = loaded_data.ml
        memoryList2 = loaded_data.ml2
        memoryList3 = loaded_data.ml3
        memoryList4 = loaded_data.ml4
    else
        --Set up information for if there is no saved saved data
        memoryList = {}
        memoryList2 = {}
        memoryList3 = {}
        memoryList4 = {}
    end

    if next(memoryList) == nil then
        createSetupButton()
    end
end


--Beginning Setup


--Make setup button
function createSetupButton()
    self.createButton({
        label="Setup", click_function="buttonClick_setup", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup()
    memoryListBackup = duplicateTable(memoryList)
    memoryList = {}
    self.clearButtons()
    createButtonsOnAllObjects()
    createSetupActionButtons()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects()
    local howManyButtons = 0
    for _, obj in ipairs(getAllObjects()) do
        if obj ~= self then
            local dummyIndex = howManyButtons
            --On a normal bag, the button positions aren't the same size as the bag.
            globalScaleFactor = 1* 1/self.getScale().x
            --Super sweet math to set button positions
            local selfPos = self.getPosition()
            local objPos = obj.getPosition()
            local deltaPos = findOffsetDistance(selfPos, objPos, obj)
            local objPos = rotateLocalCoordinates(deltaPos, self)
            objPos.x = -objPos.x * globalScaleFactor
            objPos.y = objPos.y * globalScaleFactor +12
            objPos.z = objPos.z * globalScaleFactor
            --Offset rotation of bag
            local rot = self.getRotation()
            rot.y = -rot.y + 180
            --Create function
            local funcName = "selectButton_" .. howManyButtons
            local func = function() buttonClick_selection(dummyIndex, obj) end
            self.setVar(funcName, func)
            self.createButton({
                click_function=funcName, function_owner=self,
                position=objPos, rotation=rot, height=800, width=800,
                color={0.75,0.25,0.25,0.6},
            })
            howManyButtons = howManyButtons + 1
        end
    end
end

--Creates submit and cancel buttons
function createSetupActionButtons()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="1p", click_function="buttonClick_1p", function_owner=self,
        position={0,3,-7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
--    self.createButton({
--        label="Reset", click_function="buttonClick_reset", function_owner=self,
--        position={3,2.5,6}, rotation={0,0,0}, height=550, width=1100,
--        font_size=400, color={0,0,0}, font_color={1,1,1}
--    })
end


--During Setup


--Checks or unchecks buttons
function buttonClick_selection(index, obj)
    local color = {0,1,0,0.6}
    if memoryList[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList[obj.getGUID()] = nil
        obj.highlightOff()
    end
end

--Cancels selection process
function buttonClick_cancel()
    memoryList = memoryListBackup
    self.clearButtons()
    if next(memoryList) == nil then
        createSetupButton()
    else
        createMemoryActionButtons()
    end
    removeAllHighlights()
    broadcastToAll("Selection Canceled", {1,1,1})
end

--Saves selections
function buttonClick_1p()
    if next(memoryList) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton2()
        local count = 0
        for guid in pairs(memoryList) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton2()
    self.createButton({
        label="Setup", click_function="buttonClick_setup2", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup2()
    memoryListBackup = duplicateTable(memoryList2)
    memoryList2 = {}
    self.clearButtons()
    createButtonsOnAllObjects2()
    createSetupActionButtons2()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects2()
    local howManyButtons = 0
    for _, obj in ipairs(getAllObjects()) do
        if obj ~= self then
            local dummyIndex = howManyButtons
            --On a normal bag, the button positions aren't the same size as the bag.
            globalScaleFactor = 1* 1/self.getScale().x
            --Super sweet math to set button positions
            local selfPos = self.getPosition()
            local objPos = obj.getPosition()
            local deltaPos = findOffsetDistance(selfPos, objPos, obj)
            local objPos = rotateLocalCoordinates(deltaPos, self)
            objPos.x = -objPos.x * globalScaleFactor
            objPos.y = objPos.y * globalScaleFactor +12
            objPos.z = objPos.z * globalScaleFactor
            --Offset rotation of bag
            local rot = self.getRotation()
            rot.y = -rot.y + 180
            --Create function
            local funcName = "selectButton_" .. howManyButtons
            local func = function() buttonClick_selection2(dummyIndex, obj) end
            self.setVar(funcName, func)
            self.createButton({
                click_function=funcName, function_owner=self,
                position=objPos, rotation=rot, height=800, width=800,
                color={0.75,0.25,0.25,0.6},
            })
            howManyButtons = howManyButtons + 1
        end
    end
end

--Checks or unchecks buttons
function buttonClick_selection2(index, obj)
    local color = {0,1,0,0.6}
    if memoryList2[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList2[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList2[obj.getGUID()] = nil
        obj.highlightOff()
    end
end

--Resets bag to starting status
function buttonClick_reset()
    memoryList = {}
    self.clearButtons()
    createSetupButton()
    removeAllHighlights()
    broadcastToAll("Tool Reset", {1,1,1})
    updateSave()
end

function createSetupActionButtons2()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="2p", click_function="buttonClick_2p", function_owner=self,
        position={0,3,-7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
--    self.createButton({
--        label="Reset", click_function="buttonClick_reset", function_owner=self,
--        position={3,2.5,6}, rotation={0,0,0}, height=550, width=1100,
--        font_size=400, color={0,0,0}, font_color={1,1,1}
--    })
end

--Cancels selection process
function buttonClick_cancel()
    memoryList = memoryListBackup
    self.clearButtons()
    if next(memoryList) == nil then
        createSetupButton()
    else
        createMemoryActionButtons()
    end
    removeAllHighlights()
    broadcastToAll("Selection Canceled", {1,1,1})
end

--Saves selections
function buttonClick_2p()
    if next(memoryList2) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton3()
        local count = 0
        for guid in pairs(memoryList2) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton3()
    self.createButton({
        label="Setup", click_function="buttonClick_setup3", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup3()
    memoryListBackup = duplicateTable(memoryList3)
    memoryList3 = {}
    self.clearButtons()
    createButtonsOnAllObjects3()
    createSetupActionButtons3()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects3()
    local howManyButtons = 0
    for _, obj in ipairs(getAllObjects()) do
        if obj ~= self then
            local dummyIndex = howManyButtons
            --On a normal bag, the button positions aren't the same size as the bag.
            globalScaleFactor = 1* 1/self.getScale().x
            --Super sweet math to set button positions
            local selfPos = self.getPosition()
            local objPos = obj.getPosition()
            local deltaPos = findOffsetDistance(selfPos, objPos, obj)
            local objPos = rotateLocalCoordinates(deltaPos, self)
            objPos.x = -objPos.x * globalScaleFactor
            objPos.y = objPos.y * globalScaleFactor +12
            objPos.z = objPos.z * globalScaleFactor
            --Offset rotation of bag
            local rot = self.getRotation()
            rot.y = -rot.y + 180
            --Create function
            local funcName = "selectButton_" .. howManyButtons
            local func = function() buttonClick_selection3(dummyIndex, obj) end
            self.setVar(funcName, func)
            self.createButton({
                click_function=funcName, function_owner=self,
                position=objPos, rotation=rot, height=800, width=800,
                color={0.75,0.25,0.25,0.6},
            })
            howManyButtons = howManyButtons + 1
        end
    end
end

--Checks or unchecks buttons
function buttonClick_selection3(index, obj)
    local color = {0,1,0,0.6}
    if memoryList3[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList3[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList3[obj.getGUID()] = nil
        obj.highlightOff()
    end
end

--Resets bag to starting status
function buttonClick_reset()
    memoryList = {}
    self.clearButtons()
    createSetupButton()
    removeAllHighlights()
    broadcastToAll("Tool Reset", {1,1,1})
    updateSave()
end

function createSetupActionButtons3()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="3p", click_function="buttonClick_3p", function_owner=self,
        position={0,3,-7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
--    self.createButton({
--        label="Reset", click_function="buttonClick_reset", function_owner=self,
--        position={3,2.5,6}, rotation={0,0,0}, height=550, width=1100,
--        font_size=400, color={0,0,0}, font_color={1,1,1}
--    })
end

--Cancels selection process
function buttonClick_cancel()
    memoryList = memoryListBackup
    self.clearButtons()
    if next(memoryList) == nil then
        createSetupButton()
    else
        createMemoryActionButtons()
    end
    removeAllHighlights()
    broadcastToAll("Selection Canceled", {1,1,1})
end

--Saves selections
function buttonClick_3p()
    if next(memoryList3) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton4()
        local count = 0
        for guid in pairs(memoryList3) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton4()
    self.createButton({
        label="Setup", click_function="buttonClick_setup4", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup4()
    memoryListBackup = duplicateTable(memoryList4)
    memoryList4 = {}
    self.clearButtons()
    createButtonsOnAllObjects4()
    createSetupActionButtons4()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects4()
    local howManyButtons = 0
    for _, obj in ipairs(getAllObjects()) do
        if obj ~= self then
            local dummyIndex = howManyButtons
            --On a normal bag, the button positions aren't the same size as the bag.
            globalScaleFactor = 1* 1/self.getScale().x
            --Super sweet math to set button positions
            local selfPos = self.getPosition()
            local objPos = obj.getPosition()
            local deltaPos = findOffsetDistance(selfPos, objPos, obj)
            local objPos = rotateLocalCoordinates(deltaPos, self)
            objPos.x = -objPos.x * globalScaleFactor
            objPos.y = objPos.y * globalScaleFactor +12
            objPos.z = objPos.z * globalScaleFactor
            --Offset rotation of bag
            local rot = self.getRotation()
            rot.y = -rot.y + 180
            --Create function
            local funcName = "selectButton_" .. howManyButtons
            local func = function() buttonClick_selection4(dummyIndex, obj) end
            self.setVar(funcName, func)
            self.createButton({
                click_function=funcName, function_owner=self,
                position=objPos, rotation=rot, height=800, width=800,
                color={0.75,0.25,0.25,0.6},
            })
            howManyButtons = howManyButtons + 1
        end
    end
end

--Checks or unchecks buttons
function buttonClick_selection4(index, obj)
    local color = {0,1,0,0.6}
    if memoryList4[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList4[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList4[obj.getGUID()] = nil
        obj.highlightOff()
    end
end

--Resets bag to starting status
function buttonClick_reset()
    memoryList = {}
    self.clearButtons()
    createSetupButton()
    removeAllHighlights()
    broadcastToAll("Tool Reset", {1,1,1})
    updateSave()
end

function createSetupActionButtons4()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="4p", click_function="buttonClick_4p", function_owner=self,
        position={0,3,-7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
--    self.createButton({
--        label="Reset", click_function="buttonClick_reset", function_owner=self,
--        position={3,2.5,6}, rotation={0,0,0}, height=550, width=1100,
--        font_size=400, color={0,0,0}, font_color={1,1,1}
--    })
end

--Cancels selection process
function buttonClick_cancel()
    memoryList = memoryListBackup
    self.clearButtons()
    if next(memoryList) == nil then
        createSetupButton()
    else
        createMemoryActionButtons()
    end
    removeAllHighlights()
    broadcastToAll("Selection Canceled", {1,1,1})
end

--Saves selections
function buttonClick_4p()
    if next(memoryList4) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        local count = 0
        for guid in pairs(memoryList4) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end


--After Setup


--Creates recall and place buttons
function createPlayers()
    local originPosition = {x=-115, y=1.5, z=125}
    local buttonPosition = originPosition
    self.createButton({
          label="1-Player", click_function="buttonClick_place1", function_owner=self,
          position=buttonPosition, rotation={0,0,0}, height=2000, width=8000,
          font_size=4000, color={1,1,1}, font_color={0,0,0}
      })
    
    buttonPosition.z = buttonPosition.z + 5
    self.createButton({
          label="2-Player", click_function="buttonClick_place2", function_owner=self,
          position=buttonPosition, rotation={0,0,0}, height=2000, width=8000,
          font_size=4000, color={1,1,1}, font_color={0,0,0}
      })

      buttonPosition.z = buttonPosition.z + 5
      self.createButton({
          label="3-Player", click_function="buttonClick_place3", function_owner=self,
          position=buttonPosition, rotation={0,0,0}, height=2000, width=8000,
          font_size=4000, color={1,1,1}, font_color={0,0,0}
      })

      buttonPosition.z = buttonPosition.z + 5
      self.createButton({
          label="4-Player", click_function="buttonClick_place4", function_owner=self,
          position=buttonPosition, rotation={0,0,0}, height=2000, width=8000,
          font_size=4000, color={1,1,1}, font_color={0,0,0}
      })
end

--Sends objects from bag/table to their saved position/rotation
function buttonClick_place1()
    local bagObjList = self.getObjects()

    for guid, entry in pairs(memoryList) do
        local obj = getObjectFromGUID(guid)
        self.clearButtons()
        --If obj is out on the table, move it to the saved pos/rot
        if obj ~= nil then
            obj.setPositionSmooth(entry.pos)
            obj.setRotationSmooth(entry.rot)
            obj.setLock(entry.lock)
        else
            --If obj is inside of the bag
            for _, bagObj in ipairs(bagObjList) do
                if bagObj.guid == guid then
                    local item = self.takeObject({
                        guid=guid, position=entry.pos, rotation=entry.rot,
                    })
                    item.setLock(entry.lock)
                    break
                end
            end
        end
    end
    broadcastToAll("Select Heroes -> Villain -> Difficulty -> Modular Set(s)", {1,1,1})
end

function buttonClick_place2()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList2) do
        local obj = getObjectFromGUID(guid)
        self.clearButtons()
        --If obj is out on the table, move it to the saved pos/rot
        if obj ~= nil then
            obj.setPositionSmooth(entry.pos)
            obj.setRotationSmooth(entry.rot)
            obj.setLock(entry.lock)
        else
            --If obj is inside of the bag
            for _, bagObj in ipairs(bagObjList) do
                if bagObj.guid == guid then
                    local item = self.takeObject({
                        guid=guid, position=entry.pos, rotation=entry.rot,
                    })
                    item.setLock(entry.lock)
                    break
                end
            end
        end
    end
    broadcastToAll("Select Heroes -> Villain -> Difficulty -> Modular Set(s)", {1,1,1})
end

function buttonClick_place3()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList3) do
        local obj = getObjectFromGUID(guid)
        self.clearButtons()
        --If obj is out on the table, move it to the saved pos/rot
        if obj ~= nil then
            obj.setPositionSmooth(entry.pos)
            obj.setRotationSmooth(entry.rot)
            obj.setLock(entry.lock)
        else
            --If obj is inside of the bag
            for _, bagObj in ipairs(bagObjList) do
                if bagObj.guid == guid then
                    local item = self.takeObject({
                        guid=guid, position=entry.pos, rotation=entry.rot,
                    })
                    item.setLock(entry.lock)
                    break
                end
            end
        end
    end
    broadcastToAll("Select Heroes -> Villain -> Difficulty -> Modular Set(s)", {1,1,1})
end

function buttonClick_place4()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList4) do
        local obj = getObjectFromGUID(guid)
        self.clearButtons()
        --If obj is out on the table, move it to the saved pos/rot
        if obj ~= nil then
            obj.setPositionSmooth(entry.pos)
            obj.setRotationSmooth(entry.rot)
            obj.setLock(entry.lock)
        else
            --If obj is inside of the bag
            for _, bagObj in ipairs(bagObjList) do
                if bagObj.guid == guid then
                    local item = self.takeObject({
                        guid=guid, position=entry.pos, rotation=entry.rot,
                    })
                    item.setLock(entry.lock)
                    break
                end
            end
        end
    end
    broadcastToAll("Select Heroes -> Villain -> Difficulty -> Modular Set(s)", {1,1,1})
end

--Utility functions

function createBoostButton()
    self.createButton({
      label = "BOOST",
      click_function = "drawBoost",
      function_owner = self,
      position = {-114.4,1.13,108.6},
      rotation = {0,0,0},
      width = 3400,
      height = 1500,
      font_size = 1700,
      color = {1,1,0}
    })
  
    self.createButton({
      label = "X",
      click_function = "discardBoost",
      function_owner = self,
      position = {-109.6,1.13,108.6},
      rotation = {0,0,0},
      width = 1000,
      height = 1500,
      font_size = 1700,
      color = {1,0,0}
    })
  
    COLLISION_ENABLED = true
end

function drawBoost(object, player, isRightClick)
local toPosition = BOOST_POS
Global.call("drawBoostcard", {toPosition, self.getRotation(), isRightClick})
end

function discardBoost(object, player, isRightClick)
local toPosition = DISCARD_POS
Global.call("discardBoostcard", {toPosition, self.getRotation(), isRightClick})
end


--Find delta (difference) between 2 x/y/z coordinates
function findOffsetDistance(p1, p2, obj)
    local deltaPos = {}
    local bounds = obj.getBounds()
    deltaPos.x = (p2.x-p1.x)
    deltaPos.y = (p2.y-p1.y) + (bounds.size.y - bounds.offset.y)
    deltaPos.z = (p2.z-p1.z)
    return deltaPos
end

--Used to rotate a set of coordinates by an angle
function rotateLocalCoordinates(desiredPos, obj)
	local objPos, objRot = obj.getPosition(), obj.getRotation()
    local angle = math.rad(objRot.y)
	local x = desiredPos.x * math.cos(angle) - desiredPos.z * math.sin(angle)
	local z = desiredPos.x * math.sin(angle) + desiredPos.z * math.cos(angle)
	--return {x=objPos.x+x, y=objPos.y+desiredPos.y, z=objPos.z+z}
    return {x=x, y=desiredPos.y, z=z}
end

--Coroutine delay, in seconds
function wait(time)
    local start = os.time()
    repeat coroutine.yield(0) until os.time() > start + time
end

--Duplicates a table (needed to prevent it making reference to the same objects)
function duplicateTable(oldTable)
    local newTable = {}
    for k, v in pairs(oldTable) do
        newTable[k] = v
    end
    return newTable
end

--Moves scripted highlight from all objects
function removeAllHighlights()
    for _, obj in ipairs(getAllObjects()) do
        obj.highlightOff()
    end
end

--Round number (num) to the Nth decimal (dec)
function round(num, dec)
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end
