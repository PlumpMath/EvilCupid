Objects = {};

Objects.Pan = {
    onclick = function(self)
        if self:pick() then
            local gm = Scene:getGameObject("gameManager");
            gm.pan = true;
            foundpansound = obe.Sound("Sounds/foundpan.ogg");
            foundpansound:play();
            Scene:getGameObject("inventory"):add("pan");
        end
    end
}

Objects.Guard = {
    onclick = function(self)
        local inv = Scene:getGameObject("inventory");

        if inv:getSelected() ~= nil and inv:getSelected().object ~= nil then
            if inv:getSelected().object.name == "Apple" then
                applesound = obe.Sound("Sounds/apple_thanks.ogg");
                applesound:play();
                inv:getSelected():remove();
                self:say("OOOH AN APPLE, THANKS");
            elseif inv:getSelected().object.name == "Pan" then
                thisispansound = obe.Sound("Sounds/thisisapan.ogg");
                thisispansound:play();
                self:say("THIS IS A PAN");
            end
        else
            hellosound = obe.Sound("Sounds/hello.ogg");
            hellosound:play();
            self:say("HELLO !");
        end
    end
}

Objects.Chicken = {
    onclick = function(self)
        if self:pick() then
            foundhensound = obe.Sound("Sounds/foundhen.ogg");
            foundhensound:play();
            Scene:getGameObject("inventory"):add("chicken");
        end
    end,
    oncreate = function(self)
        self.direction = 1;
        print("Pédé")
    end,
    onupdate = function(self, dt)
        self.sprite:move(obe.UnitVector(dt * self.direction, 0), obe.Referencial.Center);
        self.collider:move(obe.UnitVector(dt * self.direction, 0));
        if self.sprite:getPosition().x > 1 then
            if self.direction == 1 then
                print("FSWAP");
                self.sprite:scale(obe.UnitVector(-1, 1), obe.Referencial.Center);
            end
            self.direction = -1;
        elseif self.sprite:getPosition().x < 0.2 then
            if self.direction == -1 then
                print("SWAP");
                self.sprite:scale(obe.UnitVector(-1, 1), obe.Referencial.Center);
            end
            self.direction = 1;
            self.sprite:scale(obe.UnitVector(-1, 1));
        end
    end
}

Objects.Bier = {
    onclick = function(self)
        local barman = Scene:getGameObject("barman");
        local gm = Scene:getGameObject("gameManager");
        local inv = Scene:getGameObject("inventory");
        if inv:getSelected() ~= nil and inv:getSelected().object ~= nil then
            if inv:getSelected().object.name == "Coin" then
                if self:pick() then
                    boughtbeer = obe.Sound("Sounds/boughtbeer.ogg");
                    boughtbeer:play();
                    inv:getSelected():remove();
                    barman:say("Thanks ! Have fun with your bier");
                    inv:add("bier");
                    if This:getId() == "bier1" then gm.biers[1] = true; end
                    if This:getId() == "bier2" then gm.biers[2] = true; end
                    if This:getId() == "bier3" then gm.biers[3] = true; end
                end
            else
                barman:say("No you can't pay with a " .. inv:getSelected().object.name);
            end
        else
            barman:say("You must pay for this !");
        end
    end
}

Objects.Barman = {
    onclick = function(self)
        self:say("Hey boi");
    end
}

Objects.Soberman = {
    oncreate = function(self)
        local gm = Scene:getGameObject("gameManager");
        self.drunk = gm.drunk or 0;
    end,
    onclick = function(self)
        local inv = Scene:getGameObject("inventory");
        local gm = Scene:getGameObject("gameManager");
        if inv:getSelected() ~= nil and inv:getSelected().object ~= nil then
            if inv:getSelected().object.name == "Bier" then
                self:say("OH THANKS DUDE ! *BURP*");
                wowthanksdude = obe.Sound("Sounds/wowthanksdude.ogg");
                wowthanksdude:play();
                inv:getSelected():remove();
                self.drunk = self.drunk + 1;
            else
                self:say("I don't think I need your " .. inv:getSelected().object.name .. ", but thanks anyway !");
            end
        else
            if self.drunk == 0 then
                soberfornow = obe.Sound("Sounds/soberfornow.ogg");
                soberfornow:play();
                self:say("I'm sober ! For now...");
            elseif self.drunk == 1 then
                stillsober = obe.Sound("Sounds/stillsober.ogg");
                stillsober:play();
                self:say("I'm .. still sober *burp*");
            elseif self.drunk == 2 then
                stillstillsober = obe.Sound("Sounds/stillstillsober.ogg");
                stillstillsober:play();
                self:say("U kno wat ? STILL SOBER ! *burp*");
            elseif self.drunk == 3 then
                bestfriend = obe.Sound("Sounds/bestfriend.ogg");
                bestfriend:play();
                self:say("WOOOOOOOW UR MY B3ST FR13ND !!!!!!!!");
            end
        end
        gm.drunk = self.drunk;
    end
}

