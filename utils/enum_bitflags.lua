local Const = require('autoffv.utils.const');
local bitflags = require('autoffv.utils.bitflags');

local function enum_bitflags(enum, values, value_type)
  local bitflag_values = {};

  for name, value in pairs(values) do
    if type(value) == "number" then
      bitflag_values[value] = enum[name];
    else
      error("expected key=bitmask");
    end
  end

  return bitflags[value_type](bitflag_values, enum);
end

return {
  u8  = function(enum, values) return enum_bitflags(enum, values, "u8"); end,
  u16 = function(enum, values) return enum_bitflags(enum, values, "u16"); end,
  u24 = function(enum, values) return enum_bitflags(enum, values, "u24"); end,
  u32 = function(enum, values) return enum_bitflags(enum, values, "u32"); end,
};
