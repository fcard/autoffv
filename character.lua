local mem = require('ff5.utils.mem');
local value = require('ff5.utils.value');
local Const = require('ff5.utils.const');
local None = require('ff5.utils.none');
local callable = require('ff5.utils.callable');
local equip = require('ff5.equip');
local status = require('ff5.status');
local action_flags = require('ff5.action_flags');
local damage_modifier = require('ff5.damage_modifier');
local magic_element_up = require('ff5.magic_element_up');
local Stat = require('ff5.stat');
local element = require('ff5.element');
local weapon_specialty = require('ff5.weapon_specialty');
local armor_specialty = require('ff5.armor_specialty');
local magic_enabled = require('ff5.magic_enabled');
local weapon_category = require('ff5.weapon_category');
local armor_category = require('ff5.armor_category');
local action_type = require('ff5.action_type');
local monster_specialty = require('ff5.monster_specialty');
local song_chanted = require('ff5.song_chanted');
local innate_abilities = require('ff5.innate_abilities');
local creature_type = require('ff5.creature_type');
local command_immunity = require('ff5.command_immunity');
local enemy_name = require('ff5.enemy_name');
local character_name = require('ff5.character_name');

local Character = Const{
  Bartz=0x100,
  Lenna=0x101,
  Galuf=0x102,
  Faris=0x103,
  Krile=0x104,
};

local Gender = Const{Male=0, Female=1};

local function character(m)
  local obj = {id = None, gender = None, in_team = None, back_row = None};
  return value.dependant(obj, value.u8(m), function()
    local b = obj.subvalue();
    obj.id = (b & 0x07) + 0x100;
    obj.gender = (b & 0x08) >> 3;
    obj.in_team = b & 0x40 ~= 0x40;
    obj.back_row = b & 0x80 == 0x80;
  end);
end

local battler_identifier = {};

local function is_battler(t)
  return type(t) == "table" and t.__battler_identifier == battler_identifier;
end

