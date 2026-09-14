local callable_bitflags = require('ff5.utils.callable_bitflags');

return callable_bitflags.u16{
  ArmorCategory = {
    Shield         = 0x0001,
    HeavyHelmet    = 0x0002,
    LightHelmet    = 0x0004,
    DancerGear     = 0x0008,
    HeavyArmor     = 0x0010,
    LightArmor     = 0x0020,
    MageRobe       = 0x0040,
    CommonGear     = 0x0080,
    HeavyAccessory = 0x0100,
    LightAccessory = 0x0200,
    ThiefGear      = 0x0400,
    ChemistGear    = 0x0800,
    MageHat        = 0x1000,
  }
};
