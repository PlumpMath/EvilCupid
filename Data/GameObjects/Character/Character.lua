function Local.Init(VNscene, name)
    scene = VNscene;
    characterName = name;
    print("init Character "..characterName)
    parser = Vili.ViliParser.new();
    parser:parseFile(obe.Path("Data/GameObjects/Character/characters.vili"):find());
    characterExpression = parser:root():at(characterName):at("expressions"):getDataNode("default"):getString();
    Scene:createLevelSprite(characterName);
    character_sprite = Scene:getLevelSprite(characterName);
    character_sprite:setLayer(0);
    character_sprite:setZDepth(2);
    Object:setExpression(characterExpression);
end

function Object:hide()
    character_sprite:setVisible(false);
end

function Object:show()
    character_sprite:setVisible(true);
end

function Object:say(tab)
    scene:getVN():addSayQueue(characterName, tab.text, tab.font, tab.color, tab.textBackground, tab.before, tab.after);
end

function Object:ask(tab)
    scene:getVN():addAskQueue(characterName, tab.question, tab.answers, tab.font, tab.color, tab.textBackground, tab.before, tab.after);
end

function Object:expression(tab)
    scene:getVN():addExpressionQueue(characterName, tab.expression, tab.before, tab.after);
end

function Object:setExpression(expression)
    characterExpression = expression;
    local spritePath = parser:root():at(characterName):at("expressions"):at(characterExpression):getDataNode("sprite"):getString();
    character_sprite:loadTexture(spritePath);
    character_sprite:useTextureSize();
    character_sprite:setPosition(Scene:getCamera():getPosition(obe.Referencial.Center), obe.Referencial.Center);
end

function Object:getExpression()
    return characterExpression;
end