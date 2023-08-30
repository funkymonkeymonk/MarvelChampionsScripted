function getHeroDetails()
    local heroDetails = {}
  
    heroDetails.identityGuid = "776e75"
    heroDetails.starterDeckId = 575047
    heroDetails.heroDeckId = 575051
    heroDetails.nemesisGuid = "5084c4"
    heroDetails.obligationGuid = "30143b"
    heroDetails.hitPoints = 11
    heroDetails.counterUrl = "http://cloud-3.steamusercontent.com/ugc/2058745292939695220/25A7C564B51556328CB1987E9F225B51D0C19F69/"
    heroDetails.playmatUrl = "http://cloud-3.steamusercontent.com/ugc/2035118512673864953/9F191D57829E59CE767A055C9D3F6D0A08729D0B/"
  
    local extras = {}
  
    extras["Touched"] =
      {
        guid = "e42299",
        offset = {-4.94, 3, -4.66},
        locked = false
      }
  
    heroDetails["extras"] = extras
  
    return heroDetails
  end
