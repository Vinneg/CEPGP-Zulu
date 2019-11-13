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
    print("Consumables check in "..left.." sec");
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

    CEPGPZ_countdown_left:SetText("Check in "..left.." sec");

    if left < 0 then
        CEPGPZ_Countdown.active = false;
        CEPGPZ_Countdown.finish = 0;
        CEPGPZ_Countdown.last = 0;

        HideUIPanel(CEPGPZ_countdown);

        return;
    end

    if left < CEPGPZ_Countdown.last and tContains(CEPGPZ_globals.showOn, left) then
        CEPGPZ_Countdown.last = left;

        --SendChatMessage("Consumables check in "..left.." sec", CEPGPZ_globals.channel);
        print("Consumables check in "..left.." sec");
    end
end
