local Const = require('autoffv.utils.const');
local equip_proto = require('autoffv.equip_proto');
local item_description = require("autoffv.item_description");

local Element = equip_proto.Element;
local Stat = equip_proto.Stat;
local TargetType = equip_proto.TargetType;
local ActionType = equip_proto.ActionType;

local inverse_stat = equip_proto.inverse_stat;
local decode_stat_up = equip_proto.decode_stat_up;

local WeaponProp = Const{
  DoubleGripOnly=0,
  DoubleGripAllowed=1,
  SwordParry=2,
  KnifeParry=3,
  Initiative=4,
  ActionOnHit=5,
  MagicSwordAllowed=6,
  Ability=7,
  WonderRod=8,
  Throwable=9,
  BreaksOnUse=10
};

local WeaponClass = Const{
  None=0,
  Knife=2,
  NinjaKnife=3,
  Sword=4,
  Boomerang=30,
}

local function read_weapon_data(id)
  local obj = {properties = {}};

  local target_byte = memory.readbyte(0x110000 + id*12, "CARTROM");
  obj.target = {
    [TargetType.MultiOptional]  = target_byte & 0x80 == 0x80,
    [TargetType.Multi]          = target_byte & 0x40 == 0x40,
    [TargetType.Selectable]     = target_byte & 0x20 == 0x20,
    [TargetType.SideSelectable] = target_byte & 0x10 == 0x10,
    [TargetType.EnemyByDefault] = target_byte & 0x08 == 0x08,
    [TargetType.Roulette]       = target_byte & 0x04 == 0x04
  };

  local action_type_byte = memory.readbyte(0x110001 + id*12, "CARTROM");
  obj.action_type = {
    [ActionType.Physical] = action_type_byte & 0x80 == 0x80,
    [ActionType.Aerial]   = action_type_byte & 0x40 == 0x40,
    [ActionType.Song]     = action_type_byte & 0x20 == 0x20,
    [ActionType.Summon]   = action_type_byte & 0x10 == 0x10,
    [ActionType.Dimen]    = action_type_byte & 0x08 == 0x08,
    [ActionType.Black]    = action_type_byte & 0x04 == 0x04,
    [ActionType.White]    = action_type_byte & 0x02 == 0x02,
    [ActionType.Blue]     = action_type_byte & 0x01 == 0x01,
  };

  local byte3 = memory.readbyte(0x110002 + id*12, "CARTROM");
  obj.properties[WeaponProp.Throwable] = byte3 & 0x40 == 0x40;
  obj.equip_class = byte3 & 0x3f;

  local byte4 = memory.readbyte(0x110003 + id*12, "CARTROM");
  obj.element = {};
  obj.stat_up = {};

  if byte4 & 0x80 == 0x80 then
    local b = byte4 & 0x07;
    if byte4 & 0x40 == 0x40 then
      decode_stat_up(b, obj.stat_up, Stat.Strength);
    end

    if byte4 & 0x20 == 0x20 then
      decode_stat_up(b, obj.stat_up, Stat.Speed);
    end

    if byte4 & 0x10 == 0x10 then
      decode_stat_up(b, obj.stat_up, Stat.Vitality);
    end

    if byte4 & 0x08 == 0x08 then
      decode_stat_up(b, obj.stat_up, Stat.Magic);
    end
  else
    obj.element = {
      [Element.Wind]      = byte4 & 0x40 == 0x40,
      [Element.Earth]     = byte4 & 0x20 == 0x20,
      [Element.Holy]      = byte4 & 0x10 == 0x10,
      [Element.Poison]    = byte4 & 0x08 == 0x08,
      [Element.Lightning] = byte4 & 0x04 == 0x04,
      [Element.Ice]       = byte4 & 0x02 == 0x02,
      [Element.Fire]      = byte4 & 0x01 == 0x01,
    };
  end

  local byte5 = memory.readbyte(0x110004 + id*12, "CARTROM");
  obj.properties[WeaponProp.DoubleGripOnly] = byte5 & 0x80 == 0x80;
  obj.properties[WeaponProp.DoubleGripAllowed] = byte5 & 0x40 == 0x40;
  obj.description_id = byte5 & 0x3f;

  function obj.get_description()
    return item_description.get_description(obj.description_id);
  end

  local byte6 = memory.readbyte(0x110005 + id*12, "CARTROM");
  obj.properties[WeaponProp.SwordParry]        = byte6 & 0x80 == 0x80;
  obj.properties[WeaponProp.KnifeParry]        = byte6 & 0x40 == 0x40;
  obj.properties[WeaponProp.Initiative]        = byte6 & 0x20 == 0x20;
  obj.properties[WeaponProp.ActionOnHit]       = byte6 & 0x08 == 0x08;
  obj.properties[WeaponProp.MagicSwordAllowed] = byte6 & 0x04 == 0x04;
  obj.properties[WeaponProp.Ability]           = byte6 & 0x02 == 0x02;
  obj.properties[WeaponProp.WonderRod]         = byte6 & 0x01 == 0x01;

  local byte7 = memory.readbyte(0x110006 + id*12, "CARTROM");
  obj.properties[WeaponProp.BreaksOnUse] = byte7 & 0x80 == 0x80;
  obj.magic = byte7 & 0x7f;

  obj.attack_power = memory.readbyte(0x110007 + id*12, "CARTROM");
  obj.attack_formula =  memory.readbyte(0x110008 + id*12, "CARTROM");
  obj.parameter1 =  memory.readbyte(0x110009 + id*12, "CARTROM");
  obj.parameter2 =  memory.readbyte(0x11000a + id*12, "CARTROM");
  obj.parameter3 =  memory.readbyte(0x11000b + id*12, "CARTROM");

  return obj;
end

local cached_weapon_data = {};

local function get_weapon_data(id)
  if cached_weapon_data[id] == nil then
    cached_weapon_data[id] = read_weapon_data(id);
  end
  return cached_weapon_data[id];
end

return {
  read_weapon_data = read_weapon_data,
  get_weapon_data = get_weapon_data,
  WeaponClass = WeaponClass,
  WeaponProp = WeaponProp,
};
