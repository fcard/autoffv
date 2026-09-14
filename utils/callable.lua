local function no_args(t, fn)
  local callable_meta = {
    __call = function(this)
      return fn();
    end,
    __metatable = "protected",
  };

  setmetatable(t, callable_meta);
  return t;
end

local function one_arg(t, fn)
  local callable_meta = {
    __call = function(this, value)
      return fn(value);
    end,
    __metatable = "protected",
  };

  setmetatable(t, callable_meta);
  return t;
end

local function two_args(t, fn)
  local callable_meta = {
    __call = function(this, v1, v2)
      return fn(v1, v2);
    end,
    __metatable = "protected",
  };

  setmetatable(t, callable_meta);
  return t;
end

local callable_module_meta = {
  __call = function(this, t, fn, nargs)
    if nargs == 0 then
      return no_args(t, fn);
    elseif nargs == 1 then
      return one_arg(t, fn);
    elseif nargs == 2 then
      return two_args(t, fn);
    end
  end
}

local callable = {
  no_args = no_args,
  one_arg = one_arg,
  two_args = two_args
};

setmetatable(callable, callable_module_meta);
return callable;
