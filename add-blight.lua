MapDrawDeck = nil
LocationScript = nil

function onLoad()
   MapDrawDeck = getObjectFromGUID('89075e')
   LocationScript = getObjectFromGUID('1b4d88')
   for index, location in ipairs(Locations) do
        self.createButton({
            click_function = "createBlight" .. location, 
            function_owner = self,
            label          = "Add " .. location .. " Blight",
            position       = {0,0,(index - 1)/1.63},
            rotation       = {0,0,0},
            width          = 1000,
            height         = 200,
            font_size      = 100,
            color          = {0, 0, 0},
            font_color     = {1, 1, 1},
        })
    end
end

function createBlightMountains(o, c, a) createBlight('Mountains') end
function createBlightCastle(o, c, a) createBlight('Castle') end
function createBlightVillage(o, c, a) createBlight('Village') end
function createBlightSwamp(o, c, a) createBlight('Swamp') end
function createBlightForest(o, c, a) createBlight('Forest') end
function createBlightRuins(o, c, a) createBlight('Ruins') end
function createBlightMonastery(o, c, a) createBlight('Monastery') end

function createBlight(location)
    local card = MapDrawDeck.call('getDiscardDeckTopCard')
    if card == nil then
        print('No map card has been played.')
        return
    end
    -- Make sure there aren't already 4 blights
    local blightCount = LocationScript.call('countBlightsInLocation', location)
    if blightCount >= 4 then
        printToAll('The ' .. location .. ' already has 4 blights. Creating a blight at the Monastery instead. If the Monastery ever has more than 4 blights, the heroes immediately lose the game.', stringColorToRGB('Orange'))
        location = 'Monastery'
    end
    -- If so, the blight location is the Monastery
    local blightInfo = getBlightInfoFromGUID(card.guid)
    local blightName = blightInfo[location][1]
    local deployedBlightMessage = deployBlight(blightName, location)
    if deployedBlightMessage == false then
        return false
    end
    print(deployedBlightMessage)
    return true
end

function getBlightInfoFromGUID(guid)
    for _, info in ipairs(Maps) do
        if (info.GUID == guid) then
            return info
        end
    end
end

function deployBlight(blightName, location)
    local BlightZone = getObjectsWithAllTags({'Zone', 'Blight', 'Draw'})[1]
    for index, tileStack in ipairs(BlightZone.getObjects()) do
        if (tileStack.getName() == blightName) then
            if (tileStack.name == 'Custom_Tile_Stack') then
                tileStack.takeObject({position = LocationPositions[location]})
            else
                tileStack.setPositionSmooth(LocationPositions[location])
            end
            return 'Adding a ' .. blightName .. ' blight to the ' .. location .. '.';
        end
    end
    printToAll('No more ' .. blightName .. ' tokens available.', stringColorToRGB('Yellow'))
    return false
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

