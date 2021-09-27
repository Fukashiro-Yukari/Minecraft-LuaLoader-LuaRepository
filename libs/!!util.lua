util = {}

math.randomseed(os.time())

function istype(o,t)
	return type(o) == t
end

function isnum(a)
    return type(a) == 'number'
end

isnumber = isnum

function isstr(a)
    return type(a) == 'string'
end

isstring = isstr

function isbool(v)
	return type(v) == 'boolean'
end

function istable(a)
	return type(a) == 'table'
end

function isfunction(a)
	return type(a) == 'function'
end

function isarray(o)
	local b,e = pcall(function()
		return o.length != nil or (o.keySet != nil and o.get != nil) or (o.get != nil and o.size != nil)
	end)

	return b and e
end

function str(a)
	return tostring(a)
end

function num(a)
	return tonumber(a)
end

number = num

function bool(a)
	if a == nil or a == false or a == 0 or a == '0' or a == 'false' then return false end

	return true
end

tobool = bool

function len(a)
	if istable(a) then
		return table.count(a)
	elseif isstr(a) then
		return string.len(a)
	elseif str(a) then
		return len(str(a))
	end
end

function pass(a)
    if not isnum(a) then return end

    local pass = ''

    for i = 0,a do
        pass = pass..' '
    end

    return pass
end

function tblfunc(a,b,c)
    assert(istable(b),'table expected, got '..type(b))
    assert(isfunction(c),'function expected, got '..type(c))

    c = c or function() end
    
    setmetatable(b,{__index = function(t,k) return c end})
    assert(isfunction(b[a]),'function expected, got '..type(c))

    b[a]()
end

function lerp( delta, from, to )

	if ( delta > 1 ) then return to end
	if ( delta < 0 ) then return from end

	return from + ( to - from ) * delta

end

function util.GetRandomString(len)
    local str = '1234567890abcdefhijklmnopqrstuvwxyz'
	local ret = ''
	
    for i = 1,len do
        local rchr = math.random(1,string.len(str))
        ret = ret..string.sub(str,rchr,rchr)
	end
	
    return ret
end

function util.GetRandomStringNoNum(len)
    local str = 'abcdefhijklmnopqrstuvwxyz'
	local ret = ''
	
    for i = 1,len do
        local rchr = math.random(1,string.len(str))
        ret = ret..string.sub(str,rchr,rchr)
	end
	
    return ret
end

local idTemp = 0
function util.GetId()
	idTemp = idTemp+1
	
    return idTemp
end

function jnext(t,k)
	local initnil = false
	local i = k

	if !k then
		initnil = true
		i = -1
	end

    assert(type(t) == 'userdata','userdata expected, got '..type(t))
    
    if isnumber(i) then
        i = i+1
	end

	local b,e = pcall(function()
        return t.length
    end)

	if b and e then
		if initnil then
			i = i+1
		end

        if i <= t.length then
            return i,t[i]
        end
    end

    local b,e = pcall(function()
        return t.keySet
    end)

    if b and e then
		local fk

        if !k then
            fk = t:keySet():toArray()[1]

            return fk,t:get(fk)
        else
            local kf = false
			local sk

			for kk,kv in jpairs(t:keySet():toArray()) do
				if k == kv then
                    kf = true
                elseif kf then
                    sk = kv

                    break
                end
            end

            if !sk then return end

            return sk,t:get(sk)
        end
    end

    local b,e = pcall(function()
        return t.get
    end)

    if b and e then
        if !t.size then return end
        if i < t:size() then
            return i,t:get(i)
        end
    end
end

function jpairs(t)
    return jnext,t,nil
end

local old = pairs

function pairs(o,...)
    if isarray(o) then
        return jpairs(o)
    end

    return old(o,...)
end