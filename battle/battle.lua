local check = require('ff5.battle.check');
local menu  = require('ff5.battle.menu');
local character = require('ff5.character');
local status = require('ff5.status');

local fns = {}

function fns.battler(t)
  return character.get_battler(character.character_slot(t));
end

function fns.bartz()
  return fns.battler(character.Character.Bartz);
end

function fns.lenna()
  return fns.battler(character.Character.Lenna);
end

function fns.galuf()
  return fns.battler(character.Character.Galuf);
end

function fns.faris()
  return fns.battler(character.Character.Faris);
end

function fns.krile()
  return fns.battler(character.Character.Krile);
end

function fns.enemy(n)
  if character.is_slot(n) then
    return character.get_battler(n.value - 4);
  else
    return fns.battler(n);
  end
end

local query_functions = {};

local character_param_functions = {}
local character_direct_param_functions = {}

local function test_param(param, kparams)
  if type(kparams) == "table" do
    for k, v in pairs(kparams) do
      local p = true;
      if k == "lt" then
        p = param < v;
      elseif k == "gt" then
        p = param > v;
      elseif k == "leq" then
        p = param <= v;
      elseif k == "geq" then
        p = param >= v;
      elseif k == "eq" then
        p = param == v;
      elseif k == "neq" then
        p = param ~= v;
      end
      if not p then
        return false;
      end
    end
    return true;
  else
    return param == kparams;
  end
end

function character_param_functions.hp(c)
  return c.hp();
end

function character_param_functions.mp(c)
  return c.mp();
end

function character_param_functions.maxhp(c)
  return c.maxhp();
end

function character_param_functions.maxmp(c)
  return c.maxmp();
end

function character_param_functions.hp_ratio(c)
  return c.hp()/c.maxhp();
end

function character_param_functions.mp_ratio(c)
  return c.mp()/c.maxmp();
end

function character_param_functions.level(c)
  return c.level();
end

function character_direct_param_functions.name(c)
  return c.name();
end

function character_direct_param_functions.id(c)
  return c.id();
end

function character_direct_param_functions.id(c)
  return c.id();
end

local status_enum = {
  Darkness = status.StatusCurable,
  Zombie   = status.StatusCurable,
  Poison   = status.StatusCurable,
  Float    = status.StatusCurable,
  Mini     = status.StatusCurable,
  Toad     = status.StatusCurable,
  Petrify  = status.StatusCurable,
  Dead     = status.StatusCurable,

  Image1   = status.StatusTemporary,
  Image2   = status.StatusTemporary,
  Mute     = status.StatusTemporary,
  Beserk   = status.StatusTemporary,
  Charm    = status.StatusTemporary,
  Paralyze = status.StatusTemporary,
  Sleep    = status.StatusTemporary,
  Aging    = status.StatusTemporary,

  Regen        = status.StatusDispellable,
  Invulnerable = status.StatusDispellable,
  Slow         = status.StatusDispellable,
  Haste        = status.StatusDispellable,
  Stop         = status.StatusDispellable,
  Shell        = status.StatusDispellable,
  Armor        = status.StatusDispellable,
  Wall         = status.StatusDispellable,

  Hidden     = status.StatusPermanent,
  NearDeath  = status.StatusPermanent,
  Singing    = status.StatusPermanent,
  HpLeak     = status.StatusPermanent,
  Countdown  = status.StatusPermanent,
  Controlled = status.StatusPermanent,
  FalseImage = status.StatusPermanent,
  Erased     = status.StatusPermanent,
};

