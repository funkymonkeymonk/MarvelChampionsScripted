ENCOUNTER_DECK_POS              = {-12.75, 1.05, 22.25}
ENCOUNTER_DECK_SPAWN_POS        = {-12.75, 3, 22.25}
ENCOUNTER_DECK_DISCARD_POSITION = {-17.75, 1.8, 22.25}
VILLAIN_POS                     = {-0.34,3,20.44}
VILLAIN2_POS                    = {8.25,3,20.44}
LOKI_POS                        = {-0.34,1,20.44}
BOOST_POS                       = {-0.3,1.1,7.7}
ENCOUNTER_RED_POS               = {-31.25,1.1,-5.25}
ENCOUNTER_BLUE_POS              = {-3.75,1.1,-5.75}
ENCOUNTER_GREEN_POS             = {23.75,1.1,-5.75}
ENCOUNTER_YELLOW_POS            = {51.25,1.1,-5.25}
g_cardWidth  = 2.30;
g_cardHeight = 3.40;

HERO_PLACER_GUID = "4431e4"

function findInRadiusBy(pos, radius, filter, debug)
   local radius = (radius or 1)
   local objList = Physics.cast({
      origin       = pos,
      direction    = {0,1,0},
      type         = 2,
      size         = {radius, radius, radius},
      max_distance = 0,
      debug        = false
   })

   local filteredList = {}
   for _, obj in ipairs(objList) do
      if filter == nil then
         table.insert(filteredList, obj.hit_object)
      elseif filter and filter(obj.hit_object) then
         table.insert(filteredList, obj.hit_object)
      end
   end
   return filteredList
end

function dealCardsInRows(paramlist)
   local currPosition   = {};
   local numRow         = 1;
   local numCard        = 0;
   local invMultiplier  = 1;
   local allCardsDealed = 0;
   if paramlist.inverse then
      invMultiplier = -1;
   end
   if paramlist.maxCardsDealed == nil then
      allCardsDealed = 0;
      paramlist.maxCardsDealed = paramlist.cardDeck.getQuantity()
      elseif paramlist.maxCardsDealed >= paramlist.cardDeck.getQuantity() or paramlist.maxCardsDealed <=0 then
         allCardsDealed = 0;
         paramlist.maxCardsDealed=paramlist.cardDeck.getQuantity()
      else
         allCardsDealed = 1;
      end
      if paramlist.mode =="x" then
         currPosition = {paramlist.iniPosition[1]+(2*g_cardWidth*invMultiplier*allCardsDealed),paramlist.iniPosition[2],paramlist.iniPosition[3]};
      else
         currPosition = {paramlist.iniPosition[1],paramlist.iniPosition[2],paramlist.iniPosition[3]+(2*g_cardWidth*invMultiplier*allCardsDealed)};
      end
      for i = 1,paramlist.maxCardsDealed,1 do
         paramlist.cardDeck.takeObject({
            position = currPosition,
            smooth   = true
         });
         numCard = numCard+1;
         if numCard >= paramlist.maxCardRow then
            if paramlist.mode == "x" then
               currPosition    = {paramlist.iniPosition[1]+(2*g_cardWidth*invMultiplier*allCardsDealed),paramlist.iniPosition[2],paramlist.iniPosition[3]};
               currPosition[3] = currPosition[3]-(numRow*g_cardHeight*invMultiplier);
            else
               currPosition    = {paramlist.iniPosition[1],paramlist.iniPosition[2],paramlist.iniPosition[3]+(2*g_cardWidth*invMultiplier*allCardsDealed)};
               currPosition[1] = currPosition[1]+(numRow*g_cardHeight*invMultiplier);
            end
            numCard = 0;
            numRow  = numRow+1;
         else
            if paramlist.mode == "x" then
               currPosition[1] = currPosition[1]+(g_cardWidth*invMultiplier);
         else
            currPosition[3] = currPosition[3]+(g_cardWidth*invMultiplier);
         end
      end
   end
end

function isDeck(x)
   return x.tag == 'Deck'
