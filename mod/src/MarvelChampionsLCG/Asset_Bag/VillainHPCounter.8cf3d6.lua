local TEXT_COLOR = "rgb(0,0,0)"
local UI_HEIGHT = "350"
local UI_WIDTH = "350"
local UI_POSITION = "0 50 -12"
local BUTTON_OFFSET = "85 70"
local BUTTON_HEIGHT = "110"
local BUTTON_WIDTH = "190"
local BUTTON_FONT_SIZE = "95"

require('!/components/counter')

function extendUI(params)
    local ui = params.ui
    local primaryButtonLabel = getDataValue("primaryButtonLabel", "ADVANCE")
    local showPrimaryButton = tostring(getDataValue("showPrimaryButton", false))

    local primaryButton = 
    {
        tag = "Button",
        value = primaryButtonLabel,
        attributes = {
            id = "primaryButton",
            rectAlignment = "MiddleCenter",
            offsetXY = "0 230",
            onClick = "primaryButtonClicked",
            color = "rgba(0,0,0,0)",
            textColor = "rgb(1,1,1)",
            height = "120",
            width = "475",
            fontSize = "85",
            fontStyle = "Bold",
            active = showPrimaryButton
        }
    }

    table.insert(ui[1].children, primaryButton)

    local secondaryButtonLabel = getDataValue("secondaryButtonLabel", "")
    local showSecondaryButton = tostring(getDataValue("showSecondaryButton", false))

    local secondaryButton = 
    {
        tag = "Button",
        value = secondaryButtonLabel,
        attributes = {
            id = "secondaryButton",
            rectAlignment = "MiddleCenter",
            offsetXY = "90 -20",
            onClick = "secondaryButtonClicked",
            color = "rgba(0,0,0,0)",
            textColor = "rgb(1,1,1)",
            height = "55",
            width = "190",
            fontSize = "35",
            fontStyle = "Bold",
            active = showSecondaryButton
        }
    }

    table.insert(ui[1].children, secondaryButton)

    return ui
end

function afterLoad()
    if(getDataValue("showHighlight", false)) then
        self.highlightOn(getDataValue("highlightColor", {1,1,1}))
    end
end


function getVillainKey()
    return getDataValue("villainKey", nil)
end

function setVillainKey(params)
    setDataValue("villainKey", params.villainKey)
end

function setPrimaryButtonOptions(params)
    setDataValue("primaryButtonLabel", params.label)
    setDataValue("primaryButtonFunction", params.clickFunction)
    setDataValue("primaryButtonParams", params.params)
end

function setSecondaryButtonOptions(params)
    setDataValue("secondaryButtonLabel", params.label)
    setDataValue("secondaryButtonFunction", params.clickFunction)
    setDataValue("secondaryButtonParams", params.params)
end

function primaryButtonClicked()
    local functionName = getDataValue("primaryButtonFunction", "advanceVillain")
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call(functionName, {
        villainKey = getVillainKey()
    })
end

function secondaryButtonClicked()
    local functionName = getDataValue("secondaryButtonFunction", "")
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call(functionName, {
        villainKey = getVillainKey()
    })
end

function showPrimaryButton()
    if(getDataValue("showPrimaryButton", false)) then return end
    setDataValue("showPrimaryButton", true)

    self.UI.setAttribute("primaryButton", "text", getDataValue("primaryButtonLabel", "ADVANCE"))
    self.UI.setAttribute("primaryButton", "textColor", "rgb(1,1,1)")
    self.UI.show("primaryButton")
end

function hidePrimaryButton()
    if(not getDataValue("showPrimaryButton", false)) then return end
    setDataValue("showPrimaryButton", false)

    self.UI.hide("primaryButton")
end

function showSecondaryButton()
    if(getDataValue("showSecondaryButton", false)) then return end
    setDataValue("showSecondaryButton", true)

    self.UI.setAttribute("secondaryButton", "text", getDataValue("secondaryButtonLabel", "(not set)"))
    self.UI.setAttribute("secondaryButton", "textColor", "rgb(1,1,1)")
    self.UI.show("secondaryButton")
end

function hideSecondaryButton()
    if(not getDataValue("showSecondaryButton", false)) then return end
    setDataValue("showSecondaryButton", false)

    self.UI.hide("secondaryButton")
end

function showHighlight(params)
    local highlightColor = params.highlightColor or {1,1,1}
    setDataValue("highlightColor", highlightColor)
    setDataValue("showHighlight", true)

    self.highlightOn(highlightColor)
end

function hideHighlight()
    setDataValue("showHighlight", false)

    self.highlightOff()
end
