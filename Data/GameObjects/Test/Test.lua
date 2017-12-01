function Local.Init(name)
    
    print("test 1")
    VN = Scene:createGameObject("VisualNovel")();
    print("test 2")
    VN:scene("myscene");
    print("test 3")
    local bishamon = VN:character("Bishamon");
    print("test 4")
    --bob:hide();
    print("test 5")
    ---bob:show();
    print("test 6")
    local temp = function() print("started happy") end
    bishamon:expression{expression = "happy", before = temp};
    bishamon:say{text = "aaaaa", before = function() print("started aaaaa") end};
    bishamon:say{text = "bbbbb"};
    bishamon:expression{expression = "neutral", after = function() print("ended neutral") end};
    bishamon:say{text = "ccccc"};
    bishamon:ask{question = "what ?", answers = {"what, what ?", "yes", "no", "maybe", "I don't know"}}
    bishamon:say{text = "ddddd", before = function() print("started ddddd") end, after = function() print("ended dddd") end};
    bishamon:expression{expression ="happy"};
    bishamon:say{text = "eeeee"};
    VN:next();

end

function Global.Game.Update(dt)
    print(VN:getAnswer())
end;