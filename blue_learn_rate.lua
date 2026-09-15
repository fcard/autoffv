local callable_bitflags = require('autoffv.utils.callable_bitflags');

return callable_bitflags.u8{
  LearnRate = {
    CanLearn100Percent = 0x10,
    CanLearn50Percent  = 0x20,
    CanLearn10Percent  = 0x40,
    CannotLearn        = 0x80,
  }
};
