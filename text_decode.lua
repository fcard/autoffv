local Const = require('ff5.utils.const');

local TextDecode = Const{
  [1] = "\n",

  [83] = "0",
  [84] = "1",
  [85] = "2",
  [86] = "3",
  [87] = "4",
  [88] = "5",
  [89] = "6",
  [90] = "7",
  [91] = "8",
  [92] = "9",

  [96]  = "A",
  [97]  = "B",
  [98]  = "C",
  [99]  = "D",
  [100] = "E",
  [101] = "F",
  [102] = "G",
  [103] = "H",
  [104] = "I",
  [105] = "J",
  [106] = "K",
  [107] = "L",
  [108] = "M",
  [109] = "N",
  [110] = "O",
  [111] = "P",
  [112] = "Q",
  [113] = "R",
  [114] = "S",
  [115] = "T",
  [116] = "U",
  [117] = "V",
  [118] = "W",
  [119] = "X",
  [120] = "Y",
  [121] = "Z",

  [122] = "a",
  [123] = "b",
  [124] = "c",
  [125] = "d",
  [126] = "e",
  [127] = "f",
  [128] = "g",
  [129] = "h",
  [130] = "i",
  [131] = "j",
  [132] = "k",
  [133] = "l",
  [134] = "m",
  [135] = "n",
  [136] = "o",
  [137] = "p",
  [138] = "q",
  [139] = "r",
  [140] = "s",
  [141] = "t",
  [142] = "u",
  [143] = "v",
  [144] = "w",
  [145] = "x",
  [146] = "y",
  [147] = "z",

  [152] = "ll",
  [153] = "'",
  [160] = "/",
  [170] = "'",
  [175] = ".",
  [176] = "tt",
  [255] = " ",
};

local function decode(encoded)
  local decoded = {};
  local whitespace_index = 1;
  local found_whitespace = false;
  for i=1,#encoded do
    if encoded[i] == 255 then
      if not found_whitespace then
        whitespace_index = i;
        found_whitespace = true;
      end
      decoded[i] = " ";
    elseif TextDecode[encoded[i]] == nil then
      decoded[i] = "";
    else
      whitespace_index = i+1;
      found_whitespace = false;
      decoded[i] = TextDecode[encoded[i]];
    end
  end
  for i=whitespace_index,#encoded do
    decoded[i] = nil;
  end
  return table.concat(decoded);
end

local function decode_byte(encoded)
  if TextDecode[encoded] == nil then
    return "";
  else
    return TextDecode[encoded];
  end
end

return {
  decode = decode,
  decode_byte = decode_byte,
};
