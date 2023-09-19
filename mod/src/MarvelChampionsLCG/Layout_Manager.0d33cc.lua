preventDeletion = true

local defaultColumnGap = 5
local defaultRowGap = 2.5
local defaultSelectorScale = {1.13, 1.00, 1.13}
local defaultSelectorRotation = {0,180,0}

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
    local sortedList = getSortedListOfItems(items)
    local itemCount = #sortedList

    if(origin == nil) then
        if(center == nil) then
            broadcastToAll("Must supply either an origin or center position to lay out tiles.", {1,1,1})
            return
        end

        origin = calculateOrigin(center, direction, maxRowsOrColumns, columnGap, rowGap, itemCount)
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
                    imageUrl = item.tileImageUrl
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
    log(origin)
    if(origin == nil) then
        log("Origin is nil")
        return
    end
    if(column == nil) then
        log("Column is nil")
        return
    end
    if(row == nil) then
        log("Row is nil")
        return
    end
    if(columnGap == nil) then
        log("Column gap is nil")
        return
    end
    if(rowGap == nil) then
        log("Row gap is nil")
        return
    end

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
