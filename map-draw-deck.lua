-- MapDrawDeckZone = self;
MapDiscardDeckZone = nil;

function onLoad()
    MapDiscardDeckZone = getObjectFromGUID('dcbf6b')
end

function drawMapCard()
    local objects = self.getObjects()
    
    if isDeckEmpty() == true then
        resupplyMapDeck()
        Wait.time(function() drawMapCard() end, 1.3)
    else
        dealMapCard(objects)
    end
end

function dealMapCard(objects)
    for _, object in ipairs(objects) do
        if object.type == 'Card' then
            object.flip()
            object.setPositionSmooth(MapDrawLocation)
        end
        if object.type == 'Deck' then
            object.takeObject({
                position = MapDrawLocation,
                flip = true
            })
        end
    end
end

function resupplyMapDeck()
    for _, object in ipairs(MapDiscardDeckZone.getObjects()) do
        if object.type == 'Deck' then
            object.flip()
            object.shuffle()
            object.setPositionSmooth(MapSupplyLocation)
        end
    end
end

function isDeckEmpty()
    return #self.getObjects() == 0
end

function getDiscardDeckTopCard()
    return getTopCard(MapDiscardDeckZone)
end

function getTopCard(zone)
    local topCard = nil
    for _, object in ipairs(zone.getObjects()) do
        if object.type == 'Card' then
            topCard = object
        end
        if object.type == 'Deck' then
            local cards = object.getObjects()
            topCard = cards[#cards]
        end
    end
    return topCard
end

MapDrawLocation = {13.16, 2, -1.31}
MapSupplyLocation = {10.75, 2, -1.31}