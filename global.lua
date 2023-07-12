Settings = {
    difficultyOptions = {0,0,0,0,0,0,0,0},
    heroTurnPanelClosedBy = {"Nobody"},
    actionsPanelClosedBy = {"Nobody"},
    difficultyPanelClosedBy = {"Nobody"},
    mapPanelClosedBy = {"Nobody"},
    mapActive = false
}

ReturnBlight = nil
ItemBag = nil
AddDarknessScript = nil
AddBlightScript = nil
MapDeckScript = nil

function onLoad(saveData)    
    addHotkey("Return Token", function(playerColor, object, pointerPosition, isKeyUp)
        if isKeyUp == true then return end
        if object ~= nil then
            returnItem(object)
        end
    end, true)
    
    printToAll('Go to Options -> Game Keys and add a hotkey for returning tokens.', stringColorToRGB('Yellow'))
    
    -- Load the save data, if present.
    if saveData and saveData ~= "" then
       Settings = JSON.decode(saveData)
    end
    -- print(JSON.encode(Settings))
    UI.setAttribute('MapPanel', 'active', Settings.mapActive)
    UI.setAttribute('MapPanelButton', 'active', Settings.mapActive)
    showHidePanelForAllPlayers()
    
    math.randomseed(os.time())

    ReturnBlight = getObjectFromGUID('ea4c54')
    PlayerBoard = getObjectFromGUID('65a138')
    ItemBag = getObjectsWithAllTags({'Item', 'Bag'})[1]
    AddDarknessScript = getObjectFromGUID('a4642e')
    AddBlightScript = getObjectFromGUID('31c6dc')
    MapDeckScript = getObjectFromGUID('89075e')

    -- Set items uninteractable
    for key, uninteractableObject in ipairs(getObjectsWithTag('Uninteractable')) do
        uninteractableObject.interactable = false
    end
    
    highlightPawns()
end

function onObjectNumberTyped(object,  player_color,  number)
    if object.type == 'Deck' then
        if number > 9 then
            print("Sorry. You can only draw a maximum of 9 cards.")
            return true
        end
        object.deal(number, player_color)
        return true
    end
end

function returnSingleItem(object, bag)
    local taken = object.takeObject()
    if taken ~= nil then
        bag.putObject(taken) 
    else
        bag.putObject(object) 
    end
end

function returnItem(object)
    -- Unstack stacks
    if object.name == 'Custom_Token_Stack' then
        local newObject = object.takeObject()
        object = newObject
    end  
    
    if object.hasTag("Blight") then
        ReturnBlight.call("returnBlight", object)
        return true
    end
    if object.hasTag("Spark") then
        local bag = getObjectsWithAllTags({'Spark', 'Bag'})[1]
        returnSingleItem(object, bag)
        return true
    end
    if object.hasTag("Progress") then
        local bag = getObjectsWithAllTags({'Progress', 'Bag'})[1]
        returnSingleItem(object, bag)
        return true
    end
    if object.hasTag("Time") then
        local bag = getObjectsWithAllTags({'Time', 'Bag'})[1]
        returnSingleItem(object, bag)
        return true
    end
    if object.hasTag("Key") then
        local bag = getObjectsWithAllTags({'Key', 'Bag'})[1]
        returnSingleItem(object, bag)
        return true
    end
    if object.hasTag("Item") then
        returnSingleItem(object, ItemBag)
        return true
    end
end

function test()

end

-- Called when the game is saved.
function onSave()
    -- Save the game's Settings.
    return JSON.encode(Settings)
end

function darknessCardsSelected(player, selected) 
    local options = {
         '-1 dm: 1 card (at 15)',
         '+0 dm: 2 cards (at 10, 20)',
         '+1 dm: 3 cards (at 7, 14, 21)',
         '+2 dm: 4 cards (at 5, 10, 15, 20)',
         '+3 dm: 5 cards (at 4, 8, 12, 16, 20)',
         '+4 dm: 6 cards (at 2, 6, 10, 14, 18, 22)',
         '+5 dm: 7 cards (at 0, 4, 8, 12, 16, 20, 24)',
         '+6 dm: 8 cards (at 0, 3, 6, 9, 12, 15, 18, 21)'
    }
    for index, option in ipairs(options) do
        if option == selected then
            Settings.difficultyOptions[1] = index - 2
        end
    end
    updateTitle()
