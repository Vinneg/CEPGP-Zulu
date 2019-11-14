CEPGPZ_ClassConsumables = {
    mage = {
        class = "Маг",
        flask = { "17628" },
        elixir = { "17539" },
    },
}

CEPGPZ_Countdown = {
    finish = 0,
    last = 0,
    active = false,
}

function CEPGPZ_StartCountdown(left)
    CEPGPZ_Countdown.active = true;
    CEPGPZ_Countdown.finish = GetTime() + tonumber(left);
    CEPGPZ_Countdown.last = left - 1;

    --SendChatMessage("Consumables check in "..val.." sec", CEPGPZ_globals.channel);
    print("Consumables check in " .. left .. " sec");
end

function CEPGPZ_CancelCountdown()
    CEPGPZ_Countdown.active = false;
    CEPGPZ_Countdown.finish = 0;
    CEPGPZ_Countdown.last = 0;

    --SendChatMessage("Consumables check canceled", CEPGPZ_globals.channel);
    print("Consumables check canceled");

    HideUIPanel(CEPGPZ_countdown);
end

function CEPGPZ_OnUpdateCountdown()
    if not CEPGPZ_Countdown.active then
        CEPGPZ_Countdown.finish = 0;
        CEPGPZ_Countdown.last = 0;

        HideUIPanel(CEPGPZ_countdown);

        return;
    end

    local left = math.floor(CEPGPZ_Countdown.finish - GetTime());

    CEPGPZ_countdown_left:SetText("Check in " .. left .. " sec");

    if left < 0 then
        CEPGPZ_Countdown.active = false;
        CEPGPZ_Countdown.finish = 0;
        CEPGPZ_Countdown.last = 0;

        HideUIPanel(CEPGPZ_countdown);

        CEPGPZ_ScanRaid();

        return;
    end

    if left < CEPGPZ_Countdown.last and tContains(CEPGPZ_globals.showOn, left) then
        CEPGPZ_Countdown.last = left;

        --SendChatMessage("Consumables check in "..left.." sec", CEPGPZ_globals.channel);
        print("Consumables check in " .. left .. " sec");
    end
end

function CEPGPZ_ScanRaid()
    if UnitInRaid("player") then
        return;
    end

    local result = {};

    for pid = 1, GetNumGroupMembers() do
        local name, _, _, _, class, _, _, online, isDead = GetRaidRosterInfo(pid);

        if name and online and not isDead then
            tinsert(result, CEPGPZ_ScanPlayer("raid" .. pid, name, class));
        end
    end

    sort(result, function(a, b) return a.name < b.name end);
end

function CEPGPZ_ScanPlayer(pid, name, class)
    local cons;

    for _, v in pairs(CEPGPZ_ClassConsumables) do
        if v.class == class then
            cons = v;

            break;
        end
    end

    local result = {
        name = name,
        flask = {
            have = 0,
            max = #cons.flask,
        },
        elixir = {
            have = 0,
            max = #cons.elixir,
        },
    };

    for i = 1, 40 do
        local _, _, _, _, _, _, _, _, _, _, spellId = UnitBuff(pid, i);

        if buff then
            if tContains(cons.flask, spellId) then
                result.flask.have = result.flask.have + 1;
            end

            if tContains(cons.elixir, spellId) then
                result.elixir.have = result.elixir.have + 1;
            end
        end
    end

    return result;
end
