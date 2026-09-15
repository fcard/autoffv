local callable_bitflags = require('autoffv.utils.callable_bitflags');

return callable_bitflags.u8{
  MonsterSpecialty = {
    Unavoidable  = 0x80,
    Aging        = 0x40,
    Poison       = 0x20,
    Blind        = 0x10,
    Paralyze     = 0x08,
    Charm        = 0x04,
    HpLeak       = 0x02,
    Plus50Attack = 0x01,
  }
};
