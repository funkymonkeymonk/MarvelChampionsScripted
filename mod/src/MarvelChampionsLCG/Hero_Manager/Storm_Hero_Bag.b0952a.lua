function getHeroDetails()
    local heroDetails = {}
  
    heroDetails.identityGuid = "4d4f45"
    heroDetails.starterDeckId = 574726
    heroDetails.heroDeckId = 574723
    heroDetails.nemesisGuid = "abfa81"
    heroDetails.obligationGuid = "b8c00c"
    heroDetails.hitPoints = 10
    heroDetails.counterUrl = "http://cloud-3.steamusercontent.com/ugc/1924753791401507497/5A35B4B03148F0F73BDDD34B853DA0DEAF0224D4/"
    heroDetails.playmatUrl = "http://cloud-3.steamusercontent.com/ugc/2035118512670984888/FE28D2B0688C78A18DACF531F0A27B8BF474A532/"
  
    local extras = {}
  
    extras["Weather Deck"] =
      {
        guid = "1cbecc",
        offset = {-4.94, 3, -4.66},
        locked = false
      }
  
    heroDetails["extras"] = extras
  
    return heroDetails
  end	
