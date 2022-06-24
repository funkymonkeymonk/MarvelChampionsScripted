function onLoad()
    self.createButton({
        click_function="click_clopen", function_owner=self,
        position={0,0.5,0}, height=500, width=500, color={0,0,0,0}
    })
    params = {assetbundle="http://chry.me/up/new_blackhole4.unity3d",material=2}
end

function click_clopen()
    if self.AssetBundle.getLoopingEffectIndex() == 0 then
        params.type = 6
        self.AssetBundle.playLoopingEffect(1)
    else
        params.type = 0
        self.AssetBundle.playLoopingEffect(0)
    end
    self.setCustomObject(params)
    self.reload()
end




