
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local track = require("track")
MainScene = class("MainScene", function()
	return display.newScene("MainScene")
end)

function MainScene:ctor()
	local glock = require("glock")
	glock:Lock()
	-- display.addSpriteFrames("button.plist", "button.png")
	-- self:MyMisc()
	-- self:MySpeedUp()
	-- self:MyProfile()
	-- self:MySprite3D()
	-- self:MySprite3D_2()
	-- self:MySprite3D_3()
	-- self:MyBezier()
	-- self:MyBezier2()
	-- self:MyCocosEvent()
	-- self:MyMouseEvent()
	-- self:MyCocosKey()
	-- self:MyRetainEvt()
	-- self:MyTableView()
	-- self:MyListView()
	-- self:MyScrollView()
	-- self:MyTestGlProgram()
	-- self:MyEtc()
	-- self:MyEtcSep()
	-- self:MyTouchAgain()
	-- self:MySteering()
	-- self:MyTrack()
	-- self:MyDrawNode()
	-- self:MyWar()
	-- self:MyBox2d()
	-- self:MyPath2()
	-- self:MySpriteDraw()
	-- self:MySpine()
	-- self:MySprite()
	-- self:MyLabel()
	self:MyMiniMap()
end

function MainScene:MyMisc()
	local layer = display.newColorLayer(cc.c4b(255, 255, 255, 255)):addTo(self)
	local parent = self
	local spr = display.newSprite("char_hero_410.png"):addTo(parent)
	spr:setPosition(display.cx, display.cy)
	spr:setTouchEnabled(true)
	spr:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			if event.name == "began" then
				return true
			elseif event.name == "moved" then
				local x, y = spr:getPosition()
				local dx, dy = event.x-event.prevX, event.y-event.prevY
				spr:setPosition(x+dx, y+dy)
			end
		end)



	display.addSpriteFrames("char_hero_408.plist", "char_hero_408.png", function (plist, png)
			print("async", plist, png)
			-- local textureCache = cc.Director:getInstance():getTextureCache()
			-- local texture = textureCache:getTextureForKey(png)
			local texture = png
			local parent = self
			local spr2 = display.newSprite(texture):addTo(parent)
			spr2:setPosition(display.cx, display.cy)
			spr2:setTouchEnabled(true)
			spr2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
					if event.name == "began" then
						return true
					elseif event.name == "moved" then
						local x, y = spr2:getPosition()
						local dx, dy = event.x-event.prevX, event.y-event.prevY
						spr2:setPosition(x+dx, y+dy)
					end
				end)

			-- spr:setTexture(spr2:getTexture())

			-- spr2:setTexture(spr:getTexture())
			-- print("gl", tostring(spr:getGLProgramState()), tostring(spr2:getGLProgramState()))

		end)
end

function MainScene:MySpeedUp()
	local director = cc.Director:getInstance()
	-- track.printtable(director)
	-- local defaultsch = director:getScheduler()
	-- track.printtable(defaultsch)
	-- local sch = cc.Scheduler:new()
	-- track.printtable(sch)
	-- local handler = sch:scheduleScriptFunc(function (dt)
	-- 		print("RRRRR")
	-- 	end, 1, false)
	-- print("handler", handler)
	-- print("getref", sch:getReferenceCount())

	local actmgr = cc.ActionManager:new()

	local frames = {
		display.newSpriteFrame("btn_activty.png"),
		display.newSpriteFrame("btn_add.png"),
		display.newSpriteFrame("btn_area_map.png"),
		display.newSpriteFrame("btn_armyspeed.png"),
	}
	local animation = display.newAnimation(frames, 2)
	local obj = display.newSprite(frames[1]):addTo(self)
	obj:setPosition(50,50)
	obj:setActionManager(actmgr)
	obj:playAnimationOnce(animation)
	-- local act = cc.MoveTo:create(5, cc.p(display.cx,display.cy))
	-- obj:runAction(act)
	local timer = scheduler.scheduleUpdateGlobal(function (dt)
			actmgr:update(dt*3)
		end)

	scheduler.performWithDelayGlobal(function (dt)
			print("getref", actmgr:getReferenceCount())
		end, 6)
end

