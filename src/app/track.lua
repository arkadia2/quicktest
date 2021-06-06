
local track = {}

local Code2Key = {
	[76] = {VK='VK_0', Key='0', ShiftKey=')', },
	[77] = {VK='VK_1', Key='1', ShiftKey='!', },
	[78] = {VK='VK_2', Key='2', ShiftKey='@', },
	[79] = {VK='VK_3', Key='3', ShiftKey='#', },
	[80] = {VK='VK_4', Key='4', ShiftKey='$', },
	[81] = {VK='VK_5', Key='5', ShiftKey='%', },
	[82] = {VK='VK_6', Key='6', ShiftKey='^', },
	[83] = {VK='VK_7', Key='7', ShiftKey='&', },
	[84] = {VK='VK_8', Key='8', ShiftKey='*', },
	[85] = {VK='VK_9', Key='9', ShiftKey='(', },

	[124] = {VK='VK_A', Key='a', ShiftKey='A', },
	[125] = {VK='VK_B', Key='b', ShiftKey='B', },
	[126] = {VK='VK_C', Key='c', ShiftKey='C', },
	[127] = {VK='VK_D', Key='d', ShiftKey='D', },
	[128] = {VK='VK_E', Key='e', ShiftKey='E', },
	[129] = {VK='VK_F', Key='f', ShiftKey='F', },
	[130] = {VK='VK_G', Key='g', ShiftKey='G', },
	[131] = {VK='VK_H', Key='h', ShiftKey='H', },
	[132] = {VK='VK_I', Key='i', ShiftKey='I', },
	[133] = {VK='VK_J', Key='j', ShiftKey='J', },
	[134] = {VK='VK_K', Key='k', ShiftKey='K', },
	[135] = {VK='VK_L', Key='l', ShiftKey='L', },
	[136] = {VK='VK_M', Key='m', ShiftKey='M', },
	[137] = {VK='VK_N', Key='n', ShiftKey='N', },
	[138] = {VK='VK_O', Key='o', ShiftKey='O', },
	[139] = {VK='VK_P', Key='p', ShiftKey='P', },
	[140] = {VK='VK_Q', Key='q', ShiftKey='Q', },
	[141] = {VK='VK_R', Key='r', ShiftKey='R', },
	[142] = {VK='VK_S', Key='s', ShiftKey='S', },
	[143] = {VK='VK_T', Key='t', ShiftKey='T', },
	[144] = {VK='VK_U', Key='u', ShiftKey='U', },
	[145] = {VK='VK_V', Key='v', ShiftKey='V', },
	[146] = {VK='VK_W', Key='w', ShiftKey='W', },
	[147] = {VK='VK_X', Key='x', ShiftKey='X', },
	[148] = {VK='VK_Y', Key='y', ShiftKey='Y', },
	[149] = {VK='VK_Z', Key='z', ShiftKey='Z', },

	[6] = {VK='VK_ESC', Key='', ShiftKey='', },
	[12] = {VK='VK_SHIFT', Key='', ShiftKey='', },
	[14] = {VK='VK_CTRL', Key='', ShiftKey='', },
	[16] = {VK='VK_ALT', Key='', ShiftKey='', },
	[26] = {VK='VK_LEFT', Key='', ShiftKey='', },
	[27] = {VK='VK_RIGHT', Key='', ShiftKey='', },
	[28] = {VK='VK_UP', Key='', ShiftKey='', },
	[29] = {VK='VK_DOWN', Key='', ShiftKey='', },

	[20] = {VK='VK_INSERT', Key='', ShiftKey='', },
	[23] = {VK='VK_DELETE', Key='', ShiftKey='', },
	[36] = {VK='VK_HOME', Key='', ShiftKey='', },
	[24] = {VK='VK_END', Key='', ShiftKey='', },
	[38] = {VK='VK_PAGE_UP', Key='', ShiftKey='', },
	[44] = {VK='VK_PAGE_DOWN', Key='', ShiftKey='', },

	[47] = {VK='VK_F1', Key='', ShiftKey='', },
	[48] = {VK='VK_F2', Key='', ShiftKey='', },
	[49] = {VK='VK_F3', Key='', ShiftKey='', },
	[50] = {VK='VK_F4', Key='', ShiftKey='', },
	[51] = {VK='VK_F5', Key='', ShiftKey='', },
	[52] = {VK='VK_F6', Key='', ShiftKey='', },
	[53] = {VK='VK_F7', Key='', ShiftKey='', },
	[54] = {VK='VK_F8', Key='', ShiftKey='', },
	[55] = {VK='VK_F9', Key='', ShiftKey='', },
	[56] = {VK='VK_F10', Key='', ShiftKey='', },
	[57] = {VK='VK_F11', Key='', ShiftKey='', },
	[58] = {VK='VK_F12', Key='', ShiftKey='', },
	[59] = {VK='VK_SPACE', Key=' ', ShiftKey='', },

}