end
function startingBlightsSelected(player, selected)
    local options = {
        '-3 dm: Start with no blights',
        '+0 dm: 1 blight per location (except the Monastery)',
        '+3 dm: 2 blights per location (except the Monastery)'
    }
    for index, option in ipairs(options) do
        if option == selected then
            Settings.difficultyOptions[2] = (index - 2) * 3
        end
    end
    updateTitle()
end

function startingDarknessSelected(player, selected)
    local options = {
        '-1 dm: Darkness -5',
        '+0 dm: Darkness 0',
        '+1 dm: Darkness 5'
    }
    for index, option in ipairs(options) do
        if option == selected then
            Settings.difficultyOptions[3] = index - 2
        end
    end
    updateTitle()
end

function startingPowerCardsSelected(player, selected)
    local options = {
        '-2 dm: Start every hero with 5 power cards',
        '-1 dm: Start every hero with 4 power cards',
        '+0 dm: Start every hero with 3 power cards'
    }
    for index, option in ipairs(options) do
        if option == selected then
            Settings.difficultyOptions[4] = index - 3
        end
    end
    updateTitle()
end

function startingGraceSelected(player, selected)
    local options = {
        '-1 dm: Start every hero with 2 extra Grace',
        '+0 dm: Start every hero with 0 extra Grace'
    }
    for index, option in ipairs(options) do
        if option == selected then
            Settings.difficultyOptions[5] = index - 2
        end
    end
    updateTitle()
end

function startingSparksSelected(player, selected)
    local options = {
        '-1 dm: Start every hero with 3 sparks',
        '+0 dm: Start every hero with 0 sparks'
    }
    for index, option in ipairs(options) do
        if option == selected then
            Settings.difficultyOptions[6] = index - 2
        end
    end
    updateTitle()
end

function numberOfHeroesSelected(player, selected)
    local options = {
        '+4 dm: Play with 3 heroes',
        '+0 dm: Play with 4 heroes',
        '+0 dm: Play with 5 heroes. (See extra rules)'
    }
    for index, option in ipairs(options) do
        if option == selected then
            if index == 1 then
                Settings.difficultyOptions[7] = 4
            else
                Settings.difficultyOptions[7] = 0
            end
        end
    end
    updateTitle()
end

function increaseQuestsSelected(player, selected)
    local amount = 0
    if selected == 'True' then amount = 1 end
    Settings.difficultyOptions[8] = amount
    updateTitle()
end

function updateTitle()
    difficulty = 0
    for _, option in ipairs(Settings.difficultyOptions) do
        difficulty = difficulty + option
    end
    
    if difficulty >= 0  then
        difficulty = "+" .. difficulty
    end
    
    UI.setAttributes('difficultyOptionsTitle', {
        text = "Difficulty Options (Modifier " .. difficulty .. ")"
    })
end

function setDifficulty()
    print('Game difficulty chosen')
    
    -- Move starting darkness and add cards
    AddDarknessScript.call("moveStartingDarkness")
    
    Settings.mapActive = true
    UI.setAttribute('MapPanel', 'active', Settings.mapActive)
    UI.setAttribute('MapPanelButton', 'active', Settings.mapActive)
    for _, color in ipairs(Player.getColors()) do
        closePanel(color, 'difficultyPanelClosedBy', 'DifficultyPanel')
        openPanel(color, 'mapPanelClosedBy', 'MapPanel')
    end
end

-- function duplicateSnapPoints()
    -- local points = getObjectFromGUID('1baac0').getSnapPoints()
    -- local characterDeck = getObjectsWithAllTags({'Quest', 'Deck'})[1];
    -- for index, card in ipairs(characterDeck.getObjects(true)) do
        -- local obj = characterDeck.takeObject({
            -- position = {-16.28, (index / 10)+1, 29.68}
        -- })
        -- obj.setSnapPoints(points)
    -- end
-- end

function shuffleDecks()
    for _, deck in ipairs(getObjectsWithTag('deck')) do
        deck.shuffle()
    end
end

