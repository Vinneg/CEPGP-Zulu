local eventFrame = CreateFrame("Frame", nil, WorldFrame);

SLASH_CEPGPZ1 = "/cepz";

CEPGPZ_commands = {
    START = "start"
}

CEPGPZ_globals = {
    showOn = {1, 2, 3, 5, 10, 20, 30},
    channel = "RAID_WARNING",
};

function SlashCmdList.CEPGPZ(msg)
    if msg == nil then
        return;
    end

    local args = {strsplit("-", string.lower(msg))};

	for _, v in pairs(args) do
        local arg, val = strsplit(" ", v, 2);

        if arg == CEPGPZ_commands.START then
            CEPGPZ_StartCountdown(val);
            ShowUIPanel(CEPGPZ_countdown);
        end
	end
end
