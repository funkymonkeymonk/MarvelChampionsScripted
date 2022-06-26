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

  heroDetails["identityGuid"] = "d6b1e9"
  heroDetails["starterDeckId"] = 345046
  heroDetails["heroDeckGuid"] = "ec704d"
  heroDetails["nemesisGuid"] = "f342da"
  heroDetails["obligationGuid"] = "f99ef8"
  heroDetails["hitPoints"] = 9
  heroDetails["counterUrl"] = "http://cloud-3.steamusercontent.com/ugc/1834662762015024005/B5834E791B7A9AEC90CCA099E09EA575F1D567EF/"
  heroDetails["playmatUrl"] = "http://cloud-3.steamusercontent.com/ugc/1867319584754870469/2CA9B70D796D4AAEB2BD64010BEAC067B4CB59CF/"

  local extras = {}

  heroDetails["extras"] = extras

  return heroDetails
end
