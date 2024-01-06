preventDeletion = true

local defaultColumnGap = 5
local defaultRowGap = 2.5
local defaultSelectorScale = {1.13, 1.00, 1.13}
local defaultSelectorRotation = {0,180,0}

local hiddenSelectorOffset = 2

local SELECTOR_TILE_TAG = "selector-tile"

function layOutSelectorTiles(params)
    local origin = params.origin
    local center = params.center
    local direction = params.direction
    local maxRowsOrColumns = params.maxRowsOrColumns
    local columnGap = params.columnGap or defaultColumnGap
    local rowGap = params.rowGap or defaultRowGap
    local selectorScale = params.selectorScale or defaultSelectorScale
    local selectorRotation = params.selectorRotation or defaultSelectorRotation
    local items = params.items
    local itemType = params.itemType
    local behavior = params.behavior
    local hidden = params.hidden
    local sortedList = getSortedListOfItems(items)
    local itemCount = #sortedList

    if(origin == nil) then
        if(center == nil) then
            broadcastToAll("Must supply either an origin or center position to lay out tiles.", {1,1,1})
            return
        end

        origin = calculateOrigin(center, direction, maxRowsOrColumns, columnGap, rowGap, itemCount)
    end

    if(hidden) then
        origin.y = origin.y - hiddenSelectorOffset
    end

    clearSelectorTiles({itemType = itemType})

    local baseTile = getObjectFromGUID(Global.getVar("GUID_SELECTOR_TILE"))
    local currentRow = 1
    local currentColumn = 1

    for _, listItem in ipairs(sortedList) do
        local key = listItem.key
        local item = listItem.value
        local position = getCoordinates(origin, currentColumn, currentRow, columnGap, rowGap)

        local tile = baseTile.clone({
            position = position,
            rotation = selectorRotation,
            scale = selectorScale})

        Wait.frames(
            function()
                tile.setLock(true)
                tile.setPosition(position)
                tile.addTag(SELECTOR_TILE_TAG)
        
                tile.call("setUpTile", {
                    itemType = itemType,
                    itemKey = key,
                    itemName = item.name,
                    imageUrl = item.tileImageUrl,
                    behavior = behavior
                })
         end,
            1
        )

        if(direction == "horizontal") then
            currentColumn = currentColumn + 1

            if (currentColumn > maxRowsOrColumns) then
                currentColumn = 1
                currentRow = currentRow + 1
            end
        else
            currentRow = currentRow + 1

            if(currentRow > maxRowsOrColumns) then
                currentRow = 1
                currentColumn = currentColumn + 1
            end            
        end

    end    
end

function calculateOrigin(center, direction, maxRowsOrColumns, columnGap, rowGap, itemCount)
    local gridDimensions = calculateGridDimenstions(direction, maxRowsOrColumns, columnGap, rowGap, itemCount)

    return {
        x = center[1] - gridDimensions.width / 2,
        y = center[2],
        z = center[3] + gridDimensions.height / 2
    }
end

function calculateGridDimenstions(direction, maxRowsOrColumns, columnGap, rowGap, itemCount)
    local columns = 0
    local rows = 0

    if(direction == "horizontal") then
        columns = itemCount <= maxRowsOrColumns and itemCount or maxRowsOrColumns
        rows = itemCount <= maxRowsOrColumns and 1 or math.ceil(itemCount / maxRowsOrColumns)
    end

    if(direction == "vertical") then
        columns = itemCount <= maxRowsOrColumns and 1 or math.ceil(itemCount / maxRowsOrColumns)
        rows = itemCount <= maxRowsOrColumns and itemCount or maxRowsOrColumns
    end

    local width = (columns - 1) * columnGap
    local height = (rows - 1) * rowGap

    return {width = width, height = height}
end

function getSortedListOfItems(items)
    local itemList = {}

    for key, value in pairs(items) do
        table.insert(itemList, {key = key, value = value})
    end

    function compareNames(a, b)
        return stripArticles(a.value.name) < stripArticles(b.value.name) 
    end
    
    return table.sort(itemList, compareNames)
end

function stripArticles(orig)
    local lower = string.lower(orig)

    if(string.sub(lower, 1, 4) == "the ") then
        return string.sub(orig, 5, -1)
    end

    if(string.sub(lower, 1, 2) == "a ") then
        return string.sub(orig, 3, -1)
    end

    if(string.sub(lower, 1, 3) == "an ") then
        return string.sub(orig, 4, -1)
    end

    return orig
end

function getCoordinates(origin, column, row, columnGap, rowGap)
    local x = origin.x + columnGap * (column - 1)
    local z = origin.z - rowGap * (row - 1)

    return {x, origin.y, z}
end

function clearSelectorTiles(params)
    local allObjects = getAllObjects()
    local itemType = params.itemType

    for k,v in pairs(allObjects) do
        if(v.hasTag(SELECTOR_TILE_TAG)) then
            if(itemType == nil or v.getVar("itemType") == itemType) then
                v.destruct()
            end
        end
    end
end

function highlightSelectedSelectorTile(params)
    local allObjects = getAllObjects()
    local itemType = params.itemType
    local itemKey = params.itemKey

    for k,v in pairs(allObjects) do
        if(v.hasTag(SELECTOR_TILE_TAG)) then
            if( v.getVar("itemType") == itemType) then
                if(v.getVar("itemKey") == itemKey) then
                    v.call("showSelection", {selected = true})
                else
                    v.call("showSelection", {selected = false})
                end
            end
        end
    end
end

function highlightMultipleSelectorTiles(params)
    local allObjects = getAllObjects()
    local itemType = params.itemType
    local items = params.items
    --local itemKeys = getKeysFromTable(params.items)

    for k,v in pairs(allObjects) do
        if(v.hasTag(SELECTOR_TILE_TAG)) then
            if( v.getVar("itemType") == itemType) then
                --if(itemKeys:find(v.getVar("itemKey")) ~= nil) then
                item = items[v.getVar("itemKey")]
                if(item ~= nil) then
                    v.call("showSelection", {selected = true, required = item.required})
                else
                    v.call("showSelection", {selected = false})
                end
            end
        end
    end
end

-- function getKeysFromTable(table)
--     local keys = ""

--     for k, v in pairs(table) do
--         keys = keys .. k .. " "
--     end

--     return keys
-- end

function showSelectors(params)
    local allObjects = getAllObjects()
    local itemType = params.itemType

    for k,v in pairs(allObjects) do
        if(v.hasTag(SELECTOR_TILE_TAG)) then
            local currentPos = v.getPosition()

            if(v.getVar("itemType") == itemType and currentPos.y < 0) then
                v.setPosition({x = currentPos.x, y = currentPos.y + hiddenSelectorOffset, z = currentPos.z})
            end
        end
    end
end

function hideSelectors(params)
    local allObjects = getAllObjects()
    local itemType = params.itemType

    for k,v in pairs(allObjects) do
        if(v.hasTag(SELECTOR_TILE_TAG)) then
            local currentPos = v.getPosition()

            if(v.getVar("itemType") == itemType and currentPos.y >= 0) then
                v.setPosition({x = currentPos.x, y = currentPos.y - hiddenSelectorOffset, z = currentPos.z})
                v.call("showSelection", {selected = false})
            end
        end
    end
end
