function Local.Init()
    Object.canvas = obe.Canvas.Canvas(obe.Screen.Width, obe.Screen.Height);
    Object.canvas:setTarget(This:LevelSprite());
    Object.canvas:render();
end

function Object:Get()
    return self.canvas;
end