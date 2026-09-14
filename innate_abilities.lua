local enum_bitflags = require('ff5.utils.enum_bitflags');
local Passive = require('ff5.ability.passive');

return enum_bitflags.u16(Passive, {
  Passges     = 0x0001,
  Pitfalls    = 0x0002,
  DamageFloor = 0x0004,
  Dash        = 0x0008,
  Learning    = 0x0010,
  Barrier     = 0x0020,
  Evade       = 0x0040,
  Counter     = 0x0080,
  TwoHanded   = 0x0100,
  Preemtive   = 0x0200,
  Caution     = 0x0400,
  Beserk      = 0x0800,
  Medicine    = 0x1000,
  DoubleGrip  = 0x2000,
  Brawl       = 0x4000,
  Cover       = 0x8000,
});
