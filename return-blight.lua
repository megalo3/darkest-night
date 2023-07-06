BlightBoard = nil
function onLoad()
    BlightBoard = getObjectFromGUID('2f4bb6')
end

function returnBlight(object)
    local position = findSnapLocation(object.getName())
    local toWorld = BlightBoard.positionToWorld(position)
    object.setPositionSmooth({toWorld[1], 3, toWorld[3]})
    object.setRotationSmooth({0,180,0})
end

function findSnapLocation(name)
    for _, snap in ipairs(BlightBoard.getSnapPoints()) do
        if snap.tags[1] == name then
            return snap.position
        end
    end
end