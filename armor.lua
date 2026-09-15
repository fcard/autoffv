local Const = require('autoffv.utils.const');
local equip_proto = require('autoffv.equip_proto');
local item_description = require("autoffv.item_description");

local Element = equip_proto.Element;
local Stat = equip_proto.Stat;
local TargetType = equip_proto.TargetType;
local ActionType = equip_proto.ActionType;

local inverse_stat = equip_proto.inverse_stat;
local decode_stat_up = equip_proto.decode_stat_up;

local ArmorSlot = Const{Accessory=0, Armor=1, Helmet=2, Shield=3};

local ArmorSpecialty = require('autoffv.armor_specialty').ArmorSpecialty;

local ArmorElementEffect = Const{
  None = 0,
  DiamondGear = 1,
  HalveAllElements = 2,
  AngelSuit = 3,
  FlameRing = 4,
  CoralRing = 5,
  BoneMail = 6,
  FlameShield = 7,
  IceShield = 8,
};

local ArmorStatusEffect = Const{
  None = 0,
  GuardRing = 1,
  CursedRing = 2,
  RunningShoes = 3,
  AegisShield = 4,
  Ribbon = 5,
  Tiara = 6,
  BardsClothes = 7,
  Glasses = 8,
  AngelSuit = 9,
  BoneMail = 10,
  WallRing = 11,
  GiantsGloves = 12,
  AngelRing = 13,
  Thornlet = 14,
  MirageVest = 15,
  GenjiShield = 16,
  GenjiHelmet = 17,
  GenjiArmor = 18,
  GenjiGlove = 19,
};

local function read_armor_data(id)
  local offset = (id - 0x80) * 12;
  local obj = {properties = {}};

  obj.slot          = memory.readbyte(0x110600 + offset, "CARTROM");
  obj.weight        = memory.readbyte(0x110601 + offset, "CARTROM");
  obj.evade         = memory.readbyte(0x110606 + offset, "CARTROM");
  obj.defense       = memory.readbyte(0x110607 + offset, "CARTROM");
  obj.magic_evade   = memory.readbyte(0x110608 + offset, "CARTROM");
  obj.magic_defense = memory.readbyte(0x110609 + offset, "CARTROM");

  obj.description_id = memory.readbyte(0x110604 + offset, "CARTROM") & 0x3f;
  function obj.get_description()
    return item_description.get_description(obj.description_id);
  end

  local byte4 = memory.readbyte(0x110603 + offset, "CARTROM");
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
      [Element.Wind]       = byte4 & 0x40 == 0x40,
      [Element.Earth]      = byte4 & 0x20 == 0x20,
      [Element.Holy]       = byte4 & 0x10 == 0x10,
      [Element.Poison]     = byte4 & 0x08 == 0x08,
      [Element.Lightining] = byte4 & 0x04 == 0x04,
      [Element.Ice]        = byte4 & 0x02 == 0x02,
      [Element.Fire]       = byte4 & 0x01 == 0x01,
    };
  end

  local byte6 = memory.readbyte(0x110605 + offset, "CARTROM")
  obj.properties = {
    [ArmorSpecialty.ImproveCatch]      = byte6 & 0x80 == 0x80,
    [ArmorSpecialty.BecomeUndead]      = byte6 & 0x40 == 0x40,
    [ArmorSpecialty.ImproveSwordDance] = byte6 & 0x20 == 0x20,
    [ArmorSpecialty.HalfMpCost]        = byte6 & 0x10 == 0x10,
    [ArmorSpecialty.ImproveSteal]      = byte6 & 0x08 == 0x08,
    [ArmorSpecialty.ImproveBrawl]      = byte6 & 0x04 == 0x04,
    [ArmorSpecialty.ElfCapeDodge]      = byte6 & 0x02 == 0x02,
    [ArmorSpecialty.BlockAllMagic]     = byte6 & 0x01 == 0x01,
  };

  obj.element_effect = memory.readbyte(0x110610 + offset, "CARTROM");
  obj.status_effect  = memory.readbyte(0x110611 + offset, "CARTROM");

  return obj;
end

local cached_armor_data = {};

local function get_armor_data(id)
  if cached_armor_data[id] == nil then
    cached_armor_data[id] = read_armor_data(id);
  end
  return cached_armor_data[id];
end

return {
  read_armor_data = read_armor_data,
  get_armor_data = get_armor_data,
  ArmorSpecialty = ArmorSpecialty,
  ArmorStatusEffect = ArmorStatusEffect,
  ArmorElementEffect = ArmorElementEffect,
};
