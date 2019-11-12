this = {
    start = 0,
    last = 0,
};

SLASH_CEPGP1 = "/cepz";

function SlashCmdList.CEPGP(msg, editbox)
    if msg == nil then
        return;
    end

    msg = string.lower(msg);

    args = {strsplit("-", msg)};
	
	for i, v in pairs(args) do
		print(v);
	end
end

local function DoUpdate()
    this.last = GetTime();

    local pass = math.floor(this.last - this.start);
end

local eventFrame = CreateFrame("Frame", nil, WorldFrame);
eventFrame:SetScript("OnUpdate", DoUpdate);
