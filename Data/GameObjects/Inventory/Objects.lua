Objects = {};

Objects.banana = {
    icon = "Sprites/LevelSprites/banana.png",
    name = "Banana",
    maxstack = 1,
    onselect = function(inv, case)
        print("You selected a banana");
    end,
    onunselect = function(inv, case)
        print("Poor banana :(");
    end,
    oncombine = function(inv, case1, case2)
        if case2.object.name == "Apple" then
            print("You made a smoothie !");
            case1:remove();
            case2:remove();
            inv:reorganize();
            inv:add("smoothie");
            inv:refresh();
        else
            print("You can't combine a banana and a " .. object.name);
        end
    end,
    onuse = function(inv, case, target)
        print("You gave " .. target.name .. " a banana");
        case:remove();
    end
}

Objects.apple = {
    icon = "Sprites/LevelSprites/apple.png",
    name = "Apple",
    maxstack = 2,
    onselect = function(inv, case)
        print("You selected an apple");
    end,
    onunselect = function(inv, case)
        print("Poor apple :(");
    end,
    oncombine = function(inv, case1, case2)
        print("WOWOWOWO00, ", case2.index);
        if case2.object.name == "Banana" then
            print("You made a smoothie !");
            case1:remove();
            case2:remove();
            inv:reorganize();
            inv:add("smoothie");
            inv:refresh();
        else
            print("You can't combine a apple and a " .. case2.object.name);
        end
    end,
    onuse = function(inv, case, target)
        print("You gave " .. target.name .. " a apple");
        case:remove();
    end
}

Objects.smoothie = {
    icon = "Sprites/LevelSprites/smoothie.png",
    name = "Smoothie",
    maxstack = 4,
    onselect = function(inv, case)
        print("You selected a smoothie");
    end,
    onunselect = function(inv, case)
        print("Poor smoothie :(");
    end,
    oncombine = function(inv, case1, case2)
        print("You can't combine a smoothie and a " .. case2.object.name);
    end,
    onuse = function(inv, case, target)
        print("You gave " .. target.name .. " a smoothie");
        case:remove();
        inv:refresh();
    end
}

Objects.pan = {
    icon = "Sprites/LevelSprites/panicon.png",
    name = "Pan",
    maxstack = 1,
    onuse = function(inv, case, target)
        print("You used a pan on " .. target.name);
    end
}

Objects.chicken = {
    icon = "Sprites/LevelSprites/chicken.png",
    name = "Chicken",
    maxstack = 1,
    onuse = function(inv, case, target)
        print("Wow");
    end
}

Objects.coin = {
    icon = "Sprites/LevelSprites/coin.png",
    name = "Coin",
    maxstack = 99
}

Objects.bier = {
    icon = "Sprites/LevelSprites/bier.png",
    name = "Bier",
    maxstack = 3
}

Objects.recorder = {
    icon = "Sprites/LevelSprites/recorder_we.png",
    name = "Recorder",
    maxstack = 1,
    oncombine = function(inv, case1, case2)
        if case2.object ~= nil and case2.object.name == "Tape" then
            crec = obe.Sound("Sounds/canrecord.ogg");
            crec:play();
            case1:remove();
            case2:remove();
            inv:add("recorder_rec");
            inv:reorganize();
            inv:refresh();
        end
    end
}

Objects.toenailclipper = {
    icon = "Sprites/LevelSprites/toenailclipper_we.png",
    name = "Toe-nail clipper",
    maxstack = 1
}

Objects.petworm = {
    icon = "Sprites/LevelSprites/billy.png",
    name = "Billy",
    maxstack = 1
}

Objects.tape = {
    icon = "Sprites/LevelSprites/tape.png",
    name = "Tape",
    maxstack = 1,
    oncombine = function(inv, case1, case2)
        if case2.object ~= nil and case2.object.name == "Tape" then
            crec = obe.Sound("Sounds/canrecord.ogg");
            crec:play();
            case1:remove();
            case2:remove();
            inv:add("recorder_rec");
            inv:reorganize();
            inv:refresh();
        end
    end
}

Objects.recorder_rec = {
    icon = "Sprites/LevelSprites/recorder_rec.png",
    name = "Recorder-Rec",
    maxstack = 1
}

Objects.opera = {
    icon = "Sprites/LevelSprites/opera.png",
    name = "Opera",
    maxstack = 1
}