Objects.Shop = {
    onclick = function(self)
        print("Entering shop");
        Scene:loadFromFile("shop.map.vili");
    end
}

Objects.Bar = {
    onclick = function(self)
        print("Entering bar");
        Scene:loadFromFile("bar.map.vili");
    end
}

Objects.OldHouse = {
    onclick = function(self)
        print("Entering OldHouse");
        Scene:loadFromFile("oldhouse.map.vili");
    end
}

Objects.Recorder = {
    onclick = function(self)
        if self:pick() then
            Scene:getGameObject("gameManager").recorder = true;
            stolerecordersound = obe.Sound("Sounds/stolerecorder.ogg");
            stolerecordersound:play();
            Scene:getGameObject("inventory"):add("recorder");
        end
    end
}

Objects.OldMan = {
    onclick = function(self)
        self:say("I HATE RAP MUSIC !!");
        haterapsound = obe.Sound("Sounds/haterap.ogg");
        haterapsound:play();
    end
}

Objects.OldLady = {
    onclick = function(self)
        local inv = Scene:getGameObject("inventory");
        if inv:getSelected() ~= nil and inv:getSelected().object ~= nil then
            if inv:getSelected().object.name == "Recorder-Rec" then
                self:say("Oh you can record me, I'll sing for you !");
                operasound = obe.Sound("Sounds/opera.ogg");
                operasound:play();
                inv:getSelected():remove();
                inv:add("recorder");
                inv:add("opera");
            else
                self:say("I can sing some Opera for you !");
                singoperasound = obe.Sound("Sounds/singopera.ogg");
                singoperasound:play();
            end
        else
            self:say("I can sing some Opera for you !");
            singoperasound = obe.Sound("Sounds/singopera.ogg");
            singoperasound:play();
        end
    end
}

Objects.Kiosk = {
    onclick = function(self)
        print("Entering Kiosk");
        Scene:loadFromFile("kiosk.map.vili");
    end
}

Objects.TinyIsland = {
    onclick = function(self)
        local inv = Scene:getGameObject("inventory");
        local VN = Scene:getGameObject("vn");
        local gm = Scene:getGameObject("gameManager");

        if not gm.emptyTape then
            local fcoin = false
            for _, zone in pairs(inv:getZones()) do 
                if zone.object ~= nil and zone.object.name == "Coin" then
                    zone:remove();
                    inv:add("tape");
                    fcoin = true;
                    break;
                end
            end
            if fcoin then
                VN:scene("myscene");
                local fisher = VN:character("Fisher");
                fisher:say{text = "You're a lucky guy ! I will give you this empty tape and I take your coin"};
                gm.emptyTape = true;
                VN:next();
            else
                VN:scene("myscene");
                local bishamon = VN:character("Fisher");
                bishamon:say{text = "If you bring me a coin I can give you something pretty cool !"};

                VN:next();
            end
        else
            VN:scene("myscene");
            local fisher = VN:character("Fisher");
            fisher:say{text = "I already gave you my empty tape ! I don't have any more !"};

            VN:next();
        end
    end
}

Objects.Swings = {
    onclick = function(self)
        print("Entering Swings");
        Scene:loadFromFile("swings.map.vili");
    end
}

Objects.Hobo = {
    oncreate = function(self)
        local gm = Scene:getGameObject("gameManager");
        self.hoborich = gm.hoborich or false;
    end,
    onclick = function(self)
        local inv = Scene:getGameObject("inventory");
        local gm = Scene:getGameObject("gameManager");
        if self.hoborich then
            self:say("Take care of Billy the Pet Worm !");
            tkb = obe.Sound("Sounds/takecarebilly.ogg");
            tkb:play();
        else
            if inv:getSelected() ~= nil and inv:getSelected().object ~= nil then
                if inv:getSelected().object.name == "Coin" then
                    self:say("Oh thanks, I give you my pet worm !");
                    Scene:getCollider("billy"):move(obe.UnitVector(-1, 0));
                    Scene:getLevelSprite("billy"):move(obe.UnitVector(-1, 0));
                    gpw = obe.Sound("Sounds/givepetworm.ogg");
                    gpw:play();
                    inv:getSelected():remove();
                    self.hoborich = true;
                    gm.hoborich = true;
                else
                    self:say("Give me a coin you rich boi !");
                    gmcrb = obe.Sound("Sounds/givecoinrichboi.ogg");
                    gmcrb:play();
                end
            else
                self:say("Give me a coin you rich boi !");
                gmcrb = obe.Sound("Sounds/givecoinrichboi.ogg");
                gmcrb:play();
            end
        end
    end
}

