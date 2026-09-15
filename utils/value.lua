local mem = require('autoffv.utils.mem');
local ismem = mem.ismem;

local value_meta = {
  __call = function(this)
    if not this.has_value() then
      this.update();
    end
    return this.cache.value;
  end,
  __newindex = function(t,k,v)
    error("cannot change value");
  end,
  __metatable = "protected"
}

local value_dependant_meta = {
  __call = function(this)
    if not this.has_value() then
      this.update();
    end
    return this;
  end,
  __index = function(t,k)
    if t.__dict == nil then
      return nil;
    else
      return t.__dict[k];
    end
  end,
  __newindex = function(t,k,v)
    error("cannot change value");
  end,
  __metatable = "protected"
};

local function dependant(t,subvalue,update)
  local value = t;
  value.subvalue = subvalue;
  function value.get() value.update(); return value; end;
  if update ~= nil then
    function value.update() value.subvalue.update(); update(); end;
  else
    function value.update() value.subvalue.update(); end;
  end
  function value.has_value() return value.subvalue.has_value(); end;
  setmetatable(value, value_dependant_meta);
  if subvalue.has_value() and update ~= nil then
    update();
  end
  return value;
end

local function u8(x)
  local value = {cache = {}};
  if ismem(x) then
    local m = x.address;
    function value.get() return memory.readbyte(m) end;
    function value.update() value.cache.value = memory.readbyte(m) end;
    function value.has_value() return value.cache.value ~= nil; end
  elseif type(x) == "number" then
    local y = x % 0xff;
    value.cache.value = y;
    function value.get() return y end;
    function value.update() end;
    function value.has_value() return true; end
  end
  setmetatable(value, value_meta);
  return value;
end

local function u16(x)
  local value = {cache = {}};
  if ismem(x) then
    local m = x.address;
    function value.get() return memory.read_u16_le(m) end;
    function value.update() value.cache.value = memory.read_u16_le(m) end;
    function value.has_value() return value.cache.value ~= nil; end
  elseif type(x) == "number" then
    local y = x % 0xffff;
    value.cache.value = y;
    function value.get() return y end;
    function value.update() end;
    function value.has_value() return true; end
  end
  setmetatable(value, value_meta);
  return value;
end

local function u24(x)
  local value = {cache = {}};
  if ismem(x) then
    local m = x.address;
    function value.get() return memory.read_u24_le(m) end;
    function value.update() value.cache.value = memory.read_u24_le(m) end;
    function value.has_value() return value.cache.value ~= nil; end
  elseif type(x) == "number" then
    local y = x % 0xffffff;
    value.cache.value = y;
    function value.get() return y end;
    function value.update() end;
    function value.has_value() return true; end
  end
  setmetatable(value, value_meta);
  return value;
end

local function u32(mem)
  local value = {cache = {}};
  if ismem(x) then
    local m = x.address;
    function value.get() return memory.read_u32_le(m) end;
    function value.update() value.cache.value = memory.read_u32_le(m) end;
    function value.has_value() return value.cache.value ~= nil; end
  elseif type(x) == "number" then
    local y = x % 0xffffffff;
    value.cache.value = y;
    function value.get() return y end;
    function value.update() end;
    function value.has_value() return true; end
  end
  setmetatable(value, value_meta);
  return value;
end

local function bool(mem)
  local value = {cache = {}};
  if ismem(x) then
    local m = x.address;
    function value.get() return memory.readbyte(m) ~= 0 end;
    function value.update() value.cache.value = memory.readbyte(m) ~= 0 end;
    function value.has_value() return value.cache.value ~= nil; end
  elseif type(x) == "number" then
    local y = x ~= 0;
    value.cache.value = y;
    function value.get() return y end;
    function value.update() end;
    function value.has_value() return true; end
  end
  setmetatable(value, value_meta);
  return value;
end

return {
  u8 = u8,
  u16 = u16,
  u24 = u24,
  u32 = u32,
  bool = bool,
  dependant = dependant,
};
