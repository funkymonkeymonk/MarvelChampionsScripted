local TEXT_COLOR = "{1,1,1}"
local data = {}

function onload(saved_data)
    loadSavedData(saved_data)
 
    setUpUI()
end

function loadSavedData(saved_data)
    if saved_data ~= "" then
       local loaded_data = JSON.decode(saved_data)
       data = loaded_data
    end
end
 
function setDataValue(key, value)
    data[key] = value
    local saved_data = JSON.encode(data)
    self.script_state = saved_data
end
 
function getDataValue(key, default)
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
                height="350",
                width="350",
                position="20 25 -10",
                rotation="0 0 180"
            },
            children={
                {
                    tag="Button",
                    value="+" .. getDataValue("value", 0),
                    attributes={
                        id="valueButton",
                        rectAlignment="MiddleCenter ",
                        onClick="buttonClicked",
                        color="rgba(0,0,0,0)",
                        textColor=TEXT_COLOR,
                        scale="0.45 0.45",
                        height="600",
                        width="650",
                        fontSize="5000",
                        fontStyle="Bold"
                    }
                }
            }
        }
    }

    self.UI.setXmlTable(ui) 
end

function buttonClicked(player, value, id)
    local rightClick = value == "-2"
    local value = getDataValue("value", 0)

    value = rightClick and value - 1 or value + 1
    if value < 0 then
        value = 0
    end

    updateValue(value)
end

function updateValue(value)
    setDataValue("value", value)
 
    self.UI.setAttribute("valueButton", "text", "+" .. value)
    self.UI.setAttribute("valueButton", "textColor", TEXT_COLOR)
end

function getValue()
    return getDataValue("value", 0)
end

function setValue(params)
    local value = params.value
    updateValue(value)
end

function addToValue(params)
    local valueToAdd = params.valueToAdd
    local currentValue = getDataValue("value", 0)
    setValue({
        value = currentValue + valueToAdd
    })
end
