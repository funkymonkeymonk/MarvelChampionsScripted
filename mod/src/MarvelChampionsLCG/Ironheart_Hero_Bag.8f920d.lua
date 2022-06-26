function onload(saved_data)
  createButtons()
end

function createButtons()
  self.createButton({
      label=" S|", click_function="buttonClick_Starter", function_owner=self,
      position={-0.8,4.3,0}, rotation={0,0,0}, height=1000, width=500,
      font_size=600, color={1,1,1}, font_color={0,0,0}, tooltip="Starter"
  })
  self.createButton({
      label="C", click_function="buttonClick_Constructed", function_owner=self,
      position={0.1,4.3,0}, rotation={0,0,0}, height=1000, width=500,
      font_size=600, color={1,1,1}, font_color={0,0,0}, tooltip="Constructed"
  })
end

function buttonClick_Starter(obj, player_color)
  placeHero(player_color, "starter")
end

function buttonClick_Constructed(obj, player_color)
  placeHero(player_color, "constructed")
end

function placeHero(playerColor, deckType)
  params = {
    heroBag = self,
    playerColor = playerColor,
    deckType = deckType
  }

  heroPlacer = getObjectFromGUID(Global.getVar("HERO_PLACER_GUID"))

  heroPlacer.call("placeHero", params)
end

function getHeroDetails()
  local heroDetails = {}

  heroDetails["counterGuid"] = "986174"
  heroDetails["identityGuid"] = "eaab93"
  heroDetails["starterDeckGuid"] = "f11701"
  heroDetails["heroDeckGuid"] = "94dfa3"
  heroDetails["nemesisGuid"] = "ccc019"
  heroDetails["obligationGuid"] = "615675"
  heroDetails["playmatUrl"] = "http://cloud-3.steamusercontent.com/ugc/1867319584754870340/75ABB3535CA77D11DF90940C8D8586B5A0C99A25/"

  local extras = {}

  extras["Instructions"] =
    {
      guid = "915892",
      offset = {-2.04, 2, 0},
      locked = false
    }

  extras["ProgressCounter"] = 
    {
      guid = "a4dde0",
      offset = {-12.57, .28, 3.28},
      locked = true
    }

  heroDetails["extras"] = extras

  return heroDetails
end