function MainScene:MyProfile()
	local profiler = require("profiler")
	profiler.start()
	track.printtable(cc.ActionManager)
	profiler.stop()
end

function MainScene:MySprite3D()
	local fname = "3d/drragon.c3t"
	local sprite = cc.Sprite3D:create(fname)
	-- sprite:setScale(0.5)
	-- sprite:setTexture("c3x/dragon1_texture.jpg")
	sprite:setPosition(display.cx, display.cy)
	-- sprite:setRotation3D({x = random(360), y = random(360), z = random(360)})
	self:addChild(sprite, -1)
	-- track.printtable(sprite)
	local node = display.newNode():addTo(self)
	node:setContentSize(display.size)
	node:setTouchEnabled(true)
	node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			if event.name == "began" then
				return true
			elseif event.name == "moved" then
				local r = sprite:getRotation3D()
				local dx,dy = event.x-event.prevX, event.y-event.prevY
				local ratio = 10
				r.x = r.x-dy/ratio
				r.y = r.y+dx/ratio
				sprite:setRotation3D(r) -- r.x,x轴方向旋转的角度
			end
		end)
	local animation = cc.Animation3D:create(fname)
	local ani = cc.Animate3D:create(animation)
	sprite:runAction(cc.RepeatForever:create(ani))
end

function MainScene:MySprite3D_2()
	local fileName = "3d/orc.c3b"
	local sprite = cc.Sprite3D:create(fileName)
	sprite:setScale(5)
	sprite:setRotation3D({x=0,y=180,z=0})
	self:addChild(sprite)
	sprite:setPosition(display.cx, display.cy)
	
	--test attach
	local sp = cc.Sprite3D:create("3d/axe.c3b")
	sprite:getAttachNode("Bip001 R Hand"):addChild(sp)
	
	local animation = cc.Animation3D:create(fileName)
	if animation then
		local animate = cc.Animate3D:create(animation)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
end

function MainScene:MySprite3D_3()
	local fileName = "3d/ReskinGirl.c3b"
	local sprite = cc.Sprite3D:create(fileName)
	sprite:setScale(4)
	self:addChild(sprite)
	sprite:setPosition(display.cx, display.cy)
end

function MainScene:MyBezier()
	display.addSpriteFrames("war/war.plist", "war/war.png")
	local x0,y0 = 50,50
	local x2,y2 = 600,400
	local ratio = 0.5
	local hight = 100
	local x1 = (x2-x0)*0.2+x0
	local y1 = math.max(y0,y2)+hight
	local spr = display.newSprite("#war/bomb0.png"):addTo(self)
	spr:setPosition(x0,y0)
	track.box(spr, 100)
	local args = {
		cc.p(x0,y0),
		cc.p(x1,y1), 
		cc.p(x2,y2)
	}
	for i,p in ipairs(args) do
		track.point(self, p)
		local np = args[i+1]
		if np then
			track.line(self, p.x, p.y, np.x, np.y, cc.c4f(0,0,1,1))
		end
	end

	local li = cc.Sequence:create(
		cc.BezierTo:create(5, args),
		cc.MoveTo:create(0.1, cc.p(x0,y0)))
	spr:runAction(cc.RepeatForever:create(li))
	local node = cc.DrawNode:create():addTo(self)
	node:drawCubicBezier(args[1], args[1], args[2], args[3], 20, cc.c4f(1,0,0,1))
	-- node:drawQuadBezier(args[1], args[2], args[3], 20, cc.c4f(1,0,0,1))
end

