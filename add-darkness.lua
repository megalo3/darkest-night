ClueToken = nil
DarknessToken = nil

function onLoad()
    ClueToken = getObjectsWithAllTags({'Search', 'Token'})[1]
    DarknessToken = getObjectsWithAllTags({'Darkness', 'Token'})[1]
    self.createButton({
        click_function = "increaseDarkness", 
        function_owner = self,
        label          = "Add Darkness",
        position       = {0,0,0},
        rotation       = {0,180,0},
        width          = 850,
        height         = 200,
        font_size      = 100,
        color          = {0, 0, 0},
        font_color     = {1, 1, 1},
    })
end

function increaseDarkness() moveDarkness(1) end
function decreaseDarkness() moveDarkness(-1) end
function increaseClues() moveClues(1) end
function decreaseClues() moveClues(-1) end

function moveClues(amount)
    local clueLevel = getTrackLevel('Clues')
    local pos = getDarknessTrackPosition(clueLevel + amount)
    ClueToken.setPositionSmooth(pos)
    print('Moving clues to level ' .. clueLevel + amount .. '.')
end

function moveDarkness(amount)
    local darknessCardLevels = getDarknessCardLevels()
    
    local darknessLevel = getTrackLevel('Darkness')
    local nextLevel = darknessLevel + amount
    print('Moving darkness to level ' .. nextLevel .. '.')
    
    local darknessIndex = getDarknessCardIndex(nextLevel, darknessCardLevels)
    if darknessIndex ~= false then
        print('Drawing a Darkness card at darkness for level ' .. nextLevel ..'.')
        drawDarknessCard(darknessIndex)
    end
    
    if nextLevel == 25 then
        print('All blights have +1 might.')
    elseif nextLevel == 31 then
        print("You've reached the end of the darkness track. Add a blight to the Monastery instead.")
        return
    end
    moveDarknessToken(nextLevel)
end

function getDarknessCardLevels()
    local darknessCardsDm = Global.getVar('Settings').difficultyOptions[1]
    local darknessCardLevels = {};
    if darknessCardsDm == -1 then darknessCardLevels = {15} end
    if darknessCardsDm == 0 then darknessCardLevels = {10,20} end
    if darknessCardsDm == 1 then darknessCardLevels = {7,14,21} end
    if darknessCardsDm == 2 then darknessCardLevels = {5,10,15,20} end
    if darknessCardsDm == 3 then darknessCardLevels = {4,8,12,16,20} end
    if darknessCardsDm == 4 then darknessCardLevels = {2,6,10,14,18,22} end
    if darknessCardsDm == 5 then darknessCardLevels = {0,4,8,12,16,20,24} end
    if darknessCardsDm == 6 then darknessCardLevels = {0,3,6,9,12,15,18,21} end
    return darknessCardLevels
end

function moveStartingDarkness()
    local startingDarknessDm = Global.getVar('Settings').difficultyOptions[3]
    local darkness = 0
     -- Move starting darkness 
    if startingDarknessDm == -1 then
        moveDarknessToken(-5)
        darkness = -5
    end
    if startingDarknessDm == 1 then
        moveDarknessToken(5)
        darkness = 5
    end
    drawStartingDarknesses(darkness)
end

function drawStartingDarknesses(darkness)
    local darknessCardLevels = getDarknessCardLevels()
    
    for index, value in ipairs(darknessCardLevels) do
        if value <= darkness then
            print('Drawing a Darkness card for darkness level ' .. value .. '.')
            drawDarknessCard(index)
        end
    end
end

function getDarknessTrackPosition(level)
    local z = 3.08
    if level < 0 then
        level = level * -1
        z = NegativeTrackZ
    end
    return {DarknessTrack[level+1], 1.6, z}
end

function moveDarknessToken(level)
    local token = getObjectsWithAllTags({'Darkness', 'Token'})[1];
    token.setPositionSmooth(getDarknessTrackPosition(level))
end

function getDarknessCardIndex(number, levels)
    for index, level in ipairs(levels) do
        if level == number then
            return index
        end
    end
    return false
end

function drawDarknessCard(n)
    local deck = getObjectsWithAllTags({'Darkness', 'Deck'})[1]; 
    local position = deck.getPosition()
    local xPos = position[1] + 2.5 * n
    deck.takeObject({ position = {xPos, 2, position[3]}, flip = true })
end

function getTrackLevel(pType)
    local token = pType == 'Darkness' and DarknessToken or ClueToken
    local xpos = math.floor(token.getPosition()[1])
    local darknessLevel = xpos + 14;
    if  math.floor(token.getPosition()[3]) == math.floor(NegativeTrackZ)
        then darknessLevel = darknessLevel * -1
    end
    return darknessLevel
end

DarknessTrack = {-13.80, -12.80, -11.80, -10.80, -9.80, -8.80, -7.80, -6.80, -5.80, -4.80, 
-3.79, -2.77, -1.77, -0.77, 0.22, 1.22, 2.22, 3.20, 4.19, 5.20,
6.20, 7.20, 8.20, 9.20, 10.20, 11.20, 12.27, 13.27, 14.27, 15.27, 16.27}
DarknessDeck = {25.77, 28.12}
NegativeTrackZ = 2.15