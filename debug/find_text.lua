
local text_decode = require('autoffv.text_decode');

local function find_text(text)
  local encoded = memory.read_bytes_as_array(0, memory.getmemorydomainsize("CARTROM"), "CARTROM");
  local decoded = {};
  local first_char = string.sub(text, 1, 1);
  for i=1,#encoded do
    decoded[i] = text_decode.decode_byte(encoded[i]);
  end
  for i, x in ipairs(decoded) do
    if x == first_char then
      local subt = {};
      for j=1,#text do
        subt[j] = decoded[i+j-1];
      end
      if table.concat(subt) == text then
        return i-1;
      end
    end
  end
  return -1;
end

return find_text;