function MainScene:MyBezier2()
	local function bezierat(a,b,c,t)
		local pow = math.pow
		return pow((1-t),2)*a + 2*t*(1-t)*b + pow(t,2)*c
	end

	display.addSpriteFrames("war/war.plist", "war/war.png")
	local p0 = cc.p(50,50)
	local p1 = cc.p(100,800)
	local p2 = cc.p(600,50)
	local spr = display.newSprite("#war/bomb0.png"):addTo(self)
	spr:setPosition(p0)
	spr.m_MaxTime = 5
	spr:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function (dt)
			if not spr.m_Time then
				spr.m_Time = 0
				spr.m_Cnt = 0
			else
				spr.m_Time = spr.m_Time + dt
				spr.m_Cnt = spr.m_Cnt + 1
			end
			local t = spr.m_Time/spr.m_MaxTime
			if t > 1 then
				t = 1
			end
			local sx, sy = p0.x, p0.y
			local x = bezierat(sx, p1.x, p2.x, t)
			local y = bezierat(sy, p1.y, p2.y, t)
			spr:setPosition(x,y)
			if t == 1 then
				spr:removeNodeEventListenersByEvent(cc.NODE_ENTER_FRAME_EVENT)
			end
			if spr.m_Cnt%10 == 0 then
				track.point(self, cc.p(x,y))
			end
		end)
	spr:scheduleUpdate()
	-- local node = cc.DrawNode:create():addTo(self)
	-- node:drawQuadBezier(p0, p1, p2, 20, cc.c4f(1,0,0,1))
end

function MainScene:MyCocosEvent()
	local eventDispatcher = cc.Director:getInstance():getEventDispatcher()

	local spr = display.newSprite("#btn_activty.png"):addTo(self)
	spr:setPosition(display.cx, display.cy)
	spr.m_Name = "spr1"
	local listener = cc.EventListenerTouchOneByOne:create()
	-- listener:setSwallowTouches(true)
	-- track.printtable(cc.Handler)
	listener:registerScriptHandler(function (touch, event)
			track.printtable(touch)
			track.printtable(event)
			return true
		end, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(function (touch, event)
			print("moved")
		end, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(function (touch, event)
			print("ended")
			-- local obj = event:getCurrentTarget()
			-- print(obj.m_Name)
			-- obj:removeSelf()
		end, cc.Handler.EVENT_TOUCH_ENDED)
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, spr)


	local listener2 = cc.EventListenerTouchAllAtOnce:create()
	listener2:registerScriptHandler(function (touch, event)
			return true
		end, cc.Handler.EVENT_TOUCHES_BEGAN)
	listener2:registerScriptHandler(function (touch, event)
			print("\tquick moved")
		end, cc.Handler.EVENT_TOUCHES_MOVED)
	listener2:registerScriptHandler(function (touch, event)
			print("\tquick ended")
		end, cc.Handler.EVENT_TOUCHES_ENDED)
	eventDispatcher:addEventListenerWithFixedPriority(listener2, -1)
end

function MainScene:MyMouseEvent()
	local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	local listener = cc.EventListenerMouse:create()
	listener:registerScriptHandler(function (event)
			-- track.printtable(event)
			print("mouse_down", event:getMouseButton())
		end, cc.Handler.EVENT_MOUSE_DOWN)
	listener:registerScriptHandler(function (event)
			-- track.printtable(event)
			print("mouse_up", event:getMouseButton())
		end, cc.Handler.EVENT_MOUSE_UP)
	listener:registerScriptHandler(function (event)
			-- track.printtable(event)
			track.print("mouse_move", event:getLocation())
		end, cc.Handler.EVENT_MOUSE_MOVE)
	listener:registerScriptHandler(function (event)
			-- track.printtable(event)
			print("mouse_scroll", event:getScrollY())
		end, cc.Handler.EVENT_MOUSE_SCROLL)

	eventDispatcher:addEventListenerWithFixedPriority(listener, -1)
	-- eventDispatcher:removeEventListener(listener)
end

function MainScene:MyCocosKey()
	local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	local listener = cc.EventListenerKeyboard:create()
	listener:registerScriptHandler(function (keycode, event)
			print("press", keycode)
		end, cc.Handler.EVENT_KEYBOARD_PRESSED)
	listener:registerScriptHandler(function (keycode, event)
			-- track.printtable(cc.KeyCodeKey, "keycodekey")
			-- track.printtable(cc.KeyCode, "keycode")
			-- track.printtable(event, "release")
			-- print("release", cc.KeyCodeKey[keycode]) -- 对应的是手机键盘
			print("release", track.getkey(keycode))
		end, cc.Handler.EVENT_KEYBOARD_RELEASED)
	local node = display.newNode():addTo(self)
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
end

function MainScene:MyRetainEvt()
	local node = display.newNode():addTo(self):pos(display.cx, display.cx)
	node:setContentSize(cc.size(200,100))
	track.box(node)
	node:setTouchEnabled(true)
	node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			print("event",track.count())
		end)
	node:retain()
	-- node:removeSelf()
	node:removeFromParent(false)
	self:performWithDelay(function (dt)
		node:setPosition(display.cx, display.cy-200)	
		node:addTo(self)
		node:release()
		end, 3)
