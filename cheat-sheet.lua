AddBlightScript = nil

function onLoad()
    AddBlightScript = getObjectFromGUID('31c6dc')
    local items1 = {'getArtifact', 'getBottledMagic', 'getCharm', 'getCursedAshes', 'getPsionStone', 'getSkullToken'}
    for index, item in ipairs(items1) do
        self.createButton({
            click_function = item, 
            function_owner = self,
            label          = "+",
            position       = {-2.35,.25,-1.50 + .325 * (index-1)},
            rotation       = {0,0,0},
            width          = 90,
            height         = 90,
            font_size      = 90,
            color          = {0/255,255/255,130/255,0.9},
            font_color     = {95/255,120/255,0/255,1},
        })
    end
    
    local items2 = {'getSoothingLyre', 'getTomeOfRetraining', 'getTreasureChest', 'getVanishingDust', 'getWaystone'}
    for index, item in ipairs(items2) do
        self.createButton({
            click_function = item, 
            function_owner = self,
            label          = "+",
            position       = {-.75,.25,-1.50 + .325 * (index-1)},
            rotation       = {0,0,0},
            width          = 90,
            height         = 90,
            font_size      = 90,
            color          = {0/255,255/255,130/255,0.9},
            font_color     = {95/255,120/255,0/255,1},
        })
    end

    local items3 = {'getMystery', 'getRevelation'}
    for index, item in ipairs(items3) do
        self.createButton({
            click_function = item, 
            function_owner = self,
            label          = "+",
            position       = {.85,.25,-.88 + .45 * (index-1)},
            rotation       = {0,0,0},
            width          = 90,
            height         = 90,
            font_size      = 90,
            color          = {0/255,255/255,130/255,0.9},
            font_color     = {95/255,120/255,0/255,1},
        })
    end
    
end

-- ItemName, Color
function getArtifact(o,c) AddBlightScript.call('dealItem', {ItemName = 'Artifact', Color = c}) end
function getBottledMagic(o,c) AddBlightScript.call('dealItem', {ItemName = 'Bottled Magic', Color = c}) end
function getCharm(o,c) AddBlightScript.call('dealItem', {ItemName = 'Charm', Color = c}) end
function getCursedAshes(o,c) AddBlightScript.call('dealItem', {ItemName = 'Cursed Ashes', Color = c}) end
function getPsionStone(o,c) AddBlightScript.call('dealItem', {ItemName = 'Psion Stone', Color = c}) end
function getSkullToken(o,c) AddBlightScript.call('dealItem', {ItemName = 'Skull Token', Color = c}) end

function getSoothingLyre(o,c) AddBlightScript.call('dealItem', {ItemName = 'Soothing Lyre', Color = c}) end
function getTomeOfRetraining(o,c) AddBlightScript.call('dealItem', {ItemName = 'Tome of Retraining', Color = c}) end
function getTreasureChest(o,c) AddBlightScript.call('dealItem', {ItemName = 'Treasure Chest', Color = c}) end
function getVanishingDust(o,c) AddBlightScript.call('dealItem', {ItemName = 'Vanishing Dust', Color = c}) end
function getWaystone(o,c) AddBlightScript.call('dealItem', {ItemName = 'Waystone', Color = c}) end

function getMystery(o,c) AddBlightScript.call('dealItem', {ItemName = 'Mystery', Color = c}) end
function getRevelation(o,c) AddBlightScript.call('dealItem', {ItemName = 'Revelation', Color = c}) end