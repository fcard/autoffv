local callable_bitflags = require('ff5.utils.callable_bitflags');

return callable_bitflags.u8{
  ActionType = {
    Physical = 0x80,
    Aerial   = 0x40,
    Song     = 0x20,
    Summon   = 0x10,
    Dimen    = 0x08,
    Black    = 0x04,
    White    = 0x02,
    Blue     = 0x01,
  }
};
