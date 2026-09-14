local value = require('ff5.utils.value');
local Command = require('ff5.ability.command');

local function magic_enabled(mem)
  local obj = {
    sword  = -1,
    white  = -1,
    black  = -1,
    time   = -1,
    summon = -1,
    misc   = -1,
    __dict = {},
  };

  function obj.update_command(cmd,n,m)
    for i = 0, n-1 do
      obj.__dict[cmd + i] = true;
    end

    for i = n, m-1 do
      obj.__dict[cmd + i] = false;
    end
  end

  return value.dependant(obj, value.u24(mem), function()
    obj.bitflags.update();
    local b = obj.bitflags();

    obj.sword  = (b & 0x00000f) >> 4*0;
    obj.white  = (b & 0x0000f0) >> 4*1;
    obj.black  = (b & 0x000f00) >> 4*2;
    obj.time   = (b & 0x00f000) >> 4*3;
    obj.summon = (b & 0x0f0000) >> 4*4;
    obj.misc   = (b & 0xf00000) >> 4*5;

    obj.update_command(Command.MagicSwordLv1, obj.sword,  6);
    obj.update_command(Command.WhiteLv1,      obj.white,  6);
    obj.update_command(Command.BlackLv1,      obj.black,  6);
    obj.update_command(Command.DimenLv1,      obj.time,   6);
    obj.update_command(Command.SummonLv1,     obj.summon, 6);
  end);
end

return magic_enabled;
