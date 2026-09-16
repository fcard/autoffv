# AutoFFV - Final Fantasy V Automation Lua Library for Bizhawk

This is a library meant to allow easy automation of FFV. For example, to automatically set party members to use a potion on anyone below 50% hp:

```lua
local battle = require('autoffv.battle.battle');
local battle_menu = require('autoffv.automation.battle_menu');

while true
  if battle.check.in_battle() then
    local hurt_characters = battle.query{character={hp_ratio={lt=0.5}}};
    if hurt_characters[1] then
      battle_menu.use_item("Potion", hurt_characters[1]);
    end
  end
  emu.frameadvance();
end
```

## Instalation

Clone the repository into your Bizhawk's Lua folder.

```bash
$ cd /path/to/Bizhawk/Lua && git clone https://github.com/fcard/autoffv
```

## Usage

The main interface is currently made up of `battle.query`, which is a function that lets you obtain a list of entities who fulfill certain criteria, and the module `automation.battle_menu`, which has a series of functions that generate the inputs needed to achieve a certain action. Most battle automation scripts will therefore follow the format below:

```lua
local battle = require('autoffv.battle.battle');
local battle_menu = require('autoffv.automation.battle_menu');

while true
  if battle.check.in_battle() then
    -- automation happens here
  end
  emu.frameadvance();
end
```

## `battle_menu`

`battle_menu` functions should be called every frame as long as their action is desired, since they generate a single input that frame that is determined by the current context, instead of queueing up inputs.

```lua
local battle = require('autoffv.battle.battle');
local battle_menu = require('autoffv.automation.battle_menu');

while true
  if battle.check.in_battle() then
    battle_menu.fight("Goblin", "Bartz");    -- will only generate inputs when Bartz can actually use !Fight on a goblin
    battle_menu.use_item("Potion", "Lenna"); -- similarly, will only generate inputs when a potion can be applied to Lenna
  end
  emu.frameadvance();
end
```

This however means that calling `battle_menu` functions once doesn't guarantee that their action will conclude:
```lua
local battle = require('autoffv.battle.battle');
local battle_menu = require('autoffv.automation.battle_menu');

local action_taken = false;
while true
  if battle.check.in_battle() then
    if not action_taken then
      battle_menu.fight("Goblin"); -- will be called once, but will not result in anyone attacking a goblin
      action_taken = true;
    end
  end
  emu.frameadvance();
end
```

The function needs to be constantly called to have any effect. On the other hand, this allows the script to "change its mind." For example, looking back at our script that heals hurt characters, it keeps characters from being healed unnecessarily; if we were queuing our actions in advance, and character A was selected to heal character B, but B was healed by someone else in the time between setting up the action and executing it, A would still heal B regardless. By checking every frame what action to do, we can avoid such scenarios.

The following actions can performed by `battle_menu` currently:

```lua
battle_menu.fight(TARGET); -- has the active party member fight TARGET
battle_menu.fight(TARGET, USER); -- has USER fight TARGET
battle_menu.use_item(ITEM, TARGET); -- has the active party member use ITEM on TARGET
battle_menu.use_item(ITEM, TARGET, USER); -- has USER use ITEM on TARGET
```

## `battle.query`

`battle.query` returns a list of objects that can be inspected or used as arguments to `battle_menu` functions.

```lua
local battle = require('autoffv.battle.battle');
local battle_menu = require('autoffv.automation.battle_menu');

while true
  if battle.check.in_battle() then
    local t = battle.query{character={level={gt=10}}}; -- list of all player characters with level above 10
  end
  emu.frameadvance();
end
```

The following classes can be currently queried:
```lua
battle.query{character=...}; -- selectable player characters
battle.query{enemy=...}; -- selectable enemies in the oposing party
battle.query{battler=...}; -- any active selectable battler in the fight
```

The following attributes can be currently queried:
```lua
character|enemy|battler = {
  -- operand parameters (can be compared to with {eq=...,neq=...,lt=...,leq=...,gt=...,geq=...})
  hp,
  mp,
  maxhp,
  maxmp,
  hp_ratio, -- hp/maxhp
  mp_ratio, -- mp/maxmp
  level,

  -- direct parameters (can only be compared to a direct value, e.g. battle.query{character={name="Bartz"}})
  name,
  id,

  
  -- special parameters
  
  targeted = { -- query based on who is targetting this character
    ally = "Any"|"Bartz"|"Lenna"|"Galuf"|"Faris"|"Krile",
    item = ... -- item that is being used on the character, optional
    neg = true|false -- negate filter, i.e. instead becomes who is *not* being targeted. Defaults to false.
  },
  
  has_command = ..., -- argument can be "<Command Name>", Command.<Command Name>* or a list of commands in either of those formats
                     -- *Command = require('autoffv.ability.command');
}
```
Examples:
```lua
battle.query{enemy={hp_ratio={lt=0.125}}} -- any enemy with health below 1/8 its total (for e.g. Catch)
battle.query{character={status="Dead", targeted={ally="Any", item="PhoenxDwn", neg=true}}} -- any character that is dead and not currently targeted by a phoenix down.
battle.query{character={has_command={"White", "XMagic"}}} -- any character that has both the !White magic and the !X Nagic commands.
```
