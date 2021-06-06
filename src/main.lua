

local trace
local LastErrMd5 = "" -- 防止同一报错多次发
function __G__TRACKBACK__(errorMessage)
	local traceMsg = debug.traceback("",2)
	local li = {}
	table.insert(li, "----------------------------------------")
	table.insert(li, "LUA ERROR: "..tostring(errorMessage))
	-- if trace then
	-- 	table.insert(li, trace.GetLocals())
	-- end
	table.insert(li, traceMsg)
	table.insert(li, "----------------------------------------")
	local str = table.concat(li,"\n")
	print(str)
end

cc.FileUtils:getInstance():addSearchPath("src", true)
cc.FileUtils:getInstance():addSearchPath("src/app/",true)
-- local sharedDirector = cc.Director:getInstance()
-- sharedDirector:setAnimationInterval(1.0 / 30)
trace = require("trace")
require("config")
require("cocos.init")
require("framework.init")

cc.FileUtils:getInstance():addSearchPath("res/", true)
cc.FileUtils:getInstance():addSearchPath(device.writablePath .. "tank/res/", true)
package.path = "./src/app/?.lua;" .. "./src/?.lua;" .. "./res/mapdata/?.lua;" .. package.path
cc.FileUtils:getInstance():setPopupNotify(false)

print("FileUtils SearchPaths>>>")
for k,v in pairs(cc.FileUtils:getInstance():getSearchPaths()) do
	print(k,v)
end

xpcall(function()
	require("myapp").new():run()
end, __G__TRACKBACK__)

collectgarbage( "setpause", 120) -- 内存到1.2倍时开始回收

