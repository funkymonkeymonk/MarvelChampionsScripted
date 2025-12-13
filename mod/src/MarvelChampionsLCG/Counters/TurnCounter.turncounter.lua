local TEXT_COLOR = "rgb(0,0,0)"
local UI_HEIGHT = "350"
local UI_WIDTH = "350"
local UI_POSITION = "90 0 -12"
local BUTTON_HEIGHT = "180"
local BUTTON_WIDTH = "200"
local BUTTON_FONT_SIZE = "150"

require('!/components/counter')

function showTile()
	local currentPos = self.getPosition()

  	self.setPosition({x = currentPos.x, y = 0.5, z = currentPos.z})

	setUpUI()
end

function hideTile()
	local currentPos = self.getPosition()

  	self.setPosition({x = currentPos.x, y = -2, z = currentPos.z})

	self.UI.setXml("")
end