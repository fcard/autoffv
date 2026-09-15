local callable_bitflags = require('autoffv.utils.callable_bitflags');

return callable_bitflags.u8{
  TargetType = {
    Roulette       = 0x04,
    EnemyByDefault = 0x08,
    SideSelectable = 0x10,
    Selectable     = 0x20,
    Multi          = 0x40,
    MultiOptional  = 0x80,
  }
};
