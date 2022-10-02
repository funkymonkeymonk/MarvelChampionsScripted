        function placeHeroWithStarterDeck(obj, player_color)
            local heroPlacer = getObjectFromGUID(Global.getVar("HERO_PLACER_GUID"))
            heroPlacer.call("placeHeroWithStarterDeck", {heroBagGuid="c8c4d3", playerColor=player_color})
        end
        function placeHeroWithHeroDeck(obj, player_color)
            local heroPlacer = getObjectFromGUID(Global.getVar("HERO_PLACER_GUID"))
            heroPlacer.call("placeHeroWithHeroDeck", {heroBagGuid="c8c4d3", playerColor=player_color})
        end    
    
