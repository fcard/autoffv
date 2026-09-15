local callable_bitflags = require('autoffv.utils.callable_bitflags');

return callable_bitflags.u8{
  DamageModifier = {
    AutoHit                 = 0x80,
    DoubleDamage            = 0x40,
    HalfDamage              = 0x20,
    DoubleM                 = 0x10,
    HalfM                   = 0x08,
    DefenseToZero           = 0x04,
    SwordSlap               = 0x02,
    DoubleDamageOnHumanoids = 0x01,
  };
};
