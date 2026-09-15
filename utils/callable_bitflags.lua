local Const = require('autoffv.utils.const');
local bitflags = require('autoffv.utils.bitflags');
local callable = require('autoffv.utils.callable');

local function callable_bitflags(values, value_type)
  local module = {};
  local last_bitflags = nil;
  local callables = 0;

  for enum_name, enum_values in pairs(values) do
    local i = 0;
    local enum = {};
    local bitflag_values = {};
    local bitflags_name = nil;

    for name, value in pairs(enum_values) do
      if name == '__name' then
        bitflags_name = value;
        i = i - 1;
      elseif type(value) == "number" then
        enum[name] = i;
        bitflag_values[value] = i;
      else
        enum[name] = value[1];
        bitflag_values[value[2]] = value[1];
      end
      i = i + 1;
    end

    module[enum_name] = Const(enum);
    last_bitflags = bitflags[value_type](bitflag_values, enum);
    if bitflags_name ~= nil then
      callables = callables + 1;
      module[bitflags_name] = last_bitflags;
    end
  end

  if callables == 0 then
    return callable(module, last_bitflags, 1);
  else
    return module;
  end
end

return {
  u8  = function(values) return callable_bitflags(values, "u8"); end,
  u16 = function(values) return callable_bitflags(values, "u16"); end,
  u24 = function(values) return callable_bitflags(values, "u24"); end,
  u32 = function(values) return callable_bitflags(values, "u32"); end,
};
