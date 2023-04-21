function onLoad()
    self.createButton({
        click_function = "removeCharacters", 
        function_owner = self,
        label          = "Remove",
        position       = {0,0,0},
        rotation       = {0,0,0},
        width          = 600,
        height         = 200,
        font_size      = 100,
        color          = {0, 0, 0},
        font_color     = {1, 1, 1},
    })
end

function removeCharacters()
    local removeBag = getObjectsWithAllTags({'Bag', 'Remove'})[1];
    local characterSheetDeck = getObjectsWithAllTags({'Character Sheet', 'Deck'})[1];
    local characterDeck = getObjectsWithAllTags({'Characters', 'Deck'})[1];
    for _, pawn in ipairs(removeBag.getObjects(true)) do
        local characterSheet = getObjectsWithAllTags({'Character Sheet', pawn.name})[1];
        if characterSheet != nil then
            characterSheet.setLock(false)
            characterSheetDeck.putObject(characterSheet)
            for _, card in ipairs(getObjectsWithAllTags({pawn.name})) do
                characterDeck.putObject(card)
            end
        end
    end
    Wait.time(function() deleteExtraTokens() end, .5)
end

function deleteExtraTokens()
    local characterSheetZones = getObjectsWithAllTags({'Character Sheet', 'Zone'});
    local secrecyBag = getObjectsWithAllTags({'Bag', 'Secrecy'})[1];
    local graceBag = getObjectsWithAllTags({'Bag', 'Grace'})[1];
    for _, zone in ipairs(characterSheetZones) do
        local graceToken = nil
        local secrecyToken = nil
        local hasCard = false
        for _, object in ipairs(zone.getObjects()) do
            if object.name == 'Card' then hasCard = true end
            if object.getName() == 'Grace' then graceToken = object end
            if object.getName() == 'Secrecy' then secrecyToken = object end
        end
        if hasCard == false then
            if graceToken != nil then
                graceBag.putObject(graceToken)
            end
            if secrecyToken != nil then
                secrecyBag.putObject(secrecyToken)
            end
        end
    end
end