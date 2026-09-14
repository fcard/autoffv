local callable_bitflags = require('ff5.utils.callable_bitflags');

return callable_bitflags.u8{
  StatusCurable = {
    __name = "curable",
    Darkness = 0x01,
    Zombie   = 0x02,
    Poison   = 0x04,
    Float    = 0x08,
    Mini     = 0x10,
    Toad     = 0x20,
    Petrify  = 0x40,
    Dead     = 0x80,
  },

  StatusTemporary = {
    __name = "temporary",
    Image1   = 0x01,
    Image2   = 0x02,
    Mute     = 0x04,
    Beserk   = 0x08,
    Charm    = 0x10,
    Paralyze = 0x20,
    Sleep    = 0x40,
    Aging    = 0x80,
  },

  StatusDispellable = {
    __name = "dispellable",
    Regen        = 0x01,
    Invulnerable = 0x02,
    Slow         = 0x04,
    Haste        = 0x08,
    Stop         = 0x10,
    Shell        = 0x20,
    Armor        = 0x40,
    Wall         = 0x80,
  },

  StatusPermanent = {
    __name = "permanent",
    Hidden     = 0x01,
    NearDeath  = 0x02,
    Singing    = 0x04,
    HpLeak     = 0x08,
    Countdown  = 0x10,
    Controlled = 0x20,
    FalseImage = 0x40,
    Erased     = 0x80,
  },

  StatusMagicSwordLv3 = {
    __name = "magic_sword_lv3",
    MpDrain = 0x20,
    HpDrain = 0x40,
    PowerUp = 0x80,
  },
};
