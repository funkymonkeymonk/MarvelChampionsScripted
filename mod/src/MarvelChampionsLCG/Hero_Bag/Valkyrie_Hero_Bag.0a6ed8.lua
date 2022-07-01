function getHeroDetails()
  local heroDetails = {}

  heroDetails.identityGuid = "961038"
  heroDetails.starterDeckId = 344983
  heroDetails.heroDeckId = 347191
  heroDetails.nemesisGuid = "d25aa9"
  heroDetails.obligationGuid = "c02cbd"
  heroDetails.hitPoints = 12
  heroDetails.counterUrl = "http://cloud-3.steamusercontent.com/ugc/1833524813259370146/95AF051AF3D5A3D8E9CCFD33259482641CD7AE0A/"
  heroDetails.playmatUrl = "http://cloud-3.steamusercontent.com/ugc/1867319584749113032/BCCEC8078F2B0C822E23C8149F0A686E4D163F6B/"

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
