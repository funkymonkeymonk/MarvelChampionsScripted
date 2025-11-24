local logData = {
    reputation = 0
}

function onload(saved_data)
    loadSavedData(saved_data)
    setUpUI()
end

function loadSavedData(saved_data)
    if saved_data ~= "" then
        logData = JSON.decode(saved_data)
    end
end

function saveData()
    local saved_data = JSON.encode(logData)
    self.script_state = saved_data
end

function setUpUI()
    local checkboxes = {}
    local yOrigin = 140.75
    local ySpacing = 10.53

    local yTopRow = -120.65
    local yBottomRow = -127
    local xOriginLeft = -26.4
    local xOriginRight = 4.3
    local xSpacing = 5.525

    for i = 1, 25 do
        local yPos = yOrigin - ((i - 1) * ySpacing)
        local formattedIndex = string.format("%02d", i)
        table.insert(checkboxes, {
            tag = "ToggleButton",
            attributes = {
                id = "reputation" .. formattedIndex,
                class = "reputationToggle",
                offsetXY = "0 " .. yPos
            }
        })
    end

    for i = 26, 30 do
        local xPos = xOriginLeft + ((i - 26) * xSpacing)
        local formattedIndex = string.format("%02d", i)
        table.insert(checkboxes, {
            tag = "ToggleButton",
            attributes = {
                id = "reputation" .. formattedIndex,
                class = "reputationToggle",
                scale = "0.1 0.1",
                offsetXY = xPos .. " " .. yTopRow
            }
        })
    end

    for i = 31, 35 do
        local xPos = xOriginRight + ((i - 31) * xSpacing)
        local formattedIndex = string.format("%02d", i)
        table.insert(checkboxes, {
            tag = "ToggleButton",
            attributes = {
                id = "reputation" .. formattedIndex,
                class = "reputationToggle",
                scale = "0.1 0.1",
                offsetXY = xPos .. " " .. yTopRow
            }
        })
    end

    for i = 36, 40 do
        local xPos = xOriginLeft + ((i - 36) * xSpacing)
        local formattedIndex = string.format("%02d", i)
        table.insert(checkboxes, {
            tag = "ToggleButton",
            attributes = {
                id = "reputation" .. formattedIndex,
                class = "reputationToggle",
                scale = "0.1 0.1",
                offsetXY = xPos .. " " .. yBottomRow
            }
        })
    end

    for i = 41, 45 do
        local xPos = xOriginRight + ((i - 41) * xSpacing)
        local formattedIndex = string.format("%02d", i)
        table.insert(checkboxes, {
            tag = "ToggleButton",
            attributes = {
                id = "reputation" .. formattedIndex,
                class = "reputationToggle",
                scale = "0.1 0.1",
                offsetXY = xPos .. " " .. yBottomRow
            }
        })
    end

    self.UI.setCustomAssets({{
        name = "webIcon",
        url = "https://steamusercontent-a.akamaihd.net/ugc/9718404581222949567/0DE829FA7D7E9AC666EB3889336E686D89656B6A/"
    }, {
        name = "blankIcon",
        url = "https://steamusercontent-a.akamaihd.net/ugc/14444398757922775072/ED62CA31E47C706AB71C5AEC37371E59ABA932EA/"
    }})

    local ui = {{
        tag = "Defaults",
        children = {{
            tag = "ToggleButton",
            class = "reputationToggle",
            attributes = {
                width = "35",
                height = "35",
                scale = "0.25 0.25",
                colors = "rgba(1,1,1,0)|rgba(1,1,1,0)|rgba(1,1,1,0)|rgba(1,1,1,0)",
                selectedBackgroundColor = "rgba(1,1,1,0)",
                deselectedBackgroundColor = "rgba(1,1,1,0)",
                iconWidth = "35",
                icon = "blankIcon",
                selectedIcon = "webIcon",
                padding = "0 0 0 0",
                onValueChanged = "toggleValueChanged"
            }
        }}
    }, {
        tag = "Panel",
        attributes = {
            height = "370",
            width = "370",
            color = "rgba(0,0,0,0)",
            position = "0 0 -6",
            rotation = "0 0 180"
        },
        children = checkboxes
    }}

    self.UI.setXmlTable(ui)

    Wait.frames(function()
        updateReputationToggles(logData.reputation)
    end, 30)
end

function toggleValueChanged(player, value, id)
    local boolValue = (value == "True")
    local reputation = tonumber(string.sub(id, -2))

    if (reputation == logData.reputation) then
        reputation = reputation - 1
    end

    updateReputationToggles(reputation)

    logData.reputation = reputation

    saveData()
end

function updateReputationToggles(reputationValue)
    for i = 1, 45 do
        local toggleId = "reputation" .. string.format("%02d", i)
        self.UI.setAttribute(toggleId, "isOn", tostring(reputationValue >= i))
    end
end
