local callable_bitflags = require('ff5.utils.callable_bitflags');

return callable_bitflags.u8{
  ArmorSpecialty = {
    ImproveCatch      = 0x01,
    BecomeUndead      = 0x02,
    ImproveSwordDance = 0x04,
    HalfMpCost        = 0x08,
    ImproveSteal      = 0x10,
    ImproveBrawl      = 0x20,
    ElfCapeDodge      = 0x40,
    BlockAllMagic     = 0x80,
  }
};
