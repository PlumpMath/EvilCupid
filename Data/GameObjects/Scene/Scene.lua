function Local.Init(VisualNovel, name)
    sceneName = name;
    visualNovel = VisualNovel;
    print("init Scene "..sceneName)
    characters = {};

    local parser = Vili.ViliParser.new();
    parser:parseFile(obe.Path("Data/GameObjects/Scene/scenes.vili"):find());
    local spritePath = parser:root():at(sceneName):getDataNode("background"):getString();
    Scene:createLevelSprite(sceneName);
    background_sprite = Scene:getLevelSprite(sceneName);
    background_sprite:loadTexture(spritePath);
    background_sprite:useTextureSize();
    background_sprite:setLayer(0);
    background_sprite:setZDepth(3);
    background_sprite:setPosition(Scene:getCamera():getPosition(obe.Referencial.Center), obe.Referencial.Center);
end

function Object:character(name)
    local newCharac = Scene:createGameObject("Character", name)({VNscene = Object, name = name});
    table.insert(characters, newCharac);
    return newCharac;
end

function Object:getVN()
    return visualNovel;
end

function Object:getName()
    return sceneName;
end