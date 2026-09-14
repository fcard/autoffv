local const_meta = {
  __newindex = function(t, k, v)
    error("cannot change constant");
  end,
  __metatable = "protected"
};

local function Const(t)
  setmetatable(t, const_meta);
  return t;
end

return Const;
