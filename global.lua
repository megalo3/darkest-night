function darknessCardsSelected(player, option, id) end
function startingBlightsSelected(player, option, id) end
function startingDarknessSelected(player, option, id) end
function startingPowerCardsSelected(player, option, id) end
function startingGraceSelected(player, option, id) end
function startingSparksSelected(player, option, id) end
function numberOfHeroesSelected(player, option, id) end
function modifyTitle()

end
function setDifficulty()
    print('Game difficulty chosen')
    PlayerBoard.addTag('DifficultySelected')
    UI.hide('DifficultyOptions')
    UI.show('MapDeckPanel')
end

function onLoad()
    math.randomseed(os.time())
    PlayerBoard = getObjectFromGUID('65a138')
    if PlayerBoard.hasTag('DifficultySelected') then
        UI.hide('DifficultyOptions')
    end
    if PlayerBoard.hasTag('MapSelected') then
        UI.hide('MapDeckPanel')
    end

    -- Set items uninteractable
    for key, uninteractableObject in ipairs(getObjectsWithTag('Uninteractable')) do
        uninteractableObject.interactable = false
    end
    
--     self.createButton({
--         click_function = "duplicateSnapPoints", 
--         function_owner = self,
--         label          = "Clone Snaps",
--         position       = {0,0,0},
--         rotation       = {0,0,0},
--         width          = 850,
--         height         = 200,
--         font_size      = 100,
--         color          = {0, 0, 0},
--         font_color     = {1, 1, 1},
--     })
end

function duplicateSnapPoints()
    local points = getObjectFromGUID('1baac0').getSnapPoints()
    local characterDeck = getObjectsWithAllTags({'Quest', 'Deck'})[1];
    for index, card in ipairs(characterDeck.getObjects(true)) do
        local obj = characterDeck.takeObject({
            position = {-16.28, (index / 10)+1, 29.68}
        })
        obj.setSnapPoints(points)
    end
end

function shuffleDecks()
    for _, deck in ipairs(getObjectsWithTag('deck')) do
        deck.shuffle()
    end
end

function mapDeckSelected(player, option, id)
    SelectedMapDeck = MapDecks[option + 1]
end

function setMapDeck()
    UI.hide('MapDeckPanel')
    
    shuffleDecks()
    print('Selected "' .. DeckMapNames[SelectedMapDeck] .. '" map deck.')
    PlayerBoard.addTag('MapSelected')
    if SelectedMapDeck == 'Everything' then return end
    createMapDeck(SelectedMapDeck)
end

function setCharacters()
    local pawns = {}
    for _, color in ipairs(Colors) do
        local pawn = getStarterPawn(color)
        if pawn != nil then
            table.insert(pawns, {Color = color, Pawn = getStarterPawn(color)})
        end
    end
    
    if #pawns != 4 then
        printToAll('Four characters are required to play this game. See rules for 3 or 5 player variants.', stringColorToRGB('Red'))
    end
    
    for _, p in ipairs(pawns) do
        -- Move the pawn to the Monestary
        getObjectsWithAllTags({'Pawn', p['Pawn']})[1].setPositionSmooth(MonestaryPositions[p['Color']])
        dealPlayerCards(p['Color'], p['Pawn'])
        dealCharacterSheet(p['Color'], p['Pawn'])
    end
    print('Choose three of your starting cards, put the other two back in your character deck, and then shuffle it.')
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
        if has_value(point.tags, 'Default Grace') then
            graceBag.takeObject({
                position = object.positionToWorld(point.position),
                rotation = {0,180,0}
            })
        end
    end
end

function createMapDeck(color)
    local MapDeck = getObjectsWithAllTags({'Map', 'Deck'})[1];
    for _, card in ipairs(MapDeck.getObjects(true)) do
        if has_value(card.tags, color) == false then
            MapDeck.takeObject({
                guid = card.guid,
                position = {-16.15, 1.15, 28.98}
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