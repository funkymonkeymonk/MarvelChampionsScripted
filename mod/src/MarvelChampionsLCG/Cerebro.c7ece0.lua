local deckId = 0
local isPrivateDeck = true

function onLoad()
  createUI()
end

function createUI()
  self.createInput({
    input_function = "setDeckId",
    function_owner = self,
    position = {0,0.2,0.2},
    width = 3620,
    scale = {0.1,0.1,0.1},
    height = 900,
    font_size = 8000,
    tooltip = "Input deck ID from MarvelCDB",
    alignment = 3,
    value=""
  })

  self.createButton({
    click_function = "setIsPrivateDeck",
    function_owner = self,
    position = {0,0.2,0.4},
    width = 1700,
    height = 400,
    tooltip = "Click to toggle Private/Public deck ID",
    label = "Private",
    font_size = 350,
    scale = {0.2,0.2,0.2}  
  })

  self.createButton({
    click_function = "importDeck",
    function_owner = self,
    position = {0,0.2,0.7},
    width = 1700,
    height = 400,
    label = "Search",
    font_size = 350,
    scale = {0.3,0.3,0.3},
    tooltip = "Search for Heroes!",
    color = {1,1,0}  
  })
end

function setDeckId(obj, playerColor, value, selected)
  deckId = value
end

function setIsPrivateDeck()
  isPrivateDeck = not isPrivateDeck
  local newLabel = isPrivateDeck and "Private" or "Public"

  for k, v in pairs(self.getButtons()) do
    if (v.label == "Private" or v.label == "Public") then
      self.editButton({
        label = newLabel,
        index = v.index          
      })
    end
  end
end

function importDeck(params)
  params = {
    deckId = deckId,
    isPrivateDeck = isPrivateDeck,
    callbackFunction = "spawnDeck",
    callbackTarget = self
  }

  Global.call("importDeck", params)
end

function spawnDeck(params)
  local deckPosition = self.positionToWorld({0,1.5,-0.45})  
  local deckScale = Vector(Global.getVar("CARD_SCALE_PLAYER"))
  local slots = params.deckInfo.slots

  local deck = Global.call("spawnDeck", {cards = slots, position = deckPosition, scale = deckScale})

  local linkedCards = deck.getGMNotes()

  if(#linkedCards > 0) then
    Global.call("displayMessage", {message="This deck includes linked cards.", messageType=Global.getVar("MESSAGE_TYPE_INFO")})
  end
end
