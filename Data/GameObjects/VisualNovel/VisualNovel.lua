function Local.Init()
    print("init VN")
    InitializeBindings();
    currentScene = nil;
    queue = {};
    isAsking = false;
    Object.answer = nil;
    Scene:createLevelSprite("textBackground_sprite");
    textBackground_sprite = Scene:getLevelSprite("textBackground_sprite");
    textBackground_sprite:setVisible(false);
    local pSize = This:LevelSprite():getSize():to(obe.Units.WorldPixels);
    canvas = obe.Canvas.Canvas(pSize.x, pSize.y);
    canvas:setTarget(This:LevelSprite());
    canvas:render();
    canvasText = canvas:Text("text")({});
    
    print(This:LevelSprite():getSize().x, This:LevelSprite():getSize().y)
end

function InitializeBindings()
    Global.Actions["Enter"] = function()
        print("HEHEHEHE");
        if isAsking == false and #queue > 0 then
            Object:next();
        end
    end
    for i = 1, 4 do
        Global.Actions["Answer_"..i] = function()
            print("Object.answer "..i)
            if isAsking then
                print("asking")
                Object.answer = i
                isAsking = false;
                if #queue > 0 then
                    Object:next();
                end
            end
        end
    end
end

function Object:getAnswer()
    return Object.answer;
end

function Object:next()
    if queue[1].type == "expression" then
        expression(table.remove(queue, 1));
    end
    if queue[1].type == "say" then
        say(table.remove(queue, 1));
    elseif queue[1].type == "ask" then
        ask(table.remove(queue, 1));
    end
end;

function Object:character(name)
    return currentScene:character(name);
end

function Object:scene(name)
    print("creating Scene "..name)
    currentScene = Scene:createGameObject("Scene")({VisualNovel = Object, name = name});
    return currentScene;
end

function Object:addExpressionQueue(character, expression, before, after)
    print("add expression to queue : ",character,expression)
    table.insert(queue, {type = "expression", character = character, expression = expression, before = before, after = after});    
end

function Object:addSayQueue(character, text, font, color, textBackground, before, after)
    table.insert(queue, {type = "say", character = character, text = text, font = font, color = color, textBackground = textBackground, before = before, after = after});    
end
function Object:addAskQueue(character, question, answers, font, color, textBackground, before, after)
    table.insert(queue, {type = "ask", character = character, question = question, answers = answers, font = font, color = color, textBackground = textBackground, before = before, after = after});    
end

function expression(tab)
    if tab.before then
        tab.before();
    end

    Scene:getGameObject(tab.character):setExpression(tab.expression);
    if tab.after then
        tab.after();
    end
end

function say(tab)
    if tab.before then
        tab.before();
    end
    local expression = Scene:getGameObject(tab.character):getExpression();
    local font = tab.font and tab.font or get("font", tab.character, expression);
    local color = tab.color and tab.color or get("color", tab.character, expression);
    local textBackground = tab.textBackground and tab.textBackground or get("textBackground", tab.character, expression);

    
    textBackground_sprite:loadTexture(textBackground);
    textBackground_sprite:useTextureSize();
    textBackground_sprite:setLayer(0);
    textBackground_sprite:setZDepth(1);
    textBackground_sprite:setPosition(Scene:getCamera():getPosition(obe.Referencial.Bottom), obe.Referencial.Bottom);
    textBackground_sprite:setVisible(true);

    local textBackground_position = textBackground_sprite:getPosition(obe.Referencial.TopLeft):to(obe.Units.WorldPixels);
    print(textBackground_position.x, textBackground_position.y);
    
    canvasText{text = tab.character .. " :\n" .. tab.text, size = 30, x = textBackground_position.x + 50, y = textBackground_position.y + 50, color = color, font = font};
    canvas:render();
    if tab.after then
        tab.after();
    end
end

function ask(tab)
    if tab.before then
        tab.before();
    end
    isAsking = true;
    local expression = Scene:getGameObject(tab.character):getExpression();
    local font = tab.font and tab.font or get("font", tab.character, expression);
    local color = tab.color and tab.color or get("color", tab.character, expression);
    local textBackground = tab.textBackground and tab.textBackground or get("textBackground", tab.character, expression);

    
    textBackground_sprite:loadTexture(textBackground);
    textBackground_sprite:useTextureSize();
    textBackground_sprite:setLayer(4.0);
    textBackground_sprite:setPosition(Scene:getCamera():getPosition(obe.Referencial.Bottom), obe.Referencial.Bottom);
    textBackground_sprite:setVisible(true);

    local textBackground_position = textBackground_sprite:getPosition(obe.Referencial.TopLeft):to(obe.Units.WorldPixels);
    print(textBackground_position.x, textBackground_position.y);
    
    canvasText{text = tab.character .. " :\n" .. tab.question .. "\n1 - " .. tab.answers[1] .. "\n2 - " .. tab.answers[2] .. "\n3 - " .. tab.answers[3] .. "\n4 - " .. tab.answers[4], size = 30, x = textBackground_position.x + 50, y = textBackground_position.y + 50, color = color, font = font};
    canvas:render();
    if tab.after then
        tab.after();
    end
end

function get(datanode, character, expression)
    local parserC = Vili.ViliParser.new();
    parserC:parseFile(obe.Path("Data/GameObjects/Character/characters.vili"):find());

    local parserS = Vili.ViliParser.new();
    parserS:parseFile(obe.Path("Data/GameObjects/Scene/scenes.vili"):find());

    local parserVN = Vili.ViliParser.new();
    parserVN:parseFile(obe.Path("Data/GameObjects/VisualNovel/visualnovel.vili"):find());

    
    if parserC:root():at(character.."/expressions/"..expression):contains(Vili.NodeType.DataNode, datanode) then
        return parserC:root():at(character.."/expressions/"..expression):getDataNode(datanode):getString();
    elseif parserC:root():at(character):contains(Vili.NodeType.DataNode, datanode) then
        return parserC:root():at(character):getDataNode(datanode):getString();
    elseif parserS:root():at(currentScene:getName()):contains(Vili.NodeType.DataNode, datanode) then
        return parserS:root():at(currentScene:getName()):getDataNode(datanode):getString();
    elseif parserVN:root():contains(Vili.NodeType.DataNode, datanode) then
        return parserVN:root():getDataNode(datanode):getString();
    else
        return nil;
    end
end
