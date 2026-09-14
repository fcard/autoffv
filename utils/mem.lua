local callable = require('ff5.utils.callable');
local mem = {};

local mem_identifier = {};
local mem_meta = {
  __call = function(this, size, domain)
    if size == 1 then
      return memory.readbyte(this.address, domain);
    elseif size == 2 then
      return memory.read_u16_le(this.address, domain);
    elseif size == 3 then
      return memory.read_u24_le(this.address, domain);
    elseif size == 4 then
      return memory.read_u32_le(this.address, domain);
    else
      return memory.read_bytes_as_array(this.address, size, domain);
    end
  end,

  __add = function(this, other)
    if type(other) == "number" then
      return mem(this.address + other);
    else
      error(string.format("cannot add memory address with %s"), type(other));
    end
  end,

  __sub = function(this, other)
    if type(other) == "number" then
      return mem(this.address - other);
    else
      error(string.format("cannot add memory address with %s"), type(other));
    end
  end,
};

local function new_mem(address)
  local obj = {
    address = address,
    __memid = mem_identifier,
  };
  setmetatable(obj, mem_meta);
  return obj;
end

local function ismem(x)
  return type(x) == "table" and x.__memid == mem_identifier;
end

mem.ismem = ismem;
return callable(mem, new_mem, 1);
