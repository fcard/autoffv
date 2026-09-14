local Const = require('ff5.utils.const');
local Command = require('ff5.ability.command');
local ram_map = require('ff5.ram_map.ram_map');
local magic = require('ff5.magic');
local item = require('ff5.item');
local character = require('ff5.character');
local check = require('ff5.battle.check');

local fns = {};

function fns.active_character()
  return memory.readbyte(ram_map.InputMenu.ActiveCharacter);
end

function fns.command_selection(character_slot)
  return memory.readbyte(ram_map.InputMenu.CmdSelectedC1 + character_slot);
end

function fns.item_selection(character_slot)
  return memory.readbyte(ram_map.InputMenu.ItemSelectedC1 + character_slot);
end

function fns.spell_sword_selection(character_slot)
  return memory.readbyte(ram_map.InputMenu.SpSwSelectedC1 + character_slot);
end

function fns.spell_sword_selection(character_slot)
  return memory.readbyte(ram_map.InputMenu.SpSwSelectedC1 + character_slot);
end

function fns.white_magic_selection(character_slot)
  return memory.readbyte(ram_map.InputMenu.WhiteSelectedC1 + character_slot);
end

function fns.black_magic_selection(character_slot)
  return memory.readbyte(ram_map.InputMenu.BlackSelectedC1 + character_slot);
end

function fns.time_magic_selection(character_slot)
  return memory.readbyte(ram_map.InputMenu.TimeSelectedC1 + character_slot);
end

function fns.summoner_magic_selection(character_slot)
  return memory.readbyte(ram_map.InputMenu.SummonSelectedC1 + character_slot);
end

function fns.blue_magic_selection(character_slot)
  return memory.readbyte(ram_map.InputMenu.BlueSelectedC1 + character_slot);
end

function fns.red_magic_selection(character_slot)
  return memory.readbyte(ram_map.InputMenu.RedSelectedC1 + character_slot);
end

function fns.x_magic_selection(character_slot)
  return memory.readbyte(ram_map.InputMenu.XMagicSelectedC1 + character_slot);
end

local atb_timer_addresses = {
  [0] = ram_map.InputMenu.AtbCharacter1,
  [1] = ram_map.InputMenu.AtbCharacter2,
  [2] = ram_map.InputMenu.AtbCharacter3,
  [3] = ram_map.InputMenu.AtbCharacter4,
};

function fns.atb_timer(character_slot)
  return memory.readbyte(atb_timer_addresses[character_slot]);
end

function fns.get_item(index)
  return item(memory.readbyte(ram_map.InputMenu.BattleItemIds + index));
end

function fns.get_item_qty(index)
  return memory.readbyte(ram_map.InputMenu.BattleItemQty + index);
end

function fns.get_spell_sword(index)
  return magic(index);
end

function fns.get_white_magic(index)
  return magic(index + 0x12);
end

function fns.get_black_magic(index)
  return magic(index + 0x24);
end

function fns.get_time_magic(index)
  return magic(index + 0x36);
end

function fns.get_summon_magic(index)
  return magic(index + 0x48);
end

function fns.get_blue_magic(index)
  return magic(index + 0x82);
end

function fns.get_red_magic(index)
  return magic(index + 0x12);
end

