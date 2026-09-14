local function button_down(prop)
  if prop == nil or prop.only == nil or prop.only then
    joypad.set({Down=true, Up=false, Left=false, Right=false, A=false, B=false, X=false, Y=false, L=false, R=false, Start=false, Select=false}, 1)
  elseif prop.only == false then
    joypad.set({Down=true}, 1);
  end
end

local function button_up(prop)
  if prop == nil or prop.only == nil or prop.only then
    joypad.set({Down=false, Up=true, Left=false, Right=false, A=false, B=false, X=false, Y=false, L=false, R=false, Start=false, Select=false}, 1)
  elseif prop.only == false then
    joypad.set({Up=true}, 1);
  end
end

local function button_left(prop)
  if prop == nil or prop.only == nil or prop.only then
    joypad.set({Down=false, Up=false, Left=true, Right=false, A=false, B=false, X=false, Y=false, L=false, R=false, Start=false, Select=false}, 1)
  elseif prop.only == false then
    joypad.set({Left=true}, 1);
  end
end

local function button_right(prop)
  if prop == nil or prop.only == nil or prop.only then
    joypad.set({Down=false, Up=false, Left=false, Right=true, A=false, B=false, X=false, Y=false, L=false, R=false, Start=false, Select=false}, 1)
  elseif prop.only == false then
    joypad.set({Right=true}, 1);
  end
end

local function button_a(prop)
  if prop == nil or prop.only == nil or prop.only then
    joypad.set({Down=false, Up=false, Left=false, Right=false, A=true, B=false, X=false, Y=false, L=false, R=false, Start=false, Select=false}, 1)
  elseif prop.only == false then
    joypad.set({A=true}, 1);
  end
end

local function button_b(prop)
  if prop == nil or prop.only == nil or prop.only then
    joypad.set({Down=false, Up=false, Left=false, Right=false, A=false, B=true, X=false, Y=false, L=false, R=false, Start=false, Select=false}, 1)
  elseif prop.only == false then
    joypad.set({B=true}, 1);
  end
end

local function button_x(prop)
  if prop == nil or prop.only == nil or prop.only then
    joypad.set({Down=false, Up=false, Left=false, Right=false, A=false, B=false, X=true, Y=false, L=false, R=false, Start=false, Select=false}, 1)
  elseif prop.only == false then
    joypad.set({X=true}, 1);
  end
end

local function button_y(prop)
  if prop == nil or prop.only == nil or prop.only then
    joypad.set({Down=false, Up=false, Left=false, Right=false, A=false, B=false, X=false, Y=true, L=false, R=false, Start=false, Select=false}, 1)
  elseif prop.only == false then
    joypad.set({Y=true}, 1);
  end
end

local function button_l(prop)
  if prop == nil or prop.only == nil or prop.only then
    joypad.set({Down=false, Up=false, Left=false, Right=false, A=false, B=false, X=false, Y=false, L=true, R=false, Start=false, Select=false}, 1)
  elseif prop.only == false then
    joypad.set({L=true}, 1);
  end
end

local function button_r(prop)
  if prop == nil or prop.only == nil or prop.only then
    joypad.set({Down=false, Up=false, Left=false, Right=false, A=false, B=false, X=false, Y=false, L=false, R=true, Start=false, Select=false}, 1)
  elseif prop.only == false then
    joypad.set({R=true}, 1);
  end
end

local function button_start(prop)
  if prop == nil or prop.only == nil or prop.only then
    joypad.set({Down=false, Up=false, Left=false, Right=false, A=false, B=false, X=false, Y=false, L=false, R=false, Start=true, Select=false}, 1)
  elseif prop.only == false then
    joypad.set({Start=true}, 1);
  end
end

local function button_select(prop)
  if prop == nil or prop.only == nil or prop.only then
    joypad.set({Down=false, Up=false, Left=false, Right=false, A=false, B=false, X=false, Y=false, L=false, R=false, Start=false, Select=true}, 1)
  elseif prop.only == false then
    joypad.set({Select=true}, 1);
  end
end

return {
  button_down   = button_down,
  button_up     = button_up,
  button_left   = button_left,
  button_right  = button_right,
  button_a      = button_a,
  button_b      = button_b,
  button_x      = button_x,
  button_y      = button_y,
  button_start  = button_start,
  button_select = button_select,
};
