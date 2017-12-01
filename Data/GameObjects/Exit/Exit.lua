function Local.Init(location)
    Object.location = location;
    This:LevelSprite():setPosition(obe.UnitVector(3.172222, 0.031481));
end

function Global.Actions.Click()
    local cursorCollider = obe.PolygonalCollider("cursor");
    cursorCollider:addPoint(obe.UnitVector(Cursor:getX(), Cursor:getY(), obe.Units.WorldPixels));
    if cursorCollider:doesCollide(This:Collider(), obe.UnitVector(0, 0)) then
        Scene:loadFromFile(Object.location);
    end
end