local command_selection_functions = {
  [Command.Item]           = fns.item_selection,
  [Command.Drink]          = fns.item_selection,
  [Command.Mix]            = fns.item_selection,
  [Command.Throw]          = fns.item_selection,

  [Command.MagicSwordLv1]  = fns.spell_sword_selection,
  [Command.MagicSwordLv2]  = fns.spell_sword_selection,
  [Command.MagicSwordLv3]  = fns.spell_sword_selection,
  [Command.MagicSwordLv4]  = fns.spell_sword_selection,
  [Command.MagicSwordLv5]  = fns.spell_sword_selection,
  [Command.MagicSwordLv6]  = fns.spell_sword_selection,

  [Command.WhiteLv1]  = fns.white_magic_selection,
  [Command.WhiteLv2]  = fns.white_magic_selection,
  [Command.WhiteLv3]  = fns.white_magic_selection,
  [Command.WhiteLv4]  = fns.white_magic_selection,
  [Command.WhiteLv5]  = fns.white_magic_selection,
  [Command.WhiteLv6]  = fns.white_magic_selection,

  [Command.BlackLv1]  = fns.black_magic_selection,
  [Command.BlackLv2]  = fns.black_magic_selection,
  [Command.BlackLv3]  = fns.black_magic_selection,
  [Command.BlackLv4]  = fns.black_magic_selection,
  [Command.BlackLv5]  = fns.black_magic_selection,
  [Command.BlackLv6]  = fns.black_magic_selection,

  [Command.DimenLv1]  = fns.time_magic_selection,
  [Command.DimenLv2]  = fns.time_magic_selection,
  [Command.DimenLv3]  = fns.time_magic_selection,
  [Command.DimenLv4]  = fns.time_magic_selection,
  [Command.DimenLv5]  = fns.time_magic_selection,
  [Command.DimenLv6]  = fns.time_magic_selection,

  [Command.SummonLv1] = fns.summoner_magic_selection,
  [Command.SummonLv2] = fns.summoner_magic_selection,
  [Command.SummonLv3] = fns.summoner_magic_selection,
  [Command.SummonLv4] = fns.summoner_magic_selection,
  [Command.SummonLv5] = fns.summoner_magic_selection,

  [Command.Blue]     = fns.blue_magic_selection,
  [Command.RedLv1]   = fns.red_magic_selection,
  [Command.RedLv2]   = fns.red_magic_selection,
  [Command.RedLv3]   = fns.red_magic_selection,
  [Command.XMagic]   = fns.x_magic_selection,
};

local command_get_functions = {
  [Command.Item]           = fns.get_item,
  [Command.Drink]          = fns.get_item,
  [Command.Mix]            = fns.get_item,
  [Command.Throw]          = fns.get_item,

  [Command.MagicSwordLv1]  = fns.get_spell_sword,
  [Command.MagicSwordLv2]  = fns.get_spell_sword,
  [Command.MagicSwordLv3]  = fns.get_spell_sword,
  [Command.MagicSwordLv4]  = fns.get_spell_sword,
  [Command.MagicSwordLv5]  = fns.get_spell_sword,
  [Command.MagicSwordLv6]  = fns.get_spell_sword,

  [Command.WhiteLv1]  = fns.get_white_magic,
  [Command.WhiteLv2]  = fns.get_white_magic,
  [Command.WhiteLv3]  = fns.get_white_magic,
  [Command.WhiteLv4]  = fns.get_white_magic,
  [Command.WhiteLv5]  = fns.get_white_magic,
  [Command.WhiteLv6]  = fns.get_white_magic,

  [Command.BlackLv1]  = fns.get_black_magic,
  [Command.BlackLv2]  = fns.get_black_magic,
  [Command.BlackLv3]  = fns.get_black_magic,
  [Command.BlackLv4]  = fns.get_black_magic,
  [Command.BlackLv5]  = fns.get_black_magic,
  [Command.BlackLv6]  = fns.get_black_magic,

  [Command.DimenLv1]   = fns.get_time_magic,
  [Command.DimenLv2]   = fns.get_time_magic,
  [Command.DimenLv3]   = fns.get_time_magic,
  [Command.DimenLv4]   = fns.get_time_magic,
  [Command.DimenLv5]   = fns.get_time_magic,
  [Command.DimenLv6]   = fns.get_time_magic,

  [Command.SummonLv1] = fns.get_summon_magic,
  [Command.SummonLv2] = fns.get_summon_magic,
  [Command.SummonLv3] = fns.get_summon_magic,
  [Command.SummonLv4] = fns.get_summon_magic,
  [Command.SummonLv5] = fns.get_summon_magic,

  [Command.Blue]     = fns.get_blue_magic,
  [Command.RedLv1]   = fns.get_red_magic,
  [Command.RedLv2]   = fns.get_red_magic,
  [Command.RedLv3]   = fns.get_red_magic,
  [Command.XMagic]   = fns.get_red_magic,
};

