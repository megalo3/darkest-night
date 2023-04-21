BlightBoard = nil
function onLoad()
    BlightBoard = getObjectFromGUID('2f4bb6')
end

function onObjectEnterContainer(container, object)
    if (container.guid == self.guid) then
        local position = findSnapLocation(object.getName())
        local toWorld = BlightBoard.positionToWorld(position)
        self.takeObject({position = {toWorld[1], 3, toWorld[3]}})
    end
end

function findSnapLocation(name)
    for _, snap in ipairs(BlightBoard.getSnapPoints()) do
        if snap.tags[1] == name then
            return snap.position
        end
    end
end