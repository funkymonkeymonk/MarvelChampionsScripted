function updateSave()
    local data_to_save = {["ml"]=memoryList, ["ml2"]=memoryList2, ["ml3"]=memoryList3, ["ml4"]=memoryList4, ["ml5"]=memoryList5, ["ml6"]=memoryList6, ["ml7"]=memoryList7, ["ml8"]=memoryList8, ["ml9"]=memoryList9, ["ml10"]=memoryList10, ["ml11"]=memoryList11, ["ml12"]=memoryList12, ["ml13"]=memoryList13,     ["ml14"]=memoryList14, ["ml15"]=memoryList15, ["ml16"]=memoryList16, ["ml17"]=memoryList17, ["ml18"]=memoryList18, ["ml19"]=memoryList19, ["ml20"]=memoryList20, ["ml21"]=memoryList21, ["ml22"]=memoryList22, ["ml23"]=memoryList23, ["ml24"]=memoryList24}
    saved_data = JSON.encode(data_to_save)
    self.script_state = saved_data
end

function onload(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        --Set up information off of loaded_data
        memoryList = loaded_data.ml
        memoryList2 = loaded_data.ml2
        memoryList3 = loaded_data.ml3
        memoryList4 = loaded_data.ml4
        memoryList5 = loaded_data.ml5
        memoryList6 = loaded_data.ml6
        memoryList7 = loaded_data.ml7
        memoryList8 = loaded_data.ml8
        memoryList9 = loaded_data.ml9
        memoryList10 = loaded_data.ml10
        memoryList11 = loaded_data.ml11
        memoryList12 = loaded_data.ml12
        memoryList13 = loaded_data.ml13
        memoryList14 = loaded_data.ml14
        memoryList15 = loaded_data.ml15
        memoryList16 = loaded_data.ml16
        memoryList17 = loaded_data.ml17
        memoryList18 = loaded_data.ml18
        memoryList19 = loaded_data.ml19
        memoryList20 = loaded_data.ml20
        memoryList21 = loaded_data.ml21
        memoryList22 = loaded_data.ml22
        memoryList23 = loaded_data.ml23
        memoryList24 = loaded_data.ml24
    else
        --Set up information for if there is no saved saved data
        memoryList = {}
        memoryList2 = {}
        memoryList3 = {}
        memoryList4 = {}
        memoryList5 = {}
        memoryList6 = {}
        memoryList7 = {}
        memoryList8 = {}
        memoryList9 = {}
        memoryList10 = {}
        memoryList11 = {}
        memoryList12 = {}
        memoryList13 = {}
        memoryList14 = {}
        memoryList15 = {}
        memoryList16 = {}
        memoryList17 = {}
        memoryList18 = {}
        memoryList19 = {}
        memoryList20 = {}
        memoryList21 = {}
        memoryList22 = {}
        memoryList23 = {}
        memoryList24 = {}
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
        label="pos1", click_function="buttonClick_config1", function_owner=self,
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
function buttonClick_config1()
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
        label="pos2", click_function="buttonClick_config2", function_owner=self,
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
function buttonClick_config2()
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
        label="pos3", click_function="buttonClick_config3", function_owner=self,
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
function buttonClick_config3()
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
        label="pos4", click_function="buttonClick_config4", function_owner=self,
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
function buttonClick_config4()
    if next(memoryList4) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton5()
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

function createSetupButton5()
    self.createButton({
        label="Setup", click_function="buttonClick_setup5", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup5()
    memoryListBackup = duplicateTable(memoryList5)
    memoryList5 = {}
    self.clearButtons()
    createButtonsOnAllObjects5()
    createSetupActionButtons5()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects5()
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
            local func = function() buttonClick_selection5(dummyIndex, obj) end
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
function buttonClick_selection5(index, obj)
    local color = {0,1,0,0.6}
    if memoryList5[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList5[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList5[obj.getGUID()] = nil
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

function createSetupActionButtons5()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos5", click_function="buttonClick_config5", function_owner=self,
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
function buttonClick_config5()
    if next(memoryList5) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton6()
        local count = 0
        for guid in pairs(memoryList5) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton6()
    self.createButton({
        label="Setup", click_function="buttonClick_setup6", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup6()
    memoryListBackup = duplicateTable(memoryList6)
    memoryList6 = {}
    self.clearButtons()
    createButtonsOnAllObjects6()
    createSetupActionButtons6()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects6()
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
            local func = function() buttonClick_selection6(dummyIndex, obj) end
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
function buttonClick_selection6(index, obj)
    local color = {0,1,0,0.6}
    if memoryList6[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList6[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList6[obj.getGUID()] = nil
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

function createSetupActionButtons6()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos6", click_function="buttonClick_config6", function_owner=self,
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
function buttonClick_config6()
    if next(memoryList6) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton7()
        local count = 0
        for guid in pairs(memoryList6) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton7()
    self.createButton({
        label="Setup", click_function="buttonClick_setup7", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup7()
    memoryListBackup = duplicateTable(memoryList7)
    memoryList7 = {}
    self.clearButtons()
    createButtonsOnAllObjects7()
    createSetupActionButtons7()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects7()
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
            local func = function() buttonClick_selection7(dummyIndex, obj) end
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
function buttonClick_selection7(index, obj)
    local color = {0,1,0,0.6}
    if memoryList7[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList7[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList7[obj.getGUID()] = nil
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

function createSetupActionButtons7()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos7", click_function="buttonClick_config7", function_owner=self,
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
function buttonClick_config7()
    if next(memoryList7) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton8()
        local count = 0
        for guid in pairs(memoryList7) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton8()
    self.createButton({
        label="Setup", click_function="buttonClick_setup8", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup8()
    memoryListBackup = duplicateTable(memoryList8)
    memoryList8 = {}
    self.clearButtons()
    createButtonsOnAllObjects8()
    createSetupActionButtons8()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects8()
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
            local func = function() buttonClick_selection8(dummyIndex, obj) end
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
function buttonClick_selection8(index, obj)
    local color = {0,1,0,0.6}
    if memoryList8[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList8[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList8[obj.getGUID()] = nil
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

function createSetupActionButtons8()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos8", click_function="buttonClick_config8", function_owner=self,
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
function buttonClick_config8()
    if next(memoryList8) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton9()
        local count = 0
        for guid in pairs(memoryList8) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton9()
    self.createButton({
        label="Setup", click_function="buttonClick_setup9", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup9()
    memoryListBackup = duplicateTable(memoryList9)
    memoryList9 = {}
    self.clearButtons()
    createButtonsOnAllObjects9()
    createSetupActionButtons9()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects9()
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
            local func = function() buttonClick_selection9(dummyIndex, obj) end
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
function buttonClick_selection9(index, obj)
    local color = {0,1,0,0.6}
    if memoryList9[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList9[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList9[obj.getGUID()] = nil
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

function createSetupActionButtons9()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos9", click_function="buttonClick_config9", function_owner=self,
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
function buttonClick_config9()
    if next(memoryList9) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton10()
        local count = 0
        for guid in pairs(memoryList9) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton10()
    self.createButton({
        label="Setup", click_function="buttonClick_setup10", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup10()
    memoryListBackup = duplicateTable(memoryList10)
    memoryList10 = {}
    self.clearButtons()
    createButtonsOnAllObjects10()
    createSetupActionButtons10()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects10()
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
            local func = function() buttonClick_selection10(dummyIndex, obj) end
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
function buttonClick_selection10(index, obj)
    local color = {0,1,0,0.6}
    if memoryList10[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList10[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList10[obj.getGUID()] = nil
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

function createSetupActionButtons10()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos10", click_function="buttonClick_config10", function_owner=self,
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
function buttonClick_config10()
    if next(memoryList10) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton11()
        local count = 0
        for guid in pairs(memoryList10) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton11()
    self.createButton({
        label="Setup", click_function="buttonClick_setup11", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup11()
    memoryListBackup = duplicateTable(memoryList11)
    memoryList11 = {}
    self.clearButtons()
    createButtonsOnAllObjects11()
    createSetupActionButtons11()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects11()
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
            local func = function() buttonClick_selection11(dummyIndex, obj) end
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
function buttonClick_selection11(index, obj)
    local color = {0,1,0,0.6}
    if memoryList11[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList11[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList11[obj.getGUID()] = nil
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

function createSetupActionButtons11()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos11", click_function="buttonClick_config11", function_owner=self,
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
function buttonClick_config11()
    if next(memoryList11) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton12()
        local count = 0
        for guid in pairs(memoryList11) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton12()
    self.createButton({
        label="Setup", click_function="buttonClick_setup12", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup12()
    memoryListBackup = duplicateTable(memoryList12)
    memoryList12 = {}
    self.clearButtons()
    createButtonsOnAllObjects12()
    createSetupActionButtons12()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects12()
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
            local func = function() buttonClick_selection12(dummyIndex, obj) end
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
function buttonClick_selection12(index, obj)
    local color = {0,1,0,0.6}
    if memoryList12[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList12[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList12[obj.getGUID()] = nil
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

function createSetupActionButtons12()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos12", click_function="buttonClick_config12", function_owner=self,
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
function buttonClick_config12()
    if next(memoryList12) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton13()
        local count = 0
        for guid in pairs(memoryList12) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton13()
    self.createButton({
        label="Setup", click_function="buttonClick_setup13", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup13()
    memoryListBackup = duplicateTable(memoryList13)
    memoryList13 = {}
    self.clearButtons()
    createButtonsOnAllObjects13()
    createSetupActionButtons13()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects13()
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
            local func = function() buttonClick_selection13(dummyIndex, obj) end
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
function buttonClick_selection13(index, obj)
    local color = {0,1,0,0.6}
    if memoryList13[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList13[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList13[obj.getGUID()] = nil
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

function createSetupActionButtons13()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos13", click_function="buttonClick_config13", function_owner=self,
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
function buttonClick_config13()
    if next(memoryList13) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton14()
        local count = 0
        for guid in pairs(memoryList13) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton14()
    self.createButton({
        label="Setup", click_function="buttonClick_setup14", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup14()
    memoryListBackup = duplicateTable(memoryList14)
    memoryList14 = {}
    self.clearButtons()
    createButtonsOnAllObjects14()
    createSetupActionButtons14()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects14()
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
            local func = function() buttonClick_selection14(dummyIndex, obj) end
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
function buttonClick_selection14(index, obj)
    local color = {0,1,0,0.6}
    if memoryList14[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList14[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList14[obj.getGUID()] = nil
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

function createSetupActionButtons14()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos14", click_function="buttonClick_config14", function_owner=self,
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
function buttonClick_config14()
    if next(memoryList14) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton15()
        local count = 0
        for guid in pairs(memoryList14) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton15()
    self.createButton({
        label="Setup", click_function="buttonClick_setup15", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup15()
    memoryListBackup = duplicateTable(memoryList15)
    memoryList15 = {}
    self.clearButtons()
    createButtonsOnAllObjects15()
    createSetupActionButtons15()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects15()
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
            local func = function() buttonClick_selection15(dummyIndex, obj) end
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
function buttonClick_selection15(index, obj)
    local color = {0,1,0,0.6}
    if memoryList15[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList15[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList15[obj.getGUID()] = nil
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

function createSetupActionButtons15()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos15", click_function="buttonClick_config15", function_owner=self,
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
function buttonClick_config15()
    if next(memoryList15) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton16()
        local count = 0
        for guid in pairs(memoryList15) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton16()
    self.createButton({
        label="Setup", click_function="buttonClick_setup16", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup16()
    memoryListBackup = duplicateTable(memoryList16)
    memoryList16 = {}
    self.clearButtons()
    createButtonsOnAllObjects16()
    createSetupActionButtons16()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects16()
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
            local func = function() buttonClick_selection16(dummyIndex, obj) end
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
function buttonClick_selection16(index, obj)
    local color = {0,1,0,0.6}
    if memoryList16[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList16[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList16[obj.getGUID()] = nil
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

function createSetupActionButtons16()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos16", click_function="buttonClick_config16", function_owner=self,
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
function buttonClick_config16()
    if next(memoryList16) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton17()
        local count = 0
        for guid in pairs(memoryList16) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton17()
    self.createButton({
        label="Setup", click_function="buttonClick_setup17", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup17()
    memoryListBackup = duplicateTable(memoryList17)
    memoryList17 = {}
    self.clearButtons()
    createButtonsOnAllObjects17()
    createSetupActionButtons17()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects17()
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
            local func = function() buttonClick_selection17(dummyIndex, obj) end
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
function buttonClick_selection17(index, obj)
    local color = {0,1,0,0.6}
    if memoryList17[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList17[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList17[obj.getGUID()] = nil
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

function createSetupActionButtons17()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos17", click_function="buttonClick_config17", function_owner=self,
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
function buttonClick_config17()
    if next(memoryList17) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton18()
        local count = 0
        for guid in pairs(memoryList17) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton18()
    self.createButton({
        label="Setup", click_function="buttonClick_setup18", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup18()
    memoryListBackup = duplicateTable(memoryList18)
    memoryList18 = {}
    self.clearButtons()
    createButtonsOnAllObjects18()
    createSetupActionButtons18()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects18()
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
            local func = function() buttonClick_selection18(dummyIndex, obj) end
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
function buttonClick_selection18(index, obj)
    local color = {0,1,0,0.6}
    if memoryList18[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList18[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList18[obj.getGUID()] = nil
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

function createSetupActionButtons18()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos18", click_function="buttonClick_config18", function_owner=self,
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
function buttonClick_config18()
    if next(memoryList18) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton19()
        local count = 0
        for guid in pairs(memoryList18) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton19()
    self.createButton({
        label="Setup", click_function="buttonClick_setup19", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup19()
    memoryListBackup = duplicateTable(memoryList19)
    memoryList19 = {}
    self.clearButtons()
    createButtonsOnAllObjects19()
    createSetupActionButtons19()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects19()
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
            local func = function() buttonClick_selection19(dummyIndex, obj) end
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
function buttonClick_selection19(index, obj)
    local color = {0,1,0,0.6}
    if memoryList19[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList19[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList19[obj.getGUID()] = nil
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

function createSetupActionButtons19()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos19", click_function="buttonClick_config19", function_owner=self,
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
function buttonClick_config19()
    if next(memoryList19) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton20()
        local count = 0
        for guid in pairs(memoryList19) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton20()
    self.createButton({
        label="Setup", click_function="buttonClick_setup20", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup20()
    memoryListBackup = duplicateTable(memoryList20)
    memoryList20 = {}
    self.clearButtons()
    createButtonsOnAllObjects20()
    createSetupActionButtons20()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects20()
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
            local func = function() buttonClick_selection20(dummyIndex, obj) end
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
function buttonClick_selection20(index, obj)
    local color = {0,1,0,0.6}
    if memoryList20[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList20[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList20[obj.getGUID()] = nil
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

function createSetupActionButtons20()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos20", click_function="buttonClick_config20", function_owner=self,
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
function buttonClick_config20()
    if next(memoryList20) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton21()
        local count = 0
        for guid in pairs(memoryList20) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton21()
    self.createButton({
        label="Setup", click_function="buttonClick_setup21", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup21()
    memoryListBackup = duplicateTable(memoryList21)
    memoryList21 = {}
    self.clearButtons()
    createButtonsOnAllObjects21()
    createSetupActionButtons21()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects21()
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
            local func = function() buttonClick_selection21(dummyIndex, obj) end
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
function buttonClick_selection21(index, obj)
    local color = {0,1,0,0.6}
    if memoryList21[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList21[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList21[obj.getGUID()] = nil
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

function createSetupActionButtons21()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos21", click_function="buttonClick_config21", function_owner=self,
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
function buttonClick_config21()
    if next(memoryList21) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton22()
        local count = 0
        for guid in pairs(memoryList21) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton22()
    self.createButton({
        label="Setup", click_function="buttonClick_setup22", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup22()
    memoryListBackup = duplicateTable(memoryList22)
    memoryList22 = {}
    self.clearButtons()
    createButtonsOnAllObjects22()
    createSetupActionButtons22()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects22()
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
            local func = function() buttonClick_selection22(dummyIndex, obj) end
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
function buttonClick_selection22(index, obj)
    local color = {0,1,0,0.6}
    if memoryList22[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList22[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList22[obj.getGUID()] = nil
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

function createSetupActionButtons22()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos22", click_function="buttonClick_config22", function_owner=self,
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
function buttonClick_config22()
    if next(memoryList22) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton23()
        local count = 0
        for guid in pairs(memoryList22) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton23()
    self.createButton({
        label="Setup", click_function="buttonClick_setup23", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup23()
    memoryListBackup = duplicateTable(memoryList23)
    memoryList23 = {}
    self.clearButtons()
    createButtonsOnAllObjects23()
    createSetupActionButtons23()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects23()
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
            local func = function() buttonClick_selection23(dummyIndex, obj) end
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
function buttonClick_selection23(index, obj)
    local color = {0,1,0,0.6}
    if memoryList23[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList23[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList23[obj.getGUID()] = nil
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

function createSetupActionButtons23()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos23", click_function="buttonClick_config23", function_owner=self,
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
function buttonClick_config23()
    if next(memoryList23) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createSetupButton24()
        local count = 0
        for guid in pairs(memoryList23) do
            count = count + 1
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then obj.highlightOff() end
        end
        broadcastToAll(count.." Objects Saved", {1,1,1})
        updateSave()
    end
end

function createSetupButton24()
    self.createButton({
        label="Setup", click_function="buttonClick_setup24", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
end

--Triggered by setup button,
function buttonClick_setup24()
    memoryListBackup = duplicateTable(memoryList24)
    memoryList24 = {}
    self.clearButtons()
    createButtonsOnAllObjects24()
    createSetupActionButtons24()
end

--Creates selection buttons on objects
function createButtonsOnAllObjects24()
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
            local func = function() buttonClick_selection24(dummyIndex, obj) end
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
function buttonClick_selection24(index, obj)
    local color = {0,1,0,0.6}
    if memoryList24[obj.getGUID()] == nil then
        self.editButton({index=index, color=color})
        --Adding pos/rot to memory table
        local pos, rot = obj.getPosition(), obj.getRotation()
        --I need to add it like this or it won't save due to indexing issue
        memoryList24[obj.getGUID()] = {
            pos={x=round(pos.x,4), y=round(pos.y,4), z=round(pos.z,4)},
            rot={x=round(rot.x,4), y=round(rot.y,4), z=round(rot.z,4)},
            lock=obj.getLock()
        }
        obj.highlightOn({0,1,0})
    else
        color = {0.75,0.25,0.25,0.6}
        self.editButton({index=index, color=color})
        memoryList24[obj.getGUID()] = nil
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

function createSetupActionButtons24()
    self.createButton({
        label="Cancel", click_function="buttonClick_cancel", function_owner=self,
        position={0,3,7}, rotation={0,0,0}, height=700, width=2000,
        font_size=700, color={0,0,0}, font_color={1,1,1}
    })
    self.createButton({
        label="pos24", click_function="buttonClick_config24", function_owner=self,
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
function buttonClick_config24()
    if next(memoryList24) == nil then
        broadcastToAll("You cannot submit without any selections.", {0.75, 0.25, 0.25})
    else
        self.clearButtons()
        createMemoryActionButtons()
        local count = 0
        for guid in pairs(memoryList24) do
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
        label="Time Warp", click_function="timeWarp", function_owner=self,
        position={23.5,0.5,4}, rotation={0,0,0}, height=1600, width=4200,
        font_size=1800, color={0,0,1}, font_color={1,1,1}, tooltip="Journey through Time!"
    })
--    self.createButton({
--        label="Setup", click_function="buttonClick_setup", function_owner=self,
--        position={2,0.3,0}, rotation={0,90,0}, height=350, width=800,
--        font_size=250, color={0,0,0}, font_color={1,1,1}
--    })
end

function timeWarp()
  timeSeed = math.random(1,24)
  if timeSeed == 1 then
    era1()
  end
  if timeSeed == 2 then
    era2()
  end
  if timeSeed == 3 then
    era3()
  end
  if timeSeed == 4 then
    era4()
  end
  if timeSeed == 5 then
    era5()
  end
  if timeSeed == 6 then
    era6()
  end
  if timeSeed == 7 then
    era7()
  end
  if timeSeed == 8 then
    era8()
  end
  if timeSeed == 9 then
    era9()
  end
  if timeSeed == 10 then
    era10()
  end
  if timeSeed == 11 then
    era11()
  end
  if timeSeed == 12 then
    era12()
  end
  if timeSeed == 13 then
    era13()
  end
  if timeSeed == 14 then
    era14()
  end
  if timeSeed == 15 then
    era15()
  end
  if timeSeed == 16 then
    era16()
  end
  if timeSeed == 17 then
    era17()
  end
  if timeSeed == 18 then
    era18()
  end
  if timeSeed == 19 then
    era19()
  end
  if timeSeed == 20 then
    era20()
  end
  if timeSeed == 21 then
    era21()
  end
  if timeSeed == 22 then
    era22()
  end
  if timeSeed == 23 then
    era23()
  end
  if timeSeed == 24 then
    era24()
  end
  self.clearButtons()
  kangPhase = getObjectFromGUID('9d2108')
  kangPhase.call("advanceKang")
end

--Sends objects from bag/table to their saved position/rotation
function era1()
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
    broadcastToAll("When are we?", {1,1,1})
end

function era2()
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
    broadcastToAll("When are we?", {1,1,1})
end

function era3()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList3) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era4()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList4) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era5()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList5) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era6()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList6) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era7()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList7) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era8()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList8) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era9()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList9) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era10()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList10) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era11()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList11) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era12()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList12) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era13()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList13) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era14()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList14) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era15()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList15) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era16()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList16) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era17()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList17) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era18()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList18) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era19()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList19) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era20()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList20) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era21()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList21) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era22()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList22) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era23()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList23) do
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
    broadcastToAll("When are we?", {1,1,1})
end

function era24()
    local bagObjList = self.getObjects()
    for guid, entry in pairs(memoryList24) do
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
    broadcastToAll("When are we?", {1,1,1})
end

--Utility functions


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



