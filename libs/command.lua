module('command',package.seeall)

local commands = {}

function GetTable()
    return commands
end

function Add(n,f)
    if not isstring(n) then return end

    commands[n] = f
end

function Remove(n)
    if not isstring(n) or not commands[n] then return end

    commands[n] = nil
end

function Run(n,a,as)
    if not isstring(n) or not commands[n] then return end

    commands[n](a,as)
end