end

function isCardOrDeck(x)
   return x.getName() ~= '' or isDeck(x)
end

function drawEncountercard(params)
   local position = params[1]
   local rotation = params[2]
   local isFaceUp = params[3]
   local faceUpRotation
   if (isFaceUp) then
      faceUpRotation = 0
   else
      faceUpRotation = 180
   end
   local items = findInRadiusBy(ENCOUNTER_DECK_POS, 4, isCardOrDeck)
   if #items > 0 then
      for i, v in ipairs(items) do
         if v.tag == 'Deck' then
            v.takeObject({index = 0, position = position, rotation = {0,rotation.y,faceUpRotation}})
            return
         end
      end
      items[1].setPositionSmooth(position, false, false)
      items[1].setRotationSmooth({0,rotation.y,faceUpRotation}, false, false)
      return
   end
   reshuffleEncounterDeck(position, {0,rotation.y,faceUpRotation})
end

function drawBoostcard(params)
   local position = params[1]
   local rotation = params[2]
   local isFaceUp = params[3]
   local faceUpRotation
   if (isFaceUp) then
      faceUpRotation = 0
   else
      faceUpRotation = 180
   end
   local items = findInRadiusBy(ENCOUNTER_DECK_POS, 4, isCardOrDeck)
   if #items > 0 then
      for i, v in ipairs(items) do
         if v.tag == 'Deck' then
            v.takeObject({index = 0, position = position, rotation = {0,180,faceUpRotation}})
            return
         end
      end
      items[1].setPositionSmooth(position, false, false)
      items[1].setRotationSmooth({0,180,faceUpRotation}, false, false)
      return
   end
   reshuffleEncounterDeck(position, {0,rotation.y,faceUpRotation})
end

function discardBoostcard(params)
   local position = params[1]
   local rotation = params[2]
   local isFaceUp = params[3]
   local faceUpRotation
   if (isFaceUp) then
      faceUpRotation = 0
   else
      faceUpRotation = 0
   end
   local items = findInRadiusBy(BOOST_POS, 4, isCardOrDeck)
   if #items > 0 then
      for i, v in ipairs(items) do
         if v.tag == 'Deck' then
            v.takeObject({index = index, position = position, rotation = {0,180,faceUpRotation}})
            return
         end
      end
      items[1].setPositionSmooth(position, false, false)
      items[1].setRotationSmooth({0,rotation.y,faceUpRotation}, false, false)
      return
   end
end

function villainPhasecard(params)
   local position = params[1]
   local rotation = params[2]
   local isFaceUp = params[3]
   local faceUpRotation
   if (isFaceUp) then
      faceUpRotation = 0
   else
      faceUpRotation = 0
   end
   local items = findInRadiusBy(VILLAIN_POS, 4, isCardOrDeck)
   if #items > 0 then
      for i, v in ipairs(items) do
         if v.tag == 'Deck' then
            v.takeObject({index = index, position = position, rotation = {0,180,faceUpRotation}})
            return
         end
      end
      items[1].setPositionSmooth(position, false, false)
      items[1].setRotationSmooth({0,rotation.y,faceUpRotation}, false, false)
      return
   end
end

function villainPhasecard2(params)
   local position = params[1]
   local rotation = params[2]
   local isFaceUp = params[3]
   local faceUpRotation
   if (isFaceUp) then
      faceUpRotation = 0
   else
      faceUpRotation = 0
   end
   local items = findInRadiusBy(VILLAIN2_POS, 4, isCardOrDeck)
   if #items > 0 then
      for i, v in ipairs(items) do
         if v.tag == 'Deck' then
            v.takeObject({index = index, position = position, rotation = {0,180,faceUpRotation}})
            return
         end
      end
      items[1].setPositionSmooth(position, false, false)
      items[1].setRotationSmooth({0,rotation.y,faceUpRotation}, false, false)
      return
   end
end

