local EAX = {}
local ALX
local MSG = print
local blocks = {}
local storage = {}
--file = io.open("test.txc", "r")
--io.input(file)

-- prints the first line of the file broken fix
--local filecontents = io.read("*a")
--print(filecontents)
local JXm = [[
BLOCK ==>:
    REP << {'Lets say we have 2 things'}
>END<
BLOCK ==>:
    ADD << ? |2| {2}    
>END<
INIT > (1)
INIT > (2)
]]
function table.set(t) -- set of list
    local u = { }
    for _, v in ipairs(t) do u[v] = true end
    return u
  end
  
  function table.find(f, l) -- find element v of l satisfying f(v)
    for _, v in ipairs(l) do
      if f[v] then
        return v
      end
    end
    return nil
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
    table.insert(storage, s)
end
for i, v in pairs(storage) do
    print("storage: ", v)
end
print("\n\n", "-----void-----\n\n")

while str:find('BLOCK ==>:') ~= nil do
    local t_start, seconds = str:find('BLOCK ==>:', 1)
    local t_end = str:find('>END<',1 )+4
    local trimmed2 = str:sub(t_start, t_end)
    table.insert(blocks, t_start, trimmed2)
    local t_start2 = str:find('BLOCK ==>:')
    local t_end2 = str:find('>END<')
    local trimmed = str:sub(t_start, t_end)
    trimmed = string.gsub(str, trimmed2, "") 
    str = string.gsub(str, trimmed2, "") 
end
local JXm = trimmed

-- Compile
for s in str:gmatch("[^\r\n]+") do
    table.insert(lines, s)
end

function sL(name, val)
    local index = 1
    while true do
        local var_name, var_value = debug.getlocal(2, index)
        if not var_name then break end
        if var_name == name then 
            debug.setlocal(2, index, val)
        end
        index = index + 1
    end
end

function call(i, v)

    local linething = tonumber(v)
    for s in blocks[linething]:gmatch("[^\r\n]+") do
        runtime(i, s)
    end     
end

function gL(name)
    local index = 1
    while true do
        local var_name, var_value = debug.getlocal(2, index)
        if not var_name then break end
        if var_name == name then 
            return var_value
        end
        index = index + 1
    end
end

function runtime(i, v)
    if v:find("REP << ") then
        if v:match("%|(.+)%|") == nil then
            MSG(i, ": ","REP: ", v:match("%{'(.+)%'}"))
        else
            sL(v:match("%|(.+)%|"), v:match("%{'(.+)%'}"))
        end
    elseif v:find("REPR << ? ") then
        MSG(i, ": ","REPR: ", gL(v:match("%{'(.+)%'}")))
    elseif v:find("COMP << ") then
        if tonumber(v:match("%|(%d+)%|")) > tonumber(v:match("%{(%d+)%}")) then
            MSG(i, ": ",tonumber(v:match("%|(%d+)%|")), " Is Greater Than ", tonumber(v:match("%{(%d+)%}")))
        elseif tonumber(v:match("%|(%d+)%|")) < tonumber(v:match("%{(%d+)%}")) then
            MSG(i, ": ",tonumber(v:match("%|(%d+)%|")), " Is Less Than ", tonumber(v:match("%{(%d+)%}")))
        else
            MSG(i, ": ",tonumber(v:match("%|(%d+)%|")), " Is Equal to ", tonumber(v:match("%{(%d+)%}")))
        end
    elseif v:find("SUB << ? ") then 
        MSG(i, ": ",tonumber(v:match("%|(%d+)%|") - tonumber(v:match("%{(%d+)%}"))))
    elseif v:find("MUL << ? ") then 
        MSG(i, ": ",tonumber(v:match("%|(%d+)%|") * tonumber(v:match("%{(%d+)%}"))))
    elseif v:find("ADD << ? ") then 
        MSG(i, ": ",tonumber(v:match("%|(%d+)%|") + tonumber(v:match("%{(%d+)%}"))))
    elseif v:find("DIV << ? ") then 
        MSG(i, ": ",tonumber(v:match("%|(%d+)%|") / tonumber(v:match("%{(%d+)%}"))))
    elseif v:find("EXP << ? ") then 
        MSG(i, ": ",tonumber(v:match("%|(%d+)%|") ^ tonumber(v:match("%{(%d+)%}"))))
    elseif v:find("+ END") then
    return false
    end
end
--local variable = "2s"
--print(debug.getupvalue(function() variable() end, 1))
--==>

    for i, v in pairs(lines) do
            runtime(i, v)
            if v:find("INIT > ") then
                call(i, v:match("%((.+)%)"))
            end
    end