local playerColor = ""

function onload(saved_data)
   if saved_data ~= "" then
      local loaded_data = JSON.decode(saved_data)
      playerColor = loaded_data.playerColor
   end

   setUpUI()
end

function setPlayerColor(params)
   playerColor = params.playerColor
	local data = {
		playerColor = playerColor
   }
	local saved_data = JSON.encode(data)
	self.script_state = saved_data
end

function setUpUI()
   local ui = 
   {
      {
         tag="Panel",
         attributes={
            height="400",
            width="400",
            color="rgba(0,0,0,0)",
            position="0 0 -12",
            rotation="0 0 180"
         },
         children={
            {
               tag="Button",
               value="Spawn\nDrone",
               attributes={
                  rectAlignment="MiddleCenter",
                  offsetXY="30 0",
                  onClick= "droneButtonClicked",
                  textColor="rgb(1,1,1)",
                  color="rgba(0,0,0,0)",
                  scale="0.25 0.25",
                  height="800",
                  width="800",
                  fontSize="200",
                  fontStyle="Bold"
               }
			}
		}
	}
   }

   self.UI.setXmlTable(ui)
end

function droneButtonClicked(player, value, id)
   local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
   scenarioManager.call("ultronDiscardPlayerCardsAsDrones", {playerColor = playerColor})
end