end

function MainScene:MyTableView()
	local w = 100
	local h = 200
	local bw = 100/2
	local bh = 200
	local view = cc.TableView:create(cc.size(w,h)) -- 实际用UIScrollView，事件由quick管
	-- view:setContentOffsetInDuration(cc.p(-150,0), 1)
	track.UseQuickEventMgr(view)
	view:addTo(self)
	view:setPosition(display.cx, display.cy)
	view:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
	-- view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	view:registerScriptHandler(function (view) -- 所有cell数量
			return 5
		end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

	view:registerScriptHandler(function (view, idx) -- cell的大小
			return 0,bw -- 垂直方向取第1个数cell的高度,水平方向取第2个cell的宽度
		end, cc.TABLECELL_SIZE_FOR_INDEX)

	view:registerScriptHandler(function (view, idx) -- idx从0开始，显示时会调用这个
			local cell = view:dequeueCell() -- 复用
			if not cell then
				cell = cc.TableViewCell:new()
				local box = display.newNode():addTo(cell)
				box:setContentSize(cc.size(bw,bh))
				track.box(box)
				local label = display.newTTFLabel({text=idx})
				label:addTo(box)
				label:setPosition(bw/2, bh/2)
				cell.m_TmpBox = box
				cell.m_TmpLabel = label
				box.m_TmpIdx = idx
				box:setTag(100)
			else
				-- cell.m_TmpLabel:setString(idx)
			end
			-- 如果加到cell的物品有事件，要再加一次，因为移出去后tableview把事件移除了
			view:performWithDelay(function ()
					local box = cell.m_TmpBox
					if box.m_TmpIdx == 0 then
						box:setTouchEnabled(true)
						box:setTouchSwallowEnabled(false)
						-- local func = tolua.getcfunction(box, "isTouchEnabled")
						print("setTouchEnabled...", box:isTouchEnabled())
						print("z", view:getGlobalZOrder(), box:getGlobalZOrder())
					end
				end, 0)
			-- box:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			-- 		if event.name == "began" then
			-- 			print("event",event, idx)
			-- 			return true
			-- 		end
			-- 	end)
			return cell -- 返回cell
		end, cc.TABLECELL_SIZE_AT_INDEX)
	
	view:reloadData()
end

function MainScene:MyListView()
-- [LUA-print] "addEventListener"  function: 08524A30
-- [LUA-print] "addScrollViewEventListener"        function: 08524A78
-- [LUA-print] "create"    function: 0851CF00
-- [LUA-print] "createInstance"    function: 0851CF48
-- [LUA-print] "doLayout"  function: 0851CE28
-- [LUA-print] "getCurSelectedIndex"       function: 0851CAC8
-- [LUA-print] "getIndex"  function: 0851C8D0
-- [LUA-print] "getItem"   function: 0851CD50
-- [LUA-print] "getItems"  function: 0851CA38
-- [LUA-print] "getItemsMargin"    function: 0851CCC0
-- [LUA-print] "insertCustomItem"  function: 0851CEB8
-- [LUA-print] "insertDefaultItem" function: 0851CB10
-- [LUA-print] "new"       function: 0851C840
-- [LUA-print] "pushBackCustomItem"        function: 0851C9A8
-- [LUA-print] "pushBackDefaultItem"       function: 0851CE70
-- [LUA-print] "refreshView"       function: 0851CC30
-- [LUA-print] "removeAllItems"    function: 0851C918
-- [LUA-print] "removeItem"        function: 0851CA80
-- [LUA-print] "removeLastItem"    function: 0851CC78
-- [LUA-print] "requestRefreshView"        function: 0851CB58
-- [LUA-print] "setGravity"        function: 0851C960
-- [LUA-print] "setItemModel"      function: 0851CD98
-- [LUA-print] "setItemsMargin"    function: 0851CBA0
-- [LUA-print] "tolua_ubox"        table: 07EDE6E8

