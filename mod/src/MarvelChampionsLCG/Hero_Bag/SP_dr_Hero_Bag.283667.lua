function getHeroDetails()
  local heroDetails = {}

  heroDetails.identityGuid = "5c2697"
  heroDetails.starterDeckId = 356174
  heroDetails.heroDeckId = 356173
  heroDetails.nemesisGuid = "49bccd"
  heroDetails.obligationGuid = "ba1312"
  heroDetails.hitPoints = 9
  heroDetails.counterUrl = "http://cloud-3.steamusercontent.com/ugc/1897721393463027391/971F5CA033F0BD7AFF157E3716D3BD6B745A946C/"
  heroDetails.playmatUrl = "http://cloud-3.steamusercontent.com/ugc/1861691130254392381/73723523D39B54A9710C85B5D8CF6DE445E4E317/"

  local extras = {}

  extras["Suit"] =
  {
    guid = "a65e7d",
    offset = {-4.95, 2, 4.64},
    locked = false
  }
  return heroDetails
end
