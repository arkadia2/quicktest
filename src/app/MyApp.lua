require("config")
require("cocos.init")
require("framework.init")

local MyApp = class("MyApp", cc.mvc.AppBase)
function MyApp:ctor()
	MyApp.super.ctor(self)
	math.randomseed(os.time())
	for i=1,10 do math.random() end -- 第一个数在os.time相差不大时会是一样
end

function MyApp:run()
    self:enterScene("mainscene")
    -- self:enterScene("demoTestScene")
end

return MyApp
