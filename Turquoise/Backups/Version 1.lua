local EAX = {}
local ALX
local MSG = print
local JXm = [[
EXP << ? |2| {2} 
MUL << ? |54| {23}
REP << {'abc'} |EAX|
REP << {'This'} 
REPR << ? {'EAX'}
MUL << ? |2| {2}
ADD << ? |2| {1} 
REP << {'Hello, World!'}
COMP << |2| {98}
]]
local xyz = "hi"

str = JXm
lines = {}
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
    end
end
