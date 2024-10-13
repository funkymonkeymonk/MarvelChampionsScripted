preventDeletion = true

local layoutManager = getObjectFromGUID(Global.getVar("GUID_LAYOUT_MANAGER"))
local buttons = {}
local heroes = {}

function onload(saved_data)
    self.interactable = false
end

function createButtons(params)
    self.clearButtons()

    heroes = params.selectedHeroes
    local red = Global.getTable("MESSAGE_TINT_RED")
    local blue = Global.getTable("MESSAGE_TINT_BLUE")
    local green = Global.getTable("MESSAGE_TINT_GREEN")
    local yellow = Global.getTable("MESSAGE_TINT_YELLOW")

    red[4] = 100
    blue[4] = 100
    green[4] = 100
    yellow[4] = 100

    local fontColors = {
        Red = red,
        Blue = blue,
        Green = green,
        Yellow = yellow
    }

    buttons = {
        Random = {index = 1, label = "RANDOM"}
    }

    local heroCount = 0

    for _, hero in pairs(heroes) do
        heroCount = heroCount + 1
    end

    local colors = {"Red", "Blue", "Green", "Yellow"}

    self.createButton({
        label = "FIRST PLAYER",
        click_function = "null",
        function_owner = self,
        position = {0,0.1,0},
        rotation = {0,0,0},
        width = 0,
        height = 0,
        font_size = 500,
        color = {0,0,0,0},
        font_color = {1,1,1,100}
    })

    self.createButton({
        label = "RANDOM",
        click_function = "setFirstPlayerRandom",
        function_owner = self,
        position = {0,0.10,2},
        rotation = {0,0,0},
        width = 2000,
        height = 500,
        font_size = 450,
        color = {0,0,0,0},
        font_color = {1,1,1,100}
    })

    -- self.createButton({
    --     label = "",
    --     click_function = "setFirstPlayerRandom",
    --     function_owner = self,
    --     position = {2,0.10,2},
    --     rotation = {0,0,0},
    --     width = 0,
    --     height = 0,
    --     font_size = 450,
    --     color = {0,0,0,0},
    --     font_color = {1,1,1,100}
    -- })

    local heroNumber = 0
    local buttonNumber = 2
    local zOrigin = 3.25

    for i, color in ipairs(colors) do
        local heroName = heroes[color]

        if heroName then
            local functionName = "setFirstPlayer" .. color
            local z = zOrigin + (heroNumber * 1)

            buttons[color] = {index = buttonNumber, label = heroName}

            heroNumber = heroNumber + 1
            buttonNumber = buttonNumber + 1

            self.createButton({
                label = heroName,
                click_function = functionName,
                function_owner = self,
                position = {0,0.10,z},
                rotation = {0,0,0},
                width = 2300,
                height = 450,
                font_size = 400,
                color = {0,0,0,0},
                font_color = fontColors[color]
            })

            -- self.createButton({
            --     label = "",
            --     click_function = functionName,
            --     function_owner = self,
            --     position = {2,0.10,z},
            --     rotation = {0,0,0},
            --     width = 0,
            --     height = 0,
            --     font_size = 400,
            --     color = {0,0,0,0},
            --     font_color = fontColors[color]
            -- })
        end
    end
end

function setFirstPlayerRandom()
    layoutManager.call("setFirstPlayer", {firstPlayer = nil})
end

function setFirstPlayerRed()
    layoutManager.call("setFirstPlayer", {firstPlayer = "Red"})
end

function setFirstPlayerBlue()
    layoutManager.call("setFirstPlayer", {firstPlayer = "Blue"})
end

function setFirstPlayerGreen()
    layoutManager.call("setFirstPlayer", {firstPlayer = "Green"})
end

function setFirstPlayerYellow()
    layoutManager.call("setFirstPlayer", {firstPlayer = "Yellow"})
end

function hideTile()
    self.clearButtons()
    self.highlightOff()
end

function showTile(params)
    createButtons(params)
end

function showSelection(params)
    local selection = params.firstPlayer
    local x = " " .. string.char(10008)

    for playerChoice, button in pairs(buttons) do
        local selectionLabel = playerChoice == selection and x or ""
        self.editButton({index = button.index, label = button.label .. selectionLabel})
    end
end
