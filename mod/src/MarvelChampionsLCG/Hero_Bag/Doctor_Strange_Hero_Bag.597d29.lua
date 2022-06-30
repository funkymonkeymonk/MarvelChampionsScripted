function getHeroDetails()
    local heroDetails = {}
  
    heroDetails.identityGuid = "4eaae1"
    heroDetails.starterDeckId = 344859
    heroDetails.heroDeckId = 347733
    heroDetails.nemesisGuid = "46fdd1"
    heroDetails.obligationGuid = "a7b94b"
    heroDetails.hitPoints = 10
    heroDetails.counterUrl = "http://cloud-3.steamusercontent.com/ugc/1833524706206622034/0F18E2CD3CA5CBC2ADC7C3A09DD81AAC7B601136/"
    heroDetails.playmatUrl = "http://cloud-3.steamusercontent.com/ugc/1861691130254392007/F2A02FEBB38622779E23DE4B6DFF1B5BD98CD78B/"
  
    local extras = {}
  
    extras["InvocationDeck"] =
      {
        guid = "25db81",
        offset = {-4.94, 3, -4.66},
        locked = false
      }
  
    heroDetails["extras"] = extras
  
    return heroDetails
  end
