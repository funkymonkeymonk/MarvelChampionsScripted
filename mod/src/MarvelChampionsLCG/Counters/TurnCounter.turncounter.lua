local TEXT_COLOR = "rgb(0,0,0)"
local UI_HEIGHT = "350"
local UI_WIDTH = "350"
local UI_POSITION = "90 0 -12"
local BUTTON_HEIGHT = "180"
local BUTTON_WIDTH = "200"
local BUTTON_FONT_SIZE = "150"

require('!/components/counter')

--These are here simply for convenience (so that the layout manager can use the showTile and hideTile functions on the turn counter).
--Could create and destroy the button here, if necessary.
function showTile()
end
function hideTile()
end