-- ccui.ScrollViewDir.none
-- ccui.ScrollViewDir.vertical
-- ccui.ScrollViewDir.horizontal
-- ccui.ScrollViewDir.both
	local size = cc.size(300,200)
	local view = ccui.ListView:create():addTo(self):pos(display.cx, display.cy)
	view:setDirection(ccui.ScrollViewDir.horizontal)
	view:setContentSize(size)
	for i=1,10 do
		local w, h = 100,100
		local box = ccui.Widget:create()
		box:setContentSize(cc.size(w,h))
		track.box(box)
		local label = display.newTTFLabel({text=i}):addTo(box)
		label:setPosition(w/2, h/2)
		view:pushBackCustomItem(box)

	end
	view:refreshView()
end

function MainScene:MyScrollView()
	local size = cc.size(300,200)
	local view = cc.ScrollView:create(size):addTo(self):pos(display.cx, display.cy)
	view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	track.UseQuickEventMgr(view)
	local container = display.newNode()
	local w,h = 50,100
	local y = 0
	for i=1,10 do
		local node = track.node(cc.size(w,h),i):addTo(container)
		node:setPositionY(y)
		y = y+h
	end
	container:setContentSize(cc.size(w,y))
	view:setContainer(container)
end

function MainScene:MyTestGlProgram()
	local pProgram
	function darksp(spr)
		if not pProgram then
			local vertDefaultSource = [[
attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_color;
#ifdef GL_ES
	varying lowp vec4 v_fragmentColor;
	varying mediump vec2 v_texCoord;
#else
	varying vec4 v_fragmentColor;
	varying vec2 v_texCoord;
#endif
void main()
{
	gl_Position = CC_PMatrix * a_position;
	v_fragmentColor = a_color;
	v_texCoord = a_texCoord;
}
]]

			local pszFragSource =[[ 
#ifdef GL_ES
	precision mediump float;
#endif
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
void main(void)
{
	vec4 c = texture2D(CC_Texture0, v_texCoord);
	gl_FragColor.xyz = vec3(0.4*c.r + 0.4*c.g +0.4*c.b);
	gl_FragColor.w = c.w;
}
]]
	 
			pProgram = cc.GLProgram:createWithByteArrays(vertDefaultSource,pszFragSource)
			 
			pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
			pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
			pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
			-- pProgram:link()
			-- pProgram:updateUniforms()
			-- spr:setGLProgram(pProgram)
		end

		spr:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(pProgram))
	end

	local spr = display.newSprite("#btn_activty.png")
	-- local spr = display.newScale9Sprite("misc/menubattle.png")
	spr:addTo(self)
	spr:setPosition(display.cx,display.cy)
	spr.m_dark = false

	spr:setTouchEnabled(true)
	spr:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			if spr.m_dark then
				print("resume")
				spr.m_dark = false
				spr:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
			else
				print("todark")
				spr.m_dark = true
				darksp(spr)
			end
		end)
end

