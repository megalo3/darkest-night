AddDarknessScript = nil

function onLoad()
    AddDarknessScript = getObjectFromGUID('a4642e')
    self.createButton({
        click_function = "decreaseDarkness", 
        function_owner = self,
        label          = "-",
        position       = {1.7,0,0},
        rotation       = {0,0,0},
        width          = 125,
        height         = 125,
        font_size      = 100,
        scale          = {5, 1, 5},
        color          = {0/255,255/255,130/255,0.75},
        font_color     = {0,0,0,1},
    })
    self.createButton({
        click_function = "increaseDarkness", 
        function_owner = self,
        label          = "+",
        position       = {3.2,0,0},
        rotation       = {0,0,0},
        width          = 125,
        height         = 125,
        font_size      = 100,
        scale          = {5, 1, 5},
        color          = {0/255,255/255,130/255,0.75},
        font_color     = {0,0,0,1},
    })

end

function increaseDarkness() AddDarknessScript.call('increaseDarkness') end
function decreaseDarkness() AddDarknessScript.call('decreaseDarkness') end