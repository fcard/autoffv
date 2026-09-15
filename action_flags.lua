local callable_bitflags = require('autoffv.utils.callable_bitflags');

return callable_bitflags.u8{
  ActionFlag = {
    Flirting  = 0x08,
    Jumping   = 0x10,
    Guarding  = 0x40,
    Defending = 0x80,
  }
};