function mapDeckSelected(player, option, id)
    SelectedMapDeck = MapDecks[option + 1]
end

function setMapDeck()
    for _, color in ipairs(Player.getColors()) do
        closePanel(color, 'mapPanelClosedBy', 'MapPanel')
    end
    
    shuffleDecks()
    print('Selected "' .. DeckMapNames[SelectedMapDeck] .. '" map deck.')
    
    if SelectedMapDeck ~= 'Everything' then 
        createMapDeck(SelectedMapDeck)
    end    
    
    -- Add starting blights
    local blightDm = Settings.difficultyOptions[2]
    local startingBlights = 0
    if blightDm == 0 then startingBlights = 1 end
    if blightDm == 3 then startingBlights = 2 end
    AddBlightScript.call("createStartingBlights", startingBlights)
end

function setCharacters()
    local pawns = {}
    for _, color in ipairs(Colors) do
        local pawn = getStarterPawn(color)
        if pawn != nil then
            table.insert(pawns, {Color = color, Pawn = getStarterPawn(color)})
        end
    end
    
    highlightPawns()
    
    for _, p in ipairs(pawns) do
        -- Move the pawn to the Monestary
        getObjectsWithAllTags({'Pawn', p['Pawn']})[1].setPositionSmooth(MonestaryPositions[p['Color']])
        dealPlayerCards(p['Color'], p['Pawn'])
        dealCharacterSheet(p['Color'], p['Pawn'])
    end
     
    -- Use DM Starting Power Cards
    if Settings.difficultyOptions[4] == -2 then
        print('You get to begin with all five starting cards.')
    else
        local startingCardAmount = 'three'
        if Settings.difficultyOptions[4] == -1 then startingCardAmount = 'four' end
        print('Choose ' .. startingCardAmount .. ' of your starting cards, put the other two back in your character deck, and then shuffle it.')
    end
end

function getStarterPawn(color)
    local sheetStarterZone = getObjectsWithAllTags({'Character Sheet', 'Zone', color})[1];
    local pawns = {}
    for _, object in ipairs(sheetStarterZone.getObjects(true)) do
        if object.hasTag('Pawn') then
            table.insert(pawns, object)
        end
    end
    if #pawns > 1 then
        print('Only one pawn may be selected per player color.')
        return;
    end
    if pawns[1] == nil then return end
    pawns[1].highlightOn(color)
    return pawns[1].getName()
end

function getActiveCharacters()
    local sheetStarterZones = getObjectsWithAllTags({'Character Sheet', 'Zone'});
    local characters = {}
    for _, zone in ipairs(sheetStarterZones) do
        local color = ''
        if zone.hasTag('Red') then color = 'Red' end
        if zone.hasTag('Green') then color = 'Green' end
        if zone.hasTag('Orange') then color = 'Orange' end
        if zone.hasTag('Blue') then color = 'Blue' end
        if zone.hasTag('Purple') then color = 'Purple' end
        for _, object in ipairs(zone.getObjects(true)) do
            if object.type == 'Card' then
                for _, tag in ipairs(object.getTags()) do
                    if tag ~= 'Character Sheet' then
                        table.insert(characters, { name = tag, color = color })
                    end
                end
            end
        end
    end
    return characters;
end

function highlightPawns()
    for _, character in ipairs(getActiveCharacters()) do
        local pawn = getObjectsWithAllTags({ 'PawnSelect', character.name })[1]
        pawn.highlightOn(character.color)
    end
end

function dealCharacterSheet(color, character)
    local characterSheetDeck = getObjectsWithAllTags({'Character Sheet', 'Deck'})[1];
    local sheetStarterZone = getObjectsWithAllTags({'Character Sheet', 'Zone', color})[1];
    for _, card in ipairs(characterSheetDeck.getObjects(true)) do
        if has_value(card.tags, character) then
            characterSheetDeck.takeObject({
                guid = card.guid,
                position = sheetStarterZone.getPosition(),
                callback_function = function(spawnedObject)
                    Wait.time(function() setCharacterSheetTokens(spawnedObject) end, 1.3)
                end
            })
        end
    end
    
    -- Use DM starting sparks
    if Settings.difficultyOptions[6] == -1 then
        Wait.time(function()  AddBlightScript.call("getItemFromBag", {tag = 'Spark', color = color}) end, 1.3)
        Wait.time(function()  AddBlightScript.call("getItemFromBag", {tag = 'Spark', color = color}) end, 2)
        Wait.time(function()  AddBlightScript.call("getItemFromBag", {tag = 'Spark', color = color}) end, 2.7)
    end