function villainPhaseloki(params)
   local position = params[1]
   local rotation = params[2]
   local isFaceUp = params[3]
   local faceUpRotation
   if (isFaceUp) then
      faceUpRotation = 0
   else
      faceUpRotation = 0
   end
   local items = findInRadiusBy(LOKI_POS, 4, isCardOrDeck)
   if #items > 0 then
      for i, v in ipairs(items) do
         if v.tag == 'Deck' then
            v.takeObject({index = index, position = position, rotation = {0,180,faceUpRotation}})
            return
         end
      end
      items[1].setPositionSmooth(position, false, false)
      items[1].setRotationSmooth({0,rotation.y,faceUpRotation}, false, false)
      return
   end
end

function returnEncountercard(params)
   local position = params[1]
   local rotation = params[2]
   local isFaceUp = params[3]
   local faceUpRotation
   if (isFaceUp) then
      faceUpRotation = 0
   else
      faceUpRotation = 180
   end
   local items = findInRadiusBy(ENCOUNTER_DECK_POS, 4, isCardOrDeck)
   if #items > 0 then
      for i, v in ipairs(items) do
         if v.tag == 'Deck' then
            v.takeObject({index = index, position = position, rotation = {0,180,faceUpRotation}})
            v.takeObject({index = index, position = position, rotation = {0,180,faceUpRotation}})
            v.takeObject({index = index, position = position, rotation = {0,180,faceUpRotation}})
            v.takeObject({index = index, position = position, rotation = {0,180,faceUpRotation}})
            v.takeObject({index = index, position = position, rotation = {0,180,faceUpRotation}})
            return
         end
      end
      items[1].setPositionSmooth(position, false, false)
      items[1].setRotationSmooth({0,rotation.y,faceUpRotation}, false, false)
      return
   end
end

function discardEncounterRed(params)
   local position = params[1]
   local rotation = params[2]
   local isFaceUp = params[3]
   local faceUpRotation
   if (isFaceUp) then
      faceUpRotation = 0
   else
      faceUpRotation = 0
   end
   local items = findInRadiusBy(ENCOUNTER_RED_POS, 4, isCardOrDeck)
   if #items > 0 then
     for i, v in ipairs(items) do
        if v.tag == 'Deck' then
           v.takeObject({index = index, position = position, rotation = {0,180,faceUpRotation}})
           return
        end
      end
      items[1].setPositionSmooth(position, false, false)
      items[1].setRotationSmooth({0,rotation.y,faceUpRotation}, false, false)
      return
   end
end

function discardEncounterBlue(params)
   local position = params[1]
   local rotation = params[2]
   local isFaceUp = params[3]
   local faceUpRotation
   if (isFaceUp) then
      faceUpRotation = 0
   else
      faceUpRotation = 0
   end
   local items = findInRadiusBy(ENCOUNTER_BLUE_POS, 4, isCardOrDeck)
   if #items > 0 then
      for i, v in ipairs(items) do
         if v.tag == 'Deck' then
            v.takeObject({index = index, position = position, rotation = {0,180,faceUpRotation}})
            return
         end
      end
      items[1].setPositionSmooth(position, false, false)
      items[1].setRotationSmooth({0,rotation.y,faceUpRotation}, false, false)
      return
   end
end

function discardEncounterGreen(params)
   local position = params[1]
   local rotation = params[2]
   local isFaceUp = params[3]
   local faceUpRotation
   if (isFaceUp) then
      faceUpRotation = 0
   else
      faceUpRotation = 0
   end
   local items = findInRadiusBy(ENCOUNTER_GREEN_POS, 4, isCardOrDeck)
   if #items > 0 then
      for i, v in ipairs(items) do
         if v.tag == 'Deck' then
            v.takeObject({index = index, position = position, rotation = {0,180,faceUpRotation}})
            return
         end
      end
      items[1].setPositionSmooth(position, false, false)
      items[1].setRotationSmooth({0,rotation.y,faceUpRotation}, false, false)
      return
   end
end

