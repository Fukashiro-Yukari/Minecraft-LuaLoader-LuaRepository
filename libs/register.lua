module('Register',package.seeall)

registers = registers or {}

function GetList()
	return table.copy(registers)
end

function Add(type,t,name)
    assert(type,'Missing Type variable')
    assert(t,'Missing Class variable')
    assert(name,'Missing Class Name variable')
    assert(istable(t),'Class is not a table')

    name = string.lower(name)

    t.ClassName = name

    if !registers[type] then
        registers[type] = {}
    end

    registers[type][name] = table.copy(t)
end

function OnRegister()
    for type,v in pairs(registers) do
        for name,class in pairs(v) do
            local tbl = registers[type][name]
            local baselist = {}

            while true do
                if !isstring(tbl.Base) then
                    tbl.Base = 'base'
                end

                if tbl.Base != 'base' and tbl.Base != tbl.ClassName then
                    tbl = registers[type][tbl.Base]

                    if !istable(tbl) then return end

                    baselist[#baselist+1] = tbl.ClassName
                else
                    baselist[#baselist+1] = 'base'

                    break
                end
            end

            for i = 1,#baselist do
                registers[type][name] = table.merge(table.copy(registers[type][baselist[i]] or {}),registers[type][name])
            end

            local baseclass = {}

            for i = 1,#baselist do
                registers[type][name].BaseClass = table.merge(table.copy(registers[type][baselist[i]] or {}),baseclass)

                baseclass = registers[type][baselist[i]]
            end
        end
    end
end

function IsBasedOn(type,n,b)
    local t = GetStored(type,n)
    
	if !t then return false end
	if t.Base == n then return false end
    if t.Base == base then return true end
    
	return IsBasedOn(type,t.Base,base)
end

function GetStored(type,n)
    return registers[type][n]
end

function Get(type,n)
    local stored = GetStored(type,n)

    if !stored then return end

    local retval = retval or {}

	for k, v in pairs(stored) do
		if istable(v) then
			retval[k] = table.copy(v)
		else
			retval[k] = v
		end
    end
    
	retval.Base = retval.Base or 'base'

    return retval
end