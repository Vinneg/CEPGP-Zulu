local AceConfig = LibStub("AceConfig-3.0");
local AceDB = LibStub("AceDB-3.0");
local AceConfigDialog = LibStub("AceConfigDialog-3.0");

CEPGPZulu = LibStub("AceAddon-3.0"):NewAddon("CEPGPZulu", "AceConsole-3.0");

CEPGPZulu.defaults = { char = {} };

CEPGPZulu.options = {};

CEPGPZulu.db = {};

function CEPGPZulu:HandleChatCommand(input)
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

function CEPGPZulu:OnInitialize()
    self:RegisterChatCommand("cepz", "HandleChatCommand");

    AceConfig:RegisterOptionsTable("Options", CEPGPZulu.options);

    self.db = AceDB:New("Settings", CEPGPZulu.defaults, true);
end
