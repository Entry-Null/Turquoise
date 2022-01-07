local EAX = {}
local ALX
local MSG = print
local blocks = {}

--file = io.open("test.txc", "r")
--io.input(file)

-- prints the first line of the file broken fix
--local filecontents = io.read("*a")
--print(filecontents)
local JXm = [[
BLOCK ==>:
ADD << ? |3| {2}
MUL << ? |93| {34}
COMP << ? |2| {34}
>END<
START:BLOCK
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
    table.insert(blocks, s)
end

local t_start = str:find('BLOCK ==>:')+10
local t_end = str:find('>END<')-1
local trimmed = str:sub(t_start, t_end)

local JXm = trimmed

-- Compile
for s in JXm:gmatch("[^\r\n]+") do
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
--local variable = "2s"
--print(debug.getupvalue(function() variable() end, 1))
--==>
print(lines)
if locate(blocks, "START:BLOCK") then
    for i, v in pairs(lines) do
            if v:find("REP << ") then
                if v:match("%|(.+)%|") == nil then
                    MSG("REP: ", v:match("%{'(.+)%'}"))
                else
                    sL(v:match("%|(.+)%|"), v:match("%{'(.+)%'}"))
                end
            elseif v:find("REPR << ? ") then
                MSG("REPR: ", gL(v:match("%{'(.+)%'}")))
            elseif v:find("COMP << ") then
                if tonumber(v:match("%|(%d+)%|")) > tonumber(v:match("%{(%d+)%}")) then
                    MSG(tonumber(v:match("%|(%d+)%|")), " Is Greater Than ", tonumber(v:match("%{(%d+)%}")))
                elseif tonumber(v:match("%|(%d+)%|")) < tonumber(v:match("%{(%d+)%}")) then
                    MSG(tonumber(v:match("%|(%d+)%|")), " Is Less Than ", tonumber(v:match("%{(%d+)%}")))
                else
                    MSG(tonumber(v:match("%|(%d+)%|")), " Is Equal to ", tonumber(v:match("%{(%d+)%}")))
                end
            elseif v:find("SUB << ? ") then 
                MSG(tonumber(v:match("%|(%d+)%|") - tonumber(v:match("%{(%d+)%}"))))
            elseif v:find("MUL << ? ") then 
                MSG(tonumber(v:match("%|(%d+)%|") * tonumber(v:match("%{(%d+)%}"))))
            elseif v:find("ADD << ? ") then 
                MSG(tonumber(v:match("%|(%d+)%|") + tonumber(v:match("%{(%d+)%}"))))
            elseif v:find("DIV << ? ") then 
                MSG(tonumber(v:match("%|(%d+)%|") / tonumber(v:match("%{(%d+)%}"))))
            elseif v:find("EXP << ? ") then 
                MSG(tonumber(v:match("%|(%d+)%|") ^ tonumber(v:match("%{(%d+)%}"))))
            elseif v:find("+ END") then
            return false
            else
                print("Error on line: ", i, "\n", "Unknown: ", v)
            end
    end
else
    print("include START:BLOCK")
end