local Const = require('ff5.utils.const');
local Stat = require('ff5.stat');
local Element = require('ff5.element').Element;
local ActionType = require('ff5.action_type').ActionType;
local TargetType = require('ff5.target_type').TargetType;

local function inverse_stat(stat)
  if stat == Stat.Strength then
    return Stat.Magic;
  elseif stat == Stat.Speed then
    return Stat.Vitality;
  elseif stat == Stat.Vitality then
    return Stat.Speed;
  elseif stat == Stat.Magic then
    return Stat.Strength;
  end
end

local function decode_stat_up(b, t, stat)
  if b == 0 then
    t[stat] = 1;
  elseif b == 1 then
    t[stat] = 2;
  elseif b == 2 then
    t[stat] = 3;
  elseif b == 3 then
    if stat == Stat.Strength or stat == Stat.Vitality then
      t[stat] = 1;
    else
      t[stat] = -1;
    end
  elseif b == 4 then
    t[inverse_stat(stat)] = -1;
  elseif b == 5 then
    if stat == Stat.Strength or stat == Stat.Vitality then
      t[stat] = 5;
    else
      t[stat] = -5;
    end
  elseif b == 6 then
    t[inverse_stat(stat)] = -5;
  elseif b == 7 then
    t[stat] = 5;
  end
end

return {
  Element = Element,
  Stat = Stat,
  TargetType = TargetType,
  ActionType = ActionType,
  inverse_stat = inverse_stat,
  decode_stat_up = decode_stat_up,
}
