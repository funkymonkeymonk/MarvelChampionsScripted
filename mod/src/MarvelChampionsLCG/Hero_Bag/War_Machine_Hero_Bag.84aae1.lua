function getHeroDetails()
    local heroDetails = {}
  
    heroDetails.identityGuid = "a6c9e7"
    heroDetails.starterDeckId = 344982
    heroDetails.heroDeckId = 347736
    heroDetails.nemesisGuid = "17b4ea"
    heroDetails.obligationGuid = "523ae0"
    heroDetails.hitPoints = 10
    heroDetails.counterUrl = "http://cloud-3.steamusercontent.com/ugc/1833524420371778340/5762C4392F8E0C0AECFBD3C81ED33CE0B9068328/"
    heroDetails.playmatUrl = "http://cloud-3.steamusercontent.com/ugc/1836901154907227239/EC1BE73EF65CE8727CB3FE7E8931DC37063BC643/"
  
    local extras = {}
  
    extras["AmmoCounter"] =
      {
        guid = "0cd24c",
        offset = {-12.57, .28, 3.28},
        locked = true
      }
  
    heroDetails["extras"] = extras
  
    return heroDetails
  end
