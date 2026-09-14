local callable_bitflags = require('ff5.utils.callable_bitflags');

return callable_bitflags.u8{
  SongChanted = {
    Power    = 0x80,
    Speed    = 0x40,
    Vitality = 0x20,
    Magic    = 0x10,
    Level    = 0x08,
  }
};