function discardEncounterYellow(params)
   local position = params[1]
   local rotation = params[2]
   local isFaceUp = params[3]
   local faceUpRotation
   if (isFaceUp) then
      faceUpRotation = 0
   else
      faceUpRotation = 0
   end
   local items = findInRadiusBy(ENCOUNTER_YELLOW_POS, 4, isCardOrDeck)
   if #items > 0 then
      for i, v in ipairs(items) do
         if v.tag == 'Deck' then
            v.takeObject({index = index, position = position, rotation = {0,180,faceUpRotation}})
            return
         end
      end
      items[1].setPositionSmooth(position, false, false)
      items[1].setRotationSmooth({0,rotation.y,faceUpRotation}, false, false)
      return
   end
end

IS_RESHUFFLING = false
function reshuffleEncounterDeck(position, rotation)
   local function move(deck)
      deck.setPositionSmooth(ENCOUNTER_DECK_SPAWN_POS, true, false)
      deck.takeObject({index = 0, position = position, rotation = rotation, flip = false})
      Wait.time(function() IS_RESHUFFLING = false end, 1)
   end
   if IS_RESHUFFLING then
      return
   end
   local discarded = findInRadiusBy(ENCOUNTER_DECK_DISCARD_POSITION, 4, isDeck)
   if #discarded > 0 then
      IS_RESHUFFLING = true
      local deck = discarded[1]
      if not deck.is_face_down then
         deck.flip()
      end
      deck.shuffle()
      Wait.time(function() move(deck) end, 0.3)
   else
      printToAll("Couldn't find encounter discard pile to reshuffle", {1,0,0})
   end
end


function requestBoost()
   getObjectFromGUID('e3b2e1').call('createBoostButton')
end

function removeBoostButton()
   boostBag = getObjectFromGUID('e3b2e1')
   boostBag.clearButtons()
end

function round(params)
   return tonumber(string.format("%." .. (params[2] or 0) .. "f", params[1]))
end

function roundposition(params)
   return {round({params[1], 2}), round({params[2], 2}), round({params[3], 2})}
end

function isEqual(params)
   if params[1][1] == params[2][1] and params[1][2] == params[2][2] and params[1][3] == params[2][3] then
      return true
   else
      return false
   end
end

function isFaceup(params)
   if params.getRotation()[3] > -5 and params.getRotation()[3] < 5 then
      return true
   else
      return false
   end
end

function getHeroCount()
   local allObjects = getAllObjects()
   local playmatCount = 0

   for _, obj in pairs(allObjects) do
      if(obj.hasTag("Playmat")) then
         playmatCount = playmatCount + 1
      end
   end

   return playmatCount
end

local Decker = {}

-- provide unique ID starting from 20 for present decks
local nextID, recheckNextID
do
   local _nextID = 20
   nextID = function()
      _nextID = _nextID + 1
      return tostring(_nextID)
   end

   local function recheckObjNextDeckID(obj)
      for deckID in pairs(obj.getData().CustomDeck or {}) do
         if deckID >= _nextID then
            _nextID = deckID
         end
      end
   end

   recheckNextID = function()
      local initialNextID = _nextID
      for _, obj in ipairs(getAllObjects()) do
         recheckObjNextDeckID(obj)
      end
      return _nextID > initialNextID
   end
end

-- Asset signature (equality comparison)
local function assetSignature(assetData)
   return table.concat({
      assetData.FaceURL,
      assetData.BackURL,
      assetData.NumWidth,
      assetData.NumHeight,
      assetData.BackIsHidden and 'hb' or '',
      assetData.UniqueBack and 'ub' or ''
   })
end
-- Asset ID storage to avoid new ones for identical assets
local idLookup = {}
local function assetID(assetData)
   local sig = assetSignature(assetData)
   local key = idLookup[sig]
   if not key then
      key = nextID()
      idLookup[sig] = key
   end
   return key
end

local assetMeta = {
   deck = function(self, cardNum, options)
      return Decker.AssetDeck(self, cardNum, options)
   end
}
assetMeta = {__index = assetMeta}

