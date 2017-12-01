function Local.Init()
    This:LevelSprite():useTextureSize();
    This:LevelSprite():setPosition(obe.UnitVector(Cursor:getX() - 14, Cursor:getY() - 7, obe.Units.WorldPixels));
    Cursor:hide();
end

function Global.Cursor.CursorMoved(x, y)
    This:LevelSprite():setPosition(obe.UnitVector(x - 14, y - 7, obe.Units.WorldPixels));
    if CheckHovering(x, y) then
        This:LevelSprite():loadTexture("Sprites/LevelSprites/pointer.png");
    else
        This:LevelSprite():loadTexture("Sprites/LevelSprites/cursor.png");
    end
end

function CheckHovering(x, y)
    local cursorCollider = obe.PolygonalCollider("cursor");
    cursorCollider:addPoint(obe.UnitVector(x, y, obe.Units.WorldPixels));
    for _, col in pairs(Scene:getAllColliders()) do
        if cursorCollider:doesCollide(col, obe.UnitVector(0, 0)) then
            return true;
        end
    end
    return false;
end