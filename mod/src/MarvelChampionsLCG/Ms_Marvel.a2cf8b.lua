        function placeHeroWithStarterDeck(obj, player_color)
            local heroPlacer = getObjectFromGUID(Global.getVar("HERO_PLACER_GUID"))
            heroPlacer.call("placeHeroWithStarterDeck", {heroBagGuid="7cdb6a", playerColor=player_color})
        end
        function placeHeroWithHeroDeck(obj, player_color)
            local heroPlacer = getObjectFromGUID(Global.getVar("HERO_PLACER_GUID"))
            heroPlacer.call("placeHeroWithHeroDeck", {heroBagGuid="7cdb6a", playerColor=player_color})
        end    
    
