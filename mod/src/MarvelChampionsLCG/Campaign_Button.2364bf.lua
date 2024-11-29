local setupImageUrl = "https://steamusercontent-a.akamaihd.net/ugc/6288106005913802/4B4674B9920B438A0862A7192D8994C9380696C8/"
local deleteImageUrl = "https://steamusercontent-a.akamaihd.net/ugc/6288106005913785/A88BA7F63A6236203A779C5E792BC6D97C9185C7/"

function onload(saved_data)
    self.interactable = false

    local campaignManager = getCampaignManager()
    local campaignPlaced = campaignManager.call("getCampaignPlaced")
    local imageUrl = campaignPlaced and deleteImageUrl or setupImageUrl
    local currentImageUrl = self.getCustomObject().image

    if(currentImageUrl ~= imageUrl) then
        self.setCustomObject({image = imageUrl})
        self.reload()
    end

    createButton(campaignPlaced)
end

function getCampaignManager()
    return getObjectFromGUID(Global.getVar("GUID_CAMPAIN_MANAGER"))
end

function createButton(campaignPlaced)
    if(campaignPlaced) then
        self.createButton({
            label = "CLEAR CAMPAIGN",
            click_function = "clearCampaign",
            function_owner = self,
            position = {0,0.1,0},
            rotation = {0,0,0},
            width = 3800,
            height = 600,
            font_size = Global.getVar("SETUP_BUTTON_FONT_SIZE_ACTIVE"),
            color = {0,0,0,0},
            font_color = {1,1,1,100}
          })         
    else
        self.createButton({
            label = "SET UP CAMPAIGN",
            click_function = "displayCampaignUI",
            function_owner = self,
            position = {0,0.1,0},
            rotation = {0,0,0},
            width = 3800,
            height = 600,
            font_size = Global.getVar("SETUP_BUTTON_FONT_SIZE_ACTIVE"),
            color = {0,0,0,0},
            font_color = {1,1,1,100}
          }) 
    end
end

function displayCampaignUI()
    local campaignManager = getCampaignManager()
    local campaigns = campaignManager.call("getCampaigns")
    local campaignButtons = {}

    for i, campaign in ipairs(campaigns) do
        local functionName = "placeCampaign-" .. i

        _G[functionName] = function()
            placeCampaign(i)
        end

        local campaignButton = {
            tag="Panel",
            children={
                {
                    tag="Image",
                    attributes={
                        image=campaign.thumbnailUrl,
                        raycastTarget="true",
                        width="200",
                        height="200"
                    }
                },
                {
                    tag="Button",
                    attributes={
                        onClick=self.getGUID() .. "/" .. functionName,
                        height="200",
                        width="200",
                        fontSize="25",
                        textColor="rgba(0,0,0,1)",
                        color="rgba(0,0,0,0)"
                    }
                }
            }
        }
        table.insert(campaignButtons, campaignButton)
    end

    local buttonWidth = 200
    local buttonHeight = 200
    local buttonSpacing = 10
    local campaignGridHeight = math.ceil(#campaignButtons / 3) * (buttonHeight + buttonSpacing) - buttonSpacing

    local campaignUI = 
    {
        {
            tag="Panel",
            attributes={
                height="575",
                width="635",
                color="rgb(0,0,0)"
            },
            children={
                {
                    tag="Panel",
                    attributes={
                        height="75",
                        rectAlignment="UpperCenter"
                    },
                    children={
                        {
                            tag="Text",
                            value="CAMPAIGN SETUP",
                            attributes={
                                alignment="MiddleLeft",
                                fontSize="40",
                                color="rgb(1,1,1)",
                                offsetXY="20 0"
                            }
                        },
                        {
                            tag="Button",
                            value="X",
                            attributes={
                                rectAlignment="UpperRight",
                                onClick=self.getGUID() .. "/cancel",
                                textColor="rgba(255,0,0,1)",
                                color="rgba(0,0,0,0)",
                                fontSize="30",
                                height="40",
                                width="40",
                                offsetXY="-5 -5"
                            }
                        }
                    }
                },
                {
                    tag="Panel",
                    attributes={
                        height="500",
                        rectAlignment="LowerCenter"
                    },
                    children={
                        {
                            tag="VerticalScrollView",
                            attributes={
                                height="500",
                                width="635",
                                rectAlignment="UpperCenter",
                                verticalScrollbarVisibility="AutoHideAndExpandView",                                        
                                horizontalScrollbarVisibility="AutoHideAndExpandViewport",
                                scrollSensitivity="75",
                                raycastTarget = "true"
                            },
                            children={
                                {
                                    tag="GridLayout",
                                    attributes={
                                        width="610",
                                        height=tostring(campaignGridHeight),
                                        spacing=buttonSpacing .. " " .. buttonSpacing,
                                        cellSize=buttonWidth .. " " .. buttonHeight,
                                        constraint="FixedColumnCount",
                                        constraintCount="3"
                                    },
                                    children=campaignButtons
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Global.UI.setXmlTable(campaignUI)    
end

function placeCampaign(campaignId)
    local campaignManager = getCampaignManager()
    campaignManager.call("placeCampaign", {campaignId = campaignId})
    Global.UI.setXml("")
    self.reload()
end

function clearCampaign()
    local campaignManager = getCampaignManager()
    campaignManager.call("clearCampaign")
    self.reload()
end

function cancel()
    Global.UI.setXml("")
end