for code,data in pairs(Code2Key) do
	local vk = data["VK"]
	track[vk] = code -- enable track.VK_0
end

local function getkeydata(code)
	local data = Code2Key[code]
	if not data then
		error(string.format("not support code %d",code))
	end
	return data
end

function track.getkey(code)
	return getkeydata(code)["Key"]
end

function track.getshiftkey(code)
	return getkeydata(code)["ShiftKey"]
end

local KeyDown = nil
local function initkeydown()
	if not KeyDown then
		KeyDown = {} -- {code:1}
		local node = display.newNode()
		node:addTo(GlobalVars.TipsPanel)
		node:setKeypadEnabled(true)
		node.OrgEventDispatcher = node.EventDispatcher
		node.EventDispatcher = function (self,idx,data)
				if idx==cc.KEYPAD_EVENT then
					local code = data[1]
					local evt = data[2]
					local ename = data[3]
					if ename == "Pressed" then
						KeyDown[code] = 1
					elseif ename == "Released" then
						KeyDown[code] = nil
					end
				else
					node:OrgEventDispatcher(idx,data)
				end
			end
	end
end

function track.iskeydown(code) -- code is track.VK_XXX
	initkeydown()
	return KeyDown[code] == 1
end

function track.track()
	print("from track++++++++++++++++++++++++++")
	print(debug.traceback("",2))
	print("end track---------------------------")
end

function track.showcalls()
	local function hook(event)
		local info = debug.getinfo(2,"Sn")
		if info["what"] ~= "Lua" then
			return end
		track.print(event,debug.getinfo(2,"Sn"))
	end
	debug.sethook(hook,"c")
end

local Counters = {} -- {f:cnt,...}
local Names = {} -- {f:info,...}
local Times = {} -- {f:t,...}
local OneTime = {} -- {f:sted,...}
local getinfo = debug.getinfo
local clock = os.clock
local function clearhook()
	Counters = {}
	Names = {}
	Times = {}
	OneTime = {}
end

local function profile(sortby)
	sortby = sortby or "Time"
	local li = {}
	for f,cnt in pairs(Counters) do
		local info = Names[f]
		local t = Times[f] or 0
		if t ~= 0 then
			table.insert(li,{Name=info.name or "??",Source=info.source,What=info.what,LineDef=info.linedefined,
				Count=cnt,Time=t,PerT=t/cnt})
		end
	end
	table.sort(li,function (a,b)
			return a[sortby] > b[sortby]
		end)
	print("profile+++++++++++++++")
	for i,dic in ipairs(li) do
		print(string.format("%4d cnt:%d t:%.4f pt:%.4f n:%s->%s:%s", i, dic.Count, dic.Time, dic.PerT, dic.Source, dic.Name, dic.LineDef))
	end
	print("profile---------------")
end

function track.startcall()
	local function hook(event)
		local f = getinfo(2,"f").func
		-- track.print(event,getinfo(2,"Sn"))
		if event == "call" then
			local cnt = Counters[f]
			if not cnt then
				cnt = 1
				Names[f] = getinfo(2,"Sn")
			else
				cnt = cnt+1
			end
			Counters[f] = cnt
			OneTime[f] = clock()
		elseif event == "return" then
			if not Names[f] then
				return end
			local t = clock()-OneTime[f]
			OneTime[f] = nil
			Times[f] = (Times[f] or 0)+t
		end
	end
	clearhook()
	debug.sethook(hook,"cr")
end

function track.endcall(sortby)
	debug.sethook()
	profile(sortby)
	clearhook()
end

function track.starthook()
	local function callfunc(f)
		local cnt = Counters[f]
		if not cnt then
			cnt = 1
			Names[f] = getinfo(2,"Sn")
		else
			cnt = cnt+1
		end
		Counters[f] = cnt
		OneTime[f] = clock()
	end

	local function returnfunc(f)
		if not Names[f] then
			return end
		local t = clock()-OneTime[f]
		OneTime[f] = nil
		Times[f] = (Times[f] or 0)+t
	end
	clearhook()
	ltrack.start_hook(callfunc, returnfunc)
end

function track.endhook(sortby)
	ltrack.end_hook()
	profile(sortby)
	clearhook()
end

