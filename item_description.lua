local text_decode = require('ff5.text_decode');

local function read_description(id)
  local offset = {
    a = memory.read_u16_le(0x114000 + id*0x02, "CARTROM"),
    b = memory.read_u16_le(0x114000 + id*0x02 + 0x02, "CARTROM"),
  };
  local encoded = memory.read_bytes_as_array(0x110000+offset.a, offset.b - offset.a, "CARTROM");
  return text_decode.decode(encoded);
end

local cached_descriptions = {};

local function get_description(id)
  if cached_descriptions[id] == nil then
    cached_descriptions[id] = read_description(id);
  end
  return cached_descriptions[id];
end

return {
  read_description = read_description,
  get_description = get_description
};
