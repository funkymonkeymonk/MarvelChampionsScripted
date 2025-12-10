local baseImageUrl = Global.getVar("CDN_URL") .. "/tabletops/"

function onload()
	self.interactable = false
	setUpUI()
end

function setUpUI()
	local ui = 
    {
        {
            tag="Panel",
            attributes= {
                height = "100",
                width = "300",
                position = "0 0 -200",
				color = "rgba(0,0,0,0)",
                rotation = "0 0 180"
            },
            children = {
                {
                    tag = "Button",
                    value = "CHANGE TABLE",
                    attributes = {
                        rectAlignment = "MiddleCenter",
                        onClick = "changeTableButtonClicked",
                        color = "rgba(0,0,0,0)",
                        textColor = "rgb(1,1,1)",
                        height = "160",
                        width = "1000",
                        fontSize = "120",
                        fontStyle = "Bold"
                    }
                }
            }
        }
    }

    self.UI.setXmlTable(ui) 
end

function changeTableButtonClicked(player, value, id)
	local guid = self.getGUID()
    local scenarioUI = {
		{
        	tag = "Defaults",
			children = {
				{
					tag = "Panel",
					attributes = {
						class = "tableButton",
						preferredHeight = "75",
						flexibleHeight = "0",
						color = "rgba(0,0,1,1)",
						textColor = "rgb(1,1,1)",
						fontSize = "60",
						fontStyle = "Bold"
					}
				},
				{
					tag = "Image",
					attrubutes = {
						class = "tableImage",
						width = "300",
						height = "190"
					}
				}
			}
		},
		{
			tag = "Panel",
			attributes = {
				width = "630",
				height = "810",
				color = "rgba(0,0,0,1)",
				contentSizeFitter = "vertical"
			},
			children = {
				{
					tag="GridLayout",
					attributes = {
						width = "630",
						height = "810",
						padding = "10 10 10 10",
						childForceExpandHeight = "false",
						spacing = "10 10",
						cellSize = "300 190",
						startAxis = "Vertical",
						Constraint = "FixedRowCount",
						ConstraintCount = "4",
						color = "rgba(0,0,0,1)"
					},
					children = {
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-marvel-black",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-marvel-black.png"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-marvel-blue",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-marvel-blue.png"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-marvel-yellow",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-marvel-yellow.png"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-classic",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-classic.png"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-felt-black",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-felt-black.png"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-felt-blue",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-felt-blue.png"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-felt-green",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-felt-green.png"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-felt-red",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-felt-red.png"
									}
								}
							}
						}
					}
				}
			}
		}
	}

    Global.UI.setXmlTable(scenarioUI)
end

function setTableImage(player, value, id)
	Global.UI.setXml("")
	local currentCover = Global.call("findObjectByTag", {tag="table-cover"})
	local tableUrl = baseImageUrl .. id .. ".png"

	local tableJson = [[
		{
			"Name": "Custom_Tile",
			"Transform": {
				"posX": 0.0,
				"posY": -2,
				"posZ": 0.0,
				"rotX": 0.0,
				"rotY": 180.0,
				"rotZ": 0.0,
				"scaleX": 28.0,
				"scaleY": 1.0,
				"scaleZ": 28.0
			},
			"Nickname": "",
			"Description": "",
			"GMNotes": "",
			"ColorDiffuse": {
				"r": 1.0,
				"g": 1.0,
				"b": 1.0
			},
			"Locked": true,
			"Grid": true,
			"Snap": true,
			"IgnoreFoW": false,
			"Autoraise": true,
			"Sticky": true,
			"Tooltip": true,
			"GridProjection": false,
			"HideWhenFaceDown": false,
			"Hands": false,
			"XmlUI": "",
			"Tags": [
				"table-cover"
			],
			"CustomImage": {
				"ImageURL": "]] .. tableUrl .. [[",
				"ImageSecondaryURL": "",
				"ImageScalar": 1,
				"WidthScale": 0,
				"CustomTile": {
					"Type": 0,
					"Thickness": 0.1,
					"Stackable": false,
					"Stretch": true
				}
			},
			"LuaScript": "function onload() self.interactable = false end",
			"LuaScriptState": "",
			"GUID": "tablecover"
		}]]

	spawnObjectJSON({
		json = tableJson,
		callback_function = function(spawned_object)
			Wait.frames(function()
				spawned_object.setPosition({0, 0.85, 0})
				if currentCover ~= nil then
					currentCover.destroy()
				end
			end,
			30)
		end
	})
end