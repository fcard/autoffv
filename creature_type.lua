local callable_bitflags = require('autoffv.utils.callable_bitflags');

return callable_bitflags.u8{
  CreatureType = {
    Undead   = 0x01,
    Archaea  = 0x02,
    Creature = 0x04,
    Aevis    = 0x08,
    Dragon   = 0x10,
    Heavy    = 0x20,
    Desert   = 0x40,
    Humanoid = 0x80,
  }
};
