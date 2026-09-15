local value = require('autoffv.utils.value');
local Const = require('autoffv.utils.const');
local callable = require('autoffv.utils.callable');
local equip_proto = require('autoffv.equip_proto');
local item_description = require("autoffv.item_description");
local Command = require('autoffv.ability.command');
local LearnRate = require('autoffv.blue_learn_rate').LearnRate;
local magic_names = require('autoffv.magic_names');
local ActionType = require('autoffv.action_type').ActionType;

local Element = equip_proto.Element;
local TargetType = equip_proto.TargetType;

local function read_magic_data(id)
  local obj = {properties = {}};
  local offset = id*8;

  local byte1 = memory.readbyte(0x110B80 + offset, "CARTROM");
  local byte2 = memory.readbyte(0x110B81 + offset, "CARTROM");
  local byte3 = memory.readbyte(0x110B82 + offset, "CARTROM");
  local byte4 = memory.readbyte(0x110B83 + offset, "CARTROM");
  local byte5 = memory.readbyte(0x110B84 + offset, "CARTROM");
  local byte6 = memory.readbyte(0x110B85 + offset, "CARTROM");
  local byte7 = memory.readbyte(0x110B86 + offset, "CARTROM");
  local byte8 = memory.readbyte(0x110B87 + offset, "CARTROM");

  obj.target = {
    [TargetType.MultiOptional]  = byte1 & 0x80 == 0x80,
    [TargetType.Multi]          = byte1 & 0x40 == 0x40,
    [TargetType.Selectable]     = byte1 & 0x20 == 0x20,
    [TargetType.SideSelectable] = byte1 & 0x10 == 0x10,
    [TargetType.EnemyByDefault] = byte1 & 0x08 == 0x08,
    [TargetType.Roulette]       = byte1 & 0x04 == 0x04
  };

  obj.action_delay = byte1 & 0x03;

  obj.action_type = {
    [ActionType.Physical] = byte2 & 0x80 == 0x80,
    [ActionType.Aerial]   = byte2 & 0x40 == 0x40,
    [ActionType.Song]     = byte2 & 0x20 == 0x20,
    [ActionType.Summon]   = byte2 & 0x10 == 0x10,
    [ActionType.Dimen]    = byte2 & 0x08 == 0x08,
    [ActionType.Black]    = byte2 & 0x04 == 0x04,
    [ActionType.White]    = byte2 & 0x02 == 0x02,
    [ActionType.Blue]     = byte2 & 0x01 == 0x01,
  };

  obj.learn_rate = {
    [LearnRate.CanLearn10Percent]  = byte3 & 0x10 == 0x10,
    [LearnRate.CanLearn50Percent]  = byte3 & 0x20 == 0x20,
    [LearnRate.CanLearn100Percent] = byte3 & 0x40 == 0x40,
    [LearnRate.CannotLearn]        = byte3 & 0x80 == 0x80,
  };

  obj.mp_cost = byte4 & 0x7f;
  obj.cannot_reflect = byte4 & 0x80 == 0x80;
  obj.damage_formula = byte5;
  obj.parameter1 = byte6;
  obj.parameter2 = byte7;
  obj.parameter3 = byte8;

  return obj;
end

local cached_magic_data = {};

local function get_magic_data(id)
  if cached_magic_data[id] == nil then
    cached_magic_data[id] = read_magic_data(id);
  end
  return cached_magic_data[id];
end

local function magic(id_mem)
  local id = value.u8(id_mem);
  local obj = {};

  function obj.id()
    return id();
  end

  function obj.name()
    return magic_names.get_name(id());
  end

  function obj.data()
    return get_magic_data(id());
  end

  return value.dependant(obj, id);
end


return callable({
  read_magic_data = read_magic_data,
  get_magic_data = get_magic_data,
}, magic, 1);
