local EAX = "s"
local ALX  = "s"
local MSG = print
local blocks = {}
local storage = {}
local ifs = {}

file = io.open("test.tuq", "r")
io.input(file)


local filecontents = io.read("*a")
print(filecontents)
local JXm = filecontents

string.toHex = function(num)
    return string.format("%#X", num)
  end
  string.fromHex = function(strg)
    local strgu = strg
    return tonumber(strgu:lower():gsub('^0x',''), 16)
  end

function table.set(t)
    local u = { }
    for _, v in ipairs(t) do u[v] = true end
    return u
end

function table.find(f, l)
  for _, v in ipairs(l) do
    if f[v] then
      return v
    end
  end
  return nil
end

function sleep (a)
    local sec = tonumber(os.clock() + a);
    while (os.clock() < sec) do
    end
end

function locate( table, value )
    for i = 1, #table do
        if table[i] == value then return true end
    end
    return false
end
str = JXm
lines = {}
-- Compile Blocks
for s in JXm:gmatch("[^\r\n]+") do
    JXm = JXm:gsub("#!", "")
    table.insert(storage, s)
end
for i, v in pairs(storage) do
    print("storage: ", v)
end
print("\n\n", "-----void-----\n\n")

while str:find('SECTOR :') ~= nil do
    local t_start, seconds = str:find('SECTOR :')
    local t_end = str:find(':INT' )+4
    local trimmed2 = str:sub(t_start, t_end)
    table.insert(blocks, t_start, trimmed2)
    local t_start2 = str:find('SECTOR :')
    local t_end2 = str:find(':INT')
    local trimmed = str:sub(t_start, t_end)
    trimmed = string.gsub(str, trimmed2, "")
    str = string.gsub(str, trimmed2, "")
end
local JXm = trimmed

-- Compile
for s in str:gmatch("[^\r\n]+") do
    table.insert(lines, s)
end

function sL(index, val)
    local index = 1
    debug.setlocal(2, index, val)
end

function call2(i, v)
    local linethingY = tonumber(v)
    for s in blocks[linethingY]:gmatch("[^\r\n]+") do
        runtime(i, s)
    end
end

function callback(v)
    local linethingY = tonumber(v)
    for s in blocks[linethingY]:gmatch("[^\r\n]+") do
        if s:match("callback > ") then
            print(s:match("%'(.+)%'"))
        end
    end
end


function call(i, v)
    local linething = tonumber(v)
    for s in blocks[linething]:gmatch("[^\r\n]+") do
        if s:find("init > ") then
            if s:match("%!(.+)%!") then
                if s:match("%#(.+)%#") ~= "static" then
                    for i=1,math.huge do
                        call2(i, s:match("%$(.+)%$"))
                    end
                elseif s:match("%#(.+)%#") ~= "loop" then
                for i=1,tonumber(s:match("%!(.+)%!")) do
                    call2(i, s:match("%$(.+)%$"))
                end
            end
            else
                call2(i, s:match("%$(.+)%$"))
            end
        else
        runtime(i, s)
        end
    end
end


function gL(index)
    local var_name, var_value = debug.getlocal(2, index)
    return var_value
end

function runtime(i, v)
    --v:
    if v:find("REP 0 ") then
        if v:match("%|(.+)%|") == nil then
            MSG(v:match("%{'(.*)%'}"))
        else
            sL(v:match("%|(.+)%|"), v:match("%{'(.+)%'}"))
        end
    elseif v:find("REPR 0 ") then
        local thingtosay = v:match("%{'(.+)%'}")
        print(debug.getlocal(2, tonumber(string.fromHex(thingtosay))))
    elseif v:find("comp 0 ") then
        if tonumber(v:match("%|(%d+)%|")) > tonumber(v:match("%{(%d+)%}")) then
            MSG(i, ": ",tonumber(v:match("%|(%d+)%|")), " Is Greater Than ", tonumber(v:match("%{(%d+)%}")), "  :0x1:", string.toHex(tostring(v:match("%|(%d+)%|"))), "|", string.toHex(tostring(v:match("%|(%d+)%|"))))
        elseif tonumber(v:match("%|(%d+)%|")) < tonumber(v:match("%{(%d+)%}")) then
            MSG(i, ": ",tonumber(v:match("%|(%d+)%|")), " Is Less Than ", tonumber(v:match("%{(%d+)%}")), "  :0x1:", string.toHex(tostring(v:match("%|(%d+)%|"))), "|", string.toHex(tostring(v:match("%|(%d+)%|"))))
        else
            MSG(i, ": ",tonumber(v:match("%|(%d+)%|")), " Is Equal to ", tonumber(v:match("%{(%d+)%}")), "  :0x1:", string.toHex(tostring(v:match("%|(%d+)%|"))), "|", string.toHex(tostring(v:match("%|(%d+)%|"))))
        end
    elseif v:find("sub 0 ") then
        MSG(i, ": ",tonumber(v:match("%|(%d+)%|") - tonumber(v:match("%{(%d+)%}"))), "  :0x1:", string.toHex(tostring(v:match("%|(%d+)%|"))), "|", string.toHex(tostring(v:match("%|(%d+)%|"))))
    elseif v:find("mul 0 ") then
        MSG(i, ": ",tonumber(v:match("%|(%d+)%|") * tonumber(v:match("%{(%d+)%}"))), "  :0x1:", string.toHex(tostring(v:match("%|(%d+)%|"))), "|", string.toHex(tostring(v:match("%|(%d+)%|"))))
    elseif v:find("add 0 ") then
        MSG(i, ": ",tonumber(v:match("%|(%d+)%|") + tonumber(v:match("%{(%d+)%}"))), "  :0x1:", string.toHex(tostring(v:match("%|(%d+)%|"))), "|", string.toHex(tostring(v:match("%|(%d+)%|"))))
    elseif v:find("div 0 ") then
        MSG(i, ": ",tonumber(v:match("%|(%d+)%|") / tonumber(v:match("%{(%d+)%}"))), "  :0x1:", string.toHex(tostring(v:match("%|(%d+)%|"))), "|", string.toHex(tostring(v:match("%|(%d+)%|"))))
    elseif v:find("exp 0 ") then
        MSG(i, ": ",tonumber(v:match("%|(%d+)%|") ^ tonumber(v:match("%{(%d+)%}"))), "  :0x1:", string.toHex(tostring(v:match("%|(%d+)%|"))), "|", string.toHex(tostring(v:match("%|(%d+)%|"))))
    elseif v:find("let > ") then
        debug.setlocal(2, v:match("%|(.+)%|"), v:match("%{'(.+)%'}"))
    elseif v:find("gcall > ") then
        callback(v:match("%((.+)%)"))
    elseif v:find("DINT") then
        sleep(v:match("%'(.+)%'"))
    end
end
--local variable = "2s"
--print(debug.getupvalue(function() variable() end, 1))
--==>


    for i, v in pairs(lines) do
            runtime(i, v)
            if v:find("init > ") then
                call(i, v:match("%((.+)%)"))
            end
    end