local function get_battler(slot)
  local offset = 0x0080 * slot;
  local m = mem(0x2000 + offset);

  local battler = {
    slot = slot,
    character = character(m),
    job   = value.u8(m+0x01),
    level = value.u8(m+0x02),
    exp   = value.u24(m+0x03),
    hp    = value.u16(m+0x06),
    maxhp = value.u16(m+0x08),
    mp    = value.u16(m+0x0a),
    maxmp = value.u16(m+0x0c),
    equip = {
      head       = equip.equipment(m+0x0e),
      body       = equip.equipment(m+0x0f),
      accessory  = equip.equipment(m+0x10),
      right_hand = equip.hand(m+0x11, m+0x13),
      left_hand  = equip.hand(m+0x12, m+0x14),
    },
    monster_caught = value.u8(m+0x15),
    command = {
      value.u8(m+0x16),
      value.u8(m+0x17),
      value.u8(m+0x18),
      value.u8(m+0x19),
    },
    status = {
      curable     = status.curable(m+0x1a),
      temporary   = status.temporary(m+0x1b),
      dispellable = status.dispellable(m+0x1c),
      permanent   = status.permanent(m+0x1d),
    },
    action_flags = action_flags(m+0x1e),
    damage_modifier = damage_modifier(m+0x1f),
    innate_abilities = innate_abilities(m+0x20),
    magic_element_up = magic_element_up(m+0x22),
    equip_weight = value.u8(m+0x23),
    base_stats = {
      [Stat.Strength] = value.u8(m+0x24),
      [Stat.Speed]    = value.u8(m+0x25),
      [Stat.Vitality] = value.u8(m+0x26),
      [Stat.Magic]    = value.u8(m+0x27),
    },
    stats = {
      [Stat.Strength] = value.u8(m+0x28),
      [Stat.Speed]    = value.u8(m+0x29),
      [Stat.Vitality] = value.u8(m+0x2a),
      [Stat.Magic]    = value.u8(m+0x2b),
    },
    evasion = value.u8(m+0x2c),
    defense = value.u8(m+0x2d),
    magic_evasion = value.u8(m+0x2e),
    magic_defense = value.u8(m+0x2f),
    element = {
      absorb   = element(m+0x30),
      evade    = element(m+0x31),
      immunity = element(m+0x32),
      half     = element(m+0x33),
      weakness = element(m+0x34),
    },
    status_immunity = {
      curable = status.curable(m+0x35),
      temporary = status.temporary(m+0x36),
      dispellable = status.dispellable(m+0x37),
    },
    weapon_specialty = weapon_specialty(m+0x38),
    armor_specialty = armor_specialty(m+0x39),
    job_level = value.u8(m+0x3a),
    abp = value.u16(m+0x3b),
    magic_enabled = magic_enabled(m+0x3d),
    weapon_category = weapon_category(m+0x40),
    armor_category = armor_category(m+0x42),
    right_hand_attack = value.u8(m+0x44),
    left_hand_attack = value.u8(m+0x45),
    counter_attack = {
      [1] = {
        command = value.u8(m+0x46),
        magic = value.u8(m+0x47),
        item = value.u8(m+0x48),
        attack_attribute = value.u8(m+0x49),
        attack_category = value.u8(m+0x4a),
        attack_target = value.u8(m+0x4b),
        damaged = value.u8(m+0x4c),
      },
      [2] = {
        command = value.u8(m+0x4d),
        magic = value.u8(m+0x4e),
        item = value.u8(m+0x4f),
        attack_attribute = value.u8(m+0x7b),
        attack_category = value.u8(m+0x7c),
        attack_target = value.u8(m+0x7d),
        damaged = value.u8(m+0x7e),
      },
    },
    magic_sword = {
      element = {
        level1 = element(m+0x50),
        level2 = element(m+0x51),
        level3 = element(m+0x52),
      },
      status = {
        level1 = status.curable(m+0x53),
        level2 = status.curable(m+0x54),
        level3 = status.magic_sword_lv3(m+0x55),
      },
    },
    command_use = {
      [1] = {
        action = action_flags(m+0x56),
        command = value.u8(m+0x57),
        target = {
          enemy = value.u8(m+0x58),
          character = value.u8(m+0x59),
        },
        item_or_magic = value.u8(m+0x5a),
      },
      [2] = {
        action = action_flags(m+0x5b),
        command = value.u8(m+0x5c),
        target = {
          enemy = value.u8(m+0x5d),
          character = value.u8(m+0x5e),
        },
        item_or_magic = value.u8(m+0x5f),
      },
      acted = value.u8(m+0x61),
      damage_modifier = damage_modifier(m+0x62),
    },

    cannot_evade = action_type(m+0x64),
    creature_type = creature_type(m+0x65),
    command_immunity = command_immunity(m+0x66),
    enemy_experience = value.u16(m+0x67),
    enemy_gil = value.u16(m+0x69),
    enemy_item_stolen = value.bool(m+0x6b),
    left_hand_attack_type = action_type(m+0x6c),
    right_hand_attack_type = action_type(m+0x6d),
    monster_specialty = monster_specialty(m+0x6e),
    song_chanted = song_chanted(m+0x6f),
    initial_status = {
      curable     = status.curable(m+0x70),
      temporary   = status.temporary(m+0x71),
      dispellable = status.dispellable(m+0x72),
      permanent   = status.permanent(m+0x73),
    },
    song_bonus = {
      [Stat.Strength] = value.u8(m+0x74),
      [Stat.Speed] = value.u8(m+0x75),
      [Stat.Vitality] = value.u8(m+0x76),
      [Stat.Magic] = value.u8(m+0x77),
      [Stat.Level] = value.u8(m+0x78),
    },
    magic_sword_spell = value.u8(m+0x7a),
    __battler_identifier = battler_identifier,
  };

  battler.atb_timer = value.u8(mem(0x3d7f + slot*11));
  battler.atb_flag = value.u8(mem(0x3cfb + slot*11));

  function battler.executing()
    return (battler.atb_flag() & 0x40) == 0x40;
  end

  if slot < 4 then
    battler.is_enemy = false;
    function battler.id()
      return battler.character().id;
    end
    battler.character_id = battler.id;
    function battler.enemy_id()
      return nil;
    end
    function battler.name()
      return character_name.get_name(battler.character_id()-0x100);
    end
    function battler.selectable()
      return battler.character().in_team;
    end
  else
    local enemy_slot = slot - 4;
    local name_id = value.u8(mem(0x3f1d + 0x0020*enemy_slot));
    local coord_byte = value.u8(mem(0x4000 + enemy_slot));
    battler.is_enemy = true;
    battler.id = value.u8(mem(0x3ef3 + enemy_slot));
    battler.enemy_id = battler.id;
    function battler.character_id()
      return nil;
    end
    function battler.name()
      return enemy_name.get_name(name_id());
    end
    local coord = {x = None, y = None};
    battler.coord = value.dependant(coord, coord_byte, function()
      local b = coord.subvalue();
      coord.x = (b & 0xf0) >> 4;
      coord.y = (b & 0x0f) >> 0;
    end);
    function battler.selectable()
      return battler.id() ~= 0xff and not battler.status.curable()[status.StatusCurable.Dead];
    end
  end
  return battler;
end

local slot_identifier = {};
local function Slot(n)
  return {
    value = n,
    __slot_identifier = slot_identifier,
  };
end

local function is_slot(x)
  return type(x) == "table" and x.__slot_identifier == slot_identifier;
end

local function character_slot(t)
  if type(t) == "number" then
    for i=0,11 do
      if get_battler(i).character_id() == t then
        return i;
      end
    end
  elseif type(t) == "string" then
    for i=0,11 do
      if get_battler(i).name() == t then
        return i;
      end
    end
  elseif type(t) == "function" then
    for i=0,11 do
      if t(get_battler(i)) then
        return i;
      end
    end
  elseif is_battler(t) then
    return t.slot;
  elseif is_slot(t) then
    return t.value;
  end
end

local fns = {
  get_battler = get_battler,
  is_battler = is_battler,
  character_slot = character_slot,
  Character = Character,
  Gender = Gender,
  Slot = Slot,
  is_slot = is_slot,
};

return callable(fns, character, 1);
