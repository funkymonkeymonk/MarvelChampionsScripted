local data = {}

function onload(saved_data)
    loadSavedData(saved_data)

    heroCount = getValue("heroCount", 0)

    if(heroCount == 0) then
        local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
        heroCount = heroManager.call("getHeroCount")
    
        setValue("heroCount", heroCount)
        setValue("lockValue", heroCount * 2)
        setValue("prisonerCount", 4)
    end
 
    setUpUI()
end

function loadSavedData(saved_data)
    if saved_data ~= "" then
       local loaded_data = JSON.decode(saved_data)
       data = loaded_data
    end
end
 
function setValue(key, value)
    data[key] = value
    local saved_data = JSON.encode(data)
    self.script_state = saved_data
end
 
function getValue(key, default)
    if data[key] == nil then
       return default
    end
 
    return data[key]
end

function setUpUI()
    local ui = 
    {
        {
            tag="Panel",
            attributes={            
                height="200",
                width="270",
                color="rgba(0,0,0,0)",
                position="0 0 -12",
                rotation="0 0 180"
            },
            children={
                {
                    tag="Text",
                    value="HOLDING CELL",
                    attributes={
                        fontSize="100",
                        scale="0.25 0.25",
                        width="1000",
                        height="120",
                        rectAlignment="UpperCenter",
                        offsetXY="0 -5",
                        color="rgb(1,1,1)"
                    }
                },
                {
                    tag="Text",
                    value="Prisoners: " .. getValue("prisonerCount", 4),
                    attributes={
                        id="prisonerCount",
                        fontSize="50",
                        scale="0.25 0.25",
                        width="400",
                        height="80",
                        offsetXY="0 10",
                        color="rgb(1,1,1)",
                        rectAlignment="LowerRight"
                    }
                },
                {
                    tag="Button",
                    text=getValue("lockValue", 0),
                    attributes={
                        id="lockButton",
                        image="https://steamusercontent-a.akamaihd.net/ugc/1470941757168316639/D0252AC3E40D9E1A76512D0F1F10E38C2D5EAFE6/",
                        rectAlignment="LowerLeft",
                        offsetXY="10 10",
                        onClick="lockCounterClicked",
                        textColor="rgb(1,1,1)",
                        scale="0.25 0.25",
                        height="80",
                        width="80",
                        fontSize="60",
                        fontStyle="Bold",
                        onMouseEnter="showTooltip",
                        onMouseExit="hideTooltip"
                    }
                },
                {
                    tag="Panel",
                    attributes={
                       id="lockButtonTooltip",
                       scale="0.25 0.25",
                       padding="20 20 10 10",
                       color="rgba(0,0,0,0.75)",
                       contentSizeFitter="both",
                       position="-115 -98 -5",
                       visibility="invisible"
                    },
                    children={
                       {
                          tag="Text",
                          value="Lock",
                          attributes={
                             fontSize="36",
                             color="rgb(1,1,1)",
                             alignment="MiddleLeft"
                          }
                       }
                    }
                },
                {
                    tag="Button",
                    value="RELEASE",
                    attributes={
                        id="releaseButton",
                        rectAlignment="LowerLeft",
                        offsetXY="35 10",
                        onClick="releasePrisoner",
                        textColor="rgb(1,1,1)",
                        color="rgb(0.3,0.6,1)",
                        scale="0.25 0.25",
                        height="80",
                        width="400",
                        fontSize="60",
                        fontStyle="Bold",
                        onMouseEnter="showTooltip",
                        onMouseExit="hideTooltip"
                    }
                },
                {
                    tag="Panel",
                    attributes={
                       id="releaseButtonTooltip",
                       scale="0.25 0.25",
                       padding="20 20 10 10",
                       color="rgba(0,0,0,0.75)",
                       contentSizeFitter="both",
                       position="-51 -98 -5",
                       visibility="invisible"
                    },
                    children={
                       {
                          tag="Text",
                          value="Free the prisoner!",
                          attributes={
                             fontSize="36",
                             color="rgb(1,1,1)",
                             alignment="MiddleLeft"
                          }
                       }
                    }
                }
            }
        }
    }
 
    self.UI.setXmlTable(ui)   
end

function lockCounterClicked(player, value, id)
    local rightClick = value == "-2"
    local lockValue = getValue("lockValue", 0)

    lockValue = rightClick and lockValue - 1 or lockValue + 1
    if lockValue < 0 then
        lockValue = 0
    end

    updateLockCounter(lockValue)
end

function updateLockCounter(newValue)
    setValue("lockValue", newValue)
 
    self.UI.setAttribute("lockButton", "text", newValue)
    self.UI.setAttribute("lockButton", "textColor", "rgb(1,1,1)")
end

function releasePrisoner(player, value, id)
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call("modokFreeHoldingCellPrisoner")
end

function showTooltip(player, value, id)
    local tooltipId = id .. "Tooltip"
    local playerColor = player.color
    local visibility = self.UI.getAttribute(tooltipId, "visibility")
 
    if string.find(visibility, playerColor) then return end
 
    self.UI.setAttribute(tooltipId, "visibility", visibility.."|"..playerColor)
end
 
function hideTooltip(player, value, id)
    local tooltipId = id .. "Tooltip"
    local playerColor = player.color
    local visibility = self.UI.getAttribute(tooltipId, "visibility")
 
    if not string.find(visibility, playerColor) then return end
 
    self.UI.setAttribute(tooltipId, "visibility", visibility:gsub("|"..playerColor, ""))
end

function getLockValue()
    return getValue("lockValue", 0)
end

function setLockValue(params)
    updateLockCounter(params.value)
end

function setPrisonerCount(params)
    local prisonerCount = params.value
    local text = "Prisoners: " .. prisonerCount
 
    self.UI.setAttribute("prisonerCount", "text", text)
    setValue("prisonerCount", prisonerCountY)
end
