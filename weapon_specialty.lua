local callable_bitflags = require('autoffv.utils.callable_bitflags');

return callable_bitflags.u8{
  WeaponSpecialty = {
    WonderRod             = 0x01,
    EffectInsteadOfAttack = 0x02,
    MagicSwordOk          = 0x04,
    EffectAfterAttack     = 0x08,
    Initiative            = 0x20,
    ParryKnife            = 0x40,
    ParrySword            = 0x80,
  }
};
