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

  heroDetails["identityGuid"] = "961038"
  heroDetails["starterDeckId"] = 344983
  heroDetails["heroDeckGuid"] = "bf100d"
  heroDetails["nemesisGuid"] = "d25aa9"
  heroDetails["obligationGuid"] = "c02cbd"
  heroDetails["hitPoints"] = 12
  heroDetails["counterUrl"] = "http://cloud-3.steamusercontent.com/ugc/1833524813259370146/95AF051AF3D5A3D8E9CCFD33259482641CD7AE0A/"
  heroDetails["playmatUrl"] = "http://cloud-3.steamusercontent.com/ugc/1867319584749113032/BCCEC8078F2B0C822E23C8149F0A686E4D163F6B/"

  local extras = {}

  extras["Death Glow"] =
    {
      guid = "f4d12d",
      offset = {-4.95, 2, 4.64},
      locked = false
    }

  heroDetails["extras"] = extras

  return heroDetails
end
