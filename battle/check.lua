local ram_map = require('autoffv.ram_map.ram_map');
local callable_bitflags = require('autoffv.utils.callable_bitflags');
local character = require('autoffv.character');

local battle_over_flag = callable_bitflags.u8{
  BattleOverFlag = {
    Escape   = 0x01,
    Event    = 0x20,
    GameOver = 0x40,
    Victory  = 0x80,
  }
};

local function in_battle()
  return memory.read_u16_le(ram_map.InputMenu.InBattle) == 0x0310;
end

local function battle_only_functions(values)
  local functions = {};
  for name, fn in pairs(values) do
    functions[name] = function(...)
      if in_battle() then
        return fn(...);
      else
        return nil;
      end
    end
  end
  return functions;
end

local fns = {};

function fns.back_attack()
  return memory.readbyte(ram_map.InputMenu.BackAttack) == 1;
end

function fns.battle_state()
  return battle_over_flag(memory.readbyte(ram_map.InputMenu.BattleOverFlag));
end

function fns.victory()
  return battle_state()[battle_over_flag.BattleOverFlag.Victory];
end

function fns.game_over()
  return battle_state()[battle_over_flag.BattleOverFlag.GameOver];
end

function fns.escaped()
  return battle_state()[battle_over_flag.BattleOverFlag.Escape];
end

function fns.battle_over()
  return memory.readbyte(ram_map.InputMenu.BattleOverFlag) ~= 0;
end

local battle_only = battle_only_functions(fns);

return {
  in_battle = in_battle,
  battle_only_functions = battle_only_functions,

  back_attack = battle_only.back_attack,
  battle_state = battle_only.battle_state,
  victory = battle_only.victory,
  game_over = battle_only.game_over,
  escaped = battle_only.escaped,
  battle_over = battle_only.battle_over,

  BattleOverFlag = battle_over_flag.BattleOverFlag,
};
