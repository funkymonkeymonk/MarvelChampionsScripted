function getHeroDetails()
  local heroDetails = {}

  heroDetails.identityGuid = "a6c9e7"
  heroDetails.starterDeckId = 344982
  heroDetails.heroDeckId = 347736
  heroDetails.nemesisGuid = "17b4ea"
  heroDetails.obligationGuid = "523ae0"
  heroDetails.hitPoints = 10
  heroDetails.counterUrl = "http://cloud-3.steamusercontent.com/ugc/1833524420371778340/5762C4392F8E0C0AECFBD3C81ED33CE0B9068328/"
  heroDetails.playmatUrl = "http://cloud-3.steamusercontent.com/ugc/1861691360008105065/5AE93B832C886C56C3A47B01A4F939B277EFA156/"

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
