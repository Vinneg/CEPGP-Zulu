local CEPGPZulu = LibStub('AceAddon-3.0'):GetAddon('CEPGPZulu');

local function get(info)
    return CEPGPZulu.db.char[info[#info]];
end

local function set(info, value)
    CEPGPZulu.db.char[info[#info]] = value;
end

CEPGPZulu.defaults.char = {
    bonus = "10",
    flask = "17628 17627 17626 17538",
    message = "Химия",
};

CEPGPZulu.options = {
    name = 'EPGP consumables',
    handler = CEPGPZulu,
    type = 'group',
    args = {
        bonus = {
            type = 'input',
            order = 1,
            width = 'half',
            name = 'Flask EP bonus',
            get = function(info) return get(info) end,
            set = function(info, value) set(info, value) end,
        },
        flask = {
            type = 'input',
            order = 10,
            width = 3,
            name = 'Flask Ids',
            desc = 'Flask ids, space delimited',
            get = function(info) return get(info) end,
            set = function(info, value) set(info, value) end,
        },
        message = {
            type = 'input',
            order = 20,
            width = 'half',
            name = 'EP award message',
            get = function(info) return get(info) end,
            set = function(info, value) set(info, value) end,
        },
    },
};

function CEPGPZulu:EPGP_Scan()
end

function CEPGPZulu:EPGP_ScanRaid()
    if UnitInRaid("player") == nil then
        return;
    end

    local result = {};

    for pid = 1, GetNumGroupMembers() do
        local name, _, _, _, _, _, _, online = GetRaidRosterInfo(pid);

        if name and online then
            tinsert(result, self:EPGP_ScanUnit("raid" .. pid, name));
        end
    end

    sort(result, function(a, b) return a.name < b.name end);

    for _, v in ipairs(result) do
        if v and v.ep then
--            CEPGP_addEP(v.name, v.ep, v.msg);
            print(v.name .. ": " .. v.ep .. " for " .. v.msg);
        end;
    end
end

function CEPGPZulu:EPGP_ScanUnit(unit, name)
    local bonus = tonumber(self.db.char.bonus);
    local flasks = strtrim(self.db.char.flask);

    local result = {
        name = name,
        ep = nil,
        msg = strtrim(self.db.char.message),
    };

    for i = 1, 40 do
        local spellId = select(10, UnitBuff(unit, i));

        if spellId and strfind(flasks, spellId) then
            result.ep = bonus;
        end
    end

    return result;
end