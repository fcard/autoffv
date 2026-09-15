local Const = require('autoffv.utils.const');

local MenuScreen = Const{
  Main          = 0x01,
  Ability       = 0x02,
  Job           = 0x03,
  Equip         = 0x04,
  Status        = 0x05,
  Shop          = 0x06,
  Item          = 0x07,
  Magic         = 0x08,
  Config        = 0x09,
  DroppedItems  = 0x0a,
  SaveGame      = 0x0b,
  LoadOrNewGame = 0x0c,
  RenameHero    = 0x0d,
};

return MenuScreen;
