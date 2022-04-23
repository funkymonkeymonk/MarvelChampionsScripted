DESTROY_POS = {48.58, 2, 33.84}

function updateSave()
    local data_to_save = {["ml"]=memoryList, ["ml2"]=memoryList2}
    saved_data = JSON.encode(data_to_save)
    self.script_state = saved_data
end

function onload(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        --Set up information off of loaded_data
        memoryList = loaded_data.ml
        memoryList2 = loaded_data.ml2
    else
        --Set up information for if there is no saved saved data
        memoryList = {}
        memoryList2 = {}
    end

    if next(memoryList) == nil then
        createSetupButton()
    else
        createMemoryActionButtons()
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
        label="Standard", click_function="buttonClick_standard", function_owner=self,
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
function buttonClick_standard()
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
        label="Expert", click_function="buttonClick_expert", function_owner=self,
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
function buttonClick_expert()
    if next(memoryList2) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createMemoryActionButtons()
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

--After Setup


--Creates recall and place buttons
function createMemoryActionButtons()
    self.createButton({
        label=" S|", click_function="buttonClick_placeS", function_owner=self,
        position={-0.6,4.3,0}, rotation={0,0,0}, height=1000, width=500,
        font_size=600, color={1,1,1}, font_color={0,0,0}, tooltip="Standard"
    })
    self.createButton({
        label="E", click_function="buttonClick_placeE", function_owner=self,
        position={0.3,4.3,0}, rotation={0,0,0}, height=1000, width=500,
        font_size=600, color={1,1,1}, font_color={0,0,0}, tooltip="Expert"
    })
--    self.createButton({
--        label="Setup", click_function="buttonClick_setup", function_owner=self,
--        position={2,0.3,0}, rotation={0,90,0}, height=350, width=800,
--        font_size=250, color={0,0,0}, font_color={1,1,1}
--    })
end

--Sends objects from bag/table to their saved position/rotation
function buttonClick_placeS()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList) do
        local obj = getObjectFromGUID(guid)
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
    broadcastToAll("Objects Placed", {1,1,1})
    returnEncounter()
    removeBoost()
end

function buttonClick_placeE()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList2) do
        local obj = getObjectFromGUID(guid)
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
    broadcastToAll("Objects Placed", {1,1,1})
    returnEncounter()
    removeBoost()
end

--Utility functions
function returnEncounter(object, player, isRightClick)
local toPosition = DESTROY_POS
Global.call("returnEncountercard", {toPosition, self.getRotation(), isRightClick})
end

function removeBoost()
Global.call("removeBoostButton")
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


