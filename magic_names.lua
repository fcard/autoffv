text_decode = require('autoffv.text_decode');

local function read_name(id)
  local encoded;
  if id <= 86 then
    encoded = memory.read_bytes_as_array(0x111c80 + id*6, 6, "CARTROM");
  else
    encoded = memory.read_bytes_as_array(0x111e8a + (id-87)*9, 9, "CARTROM");
  end
  return text_decode.decode(encoded);
end

local cached_names = {};

local function get_name(id)
  if cached_names[id] == nil then
    cached_names[id] = read_name(id);
  end
  return cached_names[id];
end

return {
  read_name = read_name,
  get_name = get_name
};
