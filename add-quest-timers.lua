TimeBag = nil
ProgressBag = nil

function onObjectSpawn(object)
    if object.hasTag("Quest") and object.type == 'Card' then
        object.createButton({
            click_function = "addProgress", 
            function_owner = self,
            label          = "+",
            position       = {-0.8,0.25,-.35},
            rotation       = {0,0,0},
            width          = 125,
            height         = 125,
            font_size      = 100,
            color          = {0/255,255/255,130/255,0.9},
            font_color     = {95/255,120/255,0/255,1},
        })
        object.createButton({
            click_function = "addTime", 
            function_owner = self,
            label          = "+",
            position       = {0.8,0.25,-.35},
            rotation       = {0,0,0},
            width          = 125,
            height         = 125,
            font_size      = 100,
            color          = {0/255,255/255,130/255,0.9},
            font_color     = {95/255,120/255,0/255,1},
        })
    end
end

function addProgress(card)
    print('Adding progress to ' .. card.getName() .. ' quest.')
    addQuestToken(card, 'Progress')
end

function addTime(card)
    print('Adding time to ' .. card.getName() .. ' quest.')
    addQuestToken(card, 'Time')
end

function onLoad()
    TimeBag = getObjectsWithAllTags({'Bag', 'Time'})[1]
    ProgressBag = getObjectsWithAllTags({'Bag', 'Progress'})[1]
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
    print('Adding time to quests.')
    local zone = getObjectsWithAllTags({'Zone', 'Board', 'Quest'})[1]
    local cards = zone.getObjects()
    for _, card in ipairs(cards) do
        addQuestToken(card, 'Time')
    end
end

function addQuestToken(card, valueType)
     if card.type =='Card' then
        local value = getCardValue(card, valueType)
        local count = getTokenCount(card, valueType) + 1
        if count >= value then
            if valueType == 'Time' then
                printToAll('Quest "' .. card.getName() .. '" has expired!', stringColorToRGB('Yellow'))
            end
            if valueType == 'Progress' then
                printToAll('Quest "' .. card.getName() .. '" has been successfully completed!', stringColorToRGB('Yellow'))
            end
        end
        -- Get tokens on top of card
        -- See if the quest will expire with the next token added
        local pos = getTokenPosition(card, valueType)
        local bag = nil;
        if valueType == 'Time' then bag = TimeBag end
        if valueType == 'Progress' then bag = ProgressBag end
        bag.takeObject({
            position = {pos[1], 2, pos[3]},
            rotation = {0,180,0}
        })
    end
end

function getCardValue(card, valueType)
    local progress = 0;
    local qtime = 0;
    for p, t in (card.getDescription()):gmatch "(%d);%s?Time:%s?(%d)" do
        progress = p 
        qtime = t
    end
    if valueType == 'Progress' then return tonumber(progress) end
    if valueType == 'Time' then return tonumber(qtime) end
end

function getTokenCount(card, valueType)
    local pos = getTokenPosition(card, valueType)
    local hitList = Physics.cast({
        origin       = pos,
        direction    = {0,1,0},
        type         = 3,
        size         = { 1.3, 1, 3.10},
        max_distance = 1
    })
    
    local timeCount = 0;
    local progressCount = 0;

    for key, value in ipairs(hitList) do
        if value.hit_object.hasTag('Time') then
            if (value.hit_object.name == 'Custom_Token_Stack') then
                timeCount = value.hit_object.getQuantity()
            else
                timeCount = 1
            end
        end
        if value.hit_object.hasTag('Progress') then
            if (value.hit_object.name == 'Custom_Token_Stack') then
                progressCount = value.hit_object.getQuantity()
            else
                progressCount = 1
            end
        end         
    end

    if valueType == 'Time' then return timeCount end
    if valueType == 'Progress' then return progressCount end
end

function getTokenPosition(card, valueType)
    local pos = card.getPosition()
    pos[3] = pos[3]+1
    if valueType == 'Time' then pos[1] = pos[1]+0.8 end
    if valueType == 'Progress' then pos[1] = pos[1]-0.8 end
    return pos
end