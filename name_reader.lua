text_decode = require('autoffv.text_decode');

local function name_reader(address, width)
  local function read_name(id)
    local encoded = memory.read_bytes_as_array(address + id*width, width, "CARTROM");
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
end

return name_reader;
