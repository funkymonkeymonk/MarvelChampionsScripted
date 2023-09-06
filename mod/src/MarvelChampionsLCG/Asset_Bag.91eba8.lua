function onLoad()
    local blockComp = self.getComponent("AudioSource")
    blockComp.set("mute", true)
end

function spawnAsset(params)
    self.takeObject({
        guid = params.guid,
        callback_function = function(spawnedObject)
            Wait.frames(function()
                clone=spawnedObject.clone({position=params.position, rotation=params.rotation})
                self.putObject(spawnedObject)
                params.spawnedObject=clone
                params.caller.call(params.callback, params)
            end)
        end,
        smooth = false
    })    
end
