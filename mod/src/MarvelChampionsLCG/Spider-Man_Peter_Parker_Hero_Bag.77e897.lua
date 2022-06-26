function onload(saved_data)
  createButtons()
end

function createButtons()
    self.createButton({
        label=" S |", click_function="buttonClick_Starter", function_owner=self,
        position={-.8,4.3,-.15}, rotation={0,0,0}, height=770, width=675,
        font_size=600, color={1,1,1}, font_color={0,0,0}, tooltip="Starter"
    })
    self.createButton({
        label=" C", click_function="buttonClick_Constructed", function_owner=self,
        position={0.36,4.3,-.15}, rotation={0,0,0}, height=770, width=675, 
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

  heroDetails["identityGuid"] = "43d7e9"
  heroDetails["starterDeckId"] = 344800
  heroDetails["heroDeckGuid"] = "47a7d7"
  heroDetails["nemesisGuid"] = "80078c"
  heroDetails["obligationGuid"] = "4f37cf"
  heroDetails["hitPoints"] = 10
  heroDetails["counterUrl"] = "http://cloud-3.steamusercontent.com/ugc/1833524706207154737/3D289302F9B746908080D450E6A80185128A84A5/"
  heroDetails["playmatUrl"] = "http://cloud-3.steamusercontent.com/ugc/1867319584757427614/7D6E3AF00031FD418F87F4283985E212F75B918F/"

  local extras = {}

  heroDetails["extras"] = extras

  return heroDetails
end
