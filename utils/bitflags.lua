local function bitflags(values, value_type, enum)
  local s = {};
  local i = 1;
  for bitmask, value in pairs(values) do
    s[i] = string.format("[%d] = b & %d == %d", value, bitmask, bitmask);
    i = i + 1;
  end

  i = 1;
  local tostr = {};
  if enum ~= nil then
    for name, value in pairs(enum) do
      tostr[i] = string.format("if t[%d] then result[#result+1] = \"%s\"; end;", value, name);
      i = i + 1;
    end
  end

  return load(string.format("\
    local value = require('ff5.utils.value');\
    local bitflags_meta = {\
    __call = function(this)\
      if next(this.dict) == nil then\
        this.update();\
      end\
      return this;\
    end,\
    __index = function(t,k)\
      if next(t.dict) == nil then\
        t.update();\
      end\
      return t.dict[k]\
    end,\
    __newindex = function(t,k,v)\
      error(\"cannot change this value\");\
    end,\
    __tostring = function(t)\
        local result = {};\
        %s\
        return string.format('{%%s}', table.concat(result, '|'));\
    end,\
    __metatable = \"protected\",\
    };\
    \
    return function(mem)\
      local obj = {bitflags = value.%s(mem), dict = {}};\
      function obj.update()\
        obj.bitflags.update();\
        local b = obj.bitflags();\
        obj.dict = {%s};\
      end\
      setmetatable(obj, bitflags_meta);\
      return obj;\
    end;\
  ", table.concat(tostr, "\n"), value_type, table.concat(s, ",")))();
end

return {
  u8  = function(values, enum) return bitflags(values, "u8", enum); end,
  u16 = function(values, enum) return bitflags(values, "u16", enum); end,
  u24 = function(values, enum) return bitflags(values, "u24", enum); end,
  u32 = function(values, enum) return bitflags(values, "u32", enum); end,
};