local BattleMenu = Const{
  Command     = 0x01,
  Item        = 0x02,
  MagicSword  = 0x03,
  WhiteMagic  = 0x04,
  BlackMagic  = 0x05,
  TimeMagic   = 0x06,
  SummonMagic = 0x07,
  BlueMagic   = 0x08,
  RedMagic    = 0x09,
  XMagic      = 0x0a,
  Drink       = 0x0b,
  Mix         = 0x0c,
  Throw       = 0x0d,
};

local command_menu = {
  [Command.Fight]          = BattleMenu.Command,
  [Command.Kick]           = BattleMenu.Command,

  [Command.Item]           = BattleMenu.Item,
  [Command.Drink]          = BattleMenu.Item,
  [Command.Mix]            = BattleMenu.Item,
  [Command.Throw]          = BattleMenu.Item,

  [Command.MagicSwordLv1]  = BattleMenu.MagicSword,
  [Command.MagicSwordLv2]  = BattleMenu.MagicSword,
  [Command.MagicSwordLv3]  = BattleMenu.MagicSword,
  [Command.MagicSwordLv4]  = BattleMenu.MagicSword,
  [Command.MagicSwordLv5]  = BattleMenu.MagicSword,
  [Command.MagicSwordLv6]  = BattleMenu.MagicSword,

  [Command.WhiteLv1]  = BattleMenu.WhiteMagic,
  [Command.WhiteLv2]  = BattleMenu.WhiteMagic,
  [Command.WhiteLv3]  = BattleMenu.WhiteMagic,
  [Command.WhiteLv4]  = BattleMenu.WhiteMagic,
  [Command.WhiteLv5]  = BattleMenu.WhiteMagic,
  [Command.WhiteLv6]  = BattleMenu.WhiteMagic,

  [Command.BlackLv1]  = BattleMenu.BlackMagic,
  [Command.BlackLv2]  = BattleMenu.BlackMagic,
  [Command.BlackLv3]  = BattleMenu.BlackMagic,
  [Command.BlackLv4]  = BattleMenu.BlackMagic,
  [Command.BlackLv5]  = BattleMenu.BlackMagic,
  [Command.BlackLv6]  = BattleMenu.BlackMagic,

  [Command.DimenLv1]   = BattleMenu.TimeMagic,
  [Command.DimenLv2]   = BattleMenu.TimeMagic,
  [Command.DimenLv3]   = BattleMenu.TimeMagic,
  [Command.DimenLv4]   = BattleMenu.TimeMagic,
  [Command.DimenLv5]   = BattleMenu.TimeMagic,
  [Command.DimenLv6]   = BattleMenu.TimeMagic,

  [Command.SummonLv1] = BattleMenu.SummonMagic,
  [Command.SummonLv2] = BattleMenu.SummonMagic,
  [Command.SummonLv3] = BattleMenu.SummonMagic,
  [Command.SummonLv4] = BattleMenu.SummonMagic,
  [Command.SummonLv5] = BattleMenu.SummonMagic,

  [Command.Blue]     = BattleMenu.BlueMagic,
  [Command.RedLv1]   = BattleMenu.RedMagic,
  [Command.RedLv2]   = BattleMenu.RedMagic,
  [Command.RedLv3]   = BattleMenu.RedMagic,
  [Command.XMagic]   = BattleMenu.XMagic,
};