Locations = {'Mountains', 'Castle', 'Village', 'Swamp', 'Forest', 'Ruins', 'Monastery'}
LocationPositions = {
    Mountains = {-6.16, 2, 19.53},
    Castle = {8.46, 2, 18.52},
    Village = {1.30, 2, 12.55},
    Swamp = {12.49, 2, 12.55},
    Forest = {-5.81, 2, 5.35},
    Ruins = {10.68, 2, 5.96},
    Monastery = {-10.90, 2, 12.55}
}
Maps = {
    {
        GUID = 'ccdb75',
        Quest = '',
        Mountains = {'Unholy Aura', 'Mystery'},
        Castle = {'Evil Presence', 'Forgotten Shrine'},
        Village = {'Unholy Aura', 'Bottled Magic'},
        Swamp = {'Zombies', 'Epiphany'},
        Forest = {'Evil Presence', 'Mystery'},
        Ruins = {'Evil Presence', 'Mystery'},
        Monastery = {'Unholy Aura'}
    },
    {
        GUID = '1573e8',
        Quest = '',
        Mountains = {'Terror', 'Mystery'},
        Castle = {'Specters', 'Tome of Retraining'},
        Village = {'Stigma', 'Treasure Chest'},
        Swamp = {'Revenants', 'Bottled Magic'},
        Forest = {'Revenants', 'Mystery'},
        Ruins = {'Crows', 'Mystery'},
        Monastery = {'Terror'}
    },
    {
        GUID = 'ac44f0',
        Quest = 'Forest',
        Mountains = {'Taint', 'Mystery'},
        Castle = {'Spies', 'Treasure Chest'},
        Village = {'Curse', 'Waystone'},
        Swamp = {'Vampire', 'Epiphany'},
        Forest = {'Corruption', 'Supply Cache'},
        Ruins = {'Spies', 'Mystery'},
        Monastery = {'Desecration'}
    },
    {
        GUID = '4755d7',
        Quest = 'Swamp',
        Mountains = {'Omen', 'Forgotten Shrine'},
        Castle = {'Nexus', 'Supply Cache'},
        Village = {'Zombies', 'Treasure Chest'},
        Swamp = {'Skeletons', 'Epiphany'},
        Forest = {'Enigma', 'Artifact'},
        Ruins = {'Skeletons', 'Artifact'},
        Monastery = {'Taint'}
    },
    {
        GUID = '701b68',
        Quest = '',
        Mountains = {'Crows', 'Forgotten Shrine'},
        Castle = {'Specters', 'Supply Cache'},
        Village = {'Terror', 'Treasure Chest'},
        Swamp = {'Specters', 'Epiphany'},
        Forest = {'Revenants', 'Cursed Ashes'},
        Ruins = {'Wraiths', 'Revelation'},
        Monastery = {'Stigma'}
    },
    {
        GUID = '9f30bf',
        Quest = '',
        Mountains = {'Shroud', 'Mystery'},
        Castle = {'Curse', 'Supply Cache'},
        Village = {'Vampire', 'Mystery'},
        Swamp = {'Shroud', 'Epiphany'},
        Forest = {'Desecration', 'Artifact'},
        Ruins = {'Vampire', 'Waystone'},
        Monastery = {'Spies'}
    },
    {
        GUID = '457b84',
        Quest = '',
        Mountains = {'Stigma', 'Mystery'},
        Castle = {'Specters', 'Soothing Lyre'},
        Village = {'Crows', 'Mystery'},
        Swamp = {'Wraiths', 'Epiphany'},
        Forest = {'Terror', 'Mystery'},
        Ruins = {'Revenants', 'Mystery'},
        Monastery = {'Terror'}
    },
    {
        GUID = 'faa261',
        Quest = 'Mountains',
        Mountains = {'Oblivion', 'Mystery'},
        Castle = {'Evil Presence', 'Tome of Retraining'},
        Village = {'Wraiths', 'Artifact'},
        Swamp = {'Decay', 'Inspiration'},
        Forest = {'Gate', 'Revelation'},
        Ruins = {'Flux Cage', 'Revelation'},
        Monastery = {'Spies'}
    },
    {
        GUID = 'a378f1',
        Quest = '',
        Mountains = {'Shades', 'Treasure Chest'},
        Castle = {'Zombies', 'Supply Cache'},
        Village = {'Taint', 'Treasure Chest'},
        Swamp = {'Skeletons', 'Bottled Magic'},
        Forest = {'Shroud', 'Treasure Chest'},
        Ruins = {'Taint', 'Mystery'},
        Monastery = {'Shroud'}
    },
    {
        GUID = '77e4c2',
        Quest = 'Swamp',
        Mountains = {'Shroud', 'Artifact'},
        Castle = {'Vampire', 'Supply Cache'},
        Village = {'Curse', 'Supply Cache'},
        Swamp = {'Curse', 'Epiphany'},
        Forest = {'Shroud', 'Vanishing Dust'},
        Ruins = {'Shroud', 'Mystery'},
        Monastery = {'Curse'}
    },
    {
        GUID = '15e9a2',
        Quest = '',
        Mountains = {'Decay', 'Tome of Retraining'},
        Castle = {'Decay', 'Skull Token'},
        Village = {'Curse', 'Treasure Chest'},
        Swamp = {'Shades', 'Inspiration'},
        Forest = {'Zombies', 'Treasure Chest'},
        Ruins = {'Oblivion', 'Tome of Retraining'},
        Monastery = {'Decay'}
    },
    {
        GUID = '3a507a',
        Quest = '',
        Mountains = {'Taint', 'Supply Cache'},
        Castle = {'Shroud', 'Supply Cache'},
        Village = {'Zombies', 'Treasure Chest'},
        Swamp = {'Shades', 'Bottled Magic'},
        Forest = {'Zombies', 'Mystery'},
        Ruins = {'Skeletons', 'Mystery'},
        Monastery = {'Taint'}
    },
    {
        GUID = '5a790c',
        Quest = '',
        Mountains = {'Shades', 'Mystery'},
        Castle = {'Lich', 'Vanishing Dust'},
        Village = {'Curse', 'Vanishing Dust'},
        Swamp = {'Taint', 'Waystone'},
        Forest = {'Lich', 'Vanishing Dust'},
        Ruins = {'Skeletons', 'Mystery'},
        Monastery = {'Curse'}
    },
    {
        GUID = 'bea484',
        Quest = 'Castle',
        Mountains = {'Zombies', 'Mystery'},
        Castle = {'Skeletons', 'Supply Cache'},
        Village = {'Skeletons', 'Mystery'},
        Swamp = {'Shades', 'Bottled Magic'},
        Forest = {'Shades', 'Supply Cache'},
        Ruins = {'Zombies', 'Treasure Chest'},
        Monastery = {'Taint'}
    },
    {
        GUID = '353ca1',
        Quest = '',
        Mountains = {'Oblivion', 'Forgotten Shrine'},
        Castle = {'Shades', 'Cursed Ashes'},
        Village = {'Stigma', 'Mystery'},
        Swamp = {'Zombies', 'Psion Stone'},
        Forest = {'Stigma', 'Mystery'},
        Ruins = {'Skeletons', 'Revelation'},
        Monastery = {'Decay'}
    },
    {
        GUID = '250362',
        Quest = '',
        Mountains = {'Specters', 'Forgotten Shrine'},
        Castle = {'Crows', 'Supply Cache'},
        Village = {'Wraiths', 'Skull Token'},
        Swamp = {'Revenants', 'Tome of Retraining'},
        Forest = {'Stigma', 'Treasure Chest'},
        Ruins = {'Terror', 'Stardust'},
        Monastery = {'Terror'}
    },
    {
        GUID = 'c97c0f',
        Quest = '',
        Mountains = {'Vampire', 'Mystery'},
        Castle = {'Curse', 'Treasure Chest'},
        Village = {'Zombies', 'Mystery'},
        Swamp = {'Skeletons', 'Artifact'},
        Forest = {'Vampire', 'Treasure Chest'},
        Ruins = {'Shroud', 'Mystery'},
        Monastery = {'Curse'}
    },
    {
        GUID = 'd5592a',
        Quest = '',
        Mountains = {'Lich', 'Treasure Chest'},
        Castle = {'Desecration', 'Mystery'},
        Village = {'Confusion', 'Treasure Chest'},
        Swamp = {'Lich', 'Mystery'},
        Forest = {'Dark Fog', 'Mystery'},
        Ruins = {'Unholy Aura', 'Mystery'},
        Monastery = {'Spies'}
    },
    {
        GUID = '04b12d',
        Quest = 'Village',
        Mountains = {'Specters', 'Artifact'},
        Castle = {'Terror', 'Supply Cache'},
        Village = {'Revenants', 'Treasure Chest'},
        Swamp = {'Specters', 'Epiphany'},
        Forest = {'Terror', 'Artifact'},
        Ruins = {'Wraiths', 'Charm'},
        Monastery = {'Stigma'}
    },
    {
        GUID = 'fdb0d1',
        Quest = '',
        Mountains = {'Terror', 'Mystery'},
        Castle = {'Wraiths', 'Psion Stone'},
        Village = {'Revenants', 'Soothing Lyre'},
        Swamp = {'Revenants', 'Inspiration'},
        Forest = {'Crows', 'Mystery'},
        Ruins = {'Specters', 'Mystery'},
        Monastery = {'Stigma'}
    },
    {
        GUID = 'c22b76',
        Quest = '',
        Mountains = {'Evil Presence', 'Forgotten Shrine'},
        Castle = {'Unholy Aura', 'Treasure Chest'},
        Village = {'Evil Presence', 'Forgotten Shrine'},
        Swamp = {'Zombies', 'Bottled Magic'},
        Forest = {'Unholy Aura', 'Treasure Chest'},
        Ruins = {'Evil Presence', 'Forgotten Shrine'},
        Monastery = {'Taint'}
    },
    {
        GUID = '2e5db3',
        Quest = '',
        Mountains = {'Skeletons', 'Treasure Chest'},
        Castle = {'Shades', 'Treasure Chest'},
        Village = {'Shades', 'Supply Cache'},
        Swamp = {'Shroud', 'Artifact'},
        Forest = {'Skeletons', 'Supply Cache'},
        Ruins = {'Shades', 'Supply Cache'},
        Monastery = {'Taint'}
    },
    {
        GUID = '9a3302',
        Quest = '',
        Mountains = {'Flux Cage', 'Psion Stone'},
        Castle = {'Wraiths', 'Treasure Chest'},
        Village = {'Omen', 'Mystery'},
        Swamp = {'Wraiths', 'Bottled Magic'},
        Forest = {'Terror', 'Mystery'},
        Ruins = {'Revenants', 'Mystery'},
        Monastery = {'Flux Cage'}
    },
    {
        GUID = '7c1486',
        Quest = 'Village',
        Mountains = {'Enigma', 'Forgotten Shrine'},
        Castle = {'Decay', 'Psion Stone'},
        Village = {'Zombies', 'Tome of Retraining'},
        Swamp = {'Shades', 'Epiphany'},
        Forest = {'Vampire', 'Cursed Ashes'},
        Ruins = {'Nexus', 'Stardust'},
        Monastery = {'Taint'}
    },
    {
        GUID = 'd03cc4',
        Quest = 'Mountains',
        Mountains = {'Shades', 'Treasure Chest'},
        Castle = {'Skeletons', 'Treasure Chest'},
        Village = {'Zombies', 'Artifact'},
        Swamp = {'Shades', 'Bottled Magic'},
        Forest = {'Zombies', 'Mystery'},
        Ruins = {'Skeletons', 'Mystery'},
        Monastery = {'Taint'}
    },
    {
        GUID = 'd54c4b',
        Quest = 'Ruins',
        Mountains = {'Wraiths', 'Stardust'},
        Castle = {'Curse', 'Treasure Chest'},
        Village = {'Vampire', 'Treasure Chest'},
        Swamp = {'Lich', 'Epiphany'},
        Forest = {'Decay', 'Charm'},
        Ruins = {'Lich', 'Stardust'},
        Monastery = {'Decay'}
    },
    {
        GUID = '8536eb',
        Quest = 'Forest',
        Mountains = {'Vampire', 'Stardust'},
        Castle = {'Lich', 'Revelation'},
        Village = {'Oblivion', 'Treasure Chest'},
        Swamp = {'Curse', 'Epiphany'},
        Forest = {'Wraiths', 'Mystery'},
        Ruins = {'Decay', 'Revelation'},
        Monastery = {'Oblivion'}
    },
    {
        GUID = '87779a',
        Quest = 'Castle',
        Mountains = {'Wraiths', 'Treasure Chest'},
        Castle = {'Flux Cage', 'Cursed Ashes'},
        Village = {'Flux Cage', 'Supply Cache'},
        Swamp = {'Gate', 'Psion Stone'},
        Forest = {'Wraiths', 'Mystery'},
        Ruins = {'Specters', 'Revelation'},
        Monastery = {'Flux Cage'}
    },
    {
        GUID = '4c5437',
        Quest = '',
        Mountains = {'Curse', 'Supply Cache'},
        Castle = {'Unholy Aura', 'Waystone'},
        Village = {'Lich', 'Treasure Chest'},
        Swamp = {'Confusion', 'Epiphany'},
        Forest = {'Dark Fog', 'Treasure Chest'},
        Ruins = {'Lich', 'Supply Cache'},
        Monastery = {'Desecration'}
    },
    {
        GUID = '30708b',
        Quest = 'Ruins',
        Mountains = {'Shades', 'Artifact'},
        Castle = {'Skeletons', 'Supply Cache'},
        Village = {'Enigma', 'Treasure Chest'},
        Swamp = {'Nexus', 'Epiphany'},
        Forest = {'Omen', 'Treasure Chest'},
        Ruins = {'Shroud', 'Mystery'},
        Monastery = {'Enigma'}
    },
    {
        GUID = '04f478',
        Quest = '',
        Mountains = {'Desecration', 'Treasure Chest'},
        Castle = {'Spies', 'Supply Cache'},
        Village = {'Dark Fog', 'Treasure Chest'},
        Swamp = {'Corruption', 'Epiphany'},
        Forest = {'Confusion', 'Mystery'},
        Ruins = {'Spies', 'Mystery'},
        Monastery = {'Desecration'}
    },
    {
        GUID = 'cb44b9',
        Quest = '',
        Mountains = {'Desecration', 'Waystone'},
        Castle = {'Dark Fog', 'Supply Cache'},
        Village = {'Spies', 'Treasure Chest'},
        Swamp = {'Corruption', 'Artifact'},
        Forest = {'Desecration', 'Treasure Chest'},
        Ruins = {'Corruption', 'Treasure Chest'},
        Monastery = {'Confusion'}
    },
    {
        GUID = '3fb4cc',
        Quest = '',
        Mountains = {'Void', 'Artifact'},
        Castle = {'Void', 'Supply Cache'},
        Village = {'Confusion', 'Charm'},
        Swamp = {'Corruption', 'Inspiration'},
        Forest = {'Dark Fog', 'Tome of Retraining'},
        Ruins = {'Gate', 'Psion Stone'},
        Monastery = {'Stigma'}
    },
    {
        GUID = 'ac0b3b',
        Quest = 'Forest',
        Mountains = {'Omen', 'Artifact'},
        Castle = {'Crows', 'Mystery'},
        Village = {'Webs', 'Mystery'},
        Swamp = {'Webs', 'Epiphany'},
        Forest = {'Omen', 'Treasure Chest'},
        Ruins = {'Webs', 'Mystery'},
        Monastery = {'Webs'}
    },
    {
        GUID = '9b4232',
        Quest = '',
        Mountains = {'Stigma', 'Stardust'},
        Castle = {'Dark Fog', 'Artifact'},
        Village = {'Gate', 'Psion Stone'},
        Swamp = {'Confusion', 'Bottled Magic'},
        Forest = {'Void', 'Supply Cache'},
        Ruins = {'Void', 'Skull Token'},
        Monastery = {'Desecration'}
    },
    {
        GUID = '236a37',
        Quest = '',
        Mountains = {'Corruption', 'Forgotten Shrine'},
        Castle = {'Spies', 'Mystery'},
        Village = {'Spies', 'Treasure Chest'},
        Swamp = {'Confusion', 'Epiphany'},
        Forest = {'Spies', 'Mystery'},
        Ruins = {'Desecration', 'Artifact'},
        Monastery = {'Spies'}
    },
    {
        GUID = '4efa5a',
        Quest = '',
        Mountains = {'Void', 'Mystery'},
        Castle = {'Gate', 'Soothing Lyre'},
        Village = {'Stigma', 'Revelation'},
        Swamp = {'Corruption', 'Inspiration'},
        Forest = {'Void', 'Artifact'},
        Ruins = {'Omen', 'Revelation'},
        Monastery = {'Desecration'}
    },
    {
        GUID = '18c8e0',
        Quest = '',
        Mountains = {'Corruption', 'Mystery'},
        Castle = {'Confusion', 'Treasure Chest'},
        Village = {'Spies', 'Treasure Chest'},
        Swamp = {'Desecration', 'Epiphany'},
        Forest = {'Dark Fog', 'Mystery'},
        Ruins = {'Spies', 'Mystery'},
        Monastery = {'Spies'}
    },
    {
        GUID = '8b4808',
        Quest = 'Swamp',
        Mountains = {'Corruption', 'Forgotten Shrine'},
        Castle = {'Flux Cage', 'Treasure Chest'},
        Village = {'Flux Cage', 'Cursed Ashes'},
        Swamp = {'Void', 'Bottled Magic'},
        Forest = {'Webs', 'Charm'},
        Ruins = {'Flux Cage', 'Skull Token'},
        Monastery = {'Spies'}
    },
    {
        GUID = '1b1984',
        Quest = '',
        Mountains = {'Crows', 'Mystery'},
        Castle = {'Webs', 'Supply Cache'},
        Village = {'Omen', 'Treasure Chest'},
        Swamp = {'Webs', 'Artifact'},
        Forest = {'Webs', 'Treasure Chest'},
        Ruins = {'Crows', 'Mystery'},
        Monastery = {'Webs'}
    },
    {
        GUID = '6ca99b',
        Quest = 'Ruins',
        Mountains = {'Confusion', 'Supply Cache'},
        Castle = {'Dark Fog', 'Treasure Chest'},
        Village = {'Corruption', 'Supply Cache'},
        Swamp = {'Desecration', 'Vanishing Dust'},
        Forest = {'Confusion', 'Waystone'},
        Ruins = {'Dark Fog', 'Mystery'},
        Monastery = {'Corruption'}
    },
    {
        GUID = '6fcd83',
        Quest = 'Mountains',
        Mountains = {'Void', 'Tome of Retraining'},
        Castle = {'Webs', 'Skull Token'},
        Village = {'Flux Cage', 'Artifact'},
        Swamp = {'Confusion', 'Bottled Magic'},
        Forest = {'Omen', 'Cursed Ashes'},
        Ruins = {'Flux Cage', 'Revelation'},
        Monastery = {'Spies'}
    },
    {
        GUID = '8f1a85',
        Quest = '',
        Mountains = {'Taint', 'Artifact'},
        Castle = {'Unholy Aura', 'Treasure Chest'},
        Village = {'Webs', 'Treasure Chest'},
        Swamp = {'Omen', 'Epiphany'},
        Forest = {'Shroud', 'Mystery'},
        Ruins = {'Nexus', 'Mystery'},
        Monastery = {'Nexus'}
    },
    {
        GUID = 'e888f8',
        Quest = '',
        Mountains = {'Shroud', 'Mystery'},
        Castle = {'Enigma', 'Treasure Chest'},
        Village = {'Crows', 'Treasure Chest'},
        Swamp = {'Nexus', 'Epiphany'},
        Forest = {'Webs', 'Mystery'},
        Ruins = {'Unholy Aura', 'Mystery'},
        Monastery = {'Enigma'}
    },
    {
        GUID = 'e304c5',
        Quest = '',
        Mountains = {'Omen', 'Forgotten Shrine'},
        Castle = {'Omen', 'Supply Cache'},
        Village = {'Omen', 'Treasure Chest'},
        Swamp = {'Taint', 'Artifact'},
        Forest = {'Enigma', 'Mystery'},
        Ruins = {'Enigma', 'Mystery'},
        Monastery = {'Nexus'}
    },
    {
        GUID = 'b24b41',
        Quest = 'Castle',
        Mountains = {'Gate', 'Revelation'},
        Castle = {'Nexus', 'Tome of Retraining'},
        Village = {'Corruption', 'Supply Cache'},
        Swamp = {'Enigma', 'Tome of Retraining'},
        Forest = {'Confusion', 'Charm'},
        Ruins = {'Oblivion', 'Revelation'},
        Monastery = {'Void'}
    },
    {
        GUID = 'f70d10',
        Quest = '',
        Mountains = {'Oblivion', 'Forgotten Shrine'},
        Castle = {'Flux Cage', 'Artifact'},
        Village = {'Gate', 'Mystery'},
        Swamp = {'Nexus', 'Inspiration'},
        Forest = {'Flux Cage', 'Supply Cache'},
        Ruins = {'Evil Presence', 'Revelation'},
        Monastery = {'Spies'}
    },
    {
        GUID = 'b53aff',
        Quest = 'Village',
        Mountains = {'Unholy Aura', 'Mystery'},
        Castle = {'Evil Presence', 'Bottled Magic'},
        Village = {'Evil Presence', 'Mystery'},
        Swamp = {'Unholy Aura', 'Treasure Chest'},
        Forest = {'Evil Presence', 'Mystery'},
        Ruins = {'Unholy Aura', 'Mystery'},
        Monastery = {'Unholy Aura'}
    },
    {
        GUID = 'f367e6',
        Quest = '',
        Mountains = {'Oblivion', 'Psion Stone'},
        Castle = {'Oblivion', 'Soothing Lyre'},
        Village = {'Oblivion', 'Stardust'},
        Swamp = {'Decay', 'Inspiration'},
        Forest = {'Stigma', 'Revelation'},
        Ruins = {'Decay', 'Revelation'},
        Monastery = {'Oblivion'}
    },
    {
        GUID = 'c19a9b',
        Quest = '',
        Mountains = {'Taint', 'Artifact'},
        Castle = {'Crows', 'Treasure Chest'},
        Village = {'Crows', 'Supply Cache'},
        Swamp = {'Taint', 'Epiphany'},
        Forest = {'Crows', 'Treasure Chest'},
        Ruins = {'Shroud', 'Artifact'},
        Monastery = {'Taint'}
    }
}