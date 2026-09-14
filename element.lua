local callable_bitflags = require('ff5.utils.callable_bitflags');

return callable_bitflags.u8{
  Element = {
    Fire      = 0x01,
    Ice       = 0x02,
    Lightning = 0x04,
    Poison    = 0x08,
    Holy      = 0x10,
    Earth     = 0x20,
    Wind      = 0x40,
    Water     = 0x80,
  }
};
