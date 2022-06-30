function getHeroDetails()
  local heroDetails = {}

  heroDetails.identityGuid = "47f46b"
  heroDetails.starterDeckId = 345045
  heroDetails.heroDeckId = 347198
  heroDetails.nemesisGuid = "295d84"
  heroDetails.obligationGuid = "b61502"
  heroDetails.hitPoints = 11
  heroDetails.counterUrl = "http://cloud-3.steamusercontent.com/ugc/1833528529702931371/48FACF13014FAC2D0BBBFDBF2B14BC216DCD090C/"
  heroDetails.playmatUrl = "http://cloud-3.steamusercontent.com/ugc/1867319584754870526/0EA13872DE0C3DAE9A2F1A7A0ACD463B70E2B2DF/"

  local extras = {}

  extras["Mass Form"] =
    {
      guid = "6361b4",
      offset = {-4.95, 2, 4.64},
      locked = false
    }

  heroDetails["extras"] = extras

  return heroDetails
end
