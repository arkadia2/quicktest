
local mod = {}
local track = require("track")
local function GetLocals(level,num)
	level = level or 5
	num = num or 20
	local li = {"locals------"}
	for i=1,num do
		local name,value = debug.getlocal(level,i)
		if not name then
			break end
		if name ~= "(*temporary)" then
			local msg
			local sType = type(value)
			if sType == "table" and value.__cname then -- class
				msg = string.format("obj:%s",value.__cname)
			else
				msg = track.ser(value)
				if #msg > 100 then
					msg = string.sub(msg,1,100).."..."
				end
			end
			table.insert(li, string.format("%d %s:%s",i,name,msg))
		end
	end
	return table.concat(li,"\n")
end

function mod.GetLocals(level,num)
	local ok,ret = pcall(GetLocals,level,num)
	return ret
end


return mod