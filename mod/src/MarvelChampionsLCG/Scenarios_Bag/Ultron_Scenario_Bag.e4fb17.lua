function getScenarioDetails()
    return {
        selectorImageUrl= "http://cloud-3.steamusercontent.com/ugc/1849305905150147610/D43024CA72F4372B28AF86672D67286730C6CE72/",
        mainScheme= {
            deckGuid= "66824a",
            stages= {
                [1]= {
                    threatBase= 0,
                    threatMultiplier= 0
                }
            }
        },
        villains= {
            rhino= {
                name= "Ultron",
                hpMultiplier= 17,
                hpCounter= {
                    imageUrl= "http://cloud-3.steamusercontent.com/ugc/1849305905150147610/D43024CA72F4372B28AF86672D67286730C6CE72/"
                },
                villainDeck= {
                    guid= "5ea1bb"
                },
                encounterDeck= {
                    guid= "f160ac"
                }
            }
        },
        extras= {
            ultronDronesEnvironment = {
                guid="559246",
                position={13.75, 0.97, 29.25},
                name="Ultron Drones",
                description="",
                locked=true
            },
            droneTokens = {
                guid="542878",
                position={18.25, 1.06, 31.25},
                name="Drone Tokens",
                description="",
                locked=true
            },
            upgradedDroneTokens = {
                guid="7ca97a",
                position={18.25, 1.06, 27.75},
                name="Upgraded Drone Tokens",
                description="",
                locked=true
            }
        }
    }
end
