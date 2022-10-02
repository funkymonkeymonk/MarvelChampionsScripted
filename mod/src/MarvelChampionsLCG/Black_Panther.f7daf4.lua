        function placeHeroWithStarterDeck(obj, player_color)
            local heroPlacer = getObjectFromGUID(Global.getVar("HERO_PLACER_GUID"))
            heroPlacer.call("placeHeroWithStarterDeck", {heroBagGuid="b72fe1", playerColor=player_color})
        end
        function placeHeroWithHeroDeck(obj, player_color)
            local heroPlacer = getObjectFromGUID(Global.getVar("HERO_PLACER_GUID"))
            heroPlacer.call("placeHeroWithHeroDeck", {heroBagGuid="b72fe1", playerColor=player_color})
        end    
    
