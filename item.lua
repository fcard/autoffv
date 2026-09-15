local value = require('autoffv.utils.value');
local Const = require('autoffv.utils.const');
local callable = require('autoffv.utils.callable');
local equip_proto = require('autoffv.equip_proto');
local item_name = require('autoffv.item_name');
local item_description = require("autoffv.item_description");
local Command = require('autoffv.ability.command');
local weapon = require('autoffv.weapon');
local armor = require('autoffv.armor');

local Element = equip_proto.Element;
local TargetType = equip_proto.TargetType;
local ActionType = equip_proto.ActionType;

local function read_item_data(id)
  local obj = {properties = {}};
  local offset = id*8;

  local byte1 = memory.readbyte(0x110A80 + offset, "CARTROM");
  local byte2 = memory.readbyte(0x110A81 + offset, "CARTROM");
  local byte3 = memory.readbyte(0x110A82 + offset, "CARTROM");
  local byte4 = memory.readbyte(0x110A83 + offset, "CARTROM");
  local byte5 = memory.readbyte(0x110A84 + offset, "CARTROM");
  local byte6 = memory.readbyte(0x110A85 + offset, "CARTROM");
  local byte7 = memory.readbyte(0x110A86 + offset, "CARTROM");
  local byte8 = memory.readbyte(0x110A87 + offset, "CARTROM");

  obj.target = {
    [TargetType.MultiOptional]  = byte1 & 0x80 == 0x80,
    [TargetType.Multi]          = byte1 & 0x40 == 0x40,
    [TargetType.Selectable]     = byte1 & 0x20 == 0x20,
    [TargetType.SideSelectable] = byte1 & 0x10 == 0x10,
    [TargetType.EnemyByDefault] = byte1 & 0x08 == 0x08,
    [TargetType.Roulette]       = byte1 & 0x04 == 0x04
  };

  obj.element = {
    [Element.Wind]      = byte2 & 0x40 == 0x40,
    [Element.Earth]     = byte2 & 0x20 == 0x20,
    [Element.Holy]      = byte2 & 0x10 == 0x10,
    [Element.Poison]    = byte2 & 0x08 == 0x08,
    [Element.Lightning] = byte2 & 0x04 == 0x04,
    [Element.Ice]       = byte2 & 0x02 == 0x02,
    [Element.Fire]      = byte2 & 0x01 == 0x01,
  };

  obj.commands = {
    [Command.Throw] = byte3 & 0x40 ~= 0x40,
    [Command.Item]  = byte3 & 0x20 ~= 0x20,
    [Command.Drink] = byte3 & 0x10 ~= 0x10,
    [Command.Mix]   = byte3 & 0x02 ~= 0x02,
  };

  obj.reusable = byte3 & 0x08 ~= 0x08;

  obj.description_id = byte4 & 0x07f;
  function obj.get_description()
    return item_description.get_description(obj.description_id);
  end

  obj.damage_formula = byte5;
  obj.parameter1 = byte6;
  obj.parameter2 = byte7;
  obj.parameter3 = byte8;

  return obj;
end

local cached_item_data = {};

local function get_item_data(id)
  if cached_item_data[id] == nil then
    cached_item_data[id] = read_item_data(id);
  end
  return cached_item_data[id];
end

local function item(id_mem)
  local id = value.u8(id_mem);
  local obj = {};

  function obj.id()
    return id();
  end

  function obj.name()
    return item_name.get_name(id());
  end

  function obj.description()
    return obj.data().get_description();
  end

  function obj.data()
    local xid = id();
    if xid <= 0x7f then
      return weapon.get_weapon_data(xid);
    elseif xid <= 0xdf then
      return armor.get_armor_data(xid);
    else
      return get_item_data(xid - 0xe0);
    end
  end

  return value.dependant(obj, id);
end


return callable({
  read_item_data = read_item_data,
  get_item_data = get_item_data,
}, item, 1);
