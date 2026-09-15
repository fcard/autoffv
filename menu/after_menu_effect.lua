local Const = require('autoffv.utils.const');

local AfterMenuEffect = Const{
  Nothing     = 0x00,
  LoadFile    = 0x01,
  Teleport    = 0x3e,
  Tent        = 0xf0,
  Cottage     = 0xf1,
};

return AfterMenuEffect;
