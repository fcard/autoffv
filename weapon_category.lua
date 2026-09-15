local callable_bitflags = require('autoffv.utils.callable_bitflags');

return callable_bitflags.u16{
  WeaponCategory = {
    Knife       = 0x0001,
    NinjaKnife  = 0x0002,
    Sword       = 0x0004,
    KnightSword = 0x0008,
    Spear       = 0x0010,
    Axe         = 0x0020,
    Hammer      = 0x0040,
    Katana      = 0x0080,
    Rod         = 0x0100,
    Staff       = 0x0200,
    Flail       = 0x0400,
    Bow         = 0x0800,
    Harp        = 0x1000,
    Whip        = 0x2000,
    Bell        = 0x4000,
  }
};
