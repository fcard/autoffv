local Const = require('ff5.utils.const');
local value = require("ff5.utils.value");
local item_name = require("ff5.item_name");
local weapon = require('ff5.weapon');
local armor = require('ff5.armor');
local item = require('ff5.item');

local equip_meta = {
  __call = function(this)
    if this.id.cache.value == nil then
      this.id.update();
    end
    return this;
  end,
  __newindex = function(t,k,v)
    error("cannot change equipment");
  end,
  __metatable = "protected"
};

local function equipment(id_mem)
  local id = value.u8(id_mem);
  local obj = {};

  function obj.id()
    return id();
  end

  function obj.name()
    return item_name.get_name(id());
  end

  function obj.description()
    return obj.data().get_description();
  end

  function obj.data()
    local xid = id();
    if xid <= 0x7f then
      return weapon.get_weapon_data(xid);
    elseif xid <= 0xdf then
      return armor.get_armor_data(xid);
    else
      return item.get_item_data(xid);
    end
  end

  function obj.update()
    id.update();
  end

  setmetatable(obj, equip_meta);
  return obj;
end

local function hand(shield_id_mem, weapon_id_mem)
  local obj = {};
  obj.shield = equipment(shield_id_mem);
  obj.weapon = equipment(weapon_id_mem);

  function obj.is_shield()
    return obj.shield.id() ~= 0x80;
  end

  function obj.is_weapon()
    return obj.weapon.id() ~= 0x00;
  end

  function obj.update()
    obj.weapon.update();
    obj.shield.update();
  end

  function obj.get_equipment()
    if obj.is_weapon() then
      return obj.weapon;
    else
      return obj.shield;
    end
  end

  return obj;
end

return {
  equipment = equipment,
  hand = hand,
};