end

function setCharacterSheetTokens(object)
    object.setLock(true)
    local graceBag = getObjectsWithAllTags({'Grace', 'Bag'})[1];
    local secrecyBag = getObjectsWithAllTags({'Secrecy', 'Bag'})[1];
    for _, point in ipairs(object.getSnapPoints()) do
        if has_value(point.tags, 'Default Secrecy') then
            secrecyBag.takeObject({
                position = object.positionToWorld(point.position),
                rotation = {0,180,0}
            })
        end
        
        -- Use DM Starting Grace. A 2 modifier is the same as +1.31 x coords
        local startingGraceModifer = 0
        if Settings.difficultyOptions[5] == -1 then startingGraceModifer = 1.31 end
        
        if has_value(point.tags, 'Default Grace') then
            local gracePos = object.positionToWorld(point.position)
            gracePos[1] = gracePos[1] + startingGraceModifer
            graceBag.takeObject({
                position = gracePos,
                rotation = {0,180,0}
            })
        end
    end
end

function createMapDeck(color)

    local zone = getObjectsWithAllTags({'Map', 'Zone', 'Deck'})[1];
    local deck = Global.call('getDeckFromZone', zone)
    
    for _, card in ipairs(deck.getObjects(true)) do
        if has_value(card.tags, color) == false then
            deck.takeObject({
                guid = card.guid,
                position = {-30.37, 1.13, 32.43}
            })
        end
    end
end

-- Check if a table contains a value 
function has_value(tableObject, matchValue)
    for index, value in ipairs(tableObject) do
        if value == matchValue then
            return true
        end
    end
    return false
end

function dealPlayerCards(color, character)
    local characterDeck = getObjectsWithAllTags({'Characters', 'Deck'})[1];
    local colorDeckZone = getObjectsWithAllTags({'Deck', 'Zone', color})[1];
    for _, card in ipairs(characterDeck.getObjects(true)) do
        if has_value(card.tags, character) then
            characterDeck.takeObject({
                guid = card.guid,
                position = colorDeckZone.getPosition()
            })
        end
    end
    
    Wait.time(function() dealStarterCards(colorDeckZone, color) end, 1.8)
end

function dealStarterCards(zone, color)
    local deck = getDeckFromZone(zone)
    if deck == nil then return end
    
    local dealt = 1;
    for _, card in ipairs(deck.getObjects(true)) do
        if has_value(card.tags, 'Starter') then
            local index = dealt % 4;
            if index == 0 then index = 4 end
            local pos = { Players[color][index], Players['PlayedY'], Players['PlayedZ'][math.ceil(dealt/4)]}
            deck.takeObject({
                guid = card.guid,
                position = pos,
                flip = true
            })
            dealt = dealt + 1
        end
    end
end

function getDeckFromZone(zone)
    if (zone == nil) then return end
    for _, object in ipairs(zone.getObjects(true)) do
        if (object.type == 'Deck') then
            return object
        end
    end
    return nil 
end

function closeHeroTurnPanel(player) closePanel(player.color, 'heroTurnPanelClosedBy', 'HeroTurnPanel') end
function closeActionsPanel(player) closePanel(player.color, 'actionsPanelClosedBy', 'ActionsPanel') end
function closeDifficultyPanel(player) closePanel(player.color, 'difficultyPanelClosedBy', 'DifficultyPanel') end
function closeMapPanel(player) closePanel(player.color, 'mapPanelClosedBy', 'MapPanel') end

function openHeroTurnPanel(player) openPanel(player.color, 'heroTurnPanelClosedBy', 'HeroTurnPanel') end
function openActionsPanel(player) openPanel(player.color, 'actionsPanelClosedBy', 'ActionsPanel') end
function openDifficultyPanel(player) openPanel(player.color, 'difficultyPanelClosedBy', 'DifficultyPanel') end
function openMapPanel(player) openPanel(player.color, 'mapPanelClosedBy', 'MapPanel') end