Objects.Coin = {
    onclick = function(self)
        local gm = Scene:getGameObject("gameManager");
        if self:pick() then
            gm[self.name] = true;
            foundcoinsound = obe.Sound("Sounds/foundcoin.ogg");
            foundcoinsound:play();
            Scene:getGameObject("inventory"):add("coin");
        end
    end
}

Objects.Fish = {
    onclick = function(self)
        local inv = Scene:getGameObject("inventory");
        if inv:getSelected() ~= nil and inv:getSelected().object ~= nil then
            if inv:getSelected().object.name == "Billy" then
                local VN = Scene:getGameObject("vn");
                self:say("GIVE ME BILLY AND I'LL HELP YOU");
                gibillysound = obe.Sound("Sounds/givebilly.ogg");
                gibillysound:play();

                VN:scene("fountain");
                local fish = VN:character("Fish");
                fish:say{text = "If you give me Billy as food I can testify something for you !"};
                fish:ask{question = "Wanna give me Billy ?", answers = {"HELL YEAH, BON APPETIT !", "HECK NO, BILLY IS MY FRIEND NOW"}};
                VN:next();
            else
                self:say("Gloub gloub");
                gloubsound = obe.Sound("Sounds/gloubgloub.ogg");
                gloubsound:play();
            end
        else
            self:say("Gloub gloub");
            gloubsound = obe.Sound("Sounds/gloubgloub.ogg");
            gloubsound:play();
        end
    end
}

Objects.Fountain = {
    onclick = function(self)
        print("Entering fountain");
        Scene:loadFromFile("fountain.map.vili");
    end
}

Objects.Clipper = {
    onclick = function(self)
        local gm = Scene:getGameObject("gameManager");
        if self:pick() then
            gm.tnc = true;
            foundtncsound = obe.Sound("Sounds/foundtnc.ogg");
            foundtncsound:play();
            Scene:getGameObject("inventory"):add("toenailclipper");
        end
    end
}

Objects.Hospital = {
    onclick = function(self)
        print("Entering hospital");
        Scene:loadFromFile("hospital.map.vili");
    end
}

Objects.Billy = {
    onclick = function(self)
        local gm = Scene:getGameObject("gameManager");
        if self:pick() then
            gm.billy = true;
            foundbillysound = obe.Sound("Sounds/foundbilly.ogg");
            foundbillysound:play();
            Scene:getGameObject("inventory"):add("petworm");
        end
    end
}

Objects.LoveHouse = {
    onclick = function(self)
        print("Entering LoveHouse");
        Scene:loadFromFile("loveroom.map.vili");
    end
}

Objects.Camera = {
    onclick = function(self)
        print("Loading Camera");
        Scene:loadFromFile("camera.map.vili");
    end
}

function AllPicsToBack()
    Scene:getLevelSprite("pic_1"):setZDepth(3);
    Scene:getLevelSprite("pic_2"):setZDepth(3);
    Scene:getLevelSprite("pic_3"):setZDepth(3);
    Scene:getLevelSprite("pic_4"):setZDepth(3);
end

Objects.CameraL = {
    oncreate = function(self)
        AllPicsToBack();
        Scene:getLevelSprite("pic_" .. tostring(gm.currentPic)):setZDepth(2);
    end,
    onclick = function(self)
        local gm = Scene:getGameObject("gameManager");
        AllPicsToBack();
        gm.currentPic = gm.currentPic - 1;
        if gm.currentPic == 0 then gm.currentPic = 4; end
        Scene:getLevelSprite("pic_" .. tostring(gm.currentPic)):setZDepth(2);
    end
}

Objects.CameraR = {
    onclick = function(self)
        local gm = Scene:getGameObject("gameManager");
        AllPicsToBack();
        gm.currentPic = gm.currentPic + 1;
        if gm.currentPic == 5 then gm.currentPic = 1; end
        Scene:getLevelSprite("pic_" .. tostring(gm.currentPic)):setZDepth(2);
    end
}