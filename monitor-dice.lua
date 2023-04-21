isMonitoring = false

function onObjectRandomize(object, color)
    if isMonitoring == true then return end
    isMonitoring = true
    waitMonitor(color)
end

function waitMonitor(color)
    Wait.time(function() monitorDice(color) end, .2)
end

function monitorDice(color)
    local allDice = getObjectsWithAllTags({'Die'});
    local dice = {};
    
    for _, d in ipairs(allDice) do
        if d.resting == false then        
            table.insert(dice, d)
        end
    end

    function coroutine_monitorDice()
        repeat
            local allRest = true
            for _, die in ipairs(dice) do
                if die ~= nil and die.resting == false then
                    allRest = false
                end
            end
            coroutine.yield(0)
        until allRest == true 

        local message = getDiceResultMessage(dice)

        if (message ~= '') then
            printToAll(color .. ' player ' .. message, stringColorToRGB(color))
        end
        isMonitoring = false
        return 1
    end
    startLuaCoroutine(self, "coroutine_monitorDice")
end

function getDiceResultMessage(dice)
    local message = 'dice results: '
    local count = 0
    for index, die in ipairs(dice) do
        if (die.tag == 'Dice') then
            count = count + 1
            if index > 1 then message = message .. ', ' end
            message = message .. die.getRotationValue()
        end
    end
    if count > 0 then return message end
    return ''
end