function closePanel(color, tableName, elementId)
    table.insert(Settings[tableName], color)
    showHidePanelsForPlayers(tableName, elementId)
end
function openPanel(color, tableName, elementId)
    table.removeByValue(Settings[tableName], color)
    showHidePanelsForPlayers(tableName, elementId)
end

function showHidePanelForAllPlayers()
    showHidePanelsForPlayers('heroTurnPanelClosedBy', 'HeroTurnPanel')
    showHidePanelsForPlayers('actionsPanelClosedBy', 'ActionsPanel')
    showHidePanelsForPlayers('mapPanelClosedBy', 'MapPanel')
    showHidePanelsForPlayers('difficultyPanelClosedBy', 'DifficultyPanel')
end

function showHidePanelsForPlayers(tableName, elementId)
    local visibility = getVisibilityString(invertUIVisibilityTable(Settings[tableName]), true)
    UI.setAttribute(elementId, "visibility", visibility)
    local buttonVisibility = getVisibilityString(Settings[tableName], true)
    UI.setAttribute(elementId .. "Button", "visibility", buttonVisibility)
end

-- Turns a visibility table (a table of players) into a string suitable for the visibility attribute.
function getVisibilityString(visibilityTable, hideForAllIfEmpty)
    local tableSize = #visibilityTable

    -- If the table is empty, hide the UI for everybody if enabled. This is done by setting the visibility to "Nobody". If disabled, everybody will see the UI.
    if hideForAllIfEmpty and tableSize == 0 then
        table.insert(visibilityTable, "Nobody")
    -- Otherwise, make sure "Nobody" is removed if it's not the only value in the table.
    elseif tableSize > 1 then
        table.removeByValue(visibilityTable, "Nobody")
    end

    -- Implode the string, separating by a pipe.
    return table.concat(visibilityTable, "|")
end

-- Inverts a UI visibility table, so all players currently present in it are removed, while all players not present are added.
function invertUIVisibilityTable(visibilityTable)
    local newVisibilityTable = {}

    -- Loop through the available seats.
    for _, value in ipairs(Player.getColors()) do
        -- If they're not currently in the table, add them.
        if not table.inTable(visibilityTable, value) then
            table.insert(newVisibilityTable, value)
        end
    end

    return newVisibilityTable
end

-- Check if a value is in a table.
function table:inTable(value)
    for tableKey, tableValue in ipairs(self) do
        if value == tableValue then
            return true
        end
    end

    return false
end

-- Gets the index of a value in a given table.
function table:indexOf(value)
    for tableKey, tableValue in ipairs(self) do 
        if tableValue == value then 
            return tableKey
        end
    end
end

-- Removes an element from a table by value.
function table:removeByValue(value)
    local index = table.indexOf(self, value)
    if index then
        table.remove(self, index)
    end

    return self
end

PlayerBoard = nil
SelectedMapDeck = 'Green';
DeckMapNames = {
    Green = 'Simplicity',
    Yellow = 'Hunted',
    Orange = 'Overrun',
    Red = 'Entropy',
    Purple = 'Spiritual Warfare',
    Blue = 'Classic',
    Everything = 'Everything'
}
MapDecks = {'Green', 'Yellow', 'Orange', 'Red', 'Purple', 'Blue', 'Everything'}
Colors = {'Red', 'Orange', 'Green', 'Blue', 'Purple'}
MonestaryPositions = {
    Red = {-12.3, 1.25, 13.50},
    Orange = {-10, 1.25, 13.50},
    Green = {-12.3, 1.25, 11.25},
    Blue = {-10, 1.25, 11.25},
    Purple = {-7.7, 1.25, 12.38}
}
Players = {
    PlayedY = 1.1,
    PlayedZ = {-12.20, -15.55},
    Red = {-29.25, -26.78, -24.34, -21.86},
    Orange = {-15.92, -13.45, -11.01, -8.53},
    Green = {-2.57, -0.10, 2.34, 4.87},
    Blue = {10.44, 12.91, 15.35, 17.83},
    Purple = {23.22, 25.69, 28.13, 30.63},
}