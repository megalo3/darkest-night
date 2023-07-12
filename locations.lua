LocationAreas = {}

function onLoad()
    for _, location in ipairs(Locations) do
        LocationAreas[location] = getPolygonArea(location)
    end
end

function countBlightsInLocation(location)
    local zone = getObjectsWithAllTags({'Zone', 'Board', 'Blight'})[1]
    local bag = getObjectsWithAllTags({'Bag', 'Time'})[1]
    local blights = zone.getObjects()
    local blightCount = 0
    local locationArea = LocationAreas[location]
    for _, blight in ipairs(blights) do
        if blight.type == 'Tile' then
            local position = blight.getPosition()
            local blightArea = getPointWithPolygonArea(location, {position[1], position[3]})
            if LocationAreas[location] == blightArea then
                local newBlightCount = getTileStackCount(blight)
                -- Voids count as 2 blights
                if blight.getName() == 'Void' then newBlightCount = newBlightCount * 2 end
                blightCount = blightCount + newBlightCount
            end
        end
    end
    return blightCount
end

function getTileStackCount(tileStack)
    if (tileStack.name == 'Custom_Tile_Stack') then
        return tileStack.getQuantity()
    else
        return 1
    end
end

function findPawnLocation(object)
    local locationName = nil
    local position = object.getPosition()
    for _, location in ipairs(Locations) do
        local pawnArea = getPointWithPolygonArea(location, {position[1], position[3]})
        if LocationAreas[location] == pawnArea then
            return location
        end
    end
end

function getPolygonArea(location)
    local coords = LocationVertices[location]
    local area = 0
    for i = 0,#coords - 2 do
        local point2 = coords[i+1]
        local point3 = coords[i+2]
        local newArea = getTriangleArea(coords[1], point2, point3)
        area = area + newArea
    end
    return round(area, 2)
end

function getPointWithPolygonArea(location, point)
    local coords = LocationVertices[location]
    local area = 0
    for i = 0,#coords - 1 do
        local point2 = coords[i+1]
        local point3Index = i+2
        if point3Index > #coords then point3Index = 1 end
        local point3 = coords[point3Index]
        local newArea = getTriangleArea(point, point2, point3)
        area = area + newArea
    end
    return round(area, 2)
end

function getTriangleArea(one, two, three)
    local x1 = one[1]
    local y1 = one[2]
    local x2 = two[1]
    local y2 = two[2]
    local x3 = three[1]
    local y3 = three[2]
    return .5*(math.abs(
        x1*(y2-y3) + x2*(y3-y1) + x3*(y1-y2)
    ))
end

-- Lua doesn't have a round function!
function round(number, places)
    local mult = 10^(places or 0)
    return math.floor(number * mult + 0.5) / mult
end

Locations = {'Mountains', 'Monastery', 'Forest', 'Castle', 'Village', 'Swamp', 'Ruins'}
LocationVertices = {
    Monastery = {
        {-14.45, 18.19},
        {-4.98,15.13},
        {-4.98, 9.92},
        {-14.46, 6.97}
    },
    Mountains = {
        {-14.50, 21.83},
        {1.27, 21.91},
        {1.28, 17.29},
        {-4.98,15.13},
        {-14.45, 18.19}
    },
    Castle = {
        {1.27, 21.91},
        {17.00, 21.96},
        {16.96, 18.30},
        {7.31, 15.11},
        {1.28, 17.29}
    },
    Village = {
        {-4.98,15.13},
        {1.28, 17.29},
        {7.31, 15.11},
        {7.27, 10.03},
        {1.29, 7.75},
        {-4.98, 9.92}
    },
    Swamp = {
        {7.31, 15.11},
        {16.96, 18.30},
        {17.04, 6.85},
        {7.27, 10.03}
    },
    Forest = {
        {-14.46, 6.97},
        {-4.98, 9.92},
        {1.29, 7.75},
        {1.24, 3.52},
        {-14.53, 3.52}
    },
    Ruins = {
        {1.29, 7.75},
        {7.27, 10.03},
        {17.04, 6.85},
        {17.04, 3.51},
        {1.24, 3.52}
    }
}