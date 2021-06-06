
local AppBase = class("AppBase")

AppBase.APP_ENTER_BACKGROUND_EVENT = "APP_ENTER_BACKGROUND_EVENT"
AppBase.APP_ENTER_FOREGROUND_EVENT = "APP_ENTER_FOREGROUND_EVENT"

AppBase.APP_WILL_TERMINATE_EVENT = "APP_WILL_TERMINATE_EVENT"
AppBase.APP_RECEIVE_MEMORY_WARNING_EVENT = "APP_RECEIVE_MEMORY_WARNING_EVENT"
AppBase.APP_AUTHENTICATION_CHANGED = "APP_AUTHENTICATION_CHANGED"
AppBase.APP_DEVICETOKEN_REGISTER = "APP_DEVICETOKEN_REGISTER"

function AppBase:ctor(appName, packageRoot)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    self.name = appName
    self.packageRoot = packageRoot or "app"

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    local customListenerBg = cc.EventListenerCustom:create(AppBase.APP_ENTER_BACKGROUND_EVENT,
                                handler(self, self.onEnterBackground))
    eventDispatcher:addEventListenerWithFixedPriority(customListenerBg, 1)
    local customListenerFg = cc.EventListenerCustom:create(AppBase.APP_ENTER_FOREGROUND_EVENT,
                                handler(self, self.onEnterForeground))
    eventDispatcher:addEventListenerWithFixedPriority(customListenerFg, 1)

    local customListenerTm = cc.EventListenerCustom:create(AppBase.APP_WILL_TERMINATE_EVENT,
                                handler(self, self.onWillTerminate))
    eventDispatcher:addEventListenerWithFixedPriority(customListenerTm, 1)

    local customListenerWarning = cc.EventListenerCustom:create(AppBase.APP_RECEIVE_MEMORY_WARNING_EVENT,
                                handler(self, self.onReceiveMemoryWarning))
    eventDispatcher:addEventListenerWithFixedPriority(customListenerWarning, 1)

    local customListenerGCChanged = cc.EventListenerCustom:create(AppBase.APP_AUTHENTICATION_CHANGED,
                                handler(self, self.onAuthenticationChanged))
    eventDispatcher:addEventListenerWithFixedPriority(customListenerGCChanged, 1)

    local customListenerDTRegister = cc.EventListenerCustom:create(AppBase.APP_DEVICETOKEN_REGISTER,
                                handler(self, self.onDeviceTokenRegister))
    eventDispatcher:addEventListenerWithFixedPriority(customListenerDTRegister, 1)
    
    self.snapshots_ = {}

    -- set global app
    app = self
end

function AppBase:run()
end

function AppBase:exit()
    cc.Director:getInstance():endToLua()
    if device.platform == "windows" or device.platform == "mac" then
        os.exit()
    end
end

function AppBase:enterScene(sceneName, args, transitionType, time, more)
    local scenePackageName = "scenes." .. sceneName -- self.packageRoot .. 
    local sceneClass = require(scenePackageName)
    local scene = sceneClass.new(unpack(checktable(args)))
    display.replaceScene(scene, transitionType, time, more)
end

function AppBase:createView(viewName, ...)
    local viewPackageName = self.packageRoot .. ".views." .. viewName
    local viewClass = require(viewPackageName)
    return viewClass.new(...)
end

function AppBase:onEnterBackground()
    print(">>>>>>>>>>>>>onEnterBackground ")
    self:dispatchEvent({name = AppBase.APP_ENTER_BACKGROUND_EVENT})
end

function AppBase:onEnterForeground()
    print(">>>>>>>>>>>>>onEnterForeground ")
    self:dispatchEvent({name = AppBase.APP_ENTER_FOREGROUND_EVENT})
end

function AppBase:onWillTerminate()
    print(">>>>>>>>>>>>>onWillTerminate")
end

function AppBase:onReceiveMemoryWarning()
    collectgarbage( "setpause", 100)
    collectgarbage( "setstepmul", 5000)
    DLG.GMDlg.AddMsg(">>>>>>>>>>>>>>>onReceiveMemoryWarning, 开启lua回收步长，注意效率")
    print(">>>>>>>>>>>>>>>onReceiveMemoryWarning, 开启lua回收步长，注意效率")
end

function AppBase:onAuthenticationChanged()
    print(">>>>>>>>>>>>>>>onAuthenticationChanged")
end

function AppBase:onDeviceTokenRegister()
    print(">>>>>>>>>>>>>>>onDeviceTokenRegister")
end

return AppBase