function MainScene:MyEtc()
	local vertDefaultSource = [[
attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_color;

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
varying vec2 v_alphaCoord;

void main()
{
    gl_Position = CC_MVPMatrix * a_position;
    v_fragmentColor = a_color;
    v_texCoord = a_texCoord * vec2(1.0, 1.0);
    v_alphaCoord = v_texCoord + vec2(0.0, 0.5);
}
]]

	local pszFragSource =[[ 
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
varying vec2 v_alphaCoord;
void main()
{
    vec4 v4Colour = texture2D(CC_Texture0, v_texCoord);
    v4Colour.a = texture2D(CC_Texture0, v_alphaCoord).r;
    v4Colour.xyz = v4Colour.xyz * v4Colour.a;
    gl_FragColor = v4Colour * v_fragmentColor;
  
    //gl_FragColor = vec4(texture2D(CC_Texture0, vec2(v_texCoord.x, v_texCoord.y)).xyz, texture2D(CC_Texture0, vec2(v_texCoord.x, v_texCoord.y + 0.5)).r);
}
]]
	local pProgram = cc.GLProgram:createWithByteArrays(vertDefaultSource,pszFragSource)
	pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
	pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
	pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)

	local layer = display.newColorLayer(cc.c4b(255, 255, 255, 255)):addTo(self)
	local spr = display.newSprite("char_hero_410_total.pkm"):addTo(self)
	spr:setPosition(display.cx, display.cy)
	spr:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(pProgram))
	spr:setTouchEnabled(true)
	spr:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			if event.name == "began" then
				return true
			elseif event.name == "moved" then
				local x, y = spr:getPosition()
				local dx, dy = event.x-event.prevX, event.y-event.prevY
				spr:setPosition(x+dx, y+dy)
			end
		end)
	track.text(spr, "etc")
	track.box(spr)

	-- local spr2 = display.newSprite("char_hero_410.png"):addTo(self)
	-- spr2:setPosition(display.cx, display.cy)
	-- spr2:setTouchEnabled(true)
	-- spr2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
	-- 		if event.name == "began" then
	-- 			return true
	-- 		elseif event.name == "moved" then
	-- 			local x, y = spr2:getPosition()
	-- 			local dx, dy = event.x-event.prevX, event.y-event.prevY
	-- 			spr2:setPosition(x+dx, y+dy)
	-- 		end
	-- 	end)
	-- track.text(spr2, "png")
	-- track.box(spr2)

	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	local str = sharedTextureCache:getCachedTextureInfo()
	print("info\n", str)
end

function MainScene:MyEtcSep()
	local layer = display.newColorLayer(cc.c4b(255, 255, 255, 255)):addTo(self)
	local spr = display.newSprite("char_hero_410.pkm"):addTo(self)
	spr:setPosition(display.cx, display.cy)
	spr:setTouchEnabled(true)
	spr:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			if event.name == "began" then
				return true
			elseif event.name == "moved" then
				local x, y = spr:getPosition()
				local dx, dy = event.x-event.prevX, event.y-event.prevY
				spr:setPosition(x+dx, y+dy)
			end
		end)
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	local str = sharedTextureCache:getCachedTextureInfo()
	print("info\n", str)
	track.box(spr)
end

function MainScene:MyTouchAgain()
	local parent = track.node(cc.size(50,50)):pos(display.cx, display.cy)
	parent:setTag(1)
	parent:setTouchEnabled(true)
	parent:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			if event.name == "began" then
				print("touch parent")
				return true
			end
		end)

	local node = track.node(cc.size(100,100)):pos(20,20)
	node:setTag(2)
	node:setTouchEnabled(true)
	node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			if event.name == "began" then
				print("touch child")
				return true
			end
		end)
	node.onCleanup = function(self)
		print("clear up")
	end
	node:setNodeEventEnabled(true)

	node:addTo(parent)
	parent:addTo(self)

	
	node:retain()
	node:removeSelf()
	node:setTouchEnabled(true)
	node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			if event.name == "began" then
				print("touch child 222")
				return true
			end
		end)
	node:addTo(parent)
	node:release()


	print("...", parent:getGlobalZOrder(), node:getGlobalZOrder())

end

function MainScene:MySteering()
	local steering = require("steering.test")
	steering.Test(self)
end

function MainScene:MyTrack()
	local function f1()
		return 1+1
	end

	local function f2()
		for i=1,100 do
			f1()
		end
	end

	local function f3()
		for i=1,100 do
			f2()
		end
	end

	track.dt()
	track.startcall()
	-- track.starthook()
	f3()
	track.dt("end") -- 0.001
	track.endcall() -- 0.053
	-- track.endhook() -- 0.019

	-- ltrack.test(f3)
end

