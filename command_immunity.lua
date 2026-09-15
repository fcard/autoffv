local callable_bitflags = require('autoffv.utils.callable_bitflags');

return callable_bitflags.u8{
  CommandImmunity = {
    HpScan  = 0x80,
    Control = 0x10,
    Catch   = 0x08,
  };
};
