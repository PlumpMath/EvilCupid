function Local.Init()
    local pSize = This:LevelSprite():getSize():to(obe.Units.WorldPixels);
    canvas = obe.Canvas.Canvas(math.floor(pSize.x), math.floor(pSize.y));

    canvas:Rectangle("background")({
        width = pSize.x, height = pSize.y,
        color = "333", layer = 4
    });

    zones = {};
    rectsize = pSize.x - (pSize.x / 4);
    hoffset = pSize.x / 8;

    Object.current = -1;
    Object.combine = -1;

    for i = 0, 9, 1 do
        local rect = canvas:Rectangle("case_" .. tostring(i))({
            x = hoffset, width = rectsize,
            y = 20 + i * 105, height = rectsize,
            color = "444", outline = {
                color = "FFF", thickness = 2
            }, layer = 3
        });

        local circle = canvas:Circle("amt_circle_" .. tostring(i))({
            x = hoffset + rectsize - 8, y = 20 + i * 105 + rectsize - 8, radius = 10, color = "999", layer = 2
        });

        local text = canvas:Text("amt_text_" .. tostring(i))({
            x = hoffset + rectsize - 2, y = 20 + i * 105 + rectsize - 8, text = "0", size = 16, color = "FFF", layer = 1
        });

        local zone = Object:MakeCase(i, Scene:createCollider("case_" .. tostring(i)), rect, text, circle);
        zone.col:addPoint(obe.UnitVector(hoffset, 20 + i * 105, obe.Units.WorldPixels));
        zone.col:addPoint(obe.UnitVector(hoffset + rectsize, 20 + i * 105, obe.Units.WorldPixels));
        zone.col:addPoint(obe.UnitVector(hoffset + rectsize, 20 + i * 105 + rectsize, obe.Units.WorldPixels));
        zone.col:addPoint(obe.UnitVector(pSize.x / 10, 20 + i * 105 + rectsize, obe.Units.WorldPixels));
        zone.col:setParentId(This:getId());
        table.insert(zones, zone);
    end

    canvas:setTarget(This:LevelSprite());

    Object:refresh();
end

function Object:getZones()
    return zones;
end

function Object:MakeCase(index, collider, rect, text, circle)
    return {
        index = index,
        col = collider,
        rect = rect,
        text = text,
        circle = circle,
        stack = 0,
        remove = function(self, amount)
            amount = amount or 1;
            if self.object ~= nil then
                self.stack = self.stack - amount;
                if self.stack < 0 then
                    error("Removed too much items in case " .. tostring(index));
                elseif self.stack == 0 then
                    self.object = nil;
                    Scene:removeLevelSprite(self.sprite:getId());
                    self.sprite = nil;
                    --self.sprite:setPosition(obe.UnitVector(-1000, -1000));
                    self.text.text = tostring(self.stack);
                else
                    self.text.text = tostring(self.stack);
                end
            end
            Object:reorganize();
            Object:refresh();
        end
    }
end

function Global.Actions.Click()
    local cursorCollider = obe.PolygonalCollider("cursor");
    cursorCollider:addPoint(obe.UnitVector(Cursor:getX(), Cursor:getY(), obe.Units.WorldPixels));
    for index, zone in pairs(zones) do
        if cursorCollider:doesCollide(zone.col, obe.UnitVector(0, 0)) then
            print(zone.col:getId());
            for _, zone in pairs(zones) do
                zone.rect.outline.color = "FFF";
            end
            if Object.current ~= index then
                zone.rect.outline.color = "F00";
                Object.current = index;
                if zone.object and zone.object.onselect then
                    zone.object.onselect(zone.object, Object);
                end
            else
                zone.rect.outline.color = "FFF";
                Object.current = -1;
                if zone.object and zone.object.unonselect then
                    zone.object.onunselect(zone.object, Object);
                end
            end
        end
    end
    Object:refresh();
end

function Global.Actions.Combine()
    print("GRAGROUH COMBINE");
    local cursorCollider = obe.PolygonalCollider("cursor");
    cursorCollider:addPoint(obe.UnitVector(Cursor:getX(), Cursor:getY(), obe.Units.WorldPixels));
    for index, zone in pairs(zones) do
        if cursorCollider:doesCollide(zone.col, obe.UnitVector(0, 0)) then
            for _, zone in pairs(zones) do
                zone.rect.outline.color = "FFF";
            end
            if Object.combine == -1 then
                Object.combine = index;
                Object.current = -1;
                zone.rect.outline.color = "0F0";
            else
                if zones[Object.combine].object.oncombine then
                    zones[Object.combine].object.oncombine(Object, zones[Object.combine], zone);
                end
                Object.combine = -1;
                Object.current = -1;
            end
        end
    end
    Object:refresh();
end

function Object:reorganize()
    print("Reorganizing inventory");
    local fz = -1;
    for i, zone in pairs(zones) do
        print("Iterating on ", i);
        if zone.object == nil and fz == -1 then
            fz = i;
            print("Found empty case at : ", fz);
        end
        if zone.object and fz ~= -1 then
            zones[fz].object = zone.object;
            zones[fz].stack = zone.stack;
            zones[fz].sprite = zone.sprite;
            
            
            print("Swapping case", i, "(", zone.object.name, ") to empty case", fz);
            zone.stack = 0;
            zone.object = nil;
            zone.sprite = nil;
            for j, tzone in pairs(zones) do
                if tzone.object == nil then
                    fz = j;
                    print("Found next empty case at : ", fz);
                    break;
                end
            end
        end
    end
    print("Rendering");
    self:refresh();
end

function Object:refresh()
    for i, zone in pairs(zones) do
        if zone.sprite then
            zone.sprite:setPosition(obe.UnitVector(hoffset + 2, 20 + (i - 1) * 105, obe.Units.WorldPixels));
            zone.sprite:setParentId(This:getId());
        end
        if zone.stack == 0 then
            zone.text.visible = false;
            zone.circle.visible = false;
        elseif zone.stack > 0 then
            zone.text.visible = true;
            zone.circle.visible = true;
            zone.text.text = tostring(zone.stack);
        end
    end
    canvas:render();
end

function Object:add(object)
    print("Adding", object);
    for i, zone in pairs(zones) do
        if not zone.object then
            zone.object = Objects[object];

            zone.sprite = Scene:createLevelSprite(zone.object.name .. tostring(i));
            zone.sprite:loadTexture(zone.object.icon);
            zone.sprite:setPosition(obe.UnitVector(hoffset + 2, 20 + (i - 1) * 105, obe.Units.WorldPixels));
            zone.sprite:setSize(obe.UnitVector(rectsize, rectsize, obe.Units.WorldPixels));

            zone.stack = 1;

            self:refresh();
            return i;
        elseif zone.object.name == Objects[object].name then
            print(zone.stack, "VS", zone.object.maxstack);
            if zone.stack < zone.object.maxstack then
                zone.stack = zone.stack + 1;
                self:refresh();
                return i;
            end
        end
    end
    self:refresh();
    return -1;
end

function Object:getSelected()
    return zones[Object.current];
end

function Object:setVisible(visible)
    for i, zone in pairs(zones) do
        if zone.sprite then
            zone.sprite:setVisible(visible);
        end
    end
    This:LevelSprite():setVisible(visible);
end