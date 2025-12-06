local TEXT_COLOR = "rgb(0,0,0)"
local UI_HEIGHT = "350"
local UI_WIDTH = "350"
local UI_POSITION = "0 50 -10"
local BUTTON_HEIGHT = "180"
local BUTTON_WIDTH = "200"
local BUTTON_FONT_SIZE = "160"

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
            offsetXY = "0 280",
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

    return ui
end

function getSchemeKey()
    return getDataValue("schemeKey", nil)
end

function setSchemeKey(params)
    setDataValue("schemeKey", params.schemeKey)
end

function setTargetValue(params)
    setDataValue("targetValue", params.value)
    valueUpdated()
end

function setPrimaryButtonOptions(params)
    setDataValue("primaryButtonLabel", params.label)
    setDataValue("primaryButtonFunction", params.clickFunction)
    setDataValue("primaryButtonParams", params.params)
end

function primaryButtonClicked()
    local functionName = getDataValue("primaryButtonFunction", "advanceScheme")
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call(functionName, {
        schemeKey = getSchemeKey()
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

function valueUpdated()
    local currentValue = getValue()
    local targetValue = getDataValue("targetValue", 0)

    if (targetValue == 0 or currentValue < (targetValue / 2)) then
        self.highlightOff()
        return
    end
    
    local percentage = (currentValue - (targetValue / 2)) / (targetValue / 2)
    
    percentage = math.max(0, math.min(1, percentage))

    local red = 1
    local green = 1 - percentage 
    local blue = 0
    
    self.highlightOn({red, green, blue})
end