local battle = require('autoffv.battle.battle');
local character = require('autoffv.character');
local input = require('autoffv.automation.input');
local Command = require('autoffv.ability.command');
local MagicId = require('autoffv.magic_id');
local magic_commands = require('autoffv.magic_commands');

local function validate_character(character_data)
  if character_data == nil then
    character_data = character.Slot(battle.menu.active_character());
  end

  local character_slot = character.character_slot(character_data);
  return character.get_battler(character_slot);
end

local function validate_spell(spell)
  if type(spell) == "string" then
    return MagicId.from_name(spell);
  else
    return spell;
  end
end

local function select_command(goal_cmd, character_data)
  character_data = validate_character(character_data);
  local index = battle.menu.find_command_index(character_data, goal_cmd);
  local selection = battle.menu.current_menu_selection();
  if selection ~= nil and selection.character == character_data.slot then
    if selection.menu == battle.menu.BattleMenu.Command and index ~= nil then
      if selection.selected_index < index then
        input.button_down();
        return false;
      elseif selection.selected_index > index then
        input.button_up();
        return false;
      else
        if selection.target == nil then
          input.button_a();
          return false;
        elseif battle.menu.battle_menu_from_command(goal_cmd) == battle.menu.BattleMenu.Command then
          return true;
        end
      end
    elseif selection.menu ~= battle.menu.battle_menu_from_command(goal_cmd) then
      input.button_b();
      return false;
    else
      return true;
    end
  else
    return false;
  end
end

local function select_spell_command(spell, character_data)
  spell = validate_spell(spell);
  character_data = validate_character(character_data);
  local commands = magic_commands[spell];
  if commands ~= nil and character_data.slot == battle.menu.active_character() then
    for _, command in ipairs(commands) do
      for _, cc in ipairs(character_data.command) do
        if cc() == command then
          return select_command(command, character_data);
        end
      end
    end
    return false;
  else
    return false;
  end
end

local function select_item_slot(index, character_data)
  if select_command(Command.Item, character_data) then
    local selection = battle.menu.current_menu_selection();
    if selection.selected_index == index then
      if selection.target == nil then
        input.button_a();
        return false;
      else
        return true;
      end
    elseif selection.target == nil then
      if selection.selected_index < index-1 then
        input.button_down();
      elseif selection.selected_index < index then
        input.button_right();
      elseif selection.selected_index > index+1 then
        input.button_up();
      elseif selection.selected_index > index then
        input.button_left();
      end
      return false;
    else
      input.button_b();
      return false;
    end
  else
    return false;
  end
end

local function select_item(item, character_data)
  local index = battle.menu.find_item_index(item);
  if index ~= nil then
    return select_item_slot(index, character_data);
  else
    return false;
  end
end

local function select_spell(spell, character_data)
  if select_spell_command(spell, character_data) then
    spell = validate_spell(spell);
    local selection = battle.menu.current_menu_selection();
    local cmd = battle.menu.selected_command();
    local index_diff = selection.selected_item().id() - spell;
    if index_diff == 0 then
      if selection.target == nil then
        input.button_a();
        return false;
      else
        return true;
      end
    elseif selection.target == nil then
      if index_diff < -2 then
        input.button_down();
      elseif index_diff < 0 then
        input.button_right();
      elseif index_diff > 2 then
        input.button_up();
      elseif index_diff > 0 then
        input.button_left();
      end
      return false;
    else
      input.button_b();
      return false;
    end
  else
    return false;
  end
end

local function select_target(target)
  local t = battle.menu.current_target_selection();
  local back_attack = battle.check.back_attack();

  if t ~= nil then
    local index = battle.menu.find_entity_index(target);
    if index ~= nil then
      if t.targeted_index == index then
        input.button_a();
      else
        if t.targeted_index >= 8 and index >= 8 then
          if t.targeted_index < index then
            input.button_down();
          elseif t.targeted_index > index then
            input.button_up();
          end
        elseif t.targeted_index < 8 and index >= 8 then
          if back_attack then
            input.button_left();
          else
            input.button_right();
          end
        elseif t.targeted_index >= 8 and index < 8 then
          if back_attack then
            input.button_right();
          else
            input.button_left();
          end
        else
          local tc = t.targeted_entity().coord();
          local tx = tc.x;
          local ty = tc.y;
          local goal_entity;
          if index < 8 then
            goal_entity = character.get_battler(index+4);
          else
            goal_entity = character.get_battler(index-8);
          end
          local gc = goal_entity.coord();
          local gx = gc.x;
          local gy = gc.y;

          if tx < gx then
            if back_attack then
              input.button_left();
            else
              input.button_right();
            end
          elseif tx > gx then
            if back_attack then
              input.button_right();
            else
              input.button_left();
            end
          elseif ty < gy then
            input.button_down();
          elseif ty > gy then
            input.button_up();
          end
        end
      end
    end
  end
end

local function fight(target, character_data)
  if select_command(Command.Fight, character_data) then
    select_target(target);
  end
end

local function use_item_slot(item, target, character_data)
  if select_item_slot(item, character_data) then
    select_target(target);
  end
end

local function use_item(item, target, character_data)
  if select_item(item, character_data) then
    select_target(target);
  end
end

local function use_spell(spell, target, character_data)
  if select_spell(spell, character_data) then
    select_target(target);
  end
end

return {
  select_spell_command = select_spell_command,
  select_command = select_command,
  select_item = select_item,
  select_item_slot = select_item_slot,
  select_spell = select_spell,
  select_target = select_target,
  use_item = use_item,
  use_item_slot = use_item_slot,
  use_spell = use_spell,
  fight = fight,
};