local command_menu_equiv = {
  [Command.Item]           = BattleMenu.Item,
  [Command.Drink]          = BattleMenu.Drink,
  [Command.Mix]            = BattleMenu.Mix,
  [Command.Throw]          = BattleMenu.Throw,

  [Command.MagicSwordLv1]  = BattleMenu.MagicSword,
  [Command.MagicSwordLv2]  = BattleMenu.MagicSword,
  [Command.MagicSwordLv3]  = BattleMenu.MagicSword,
  [Command.MagicSwordLv4]  = BattleMenu.MagicSword,
  [Command.MagicSwordLv5]  = BattleMenu.MagicSword,
  [Command.MagicSwordLv6]  = BattleMenu.MagicSword,

  [Command.WhiteLv1]  = BattleMenu.WhiteMagic,
  [Command.WhiteLv2]  = BattleMenu.WhiteMagic,
  [Command.WhiteLv3]  = BattleMenu.WhiteMagic,
  [Command.WhiteLv4]  = BattleMenu.WhiteMagic,
  [Command.WhiteLv5]  = BattleMenu.WhiteMagic,
  [Command.WhiteLv6]  = BattleMenu.WhiteMagic,

  [Command.BlackLv1]  = BattleMenu.BlackMagic,
  [Command.BlackLv2]  = BattleMenu.BlackMagic,
  [Command.BlackLv3]  = BattleMenu.BlackMagic,
  [Command.BlackLv4]  = BattleMenu.BlackMagic,
  [Command.BlackLv5]  = BattleMenu.BlackMagic,
  [Command.BlackLv6]  = BattleMenu.BlackMagic,

  [Command.DimenLv1]   = BattleMenu.TimeMagic,
  [Command.DimenLv2]   = BattleMenu.TimeMagic,
  [Command.DimenLv3]   = BattleMenu.TimeMagic,
  [Command.DimenLv4]   = BattleMenu.TimeMagic,
  [Command.DimenLv5]   = BattleMenu.TimeMagic,
  [Command.DimenLv6]   = BattleMenu.TimeMagic,

  [Command.SummonLv1] = BattleMenu.SummonMagic,
  [Command.SummonLv2] = BattleMenu.SummonMagic,
  [Command.SummonLv3] = BattleMenu.SummonMagic,
  [Command.SummonLv4] = BattleMenu.SummonMagic,
  [Command.SummonLv5] = BattleMenu.SummonMagic,

  [Command.Blue]     = BattleMenu.BlueMagic,
  [Command.RedLv1]   = BattleMenu.RedMagic,
  [Command.RedLv2]   = BattleMenu.RedMagic,
  [Command.RedLv3]   = BattleMenu.RedMagic,
  [Command.XMagic]   = BattleMenu.XMagic,
};

function fns.battle_menu_from_command(cmd)
  return command_menu[cmd];
end

function fns.current_target_selection()
  local target_flag = memory.readbyte(ram_map.InputMenu.TargetFlag);
  if target_flag == 0x12 then
    local t = memory.readbyte(ram_map.InputMenu.BattleTarget);
    local targeted_entry;
    if t < 8 then
      targeted_entry = function()
        return character.get_battler(t+4);
      end
    else
      targeted_entry = function()
        return character.get_battler(t-8);
      end
    end

    return {
      targeted_index = t,
      targeted_entity = targeted_entry,
      multi_target = memory.readbyte(ram_map.InputMenu.MultiTarget),
    };
  end
end

function fns.current_menu_selection()
  local in_control = memory.readbyte(ram_map.InputMenu.InControlOfMenu) == 1;
  if in_control then
    local character_slot = fns.active_character();
    local in_magic_menu = memory.readbyte(ram_map.InputMenu.MagicMenuFlag) == 0x20;
    local in_item_menu = memory.readbyte(ram_map.InputMenu.InItemMenu) == 1;
    local in_sub_menu = in_magic_menu or in_item_menu;
    if in_sub_menu then
      local last_command = memory.readbyte(ram_map.InputMenu.LastCommandSelected1);
      local selected_index = command_selection_functions[last_command](character_slot);
      local selected_item = command_get_functions[last_command](selected_index);
      return {
        character = character_slot,
        selected_index = selected_index,
        menu = command_menu[last_command],
        target = fns.current_target_selection(),
        selected_item = function()
          return selected_item;
        end,
      };
    else
      local cmd_index = fns.command_selection(character_slot);
      local cmd = character.get_battler(character_slot).command[cmd_index+1].get();
      return {
        character = character_slot,
        selected_index = cmd_index,
        menu = BattleMenu.Command,
        target = fns.current_target_selection(),
        selected_item = function()
          return cmd;
        end,
      };
    end
  end
