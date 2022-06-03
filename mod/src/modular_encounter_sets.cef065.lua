local originX = 60.25
local originY = -2.69
local originZ = -6.25

local columnGap = 6
local rowGap = -2.5

local columns = 7

function onLoad()
	    placeModularSets()
end

function placeModularSets()
    	currentRow = 1
	    currentColumn = 1
	
    	sortedList = getSortedListOfMods()	
	
    	for _, listItem in ipairs(sortedList) do
        		if listItem[2] != "Random Modular" then
            			self.takeObject({guid = listItem[1], position = getCoordinates(currentColumn, currentRow), locked = true}).setLock(true)
			
            			currentColumn = currentColumn + 1
			
            			if currentColumn > columns then
                				currentColumn = 1
                				currentRow = currentRow + 1
            			end
        		end
    	end
	
    	placeRandomBag(currentColumn, currentRow)

end

function getSortedListOfMods()
    	modList = {}
	
    	for _, modularSet in ipairs(self.getObjects()) do
		        table.insert (modList, {modularSet.guid, modularSet.name})
    	end
	
    	compareModularNames = function(a,b)
        		return a[2] < b[2]
    	end
	
    	return table.sort(modList, compareModularNames)
end

function getCoordinates(column, row)
    	x = originX + columnGap * (column - 1)
    	z = originZ + rowGap * (row - 1)
	
	    return {x, originY, z}
end

function placeRandomBag(currentColumn, currentRow)
    	if currentColumn % columns == 0 then
        		currentRow = currentRow + 1
    	end
	
    	self.takeObject({index = 0, position = getCoordinates(columns, currentRow)}).setLock(true)
end






