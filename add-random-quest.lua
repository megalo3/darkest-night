MoveNecromancerScript = nil

function onLoad()
    MoveNecromancerScript = getObjectFromGUID('5507ea')  
    self.createButton({
        click_function = "rollQuest", 
        function_owner = self,
        label          = "Spawn Quest",
        position       = {0,0,0},
        rotation       = {0,180,0},
        width          = 700,
        height         = 200,
        font_size      = 100,
        color          = {0,0,0},
        font_color     = {1, 1, 1},
    })  
end

function rollQuest()
    local necroDie = getObjectsWithAllTags({'Necromancer', 'Die'})[1];
    necroDie.roll()
    
    isRolling = true
    function coroutine_monitorDice()
        repeat
            local allRest = true
            if necroDie ~= nil and necroDie.resting == false then
                allRest = false
            end
            coroutine.yield(0)
        until allRest == true 
        
        isRolling = false
        local dieValue = necroDie.getRotationValue()
        
        addQuest(dieValue)
        
        return 1
    end
    startLuaCoroutine(self, "coroutine_monitorDice")
end

function addQuest(number)
    local direction = MoveNecromancerScript.getVar('LocationDirection')['Village']
    local location = direction[number]
    print('Spawning a quest in the ' .. location .. '.')
    local pos = MoveNecromancerScript.getVar('LocationPosition')[location]
    
    local zone = getObjectsWithAllTags({'Quest', 'Zone'})[1];
    local deckObj = Global.call('getDeckFromZone', zone)
    local deck = getObjectFromGUID(deckObj.guid)
    deck.takeObject({
        position = {pos[1],pos[2],pos[3]},
        flip = true
    })
end

