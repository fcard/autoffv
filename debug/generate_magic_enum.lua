local magic = require('autoffv.magic');

local function generate_magic_enum()
  console.log("local MagicId = Const{");
  for i=0,255 do
    console.log(string.format("  %s = 0x%x,", string.gsub(magic(i).name(), " ", ""), i));
  end
  console.log("};");
end

return generate_magic_enum;
