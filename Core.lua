CEPGPZulu = LibStub("AceAddon-3.0"):NewAddon("CEPGPZulu", "AceConsole-3.0");

local AceConfig = LibStub("AceConfig-3.0");
local AceDB = LibStub("AceDB-3.0");
local AceConfigDialog = LibStub("AceConfigDialog-3.0");

local store = function() return CEPGPZulu.store.char; end;

CEPGPZulu.defaults = {
    char = {
        flask = {
            bonus = 10,
            ids = '17628 17627 17626',
            message = 'Химия',
        },
        buffs = {
            fine = 5,
            ids = '24425 22888',
            message = 'Ворлд баффы',
        },
    },
};

CEPGPZulu.options = {
    name = 'EPGP AddIns',
    handler = CEPGPZulu,
    type = 'group',
    args = {
        bonus = {
            type = 'input',
            order = 1,
            width = 'half',
            name = 'Flask EP bonus',
            get = function() return tostring(store().flask.bonus); end,
            set = function(_, value) store().flask.bonus = tonumber(value); end,
        },
        flask = {
            type = 'input',
            order = 10,
            width = 2,
            name = 'Flask Ids',
            desc = 'Flask ids, space delimited',
            get = function() return store().flask.ids; end,
            set = function(_, value) store().flask.ids = strtrim(value); end,
        },
        flaskMessage = {
            type = 'input',
            order = 20,
            width = 'half',
            name = 'EP award message',
            get = function() return store().flask.message; end,
            set = function(_, value) store().flask.message = value; end,
        },
        blank1 = {
            type = 'description',
            order = 21,
            name = '',
            width = 'full',
        },
        testFlask = {
            type = 'execute',
            name = 'Test',
            order = 23,
            width = 'half',
            func = function() CEPGPZulu:Scan4Flask(false); end,
        },
        doFlask = {
            type = 'execute',
            name = 'Do EP',
            order = 27,
            width = 'half',
            func = function() CEPGPZulu:Scan4Flask(true); end,
        },
        blank2 = {
            type = 'description',
            order = 30,
            name = '',
            width = 'full',
        },
        fine = {
            type = 'input',
            order = 40,
            width = 'half',
            name = 'Buffs GP fine',
            get = function() return tostring(store().buffs.fine); end,
            set = function(_, value) store().buffs.fine = tonumber(value); end,
        },
        buffs = {
            type = 'input',
            order = 50,
            width = 2,
            name = 'Buffs Ids',
            desc = 'Buffs ids, space delimited',
            get = function() return store().buffs.ids; end,
            set = function(_, value) store().buffs.ids = strtrim(value); end,
        },
        buffsMessage = {
            type = 'input',
            order = 60,
            width = 'half',
            name = 'GP fine message',
            get = function() return store().buffs.message; end,
            set = function(_, value) store().buffs.message = value; end,
        },
        blank3 = {
            type = 'description',
            order = 61,
            name = '',
            width = 'full',
        },
        testBuffs = {
            type = 'execute',
            name = 'Test',
            order = 63,
            width = 'half',
            func = function() CEPGPZulu:Scan4Buffs(false); end,
        },
        doBuffs = {
            type = 'execute',
            name = 'Do GP',
            order = 67,
            width = 'half',
            func = function() CEPGPZulu:Scan4Buffs(true); end,
        },
    },
};

CEPGPZulu.store = {};

local function unitHasBuff(unit, buffs)
    local i, count = 0, 0;

    repeat
        i = i + 1;

        local spellId = select(10, UnitBuff(unit, i));

        count = count + (spellId and strfind(buffs, spellId) and 1 or 0);
    until not spellId;

    return { hasOne = (count > 0), hasAll = (count == #{ strsplit(' ', buffs) }), };
end

function CEPGPZulu:HandleChatCommand()
    AceConfigDialog:Open("CEPGPZuluOptions");
end

function CEPGPZulu:OnInitialize()
    self:RegisterChatCommand("cepz", "HandleChatCommand");

    AceConfig:RegisterOptionsTable("CEPGPZuluOptions", CEPGPZulu.options);

    self.store = AceDB:New("CEPGPZuluSettings", CEPGPZulu.defaults, true);
end

function CEPGPZulu:Scan4Flask(doEG)
    if not UnitInRaid('player') then
        return;
    end

    local result = {};

    for pid = 1, GetNumGroupMembers() do
        local name, _, _, _, _, _, _, online = GetRaidRosterInfo(pid);

        name = Ambiguate(name, 'all');

        if name and online then
            local uhb = unitHasBuff('raid' .. pid, store().flask.ids);

            local tmp = { name = name, ep = uhb.hasOne and store().flask.bonus, };

            if tmp.ep then
                tinsert(result, tmp);
            end
        end
    end

    sort(result, function(a, b) return a.name < b.name end);

    if not doEG then
        self:Print('Total count is ', #result);
    end

    for _, v in ipairs(result) do
        if v and v.ep then
            if doEG then
                ExG.RosterFrame.AdjustDialog:UnitEG(v.name, v.ep, 0, store().flask.message);
            else
                self:Print(v.name, ': ', v.ep, ' for ', store().flask.message);
            end
        end;
    end
end

function CEPGPZulu:Scan4Buffs(doEG)
    if not UnitInRaid('player') then
        return;
    end

    local result = {};

    for pid = 1, GetNumGroupMembers() do
        local name, _, _, _, _, _, _, online = GetRaidRosterInfo(pid);

        name = Ambiguate(name, 'all');

        if name and online then
            local uhb = unitHasBuff('raid' .. pid, store().buffs.ids);

            local tmp = { name = name, gp = not uhb.hasAll and store().buffs.fine, };

            if tmp.gp then
                tinsert(result, tmp);
            end
        end
    end

    sort(result, function(a, b) return a.name < b.name end);

    if not doEG then
        self:Print('Total count is ', #result);
    end

    for _, v in ipairs(result) do
        if v and v.gp then
            if doEG then
                ExG.RosterFrame.AdjustDialog:UnitEG(v.name, 0, v.gp, store().buffs.message);
            else
                self:Print(v.name, ': ', v.gp, ' for ', store().buffs.message);
            end
        end;
    end
end
