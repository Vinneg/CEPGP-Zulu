local eventFrame = CreateFrame("Frame", nil, WorldFrame);

SLASH_CEPGPZ1 = "/cepz";
CEPGPZ_START = "start";

CEPGPZ_locals = {
    finish = 0,
    last = 0,
    showOn = {1, 2, 3, 5, 10, 20, 30},
    channel = "RAID_WARNING",
};

function SlashCmdList.CEPGPZ(msg, editbox)
    if msg == nil then
        return;
    end

    local args = {strsplit("-", string.lower(msg))};

	for i, v in pairs(args) do
        local arg, val = strsplit(" ", v, 2);

        if arg == CEPGPZ_START then
            CEPGPZ_locals.finish = GetTime() + tonumber(val);
            CEPGPZ_locals.last = val - 1;

            SendChatMessage("Consumables check in "..val.." sec", CEPGPZ_locals.channel);
            --print("Consumables check in "..val.." sec");
        end
	end
end

function CEPGPZ_locals.DoUpdate()
    if CEPGPZ_locals.finish == 0 then
        CEPGPZ_locals.last = 0;

        return;
    end

    local now = GetTime();
    local left = math.floor(CEPGPZ_locals.finish - now);

    if left < 0 then
        CEPGPZ_locals.finish = 0;
        CEPGPZ_locals.last = 0;

        return;
    end

    if left < CEPGPZ_locals.last and tContains(CEPGPZ_locals.showOn, left) then
        CEPGPZ_locals.last = left;

        SendChatMessage("Consumables check in "..left.." sec", CEPGPZ_locals.channel);
        --print("Consumables check in "..left.." sec");
    end
end

eventFrame:SetScript("OnUpdate", CEPGPZ_locals["DoUpdate"]);
