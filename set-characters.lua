function onLoad()
    self.createButton({
        click_function = "setCharacters", 
        function_owner = Global,
        label          = "Set Characters",
        position       = {0,0,0},
        rotation       = {0,0,0},
        width          = 850,
        height         = 200,
        font_size      = 100,
        color          = {0, 0, 0},
        font_color     = {1, 1, 1},
    })
end
