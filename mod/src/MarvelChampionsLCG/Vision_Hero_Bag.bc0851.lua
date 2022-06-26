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

  heroDetails["identityGuid"] = "47f46b"
  heroDetails["starterDeckId"] = 345045
  heroDetails["heroDeckGuid"] = "345be7"
  heroDetails["nemesisGuid"] = "295d84"
  heroDetails["obligationGuid"] = "b61502"
  heroDetails["hitPoints"] = 11
  heroDetails["counterUrl"] = "http://cloud-3.steamusercontent.com/ugc/1833528529702931371/48FACF13014FAC2D0BBBFDBF2B14BC216DCD090C/"
  heroDetails["playmatUrl"] = "http://cloud-3.steamusercontent.com/ugc/1867319584754870526/0EA13872DE0C3DAE9A2F1A7A0ACD463B70E2B2DF/"

  local extras = {}

  extras["Mass Form"] =
    {
      guid = "6361b4",
      offset = {-4.95, 2, 4.64},
      locked = false
    }

  heroDetails["extras"] = extras

  return heroDetails
end