-- Create a new CustomDeck asset
function Decker.Asset(face, back, options)
   local asset = {}
   options = options or {}
   asset.data = {
      FaceURL = face or error('Decker.Asset: faceImg link required'),
      BackURL = back or error('Decker.Asset: backImg link required'),
      NumWidth = options.width or 1,
      NumHeight = options.height or 1,
      BackIsHidden = options.hiddenBack or false,
      UniqueBack = options.uniqueBack or false
   }
   -- Reuse ID if asset existing
   asset.id = assetID(asset.data)
   return setmetatable(asset, assetMeta)
end
-- Pull a Decker.Asset from card JSONs CustomDeck entry
local function assetFromData(assetData)
   return setmetatable({data = assetData, id = assetID(assetData)}, assetMeta)
end

-- Create a base for JSON objects
function Decker.BaseObject()
   return {
      Name = 'Base',
      Transform = {
         posX = 0, posY = 5, posZ = 0,
         rotX = 0, rotY = 0, rotZ = 0,
         scaleX = 1, scaleY = 1, scaleZ = 1
      },
      Nickname = '',
      Description = '',
      Value = 0,
      Tags = {},
      ColorDiffuse = { r = 1, g = 1, b = 1 },
      Locked = false,
      Grid = true,
      Snap = true,
      Autoraise = true,
      Sticky = true,
      Tooltip = true,
      GridProjection = false,
      Hands = true,
      XmlUI = '',
      LuaScript = '',
      LuaScriptState = '',
      GUID = 'deadbf'
   }
end
-- Typical paramters map with defaults
local commonMap = {
   name   = {field = 'Nickname',    default = ''},
   value   = {field = 'Value',    default = 0},
   tags   = {field = 'Tags',   default = {}},
   desc   = {field = 'Description', default = ''},
   script = {field = 'LuaScript',   default = ''},
   xmlui  = {field = 'XmlUI',       default = ''},
   scriptState = {field = 'LuaScriptState', default = ''},
   locked  = {field = 'Locked',  default = false},
   tooltip = {field = 'Tooltip', default = true},
   guid    = {field = 'GUID',    default = 'deadbf'},
   hands   = {field = 'Hands',   default = true},
}
-- Apply some basic parameters on base JSON object
function Decker.SetCommonOptions(obj, options)
   options = options or {}
   for k,v in pairs(commonMap) do
      -- can't use and/or logic cause of boolean fields
      if options[k] ~= nil then
         obj[v.field] = options[k]
      else
         obj[v.field] = v.default
      end
   end
   -- passthrough unrecognized keys
   for k,v in pairs(options) do
      if not commonMap[k] then
         obj[k] = v
      end
   end
end
-- default spawnObjectJSON/spawnObjectData params since it doesn't like blank fields
local function defaultParams(params)
   params = params or {}
   params.position = params.position or {0, 5, 0}
   params.rotation = params.rotation or {0, 0, 0}
   params.scale = params.scale or {1, 1, 1}
   if params.sound == nil then
      params.sound = true
   end
   return params
end

-- For copy method
local deepcopy
deepcopy = function(t)
   local copy = {}
   for k,v in pairs(t) do
      if type(v) == 'table' then
         copy[k] = deepcopy(v)
      else
         copy[k] = v
      end
   end
   return copy
end
-- meta for all Decker derived objects
local commonMeta = {
   -- return object JSON string, used cached if present
   _cache = function(self)
      if not self.json then
         self.json = JSON.encode(self.data)
      end
      return self.json
   end,
   -- invalidate JSON string cache
   _recache = function(self)
      self.json = nil
      return self
   end,
   spawn = function(self, params)
      params = defaultParams(params)
      params.data = self.data
      return spawnObjectData(params)
   end,
   spawnJSON = function(self, params)
      params = defaultParams(params)
      params.json = self:_cache()
      return spawnObjectJSON(params)
   end,
   copy = function(self)
      return setmetatable(deepcopy(self), getmetatable(self))
   end,
   setCommon = function(self, options)
      Decker.SetCommonOptions(self.data, options)
      return self
   end,
}
-- apply common part on a specific metatable
local function customMeta(mt)
   for k,v in pairs(commonMeta) do
      mt[k] = v
   end
   mt.__index = mt
   return mt
