MapDeckScript = nil

function onLoad()
    MapDeckScript = getObjectFromGUID('89075e')  
    self.createButton({
        click_function = "drawMap", 
        function_owner = self,
        label          = "Draw Map",
        position       = {0,0,0},
        rotation       = {0,0,0},
        width          = 500,
        height         = 200,
        font_size      = 100,
        color          = {0,0,0},
        font_color     = {1, 1, 1},
    })  
end

function drawMap(o, c, a) 
    MapDeckScript.call('drawMapCard')
end