-- [LUA-print] "clear"     function: 087C00C0
-- [LUA-print] "create"    function: 087C0228
-- [LUA-print] "drawCardinalSpline"        function: 05B01E18
-- [LUA-print] "drawCatmullRom"    function: 05B01E60
-- [LUA-print] "drawCircle"        function: 087BFFA0
-- [LUA-print] "drawCubicBezier"   function: 087C01E0
-- [LUA-print] "drawDot"   function: 08E10F70
-- [LUA-print] "drawLine"  function: 087BFC40
-- [LUA-print] "drawPoint" function: 087C0198
-- [LUA-print] "drawPoints"        function: 05B01EA8
-- [LUA-print] "drawPoly"  function: 05B01DD0
-- [LUA-print] "drawPolygon"       function: 08E10F28
-- [LUA-print] "drawQuadBezier"    function: 087BFFE8
-- [LUA-print] "drawRect"  function: 087BFCD0
-- [LUA-print] "drawSegment"       function: 087BFE80
-- [LUA-print] "drawSolidCircle"   function: 087BFD18
-- [LUA-print] "drawSolidPoly"     function: 05B01D88
-- [LUA-print] "drawSolidRect"     function: 087C0108
-- [LUA-print] "drawTriangle"      function: 087C0078
-- [LUA-print] "onDraw"    function: 087BFF10
-- [LUA-print] "onDrawGLLine"      function: 087C0030
-- [LUA-print] "onDrawGLPoint"     function: 087BFD60
-- [LUA-print] "setBlendFunc"      function: 05B01EF0
-- [LUA-print] "tolua_ubox"        table: 05B09060
-- [LUA-print] ----------.mt<<cc.DrawNode>>:sum:36------------
function MainScene:MyDrawNode()
	local drawnode = cc.DrawNode:create():addTo(self)
	track.printtable(drawnode)
	local points = {cc.p(30,30), cc.p(40, 40), cc.p(50, 30)}
	drawnode:drawPolygon(points)
	local points = {cc.p(100,100), cc.p(140, 140), cc.p(180, 100), cc.p(140, 60)}
	local params = {}
	params.fillColor = cc.c4f(1,1,0,1)
	params.borderWidth  = 1
	params.borderColor  = cc.c4f(1,1,1,1)
	drawnode:drawPolygon(points, params)
	-- drawnode:drawLine(cc.p(80,80), cc.p(200,200), cc.c4f(1,1,1,1))
end

function MainScene:MyWar()
	local war = require("war.war")
	war.StartWar(self)
end

function MainScene:MyBox2d()
	local gravity = b2Vec2(0.0, -10.0)
	local issleep = true
	local _world = b2World:new_local(gravity, issleep)
	-- Create edges around the entire screen
	local groundBodyDef = b2BodyDef:new_local()
	groundBodyDef.position = b2Vec2(0, 0)
	local groundBody = _world:CreateBody(groundBodyDef)
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function (dt)

		end)
	self:scheduleUpdate()
end

function MainScene:MyPath2()
	local path2 = require("path2.path2")
	path2.Start(self)
end

function MainScene:MySpriteDraw()
	local spr = display.newSprite("#btn_activty.png")
	spr:addTo(self)
	spr:setPosition(display.cx,display.cy)
end

function MainScene:MySpine()
	-- local layer = display.newColorLayer(cc.c4b(255, 255, 255, 255)):addTo(self)
	local name = "lord_4"
	local json = string.format("%s.json", name)
	local atlas = string.format("%s.atlas", name)
	local skeletonNode = sp.SkeletonAnimation:create(json, atlas, 1)
	skeletonNode:setScale(1)
	skeletonNode:addAnimation(0, "group", true)
	skeletonNode:addTo(self)
	skeletonNode:setPosition(display.cx, display.cy-200)

	-- local name = "lord_5"
	-- local json = string.format("%s.json", name)
	-- local atlas = string.format("%s.atlas", name)
	-- local skeletonNode = sp.SkeletonAnimation:create(json, atlas, 1)
	-- skeletonNode:setScale(1)
	-- skeletonNode:addAnimation(0, "group", true)
	-- skeletonNode:addTo(self)
	-- skeletonNode:setPosition(display.cx, display.cy-200)
end

function MainScene:MySprite()
	local spr = display.newSprite("battle_civilization_blue.png"):addTo(self)
	spr:setPosition(display.cx, display.cy)
end

function MainScene:MyLabel()
	local label = display.newTTFLabel({text="Yes", font = "msyh.ttf"})
	label:addTo(self)
	label:setPosition(display.cx, display.cy)
end

function MainScene:MyMiniMap()
	print(">> test minimap")
	local MiniMap = require("minimap")
	self.minimap = MiniMap.new(self)
	self.minimap:Start()
end

return MainScene

