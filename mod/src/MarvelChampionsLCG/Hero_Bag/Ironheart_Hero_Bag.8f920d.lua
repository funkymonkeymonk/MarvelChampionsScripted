function getHeroDetails()
  local heroDetails = {}

  heroDetails.identityGuid = "eaab93"
  heroDetails.starterDeckId = 345061
  heroDetails.heroDeckId = 347200
  heroDetails.nemesisGuid = "ccc019"
  heroDetails.obligationGuid = "615675"
  heroDetails.hitPoints = 10
  heroDetails.counterUrl = "http://cloud-3.steamusercontent.com/ugc/1831285606387160774/F0DCB814C3FDEBFAF0FCF46B16480C15E4C90C1B/"
  heroDetails.playmatUrl = "http://cloud-3.steamusercontent.com/ugc/1867319584754870340/75ABB3535CA77D11DF90940C8D8586B5A0C99A25/"

  local extras = {}

  extras["Instructions"] =
    {
      guid = "915892",
      offset = {-2.04, 2, 0},
      locked = false
    }

  extras["ProgressCounter"] = 
    {
      guid = "a4dde0",
      offset = {-12.57, .28, 3.28},
      locked = true
    }

  heroDetails["extras"] = extras

  return heroDetails
end
