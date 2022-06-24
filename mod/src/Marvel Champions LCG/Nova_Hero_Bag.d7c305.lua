function onload(saved_data)
  createButtons()
end

function createButtons()
--    self.createButton({
--        label=" S|", click_function="buttonClick_Starter", function_owner=self,
--        position={-0.8,4.3,0}, rotation={0,0,0}, height=1000, width=500,
--        font_size=600, color={1,1,1}, font_color={0,0,0}, tooltip="Starter"
--    })
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

  heroDetails["counterGuid"] = "9b518d"
  heroDetails["identityGuid"] = "13ab9f"
  heroDetails["starterDeckGuid"] = ""   --TODO: add Nova's starter deck
  heroDetails["heroDeckGuid"] = "4762fa"
  heroDetails["nemesisGuid"] = "9417cb"
  heroDetails["obligationGuid"] = "947100"
  heroDetails["playmatUrl"] = "http://cloud-3.steamusercontent.com/ugc/1867319584754870404/B5E582541EEDEF4E069D80FA15A6365C490A1527/"

  local extras = {}

  heroDetails["extras"] = extras

  return heroDetails
end