end

-- DeckerCard metatable
local cardMeta = {
   setAsset = function(self, asset)
      local cardIndex = self.data.CardID:sub(-2, -1)
      self.data.CardID = asset.id .. cardIndex
      self.data.CustomDeck = {[asset.id] = asset.data}
      return self:_recache()
   end,
   getAsset = function(self)
      local deckID = next(self.data.CustomDeck)
      return assetFromData(self.data.CustomDeck[deckID])
   end,
   -- reset deck ID to a consistent value script-wise
   _recheckDeckID = function(self)
      local oldID = next(self.data.CustomDeck)
      local correctID = assetID(self.data.CustomDeck[oldID])
      if oldID ~= correctID then
         local cardIndex = self.data.CardID:sub(-2, -1)
         self.data.CardID = correctID .. cardIndex
         self.data.CustomDeck[correctID] = self.data.CustomDeck[oldID]
         self.data.CustomDeck[oldID] = nil
      end
      return self
   end
}
cardMeta = customMeta(cardMeta)
-- Create a DeckerCard from an asset
function Decker.Card(asset, row, col, options)
   row, col = row or 1, col or 1
   options = options or {}
   local card = Decker.BaseObject()
   card.Name = 'Card'
   -- optional custom fields
   Decker.SetCommonOptions(card, options)
   if options.sideways ~= nil then
      card.SidewaysCard = options.sideways
      -- FIXME passthrough set that field, find some more elegant solution
      card.sideways = nil
   end
   -- CardID string is parent deck ID concat with its 0-based index (always two digits)
   local num = (row-1)*asset.data.NumWidth + col - 1
   num = string.format('%02d', num)
   card.CardID = asset.id .. num
   -- just the parent asset reference needed
   card.CustomDeck = {[asset.id] = asset.data}

   local obj = setmetatable({data = card}, cardMeta)
   obj:_recache()
   return obj
end


