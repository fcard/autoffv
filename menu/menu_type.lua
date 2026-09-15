local Const = require('autoffv.utils.const');

local MenuType = Const{
  Nothing     = 0x00,
  ItemDrop    = 0x01,
  Shop        = 0x02,
  LoadScreen  = 0x03,
  JobTutorial = 0x04,
  HeroNaming  = 0x05,
  CloseMenu   = 0x06,
  FreezeMenu  = 0x07,
};

return MenuType;
