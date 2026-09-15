local value = require('autoffv.utils.value');
local equip_proto = require('autoffv.equip_proto');

local Element = equip_proto.Element;
local Stat = equip_proto.Stat;

local function magic_element_up(mem)
  local obj = {element = {}, stat_up = {}};

  return value.dependant(obj, value.u8(mem), function()
    local b = obj.subvalue();

    obj.stat_up = {
      [Stat.Strength] = 0,
      [Stat.Vitality] = 0,
      [Stat.Speed] = 0,
      [Stat.Magic] = 0,
    };

    if b & 0x80 == 0x80 then
      local bt = b & 0x07;
      if b & 0x40 == 0x40 then
        decode_stat_up(bt, obj.stat_up, Stat.Strength);
      end

      if b & 0x20 == 0x20 then
        decode_stat_up(bt, obj.stat_up, Stat.Speed);
      end

      if b & 0x10 == 0x10 then
        decode_stat_up(bt, obj.stat_up, Stat.Vitality);
      end

      if b & 0x08 == 0x08 then
        decode_stat_up(bt, obj.stat_up, Stat.Magic);
      end
      obj.element = {
        [Element.Wind]      = false,
        [Element.Earth]     = false,
        [Element.Holy]      = false,
        [Element.Poison]    = false,
        [Element.Lightning] = false,
        [Element.Ice]       = false,
        [Element.Fire]      = false,
      }
    else
      obj.element = {
        [Element.Wind]       = b & 0x40 == 0x40,
        [Element.Earth]      = b & 0x20 == 0x20,
        [Element.Holy]       = b & 0x10 == 0x10,
        [Element.Poison]     = b & 0x08 == 0x08,
        [Element.Lightining] = b & 0x04 == 0x04,
        [Element.Ice]        = b & 0x02 == 0x02,
        [Element.Fire]       = b & 0x01 == 0x01,
      };
    end
  end);
end

return magic_element_up;
