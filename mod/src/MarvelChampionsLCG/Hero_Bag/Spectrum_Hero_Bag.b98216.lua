function getHeroDetails()
    local heroDetails = {}
  
    heroDetails.identityGuid = "8c3f88"
    heroDetails.starterDeckId = 344973
    heroDetails.heroDeckId = 347735
    heroDetails.nemesisGuid = "47ab21"
    heroDetails.obligationGuid = "2e551f"
    heroDetails.hitPoints = 11
    heroDetails.counterUrl = "http://cloud-3.steamusercontent.com/ugc/1833524420371051743/D6FA0E4F75B7C69A5D1F538DE942BB8AFB154C99/"
    heroDetails.playmatUrl = "http://cloud-3.steamusercontent.com/ugc/1861691130254392614/18C6C8E7E0DA0E1061A8E60A46A6ED60E357F067/"
  
    local extras = {}
  
    extras["EnergyForm"] =
      {
        guid = "71bfde",
        offset = {-4.95, 2, 4.64},
        locked = false
      }

    heroDetails["extras"] = extras
  
    return heroDetails
  end
