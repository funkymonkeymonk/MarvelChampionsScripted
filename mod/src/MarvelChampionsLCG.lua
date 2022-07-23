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

require('!/cardplacer')

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