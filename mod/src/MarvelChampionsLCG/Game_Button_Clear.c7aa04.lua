function onload(saved_data)
    self.interactable = false
    createClearButton()
end

function createClearButton()
    self.createButton({
      label = "CLEAR",
      click_function = "clearScenario",
      function_owner = self,
      position = {0,0.1,0},
      rotation = {0,0,0},
      width = 2080,
      height = 970,
      font_size = Global.getVar("SETUP_BUTTON_FONT_SIZE_ACTIVE"),
      color = {0,0,0,0},
      font_color = {1,1,1,100}
    })
end

function clearScenario()
  local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
   layoutManager.call("clearScenario")
   --asyncTest()
end

function showTile()
  createClearButton()
end

function hideTile()
  self.clearButtons()
end


function asyncTest()
  log("about to call other function")
  otherFunction()
  log("returned from other function")
end

function otherFunction()
  log("other function started")
  local done = nil

  function pauseCoroutine()
    for i=1, 500 do
      coroutine.yield(0)
    end
    log("coroutine done")
    done = true
    return 1
  end

  startLuaCoroutine(self, "pauseCoroutine")
  
  Wait.condition(
    function() log("pause loop completed") end,
    function() return done ~= nil end,
    10,
    function() log("timeout") end
  )
end