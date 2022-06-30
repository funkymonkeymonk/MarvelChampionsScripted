function getHeroDetails()
    local heroDetails = {}
  
    heroDetails.identityGuid = "b02d67"
    heroDetails.starterDeckId = 344873
    heroDetails.heroDeckId = 347596
    heroDetails.nemesisGuid = "5bfb20"
    heroDetails.obligationGuid = "e604f0"
    heroDetails.hitPoints = 10
    heroDetails.counterUrl = "http://cloud-3.steamusercontent.com/ugc/1833524420370697394/0DEAEEA88256A4282B49C1EF08100BFAAF3647E1/"
    heroDetails.playmatUrl = "http://cloud-3.steamusercontent.com/ugc/1861691130254392177/6383D817A13C0EEBBEA766FD7BBC80AB996ADB52/"
  
    local extras = {}
  
    extras["GrowthCounter"] =
    {
      guid = "586720",
      offset = {-12.57, .28, 3.28},
      locked = true
    }

    heroDetails["extras"] = extras
  
    return heroDetails
  end