end

function fns.find_command_index(character_data, goal_cmd)
  local commands;
  local goal_cmd_menu = command_menu_equiv[goal_cmd];

  if type(character_data) == "number" then
    commands = character.get_battler(character_data).command;
  else
    commands = character_data.command;
  end

  local goal_index;
  for i, cmd in ipairs(commands) do
    if command_menu_equiv[cmd()] == goal_cmd_menu then
      goal_index = i-1;
    end
  end

  return goal_index;
end

local function match_item(x, data)
  if type(x) == "number" then
    return x == data.id();
  elseif type(x) == "string" then
    return x == data.name();
  elseif type(x) == "function" then
    return x(data);
  else
    return false
  end
end

function fns.find_item_index(item)
  for i=0x00,0xff do
    local listed_item = fns.get_item(i);
    local listed_item_qty = fns.get_item_qty(i);
    if listed_item_qty > 0 and match_item(item, listed_item) then
      return i;
    end
  end
end

local function match_entity(x, data)
  if type(x) == "number" then
    return x == data.id();
  elseif type(x) == "string" then
    return x == data.name() or (x == "Bartz" and data.id() == character.Character.Bartz);
  elseif type(x) == "function" then
    return x(data);
  elseif character.is_battler(x) then
    return x.id() == data.id();
  elseif character.is_slot(x) then
    return x.value == data.slot;
  else
    return false
  end
end

function fns.find_entity_index(entity)
  for i=0,3 do
    local listed_entity = character.get_battler(i);
    if listed_entity.selectable() and match_entity(entity, listed_entity) then
      return i+8;
    end
  end
  for i=0,7 do
    local listed_entity = character.get_battler(i+4);
    if listed_entity.selectable() and match_entity(entity, listed_entity) then
      return i;
    end
  end
end

local battle_only = check.battle_only_functions(fns);

return {
  active_character = battle_only.active_character,
  command_selection = battle_only.command_selection,

  item_selection = battle_only.item_selection,
  spell_sword_selection = battle_only.spell_sword_selection,
  white_magic_selection = battle_only.white_magic_selection,
  black_magic_selection = battle_only.black_magic_selection,
  time_magic_selection  = battle_only.time_magic_selection,
  summoner_magic_selection = battle_only.summoner_magic_selection,
  blue_magic_selection = battle_only.blue_magic_selection,
  red_magic_selection = battle_only.red_magic_selection,

  get_item = battle_only.get_item,
  get_item_qty = battle_only.get_item_qty,
  get_spell_sword = battle_only.get_spell_sword,
  get_white_magic = battle_only.get_white_magic,
  get_black_magic = battle_only.get_black_magic,
  get_time_magic  = battle_only.get_time_magic,
  get_summoner_magic = battle_only.get_summoner_magic,
  get_blue_magic = battle_only.get_blue_magic,
  get_red_magic = battle_only.get_red_magic,

  battle_menu_from_command = battle_only.battle_menu_from_command,

  atb_timer = battle_only.atb_timer,
  current_target_selection = battle_only.current_target_selection,
  current_menu_selection = battle_only.current_menu_selection,
  find_command_index = battle_only.find_command_index,
  find_item_index = battle_only.find_item_index,
  find_entity_index = battle_only.find_entity_index,

  BattleMenu = BattleMenu,
};
