function onLoad()
    self.createButton({
        click_function = "moveDarkness", 
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

function moveDarkness()
    local token = getObjectsWithAllTags({'Darkness', 'Token'})[1];
    local darknessLevel = getDarknessLevel(token.getPosition()[1])
    local nextLevel = darknessLevel + 1
    if nextLevel == 10 then
        print('Drawing a Darkness card.')
        drawDarknessCard(1)
    elseif nextLevel == 20 then
        print('Drawing a Darkness card.')
        drawDarknessCard(2)
    elseif nextLevel == 25 then
        print('All blights have +1 might.')
    elseif nextLevel == 31 then
        print("You've reached the end of the darkness track. Add a blight to the Monastery instead.")
        return
    end
    token.setPositionSmooth({DarknessTrack[nextLevel+1], 1.6, 3.08})
end

function drawDarknessCard(n)
    local deck = getObjectsWithAllTags({'Darkness', 'Deck'})[1];    
    deck.takeObject({ position = {DarknessDeck[n], 2, -1.37}, flip = true })
end

function getDarknessLevel(x)
    local xpos = math.floor(x)
    local darknessLevel = xpos + 14;
    return darknessLevel
end

DarknessTrack = {-13.80, -12.80, -11.80, -10.80, -9.80, -8.80, -7.80, -6.80, -5.80, -4.80, 
-3.79, -2.77, -1.77, -0.77, 0.22, 1.22, 2.22, 3.20, 4.19, 5.20,
6.20, 7.20, 8.20, 9.20, 10.20, 11.20, 12.27, 13.27, 14.27, 15.27, 16.27}
DarknessDeck = {25.77, 28.12}