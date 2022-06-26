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

  heroDetails["identityGuid"] = "c19a52"
  heroDetails["starterDeckId"] = 345053
  heroDetails["heroDeckGuid"] = "c17fbb"
  heroDetails["nemesisGuid"] = "a5a380"
  heroDetails["obligationGuid"] = "596a94"
  heroDetails["hitPoints"] = 10
  heroDetails["counterUrl"] = "http://cloud-3.steamusercontent.com/ugc/1834662762015024771/555DEED39BD41E6E8C7ECC302C5E7F596FFE33FF/"
  heroDetails["playmatUrl"] = "http://cloud-3.steamusercontent.com/ugc/1867319584754870280/4A4DF12CD1A78AC13383E58BCE6B5396D9AEC4EF/"

  local extras = {}

  heroDetails["extras"] = extras

  return heroDetails
end
