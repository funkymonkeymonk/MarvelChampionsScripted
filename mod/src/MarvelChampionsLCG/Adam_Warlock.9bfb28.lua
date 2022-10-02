        function placeHeroWithStarterDeck(obj, player_color)
            local heroPlacer = getObjectFromGUID(Global.getVar("HERO_PLACER_GUID"))
            heroPlacer.call("placeHeroWithStarterDeck", {heroBagGuid="93353d", playerColor=player_color})
        end
        function placeHeroWithHeroDeck(obj, player_color)
            local heroPlacer = getObjectFromGUID(Global.getVar("HERO_PLACER_GUID"))
            heroPlacer.call("placeHeroWithHeroDeck", {heroBagGuid="93353d", playerColor=player_color})
        end    
    
