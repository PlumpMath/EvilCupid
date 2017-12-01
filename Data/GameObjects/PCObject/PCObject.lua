function Local.Init(behaviour)
    if not Object.disabled then
        Object.type = behaviour;
        Object.name = This:getId();
        Object.sprite = Scene:doesLevelSpriteExists(Object.name) and Scene:getLevelSprite(Object.name) or nil;
        Object.collider = Scene:getCollider(Object.name);
        Object.behavior = Objects[behaviour];
        Object.onUpdate = {};
        overlay = Scene:getGameObject("overlay"):Get();
        if Object.behavior.oncreate then
            Object.behavior.oncreate(Object);
        end
    end
end

function Object:pick()
    if not Scene:doesLevelSpriteExists("got") then
        Object.pickEffect = Scene:createLevelSprite("got");
        Object.pickEffect:loadTexture("Sprites/LevelSprites/got.png");
        Object.pickEffect:setZDepth(2);
        Object.pickEffect:useTextureSize();
        --Object.pickEffect:setSize(obe.UnitVector(0, 0.8, obe.Units.ViewPercentage));
        Object.pickEffect:setPosition(obe.UnitVector(0.5, 0.5, obe.Units.ViewPercentage), obe.Referencial.Center);
        Object.pickChrono = obe.Chronometer();
        Object.pickChrono:setLimit(2000);
        Object.pickChrono:start();
        Object.sprite:scale(obe.UnitVector(3, 3));
        Object.sprite:setPosition(obe.UnitVector(0.5, 0.5, obe.Units.ViewPercentage), obe.Referencial.Center);
        Scene:removeCollider(self.name);
        overlay:Text("picked")({
            text = "YOU PICKED A " .. self.type:upper() .. " !", size = 80, font = "Data/Fonts/FluoGums.ttf",
            x = obe.Screen.Width / 2, y = obe.Screen.Height / 4, align = { h = "Center", v = "Center"}
        });
        overlay:render();
        Object.onUpdate = {};
        Object.behavior = {};
        Object.disabled = true;
        return true;
    end

    return false;
end

function Object:remove()
    Scene:removeCollider(self.id);
    Scene:removeLevelSprite(Object.id);
    Object.onUpdate = {};
    Object.behavior = {};
    Object.disabled = true;
end

function Global.Game.Update(dt)
    if Object.pickEffect then
        Object.pickEffect:rotate(180 * dt);
        if Object.pickChrono:limitExceeded() then
            Scene:removeLevelSprite("got");
            Scene:removeLevelSprite(Object.name);
            Object.pickEffect = nil;
            Object.pickChrono = nil;
            overlay:remove("picked");
            overlay:render();
        end
    end
    if Object.behavior.onupdate then
        Object.behavior.onupdate(Object, dt);
    end
    for key, update in pairs(Object.onUpdate) do 
        if not update(Object, dt) then
            Object.onUpdate[key] = nil;
        end
    end
end

function Global.Actions.Click()
    if not Object.disabled then
        local cursorCollider = obe.PolygonalCollider("cursor");
        cursorCollider:addPoint(obe.UnitVector(Cursor:getX(), Cursor:getY(), obe.Units.WorldPixels));
        if cursorCollider:doesCollide(Object.collider, obe.UnitVector(0, 0)) and Object.behavior.onclick then
            Object.behavior.onclick(Object);
        end
    end
end

function Object:say(text)
    overlay:remove("pcobj_" .. self.name .. "_say");
    overlay:render();
    local pixelPos = (self.sprite:getPosition() + obe.UnitVector(self.sprite:getSize().x / 2, 0)):to(obe.Units.WorldPixels);

    self.sayText = overlay:Text("pcobj_" .. self.name .. "_say")({
        text = text, size = 20,
        x = pixelPos.x, y = pixelPos.y, align = { h = "Center", v = "Center"}
    });
    self.sayChrono = obe.Chronometer();
    self.sayChrono:setLimit(text:len() * 150);
    self.sayChrono:start();
    overlay:render();
    self.onUpdate.say = function(self, dt)
        self.sayText.y = self.sayText.y - 100 * dt * (10 / text:len());
        overlay:render();
        if self.sayChrono:limitExceeded() then
            overlay:remove("pcobj_" .. self.name .. "_say");
            overlay:render();
            self.sayChrono = nil;
            self.sayText = nil;
            return false;
        end
        return true;
    end
end