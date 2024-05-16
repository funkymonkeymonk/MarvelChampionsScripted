local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))

function onload(saved_data)
  --self.interactable = false

  self.createButton({
      label = "ADD\r\nENCOUNTER\r\nSET",
      click_function = "addEncounterSet",
      function_owner = self,
      position = {0,0.1,0.5},
      rotation = {0,0,0},
      width = 500,
      height = 300,
      font_size = 80,
      color = {0,0,0,0},
      font_color = {1,1,1,100}
    })

    self.createButton({
      label = "7 SETS REMAINING",
      click_function = "null",
      function_owner = self,
      position = {0,0.1,0.9},
      rotation = {0,0,0},
      width = 0,
      height = 0,
      font_size = 70,
      color = {0,0,0,0},
      font_color = {1,1,1,100}
    })
end

function addEncounterSet()
  local remainingSets = scenarioManager.call("addHoodEncounterSet")
  self.editButton({index=1, label = remainingSets.." SETS REMAINING"})
end
