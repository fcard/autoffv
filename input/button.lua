local callable_bitflags = require('autoffv.utils.callable_bitflags');

return callable_bitflags.u16{
  Button = {
    Right  = 0x0001,
    Left   = 0x0002,
    Down   = 0x0004,
    Up     = 0x0008,
    Start  = 0x0010,
    Select = 0x0020,
    Y      = 0x0040,
    B      = 0x0080,
    R      = 0x1000,
    L      = 0x2000,
    X      = 0x4000,
    A      = 0x8000,
  }
};
