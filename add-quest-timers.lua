function onLoad()
    self.createButton({
        click_function = "addQuestTimers", 
        function_owner = self,
        label          = "Add Quest Timers",
        position       = {0,0,0},
        rotation       = {0,180,0},
        width          = 950,
        height         = 200,
        font_size      = 100,
        color          = {0, 0, 0},
        font_color     = {1, 1, 1},
    })
end
function addQuestTimers()
    local zone = getObjectsWithAllTags({'Zone', 'Board', 'Quest'})[1]
    local bag = getObjectsWithAllTags({'Bag', 'Time'})[1]
    local cards = zone.getObjects()
    for _, card in ipairs(cards) do
        if card.type =='Card' then
            local questValue = getQuestValue(card)
            local tokenCount = getTimeTokenCount(card) + 1
            if tokenCount >= questValue then
                printToAll('Quest "' .. card.getName() .. '" has expired!', stringColorToRGB('Yellow'))
            end
            -- Get tokens on top of card
            -- See if the quest will expire with the next token added
            local pos = getTokenPosition(card)
            bag.takeObject({
                position = {pos[1], 2, pos[3]},
                rotation = {0,180,0}
            })
        end
    end
end

function getQuestValue(card)
    local progress = 0;
    local qtime = 0;
    for p, t in (card.getDescription()):gmatch "(%d);%s?Time:%s?(%d)" do
        progress = p 
        qtime = t
    end
    return tonumber(qtime)
end

function getTimeTokenCount(card)
    local pos = getTokenPosition(card)
    local hitList = Physics.cast({
        origin       = pos,
        direction    = {0,1,0},
        type         = 3,
        size         = { 1.3, 1, 3.10},
        max_distance = 1
    })
    
    local tokenCount = 0;

    for key, value in ipairs(hitList) do
        if value.hit_object.hasTag('Time') then
            if (value.hit_object.name == 'Custom_Token_Stack') then
                tokenCount = value.hit_object.getQuantity()
            else
                tokenCount = 1
            end
        end        
    end

    return tokenCount;
end

function getTokenPosition(card)
    local pos = card.getPosition()
    return {pos[1]+0.8, pos[2], pos[3]+1}
end