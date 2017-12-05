function Local.Init()
    print("Game Manager Started");
    Scene:getGameObject("inventory"):setVisible(false);
    Object.started = false;
    Object.biers = { false, false, false };
    Object.pan = false;
    Object.cMusic = "";
    Object.emptyTape = false;
    Object.currentPic = 1;
    overlay = Scene:getGameObject("overlay"):Get();
    sorry = obe.Sound("Sounds/sorry.ogg");
    sorry:play();
end

function Global.Actions.Enter()
    if not Object.started then
        Scene:loadFromFile("map_1.map.vili");
        Object.started = true;
    end
end

function Global.Scene.MapLoaded(name)
    overlay:clear();
    overlay:render();
    print("A MAP HAS BEEN LOADED", name);

    if name == "bar.map.vili" then
        LoadBar();
    elseif name == "shop.map.vili" then
        LoadShop();
    elseif name == "map_1.map.vili" then
        LoadMap1();
    elseif name == "oldhouse.map.vili" then
        LoadOldHouse();
    elseif name == "swings.map.vili" then
        LoadSwings();
    elseif name == "kiosk.map.vili" then
        LoadKiosk();
    elseif name == "fountain.map.vili" then
        LoadFountain();
    elseif name == "hospital.map.vili" then
        LoadHospital();
    end
end

function LoadBar()
    for i, bier in pairs(Object.biers) do 
        if bier then
            Scene:getGameObject("bier" .. tostring(i)):remove();
        end
    end
end

function LoadShop()
    if Object.pan then
        Scene:getGameObject("pan"):remove();
    end
end

function LoadMap1()
    if Object.cMusic ~= "m1" then
        music = obe.Music("Sounds/map_1.ogg");
        Object.cMusic = "m1";
        music:play();
        music:setVolume(60);
    end
end

function LoadOldHouse()
    if Object.recorder then
        Scene:getGameObject("recorder"):remove();
    end
end

function LoadSwings()
    if Object.coin_swing then
        Scene:getGameObject("coin_swing"):remove();
    end
    if Object.billy then
        Scene:getGameObject("billy"):remove();
    end
end

function LoadKiosk()
    if Object.coin_kiosk then
        Scene:getGameObject("coin_kiosk"):remove();
    end
end

function LoadFountain()
    if Object.coin_fountain then
        Scene:getGameObject("coin_fountain"):remove();
    end
end

function LoadHospital()
    if Object.coin_hospital then
        Scene:getGameObject("coin_hospital"):remove();
    end
    if Object.tnc then
        Scene:getGameObject("toenailclipper"):remove();
    end
end