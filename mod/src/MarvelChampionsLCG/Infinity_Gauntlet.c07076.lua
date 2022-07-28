glow = 0
glowRate = 0.01
glowExtent = {max=0.5,min=0.1}
animatedObjects = {}
initialColors = {}

local function shallowCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

function isOnSnapPoint(object)
  local result = false
  local pos = self.positionToLocal(object.getPosition())
  for index, snapPoint in ipairs(self.getSnapPoints()) do
    --print(math.floor(snapPoint.position.x + 0.5) .. "==" .. math.floor(pos.x + 0.5) .. "|" .. math.floor(snapPoint.position.z + 0.5) .. "==" .. math.floor(pos.z + 0.5))
    if math.floor(snapPoint.position.x + 0.5) == math.floor(pos.x + 0.5) and math.floor(snapPoint.position.z + 0.5) == math.floor(pos.z + 0.5) then
      result = true
    end
  end
  return result
end

function onCollisionEnter(collision_info)
  -- collision_info table:
  --   collision_object    Object
  --   contact_points      Table     {Vector, ...}
  --   relative_velocity   Vector
  --print("collision")
  local col_object = collision_info.collision_object
  if col_object.hasTag("Infinity Stone") and isOnSnapPoint(col_object) and self.getLock() then
    --print('wow!')
    animatedObjects[col_object.getGUID()] = col_object
    initialColors[col_object.getGUID()] = shallowCopy(col_object.getColorTint())
  end
end

function onCollisionExit(collision_info)
  -- collision_info table:
  --   collision_object    Object
  --   contact_points      Table     {Vector, ...}
  --   relative_velocity   Vector
  --print("exit")
  local col_object = collision_info.collision_object
  if col_object.hasTag("Infinity Stone") then
    animatedObjects[col_object.getGUID()] = nil
    if initialColors[col_object.getGUID()] ~= nil then
      col_object.setColorTint(initialColors[col_object.getGUID()])
    end
  end
end

function addToAllInTable(table, float)
  local newTable = {}
  for k, v in pairs(table) do
    newTable[k] = v + float
  end
  return newTable
end

function addColors(color, color2)
  local newTable = {}
  for k, value in pairs(color) do
    newTable[k] = value + color2[k]
  end
  return newTable
end

function getTableLength(tbl) local count = 0 for k,v in pairs(tbl) do count = count + 1 end return count end

function updateGlow()
  --print(glow .. "," .. glowRate)
  --print(getTableLength(animatedObjects))
  if getTableLength(animatedObjects) ~= 0 then
    glow = glow + glowRate
    if glowExtent.min > glow or glow > glowExtent.max then
      glowRate = glowRate * -1
    end
    for guid, object in pairs(animatedObjects) do
      --print(initialColors[guid].r)
      object.setColorTint(addColors(initialColors[guid],{r=glow*0.78,g=glow*0.7152,b=glow*0.0722,a=0}))
    end
  else
    glow = glowExtent.max
  end
end
Wait.time(updateGlow, 0.2, -1)