-- DeckerDeck meta
local deckMeta = {
   count = function(self)
      return #self.data.DeckIDs
   end,
   -- Transform index into positive
   index = function(self, ind)
      if ind < 0 then
         return self:count() + ind + 1
      else
         return ind
      end
   end,
   swap = function(self, i1, i2)
      local ri1, ri2 = self:index(i1), self:index(i2)
      assert(ri1 > 0 and ri1 <= self:count(), 'DeckObj.rearrange: index ' .. i1 .. ' out of bounds')
      assert(ri2 > 0 and ri2 <= self:count(), 'DeckObj.rearrange: index ' .. i2 .. ' out of bounds')
      self.data.DeckIDs[ri1], self.data.DeckIDs[ri2] = self.data.DeckIDs[ri2], self.data.DeckIDs[ri1]
      local co = self.data.ContainedObjects
      co[ri1], co[ri2] = co[ri2], co[ri1]
      return self:_recache()
   end,
   -- rebuild self.data.CustomDeck based on contained cards
   _rescanUsedDecks = function(self)
      local cardIDs = {}
      for k,card in ipairs(self.data.ContainedObjects) do
         local cardID = next(card.CustomDeck)
         if not cardIDs[cardID] then
            cardIDs[cardID] = card.CustomDeck[cardID]
         end
      end
      -- eeh, GC gotta earn its keep as well
      -- FIXME if someone does shitton of removals, may cause performance issues?
      self.data.CustomDeck = cardIDs
   end,
   -- rebuild self.data.DeckIDs based on contained cards
   _rescanDeckIDs = function(self)
      local deckIDs = {}
      for _, card in ipairs(self.data.ContainedObjects) do
         table.insert(deckIDs, card.CardID)
      end
      self.data.DeckIDs = deckIDs
   end,
   remove = function(self, ind, skipRescan)
      local rind = self:index(ind)
      assert(rind > 0 and rind <= self:count(), 'DeckObj.remove: index ' .. ind .. ' out of bounds')
      local card = self.data.ContainedObjects[rind]
      table.remove(self.data.DeckIDs, rind)
      table.remove(self.data.ContainedObjects, rind)
      if not skipRescan then
         self:_rescanUsedDecks()
      end
      return self:_recache()
   end,
   removeMany = function(self, ...)
      local indices = {...}
      table.sort(indices, function(e1,e2) return self:index(e1) > self:index(e2) end)
      for _,ind in ipairs(indices) do
         self:remove(ind, true)
      end
      self:_rescanUsedDecks()
      return self:_recache()
   end,
   insert = function(self, card, ind)
      ind = ind or (self:count() + 1)
      local rind = self:index(ind)
      assert(rind > 0 and rind <= (self:count()+1), 'DeckObj.insert: index ' .. ind .. ' out of bounds')
      table.insert(self.data.DeckIDs, rind, card.data.CardID)
      table.insert(self.data.ContainedObjects, rind, card.data)
      local id = next(card.data.CustomDeck)
      if not self.data.CustomDeck[id] then
         self.data.CustomDeck[id] = card.data.CustomDeck[id]
      end
      return self:_recache()
   end,
   reverse = function(self)
      local s,e = 1, self:count()
      while s < e do
         self:swap(s, e)
         s = s+1
         e = e-1
      end
      return self:_recache()
   end,
   sort = function(self, sortFunction)
      table.sort(self.data.ContainedObjects, sortFunction)
      self:_rescanDeckIDs()
      return self:_recache()
   end,
   cardAt = function(self, ind)
      local rind = self:index(ind)
      assert(rind > 0 and rind <= (self:count()+1), 'DeckObj.insert: index ' .. ind .. ' out of bounds')
      local card = setmetatable({data = deepcopy(self.data.ContainedObjects[rind])}, cardMeta)
      card:_recache()
      return card
   end,
   switchAssets = function(self, replaceTable)
      -- destructure replace table into
      -- [ID_to_replace] -> [ID_to_replace_with]
      -- [new_asset_ID] -> [new_asset_data]
      local idReplace = {}
      local assets = {}
      for oldAsset, newAsset in pairs(replaceTable) do
         assets[newAsset.id] = newAsset.data
         idReplace[oldAsset.id] = newAsset.id
      end
      -- update deckIDs
      for k,cardID in ipairs(self.data.DeckIDs) do
         local deckID, cardInd = cardID:sub(1, -3), cardID:sub(-2, -1)
         if idReplace[deckID] then
            self.data.DeckIDs[k] = idReplace[deckID] .. cardInd
         end
      end
      -- update CustomDeck data - nil replaced
      for replacedID in pairs(idReplace) do
         if self.data.CustomDeck[replacedID] then
            self.data.CustomDeck[replacedID] = nil
         end
      end
      -- update CustomDeck data - add replacing
      for _,replacingID in pairs(idReplace) do
         self.data.CustomDeck[replacingID] = assets[replacingID]
      end
      -- update card data
      for k,cardData in ipairs(self.data.ContainedObjects) do
         local deckID = next(cardData.CustomDeck)
         if idReplace[deckID] then
            cardData.CustomDeck[deckID] = nil
            cardData.CustomDeck[idReplace[deckID]] = assets[idReplace[deckID]]
         end
      end
      return self:_recache()
   end,
   getAssets = function(self)
      local assets = {}
      for id,assetData in pairs(self.data.CustomDeck) do
         assets[#assets+1] = assetFromData(assetData)
      end
      return assets
   end
}
deckMeta = customMeta(deckMeta)
-- Create DeckerDeck object from DeckerCards
function Decker.Deck(cards, options)
   assert(#cards > 1, 'Trying to create a Decker.deck with less than 2 cards')
   local deck = Decker.BaseObject()
   deck.Hands = false
   deck.Name = 'Deck'
   Decker.SetCommonOptions(deck, options)
   deck.DeckIDs = {}
   deck.CustomDeck = {}
   deck.ContainedObjects = {}
   for _,card in ipairs(cards) do
      deck.DeckIDs[#deck.DeckIDs+1] = card.data.CardID
      local id = next(card.data.CustomDeck)
      if not deck.CustomDeck[id] then
         deck.CustomDeck[id] = card.data.CustomDeck[id]
      end
      deck.ContainedObjects[#deck.ContainedObjects+1] = card.data
   end

   local obj = setmetatable({data = deck}, deckMeta)
   obj:_recache()
   return obj
end
-- Create DeckerDeck from an asset using X cards on its sheet
function Decker.AssetDeck(asset, cardNum, options)
   cardNum = cardNum or asset.data.NumWidth * asset.data.NumHeight
   local row, col, width = 1, 1, asset.data.NumWidth
   local cards = {}
   for k=1,cardNum do
      cards[#cards+1] = Decker.Card(asset, row, col)
      col = col+1
      if col > width then
         row, col = row+1, 1
      end
   end
   return Decker.Deck(cards, options)
end

Decker.RescanExistingDeckIDs = recheckNextID

-- open in browser to see what these links depict
local cardFaces = 'https://i.imgur.com/wiyVst7.png'
local cardBack = 'https://i.imgur.com/KQtQGE7.png'

-- define a new asset from face/back links, add width/height (since these default to 1x1)
local cardAsset = Decker.Asset(cardFaces, cardBack, {width = 2, height = 2})

-- define cards on the asset, skipping three because we can (would be row 2, column 1)
local cardOne = Decker.Card(cardAsset, 1, 1) -- (asset, row, column)
local cardTwo = Decker.Card(cardAsset, 1, 2)
local cardFour = Decker.Card(cardAsset, 2, 2)

-- define a deck of cardFour, two cardOne's and two cardTwo's
local myDeck = Decker.Deck({cardFour, cardOne, cardOne, cardTwo, cardTwo})

-- so far, all of the above are just scripting definitions, nothing is spawned
-- e.g. if I decided game is balanced better with just one cardTwo in the deck, I can just remove it
--  from above code and leave rest of the code unchanged (still using myDeck below)
-- same goes for changing art on cards (just replace links from Decker.Asset definitions)

-- let's do some testing when any chat message is sent
function onChat()
   -- spawn two of our decks (e.g. for each player), one flipped
   myDeck:spawn({position = {-4, 3, 0}})
   myDeck:spawn({position = {4, 3, 0}, rotation = {0, 0, 180}})

   -- spawn a single card
   cardFour:spawn({position = {0, 3, 6}})

   -- see below for a bit more functionality Decker offers
   advancedExample()
end

function advancedExample()
   -- all :spawn methods return a regular object - proceed like with anything
   local someDeck = myDeck:spawn({position = {0, 3, -6}})
   someDeck.highlightOn({0, 0, 1}, 10)
   someDeck.setName('this is some deck')
   -- for convenience, stuff like name/description/xmlui can be assigned to stuff before spawning
   --  to avoid calls like setName above - see spawnParams in full reference section of docs

   -- we can use DeckerDeck methods to modify it
   -- let's remove both cardOne's from it (index 2 and 3)
   myDeck:removeMany(2, 3)
   -- now let's swap first and last card so it's {cardTwo, cardTwo, cardFour} and spawn it
   -- negative index (anywhere in methods) means counting from the end down
   myDeck:swap(1, -1):spawn({position = {0, 3, 0}})

   -- we can swap assets on decks after creation
   -- this new asset switches card fromnts and backs
   local weirdAsset = Decker.Asset(cardBack, cardFaces, {width = 2, height = 2})
   -- to leave myDeck as-is, we'll be working on a copy
   -- you can have many replacements at once, [oldAsset] = newAsset
   myDeck:copy():switchAssets({ [cardAsset] = weirdAsset }):spawn({position = {12, 3, 0}})
end

function onLoad()
   broadcastToAll('Post any chat message to execute example code', {1, 1, 1})
end