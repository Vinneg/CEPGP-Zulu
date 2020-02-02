local AceConfig = LibStub("AceConfig-3.0");
local AceDB = LibStub("AceDB-3.0");
local AceConfigDialog = LibStub("AceConfigDialog-3.0");

Overseer = LibStub("AceAddon-3.0"):NewAddon("Overseer", "AceConsole-3.0");

Overseer.defaults = { char = {} };

Overseer.options = {};

Overseer.db = {};

function Overseer:HandleChatCommand(input)
    if (input == nil) then
        return;
    end

    local arg = strlower(input);

    if arg == "opts" then
        AceConfigDialog:Open("Options");
    elseif arg == "scan" then
        self:EPGP_ScanRaid();
    end
end

function Overseer:OnInitialize()
    self:RegisterChatCommand("overseer", "HandleChatCommand");

    AceConfig:RegisterOptionsTable("Options", Overseer.options);

    self.db = AceDB:New("Settings", Overseer.defaults, true);
end
