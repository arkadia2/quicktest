

local mod = {}

-- 锁定全局表，用于检查忘写local
local OldMt = nil
function mod.Lock()
	OldMt = getmetatable(_G)
	setmetatable(_G, {__newindex = function (t,k,v)
			if type(k)=="string" and (string.sub(k,1,2) == "g_") then
				rawset(t,k,v)
			else
				error(string.format("want to do _G[%s]=%s!!",tostring(k),tostring(v)),2)
			end
		end})
end

function mod.Unlock()
	setmetatable(_G, OldMt)
	OldMt = nil
end


return mod