local status_field = {
  Darkness = "curable",
  Zombie   = "curable",
  Poison   = "curable",
  Float    = "curable",
  Mini     = "curable",
  Toad     = "curable",
  Petrify  = "curable",
  Dead     = "curable",

  Image1   = "temporary",
  Image2   = "temporary",
  Mute     = "temporary",
  Beserk   = "temporary",
  Charm    = "temporary",
  Paralyze = "temporary",
  Sleep    = "temporary",
  Aging    = "temporary",

  Regen        = "dispellable",
  Invulnerable = "dispellable",
  Slow         = "dispellable",
  Haste        = "dispellable",
  Stop         = "dispellable",
  Shell        = "dispellable",
  Armor        = "dispellable",
  Wall         = "dispellable",

  Hidden     = "permanent",
  NearDeath  = "permanent",
  Singing    = "permanent",
  HpLeak     = "permanent",
  Countdown  = "permanent",
  Controlled = "permanent",
  FalseImage = "permanent",
  Erased     = "permanent",
};

local character_target = {
  [0x80] = 0,
  [0x40] = 1,
  [0x20] = 2,
  [0x10] = 1,
};

local function filter_targeted(allies, characters, kparams)
  local result = {};
  for _, c in pairs(characters) do
    local p = kparams.neg;
    for _, i in pairs(allies) do
      if i ~= c.slot then
        local k = character.get_battler(i);
        local t = character_target[k.command_use[1].target.character()];
        if kparams.item ~= nil then
          local item = menu.get_item(menu.item_selection(i));
          if item ~= nil and item.name() == kparams.item and k.executing() and t == c.slot then
            p = not kparams.neg;
            break;
          end
        else
          if k.executing() and t == c.slot then
            p = not kparams.neg;
            break;
          end
        end
      end
    end
    if p then
      table.insert(result, c);
    end
  end
  return result;
end

local function filter_battlers(characters, params)
  for key, kparams in pairs(params) do
    local result = {};
    if key == "status" then
      if type(kparams) == "string" then
        kparams = {kparams};
      end
      for _, c in pairs(characters) do
        local p = true;
        for _, s in pairs(kparams) do
          local enum = status_enum[s];
          local field = status_field[s];
          if not c.status[field]()[enum[s]] then
            p = false;
            break;
          end
        end
        if p then
          table.insert(result, c);
        end
      end
    elseif character_param_functions[key] ~= nil then
      for _, c in pairs(characters) do
        if test_param(character_param_functions[key](c), kparams) then
          table.insert(result, c);
        end
      end
    elseif character_str_param_functions[key] ~= nil then
      for _, c in pairs(characters) do
        if character_str_param_functions[key](c) == kparams then
          table.insert(result, c);
        end
      end
    elseif key == "targeted" then
      if kparams.ally == "Any" then
        result = filter_targeted({0,1,2,3}, characters, kparams);
      elseif kparams.ally ~= nil then
        local allies;
        if type(kparams.ally) == "string" then
          allies = {character.character_slot(kparams.ally)};
        else
          allies = {};
          for _, a in pairs(kparams.ally) do
            table.insert(allies, character.character_slot(a));
          end
        end
        result = filter_targeted(allies, characters, kparams);
      end
    end
    characters = result;
  end
  return characters;
end

function query_functions.character(params)
  local characters = {};
  for i=0,3 do
    local c = character.get_battler(i);
    if c.selectable() then
      table.insert(characters, c);
    end
  end
  return filter_battlers(characters, params);
end

function query_functions.enemy(params)
  local characters = {};
  for i=0,7 do
    local c = character.get_battler(i+4);
    if c.selectable() then
      table.insert(characters, c);
    end
  end
  return filter_battlers(characters, params);
end

function query_functions.battler(params)
  local characters = {};
  for i=0,11 do
    local c = character.get_battler(i);
    if c.selectable() then
      table.insert(characters, c);
    end
  end
  return filter_battlers(characters, params);
end

function fns.query(params)
  for key, values in pairs(params) do
    return query_functions[key](values);
  end
end

local battle_only = check.battle_only_functions(fns);

return {
  check = check,
  menu = menu,
  battler = battle_only.battler,
  bartz = battle_only.bartz,
  lenna = battle_only.lenna,
  galuf = battle_only.galuf,
  faris = battle_only.faris,
  krile = battle_only.krile,
  enemy = battle_only.enemy,
  Slot  = character.Slot,
  query = battle_only.query,
};