function track.printtable(tb, name, supers)
	local function _deal(tb,name)
		name = name or ""
		if type(tb) == "userdata" or (type(tb) == "table" and tb[".isclass"]) then
			if tolua then
				name = string.format("%s.mt<<%s>>",name,tolua.type(tb))
			else
				name = string.format("%s.<<ud>>",name)
			end

			if supers == nil then 
				supers = true -- 默认显示基类函数
			end
			local mt = getmetatable(tb)
			if mt then
				tb = {}
			end
			while mt do
				for k,v in pairs(mt) do
					tb[k] = v
				end
				if not supers then
					break
				end
				mt = getmetatable(mt)
			end
			local peer = tolua.getpeer(tb) -- self.attr都挂在peer里
			if peer then
				for k, v in pairs(peer) do
					tb[k] = v
				end
			end
		end
		return tb,name
	end

	local obj = tb
	tb,name = _deal(tb,name)
	local st = type(tb)
	if st ~= "table" then
		print(string.format("printtable need a table not %s,name:%s",st,name))
		return
	end
	name = name or "table"
	print(string.format("++++++++++++++%s:%s++++++++++++++++",name,tostring(tb.__cname)))
	local sum = 0
	local keys = {}
	for k in pairs(tb) do keys[#keys+1]=k end
	table.sort(keys,function (a,b)
		return tostring(a) < tostring(b)
	end)

	for i,k in ipairs(keys) do
		local v = tb[k]
		local ret
		if type(v) == "function" and (string.sub(k,1,3) == "get" or string.sub(k,1,2) == "is") then
			local ok, r1, r2, r3, r4, r5 = pcall(v,obj)
			if not ok then
				ret = nil
			else
				local l = {r1, r2, r3}
				if #l>1 then
					ret = track.ser(l)
				else
					ret = track.ser(r1)
				end
			end
		end
		if not ret then
			ret = track.tostr(v)
		end
		print(track.tostr(k),ret)
		sum = sum+1
	end
	print(string.format("----------%s:sum:%d------------",name,sum))
end

function track.tostr(obj)
	local t = type(obj)
	if t == "string" then return string.format("%q",obj) end
	return tostring(obj)
end

function track.subtable(tb1,tb2)
	local tb = {}
	for k,v in pairs(tb1) do
		if tb2[k] == nil then tb[k] = v end
	end
	return tb
end

function track.printnodetree(parent,func,lv)
	lv = lv or 1
	if parent.getChildren == nil then 
		return end
	if func then 
		func(parent) 
	else
		local s = string.format("%s|-%s,%d,%s,cls:%s",string.rep("   ",lv),tostring(parent.name or parent:getName()),tostring(parent:getTag()),tolua.type(parent),tostring(parent.__cname))
		print(s)
	end
	for _,child in ipairs(parent:getChildren()) do
		track.printnodetree(child,func,lv+1)
	end
end

function track.printparent(obj)
	local lv = 0
	local parent = obj:getParent()
	while parent do
		lv = lv + 1
		local s = string.format("%s|-%s,%d,%s",string.rep("   ",lv),tostring(parent.name or parent:getName()),tostring(parent:getTag()),tolua.type(parent))
		print(s)
		parent = parent:getParent()
	end
end

function track.ser(obj,lookup) -- 序列化
	lookup = lookup or {}
	local sType = type(obj)
	if sType == "string" then
		return string.format("%q",obj)
	end
	if sType == "userdata" then
		return string.format("<<ud-%s>>",tolua.type(obj))
	end
	if sType == "table" then
		if lookup[obj] then  -- 有环
			return "\"<<self>>\""
		end
		lookup[obj] = true
		local li = {}
		for i,v in ipairs(obj) do
			li[i] = v
		end
		local dic = {}
		local dicnum = 0
		for k,v in pairs(obj) do
			if not li[k] then 
				dicnum = dicnum + 1
				dic[k] = v 
			end 
		end
		local tb = {"{"}
		for i,v in ipairs(li) do
			table.insert(tb,track.ser(v))
			table.insert(tb,", ")
		end
		if #li > 0 and dicnum > 0 then 
			table.remove(tb, #tb)
			table.insert(tb, "; ") 
		end
		for k,v in pairs(dic) do
			local skey
			if type(k) == "number" then
				skey = string.format("[%d]",k)
			elseif type(k) == "string" then
				skey = k
			else
				skey = track.ser(k,lookup)
			end
			table.insert(tb, string.format("%s=%s, ",skey,track.ser(v,lookup)))
		end
		table.insert(tb,"}")
		lookup[obj] = nil
		return table.concat(tb,"")
	end
	return tostring(obj)
end

function track.print(...)
	local tb = {}
	for _,arg in ipairs({...}) do
		table.insert(tb,track.ser(arg))
	end
	local msg = table.concat(tb," ")
	print(msg)
end

function track.orgbox(node,color) -- 一些label等不能加子节点
	color = color or cc.c4b(255,0,0,100)
	local parent = node:getParent()
	local x,y = node:getPosition()
	local z = node:getLocalZOrder()
	local size = node:getContentSize()
	local w,h = size.width,size.height
	local ap = node:getAnchorPointInPoints()
	local ax,ay = ap.x,ap.y
	local orgx,orgy = x-ax,y-ay
	local box = cc.LayerColor:create(color,w,h)
	box:ignoreAnchorPointForPosition(false)
	box:setAnchorPoint(cc.p(0,0))
	local drawnode = cc.DrawNode:create()
	box:add(drawnode)
	drawnode:drawLine(cc.p(0,ay),cc.p(w,ay),cc.c4f(0,1,0,1))
	drawnode:drawLine(cc.p(ax,0),cc.p(ax,h),cc.c4f(0,0,1,1))
	box:setPosition(orgx,orgy)
	box:setLocalZOrder(z+1)
	-- if parent.m_OrgBox then parent.m_OrgBox:removeSelf() end
	-- parent.m_OrgBox = box
	parent:add(box)
end

function track.box(node,z,color)
	color = color or cc.c4b(255,0,0,100)
	z = z or -1
	local size = node:getContentSize()
	local w,h = size.width,size.height
	local ap = node:getAnchorPointInPoints()
	local ax,ay = ap.x,ap.y
	local box = cc.LayerColor:create(color,w,h)
	box:ignoreAnchorPointForPosition(false)
	box:setAnchorPoint(cc.p(0,0))
	local drawnode = cc.DrawNode:create()
	box:add(drawnode)
	drawnode:drawLine(cc.p(0,ay),cc.p(w,ay),cc.c4f(0,1,0,1))
	drawnode:drawLine(cc.p(ax,0),cc.p(ax,h),cc.c4f(0,0,1,1))
	node:add(box,z)
end

function track.text(parent,text,color,size)
	color = color or cc.c3b(255, 0, 0)
	size = size or 24
	local label = display.newTTFLabel({
		text = text,
		size = size,
		color = color,
	})
	label:addTo(parent)
	return label
end

function track.line(parent,sx,sy,ex,ey,color)
	color = color or cc.c4f(1,0,0,1)
	local drawnode = cc.DrawNode:create()
	parent:add(drawnode)
	drawnode:drawLine(cc.p(sx,sy),cc.p(ex,ey),color)
	return drawnode
end

function track.point(parent,p,name,color)
	name = name or "p"
	local node = display.newNode()
	node:setContentSize(cc.size(10,10))
	node:setPosition(p.x,p.y)
	node:setAnchorPoint(cc.p(0.5,0.5))
	parent:add(node)
	track.box(node,99999,color)
	if name ~= "" then
		track.text(node,string.format("%s",name))
	end
	return node
end

function track.rect(parent,rect,color)
	color = color or cc.c4b(255,0,0,100)
	local x,y,w,h = rect.x,rect.y,rect.width,rect.height
	local box = cc.LayerColor:create(color,w,h)
	box:ignoreAnchorPointForPosition(false)
	box:setAnchorPoint(cc.p(0,0))
	box:setPosition(x,y)
	parent:add(box)
	return box
end

function track.circle(parent, center, radius, color)
	color = color or cc.c4f(1,0,0,1)
	local drawnode = cc.DrawNode:create()
	parent:add(drawnode)
	drawnode:drawCircle(center, radius, 0, 50, true, color)
	return drawnode
end

function track.polygon(parent, points, params)
	params = params or {}
	params.fillColor = params.fillColor or cc.c4f(1,0,0,0)
	params.borderWidth = params.borderWidth or 1
	params.borderColor = params.borderColor or cc.c4f(0,0,1,1)
	local drawnode = cc.DrawNode:create()
	parent:add(drawnode)
	drawnode:drawPolygon(points, params)
	return drawnode
end

function track.node(parent, size, text, color)
	size = size or cc.size(10, 10)
	local node = display.newNode():addTo(parent)
	node:setContentSize(size)
	node:setAnchorPoint(cc.p(0.5, 0.5))
	track.box(node,nil,color)
	if text then
		local label = display.newTTFLabel({text=text}):addTo(node)
		label:setPosition(size.width/2, size.height/2)
	end
	return node
end

function track.functor(func,...)
	local args = {...}
	return function (...)
		local newargs = {}
		table.merge(newargs,args)
		for _,x in ipairs({...}) do
			newargs[#newargs+1] = x
		end
		return func(unpack(newargs))
	end
end

function track.funcname(func)
	local info = debug.getinfo(func,"S")
	local fname = info["source"]
	fname = string.sub(fname,3,#fname)
	fname = GetSrcPath().."/"..fname
	local lineno = info["linedefined"]
	local fobj = io.open(fname,"rb")
	local i = 0
	for line in fobj:lines() do
		i = i + 1
		if i == lineno then
			return line
		end
	end
	fobj:close()
end

function track.dlgpos(dlgname,parent)
	local node,w,h = cc.uiloader:load(dlgname)
	if parent then
		if GlobalVars then
			GlobalVars.UIPanel:removeChild(node)
		end
		parent:add(node)
	end
	local function getpos(n)
		if not n.name then return end
		if not string.find(n.name,"pos_") then return end
		local x,y = n:getPosition()
		local size = n:getContentSize()
		local w,h = size.width,size.height
		track.print(n.name,x,y,w,h)
	end
	track.printnodetree(node,getpos)
end

function track.playarm(json,name,on_move,on_frame)
	local manager = ccs.ArmatureDataManager:getInstance() -- 数据管理器
	manager:addArmatureFileInfo(json) -- 增加资源数据
	local arm = ccs.Armature:create(name) -- 创建骨骼节点，可以进行移位，缩放等
	local ani = arm:getAnimation() -- 获取动画对象
	if on_move then
		ani:setMovementEventCallFunc(on_move) -- 动作事件
	end
	if on_frame then
		ani:setFrameEventCallFunc(on_frame) -- 帧事件
	end
	-- ani:play(mov)  -- 播放动作,最后参数 0:播放一次 1:循环播放 没有时用lp属性
	return arm,ani
end

function track.playani(fname,patt,st,ed,time,on_complete) -- track.playani("effect/1001","1001/ani%d.png",1,9,0.5)
	local plist = fname..".plist"
	local png = fname..".png"
	display.addSpriteFrames(plist, png)
	local frames = display.newFrames(patt, st, ed)
	local t = time/#frames
	local animation = display.newAnimation(frames, t)
	local spr = display.newSprite(frames[1])
	spr:playAnimationOnce(animation, true, function ()
			display.removeSpriteFramesWithFile(plist,png)
			if on_complete then 
				on_complete() 
			end
		end)
	return spr
end

function track.reload(name) -- 热更新
	local package = require("package")
	local loaded = package.loaded
	if not loaded[name] then
		require(name)
		return
	end
	
	local old = loaded[name]
	loaded[name] = nil
	local new = require(name)
	loaded[name] = old
	
	for k,v in pairs(old) do -- delete and replace
		if type(v) == "table" then
			for kk,vv in pairs(v) do
				v[kk] = new[k][kk]
			end
		else
			old[k] = new[k]
		end
	end
	
	for k,v in pairs(new) do -- add
		if type(v) == "table" then
			for kk,vv in pairs(new[k]) do
				if not v[kk] then v[kk] = vv end
			end 
		else
			if not old[k] then old[k]=v end
		end
	end
end

function track.cal53(exp,env)
	-- local ret = track.cal("math.floor(a+b+1.5)",{a=1,b=2})
	env = env or {}
	local dic = {}
	for k,v in pairs(_G) do dic[k] = v end
	for k,v in pairs(env) do dic[k] = v end
	local func = load("return "..exp,"cal","bt",dic)
	return func()
end

function track.cal51(exp,env)
	-- local ret = track.cal("math.floor(a+b+1.5)",{a=1,b=2})
	env = env or {}
	local _cal = loadstring("return "..exp)
	setfenv(_cal,env)
	return _cal()
end

-- 分离字符成一个列表
-- num是取出的个数,如
-- s="1:2:3:4"
-- split(s,":",2) -> {"1","2:3:4"}

function track.split(str,sp,num)
	local i = 1
	local j = 0
	local st = 1
	local li = {}
	while true do
		i,j = string.find(str,sp,i)
		if not i then
			break
		end
		table.insert(li,string.sub(str,st,i-1))
		i = j+1
		st = i
		if num and #li >=num then
			break
		end
	end
	if st == 1 then -- 没找到
		table.insert(li,str)
	else -- 把剩下的放进去
		table.insert(li,string.sub(str,st,#str))
	end
	return li
end

track.firstlog = 1
function track.log(str,fname)
	fname = fname or "track.log"
	local mod = "ab"
	if track.firstlog then
		mod = "wb"
		track.firstlog = nil
	end
	local fobj = io.open(fname,mod)
	fobj:write(str)
	fobj:write("\n")
	fobj:close()
end

function track.class(classname, ...)
	local cls
	local lSuper = {...}
	if next(lSuper) then
		cls = {}
		local find = function (obj, key)
			for _, c in ipairs(obj.__superclass) do
				local value = c[key]
				if value then
					return value
				end
			end
		end
		local super = setmetatable({}, {__index = find})
		super.__superclass = lSuper
		cls.super = super
		setmetatable(cls, {__index = super})
	else
		cls = {ctor = function() end}
	end
	cls.__cname = classname
	cls.__index = cls
	function cls.new(...)
		local instance = setmetatable({}, cls)
		instance.class = cls
		instance:ctor(...)
		return instance
	end
	return cls
end

function track.showmem(parent,all)
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	local node = display.newNode()
	node:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function (dt)
			local str = sharedTextureCache:getCachedTextureInfo()
			local last = str
			if not all then
				local tb = track.split(str,"\n") -- 只取最后一行
				last = tb[#tb-1]
			end
			last = last..string.format("LUA VM MEMORY USED: %0.2f KB", collectgarbage("count"))
			if not node.txt then
				local txt = display.newTTFLabel({text=last, size=16})
				node:add(txt)
				node.txt = txt
				txt:setAnchorPoint(cc.p(1,0))
				txt:setPosition(display.width,0)
			else
				node.txt:setString(last)
			end
		end)
	node:scheduleUpdate()
	parent:add(node) -- parent释放计时器也就没了
end

function track.printmem(head,all)
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	local str = sharedTextureCache:getCachedTextureInfo()
	local last = str
	if not all then
		local tb = track.split(str,"\n") -- 只取最后一行
		last = tb[#tb-1]
	end
	print("======printmem",head)
	print(last)
end

track.cnt = 0
function track.count()
	track.cnt = track.cnt+1
	return track.cnt
end
function track.recount()
	track.cnt = 0
end


track.frametext = nil
function track.showframe() -- 30fps
	if track.frametext then
		return end
	local frame = 0
	local cnt = 0
	local text = display.newTTFLabel({text=string.format("frame:%d",frame),size=30,color=cc.c3b(255,0,0)})
	GlobalVars.TipsPanel:add(text)
	text:setAnchorPoint(cc.p(1,0)) -- right down
	text:setPosition(display.width,0)
	track.frametext = text
	local function func(dt)
		cnt = cnt + 1
		if cnt%2 == 0 then
			return end
		frame = frame+1
		text:setString(string.format("frame:%d",frame))
	end
	text.m_sc = scheduler.scheduleUpdateGlobal(func)
end

function track.rmframe()
	local text = track.frametext
	if not text then
		return end
	if text.m_sc then
		scheduler.unscheduleGlobal(text.m_sc)
	end
	text:removeSelf()
	track.frametext = nil
end

function track.hooktouch(obj,func) -- 模拟多点触摸
	local function nodetext(node)
		local x,y = node:getPosition()
		local txt = string.format("P:%d %d,%d",node.idx,x,y)
		if node.text then
			node.text:setString(txt)
		else
			local size = node:getContentSize()
			local cw,ch = size.width/2,size.height/2
			node.text = display.newTTFLabel({text=txt,size=16}):addTo(node):align(display.CENTER, cw, ch)
			-- node.text:enableOutline(cc.c4b(0,0,0,255), 1)
		end
	end

	local function addnode(idx,event)
		local node = display.newNode():addTo(GlobalVars.TipsPanel):align(display.CENTER, event.x, event.y)
		node:setContentSize(cc.size(20,20))
		track.box(node)
		node.idx = idx
		obj.mp[idx] = node
		obj.selp = node
		nodetext(node)
	end

	local function delnode(idx)
		local node = obj.mp[idx]
		if obj.selp == node then obj.selp = nil end
		node:removeSelf()
		obj.mp[idx] = nil
		if table.nums(obj.mp) == 0 then
			obj.mp = nil
		end
	end


	local function getevt(idx,name,event)
		return {name=name,points={[tostring(idx)]={x=event.x,y=event.y,prevX=event.prevX,prevY=event.prevY}}}
	end

	local function onkey(event)
		track.print("event",event)
		-- if event.code == track.VK_ESC then
		if event.code == 16 then -- alt
			if obj.mp then
				local idxlist = table.keys(obj.mp)
				local lastidx = idxlist[#idxlist]
				for idx,node in pairs(obj.mp) do
					local x,y = node:getPosition()
					local event = {x=x,y=y,prevX=x,prevY=y}
					local evt
					if idx ~= lastidx then
						evt = getevt(idx,"removed",event)
					else
						evt = getevt(idx,"ended",event)
					end
					node:removeSelf()
					func(evt)
				end
			end
			obj.mp = nil
			obj.selp = nil
		end
	end

	local function ontouch(event)
		if event.name == "began" then
			if not obj.mp then
				obj.mp = {}
				local idx = 0
				addnode(idx,event)
				local evt = getevt(idx,"began",event)
				func(evt)
			else
				local selnode
				for idx,node in pairs(obj.mp) do
					local lp = node:convertToNodeSpaceAR(event)
					local size = node:getContentSize()
					local cw,ch = size.width/2,size.height/2
					if lp.x > -cw and lp.x < cw and lp.y > -ch and lp.y < ch then
						selnode = node
						break
					end
				end
				if selnode then
					if track.iskeydown(track.VK_CTRL) then
						delnode(selnode.idx)
						local evt
						if not obj.mp then
							evt = getevt(idx,"ended",event)
						else
							evt = getevt(idx,"removed",event)
						end
						func(evt)
					else
						obj.selp = selnode
					end
				else
					local idx = math.max(unpack(table.keys(obj.mp)))+1
					addnode(idx,event)
					local evt = getevt(idx,"added",event)
					func(evt)
				end
			end
			return true
		elseif event.name == "moved" then
			if not obj.selp then 
				return end
			local dx = event.x - event.prevX
			local dy = event.y - event.prevY
			local x,y = obj.selp:getPosition()
			obj.selp:setPosition(x+dx,y+dy)
			nodetext(obj.selp)
			local evt = {name="moved",points={}}
			for idx,node in pairs(obj.mp) do
				local pdata
				if idx == obj.selp.idx then
					pdata = {x=event.x,y=event.y,prevX=event.prevX,prevY=event.prevY}
				else
					local x,y = node:getPosition()
					pdata = {x=x,y=y,prevX=x,prevY=y}
				end
				evt["points"][tostring(idx)] = pdata
			end
			func(evt)
		elseif event.name == "ended" then
			obj.selp = nil
			onkey({code=track.VK_ESC})
		end
	end

	obj.mp = nil
	obj:setTouchEnabled(true)
	obj:addNodeEventListener(cc.NODE_TOUCH_EVENT, ontouch)
	obj:setKeypadEnabled(true)
	obj:addNodeEventListener(cc.KEYPAD_EVENT, onkey)
end

-- 锁定全局表，用于检查忘写local
local nolock = { -- 放过检查
	} 
function track.lockglobal()
	setmetatable(_G, {__newindex = function (t,k,v)
			if nolock[k] or type(k)=="string" and string.sub(k,1,2) == "g_" then
				rawset(t,k,v)
			else
				error(string.format("want to do _G[%s]=%s!!",track.ser(k),track.ser(v)),2)
			end
		end})
end


function track.testsort()
	local li = {}
	for i=1,10 do
		local x1 = math.random(1,10)
		local x2 = math.random(1,10)
		table.insert(li,{x1,x2})
	end
	table.sort(li,function (a,b)
			if a[1] < b[1] then -- >则由大到小,<则由小到大
				return true
			elseif a[1] == b[1] then
				return a[2] < b[2]
			end
			return false
		end)
	track.print(li)
end

function track.testtime()
	-- http://blog.csdn.net/goodai007/article/details/8077285
	local time = os.time({year=2015,month=3,day=12,hour=12,min=0,sec=0})
	track.print("time",time)
	track.print(os.date("%c",time))
	track.print(os.date("*t",time))
	track.print(os.date("%Y/%m/%d %H:%M:%S",time))
end

function track.testpcall()
	local function func()
		error("raise error")
		return {1,2}
	end
	local function err(msg)
		print(msg)
		print(debug.traceback())
	end
	local ok,ret = xpcall(func, err)
	track.print("ret",ok,ret)
end

-- 国际化
function track.intlpack(fmt,...)
	return string.format("%s%s",fmt,table.concat({...},""))
end

function track.intljoin(...)
	local lfmt = {}
	for i=1,#{...} do
		table.insert(lfmt,"%s")
	end
	return track.intlpack(table.concat(lfmt,""),...)
end

function track.intlreplace(s,old,new,cnt)
	local reps
	if cnt then
		reps = string.format("%s@%s@%d@",old,new,cnt)
	else
		reps = string.format("%s@%s@",old,new)
	end
	return track.intlpack("%s",s,reps)
end

function track.intlunpack(s)
	if string.byte(s,1) ~= 17 then -- 17,的ascii码
		return s
	end
	local i,j,st = 1,1,1
	local isfmt = false
	local sp = ""
	local ss = ""
	local stack = {}
	local lfmt = {}
	local base = 0
	local fmt = ""
	local args = {}
	local old,new,cnt = "","",nil -- replace相关
	while true do
		i,j,sp = string.find(s,"([])",i)
		if not i then
			break
		end
		-- print("i,j,st,sp",i,j,st,sp)
		if sp == "" then
			isfmt = true
		elseif sp == "" or sp == "" then
			ss = string.sub(s,st+1,i-1)
			if #ss > 0 then
				-- print("push",ss)
				table.insert(stack,ss)
				if isfmt then
					isfmt = false
					table.insert(lfmt,#stack)
				end
			end
			if sp == "" then
				base = lfmt[#lfmt]
				table.remove(lfmt,#lfmt)
				fmt = stack[base]
				args = {}
				for x=#stack,base+1,-1 do
					table.insert(args,1,stack[x])
					table.remove(stack,x)
				end
				old,new,cnt = "","",nil
				if #args == 2 and string.byte(args[2],-1) == 26 then -- 26,@的ascii码
					local li = track.split(args[2],"@")
					old = li[1]
					new = li[2]
					cnt = tonumber(li[3])
					table.remove(args,#args)
				end
				stack[base] = string.format(fmt,unpack(args))
				if #old>0 then
					-- print("replace",stack[base],old,new,cnt)
					stack[base] = string.gsub(stack[base],old,new,cnt)
				end
			end
		end
		st = j
		i = j + 1
	end
	if #stack ~= 1 or #lfmt ~= 0 then
		error(string.format("解包字符串错误 stack:%d lfmt:%d %s",#stack,#lfmt,s))
		return s
	end
	return stack[1]
end

function track.testintl()
	-- local s1 = track.intlpack("111:%s,%s","1a","1b")
	-- local s2 = track.intlpack("222:%s,%s",s1,"2a")
	-- print("s2",s2)
	-- local s3 = track.intlunpack(s2)
	-- print("s3",s3)

	-- local s4 = track.intljoin("a","b","c")
	-- print("s4",s4)
	-- local s5 = track.intlunpack(s4)
	-- print("s5",s5)
	-- local s6 = track.intljoin(s2,s5,"zzz")
	-- print("s6",s6)
	-- local s7 = track.intlunpack(s6)
	-- print("s7",s7)

	local s8 = track.intlreplace("abc...def...","%.%.%.","#r",1)
	print("s8",s8)
	local s9 = track.intlunpack(s8)
	print("s9",s9)
end

function track.getlocals(n)
	print("locals-----")
	n = n or 2
	local a = 1
	while true do
		local name,value = debug.getlocal(n,a)
		if not name then
			break
		end
		print(name,value)
		a = a+1
	end
end

function track.testlocal(x)
	local i = 1
	local s = "abc"
	local d = {A='a'}
	d[zz] = a;
end

local function err(msg)
	print(msg)
	track.getlocals(3)
	-- print(debug.traceback())
end

-- xpcall(track.testlocal,err,3)

local lastt
function track.dt(name)
	if not name then
		lastt = os.clock()
	else
		local t = os.clock()
		print(string.format("dt %s %.3f",name, t-lastt))
		lastt = t
	end
end

-- 使引擎自带的控件cc.TableView,cc.ScrollView等的事件设为由quick管理
function track.UseQuickEventMgr(obj)
	local director = cc.Director:getInstance()
	obj:setTouchEnabled(false) -- 关了引擎的事件
	cc.Node.setTouchEnabled(obj, true) -- 使用quick事件
	obj:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			local uipoint = director:convertToUI(event) -- touch对象的坐标是屏幕坐标
			local touch = obj.m_TmpTouch
			local evt = obj.m_TmpEvent
			if not touch then
				touch = cc.Touch:new()
				evt = cc.EventTouch:new()
				touch:retain()
				evt:retain()
			end
			touch:setTouchInfo(1, uipoint.x, uipoint.y)
			local name = event.name
			if name == "began" then
				local ret = obj:onTouchBegan(touch, evt)
				if ret then
					obj.m_TmpTouch = touch
					obj.m_TmpEvent = evt
				end
				return ret
			elseif name == "moved" then
				obj:onTouchMoved(touch, evt)
			elseif name == "ended" then
				obj:onTouchEnded(touch, evt)
				touch:release()
				evt:release()
				obj.m_TmpTouch = nil
				obj.m_TmpEvent = nil
			elseif name == "canceled" then
				obj:onTouchCancelled(touch, evt)
				touch:release()
				evt:release()
				obj.m_TmpTouch = nil
				obj.m_TmpEvent = nil
			end
		end)
end

-- ccui.EditBox的事件设为由quick管理
function track.UseQuickEventMgrForEditBox(obj)
	obj:setTouchEnabled(false) -- 关了引擎的事件
	cc.Node.setTouchEnabled(obj, true) -- 使用quick事件
	obj:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			local name = event.name
			if name == "began" then
				return true
			elseif name == "ended" then
				obj:touchDownAction(obj, ccui.TouchEventType.ended)
			end
		end)
end

function track.print(...)
	local li = {}
	local args = table.pack(...)
	for i=1, args.n do
		table.insert(li, track.ser(args[i]))
	end
	print(table.concat(li, " "))
end

function track.printf(fmt, ...)
	local li = {}
	local args = table.pack(...)
	for i=1, args.n do
		table.insert(li, track.ser(args[i]))
	end
	print(string.format(fmt, table.unpack(li)))
end

return track