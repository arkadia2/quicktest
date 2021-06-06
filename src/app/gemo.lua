
-- 几何计算
local mod = {}
local math_abs = math.abs
local math_modf = math.modf
local math_sqrt = math.sqrt
local math_floor = math.floor
local math_ceil = math.ceil
local table_insert = table.insert

-- 点x,y是否在矩形x1,y1,x2,y2内
local function IsPointInRect(x, y, x1, y1, x2, y2)
	if x < x1 or x > x2 or y < y1 or y > y2 then
		return false
	end
	return true
end
mod.IsPointInRect = IsPointInRect

-- 点x,y是否在圆cx,cy,半径平方rSq内
local function IsPointInCircle(x, y, cx, cy, rSq)
	local d = (x-cx)^2+(y-cy)^2
	return d <= rSq
end
mod.IsPointInCircle = IsPointInCircle

-- 点x,y是否在菱形cx,cy,宽高为w,h内
local function IsPointInRhombus(x, y, cx, cy, w, h)
	local lx, ly = x-cx, y-cy
	return math_abs(lx*h)+math_abs(ly*w) <= w*h/2
end
mod.IsPointInRhombus = IsPointInRhombus

-- 由两点x1,y1->x2,y2求直线方程一般式ax+by+c=0
local function GetLineABC(x1, y1, x2, y2)
	local a = y1-y2
	local b = x2-x1
	local c = x1*y2-x2*y1
	return a, b, c
end
mod.GetLineABC = GetLineABC

-- 由两点x1,y1->x2,y2求直线点斜式y=kx+b, 要保证x1~=x2
local function GetLineKB(x1, y1, x2, y2)
	local dx = x2-x1
	local k = (y2-y1)/dx
	local b = (x2*y1-x1*y2)/dx
	return k, b
end
mod.GetLineKB = GetLineKB

-- 求两直线a1,b1,c1->a2,b2,c2的交点
local function GetLineIntersetPoint(a1, b1, c1, a2, b2, c2)
	local d = a1*b2-a2*b1
	if d == 0 then -- 两直线平行
		return
	end
	local x = (b1*c2-b2*c1)/d
	local y = (a2*c1-a1*c2)/d
	return x, y
end
mod.GetLineIntersetPoint = GetLineIntersetPoint

-- 求点(x3,y3)到直线(x1,y1)->(x2,y2)的交点
function mod.GetNearestP2Line(x1, y1, x2, y2, x3, y3)
	local a1, b1, c1 = GetLineABC(x1, y1, x2, y2)
	local dx = x2-x1
	local dy = y2-y1
	local a2, b2, c2 = dx, dy, -dx*x3-dy*y3
	return GetLineIntersetPoint(a1, b1, c1, a2, b2, c2)
end

-- function mod.GetNearestP2Line(x1, y1, x2, y2, x3, y3)
-- 	local dx = x2-x1
-- 	local dy = y2-y1
-- 	local len, x, y
-- 	if dx == 0 then -- 垂直
-- 		x = x1
-- 		y = y3
-- 	elseif dy == 0 then -- 水平
-- 		x = x3
-- 		y = y1
-- 	else -- 解方程得
-- 		-- 1式,直线方程两点式: (y-y1)/(y2-y1) = (x-x1)/(x2-x1)
-- 		-- 2式,向量点程为0: (x2-x1)(x-x3)+(y2-y1)(y-y3) = 0
-- 		local t1 = dy*dy/dx
-- 		x = (y3*dy-y1*dy+x1*t1+dx*x3)/(dx+t1)
-- 		local t2 = dx*dx/dy
-- 		y = (x3*dx-x1*dx+y1*t2+dy*y3)/(dy+t2)
-- 	end
-- 	return x, y
-- end

-- 求点(x3,y3)到线段(x1,y1)->(x2,y2)的交点
function mod.GetNearestP2Segment(x1, y1, x2, y2, x3, y3)
	local ax, ay = x2-x1, y2-y1 -- a向量
	local bx, by = x3-x1, y3-y1 -- b向量
	local val = ax*bx+ay*by -- 点积
	if val < 0 then -- 在线段左边
		return x1, y1
	end
	ax, ay = -ax, -ay
	bx, by = x3-x2, y3-y2
	local val = ax*bx+ay*by
	if val < 0 then -- 在线段右边
		return x2, y2
	end
	-- 在线段中间
	return mod.GetNearestP2Line(x1, y1, x2, y2, x3, y3)
end

-- 两线段x1,y1->x2,y2和_x1,_y1->_x2,_y2的交点
function mod.GetSegmentIntersetPoint(x1, y1, x2, y2, _x1, _y1, _x2, _y2)
	local x, y = GetLineIntersetPoint(x1, y1, x2, y2, _x1, _y1, _x2, _y2)
	if not x then
		return
	end
	local minx, maxx = x1, x2
	if x1 > x2 then
		minx, maxx = x2, x1
	end
	local _minx, _maxx = _x1, _x2
	if _x1 > _x2 then
		_minx, _maxx = _x2, _x1
	end
	if x > minx or x < maxx or x >_minx or x < _maxx then -- 不在线段上
		return
	end
	return x, y
end


-- 圆x1,y1,r1与圆x2,y2,r2是否相交
function mod.IsCircleInterset(x1, y1, r1, x2, y2, r2)
	local ax, ay = x2-x1, y2-y1 -- 圆心向量
	return ax^2+ay^2 <= (r1+r2)^2
end

-- 矩形x1,y1,x2,y2与矩形_x1,_y1,_x2,_y2是否相交
function mod.IsRectInterset(x1,y1,x2,y2, _x1,_y1,_x2,_y2)
	if _x1>x2 or _x2<x1 or _y1>y2 or _y2<y1 then
		return false
	end
	return true
end

-- 圆x,y,r与矩形(中心点cx, cy, w1,h1为半宽和半高)是否相交,矩形不支持旋转
-- 参考:http://blog.csdn.net/zaffix/article/details/25077835
function mod.IsCircleRectInterset(x, y, r, cx, cy, w1, h1)
	local w2 = math_abs(x-cx)
	local h2 = math_abs(y-cy)

	if w2 > w1 + r then
		return false
	end
	if h2 > h1 + r then
		return false
	end

	if w2 <= w1 then
		return true
	end
	if h2 <= h1 then
		return true
	end

	return (w2 - w1)^2 + (h2 - h1)^2 <= r^2
end

-- 圆与旋转矩形是否相交

-- 圆x,y,r与菱形cx,cy,w,h是否相交
function mod.IsCircleRhombusInterset(x, y, r, cx, cy, w, h)
	if IsPointInRhombus(x, y, cx, cy, w, h) then -- 圆心在菱形内
		return true
	end
	local hw, hh = w/2, h/2
	local q -- 圆在以菱形中心为原点的坐标系中的哪个象限
	if x >= cx then
		q = x >= cy and 1 or 4
	else
		q = y >= cy and 2 or 3
	end
	-- 由象限确定菱形的一条边
	local x1, y1, x2, y2
	if q == 1 then
		x1, y1, x2, y2 = hw, 0, 0, hh 
	elseif q == 2 then
		x1, y1, x2, y2 = 0, hh, -hw, 0
	elseif q == 3 then
		x1, y1, x2, y2 = -hw, 0, 0, -hh
	else -- q == 4
		x1, y1, x2, y2 = 0, -hh, hw, 0
	end
	x1, y1, x2, y2 = cx+x1, cy+y1, cx+x2, cy+y2
	local tx, ty = mod.GetNearestP2Segment(x1, y1, x2, y2, x, y) -- 圆心到边的交点
	local dSq = (tx-x)^2+(ty-y)^2
	if dSq <= r*r then
		return true
	end
	return false
end

-- 矩形x1,y1,x2,y2与菱形cx,cy,w,h是否相交
function mod.IsRectRhombusInterset(x1, y1, x2, y2, cx, cy, w, h)
	for _, x in ipairs({x1,x2}) do
		for _, y in ipairs({y1,y2}) do
			if IsPointInRhombus(x, y, cx, cy, w, h) then
				return true
			end
		end
	end
	return false
end


-- 直线(sx,sy)->(ex,ey)到矩形x1,y1,x2,y2的交点
function mod.CalLineRectPoints(sx, sy, ex, ey, x1, y1, x2, y2)
	local li = {}
	local dx = sx-ex
	if dx == 0 then -- 垂直于x轴
		local x = sx -- ex也可以一样的
		if x>=x1 and x<=x2 then
			table_insert(li, {x, y1})
			table_insert(li, {x, y2})
		end
	else
		local k = (sy-ey)/dx
		local b = (sx*ey-ex*sy)/dx
		-- (y=y1 or y=y2) and x1<=x<=x2
		for _, y in ipairs({y1, y2}) do
			local x = math_modf((y-b)/k)
			if x <= x2 and x >= x1 then
				table_insert(li, {x, y})
			end
		end
		-- (x=x1 or x=x2) and y1<=y<=y2
		for _, x in ipairs({x1, x2}) do
			local y = math_modf(k*x+b)
			if y<=y2 and y>=y1 then
				table_insert(li, {x, y})
			end
		end
	end
	return li
end

-- 直线(sx,sy)->(ex,ey)到圆cx,cy,r的交点
function mod.CalLineCirclePoints(sx, sy, ex, ey, cx, cy, r)
	local li = {}
	local dx = sx-ex
	if dx == 0 then -- 垂直于x轴
		local val = r^2-(sx-cx)^2
		if val > 0 then
			local v = math_sqrt(val)
			table_insert(li, {sx, v+cy})
			table_insert(li, {sx, -v+cy})
		elseif val == 0 then -- 相切
			table_insert(li, {sx, cy})
		end
	else
		local k = (sy-ey)/dx
		local z = (sx*ey-ex*sy)/dx
		-- y = kx+z
		-- (x-cx)^2+(y-cy)^2=r^2
		-- 化简到一元二次方程
		-- ax^2+bx+c = 0
		-- 再由公式法求解
		local a = 1+k^2
		local b = 2*k*(z-cy)-2*cx
		local c = (z-cy)^2-r^2+cx^2
		local delta = b^2-4*a*c
		if delta > 0 then
			local v = math_sqrt(delta)
			local x1 = ((-b)+v)/(2*a)
			local y1 = k*x1+z
			local x2 = ((-b)-v)/(2*a)
			local y2 = k*x2+z
			table_insert(li, {x1, y1})
			table_insert(li, {x2, y2})
		elseif delta == 0 then
			local x = (-b)/(2*a)
			local y = k*x+z
			table_insert(li, {x, y})
		end
	end
	return li
end

-- 计算点x,y与城墙x1,y1,x2,y2的交点
function mod.CalWallRectPoint(x, y, x1, y1, x2, y2)
	local tx = x
	if tx > x2 then tx = x2 end
	if tx < x1 then tx = x1 end
	local ty = y
	if ty > y2 then ty = y2 end
	if ty < y1 then ty = y1 end
	return tx, ty
end


-- 画直线算法
-- local gemo = require("logic.war.gemo")
-- local x1, y1, x2, y2 = 100,100,200,200
-- -- add
-- local points = {}
-- local function add(x, y)
-- 	table.insert(points, {x=x, y=y})
-- end
-- gemo.Bresenham(x1, y1, x2, y2, add)
-- -- check
-- local function check(x, y)
-- 	if valid(x, y) then -- check here
-- 		return true
-- 	end
-- 	return false
-- end
-- if gemo.Bresenham(x1, y1, x2, y2, check) then
-- 	print("valid")
-- end

function mod.Bresenham(x1, y1, x2, y2, func, ...)
	-- local points = {}
	local dx = x2 - x1
	local dy = y2 - y1
	local ux = dx > 0 and 1 or -1 -- x的增量方向，取1或-1
	local uy = dy > 0 and 1 or -1 -- y的增量方向，取1或-1
	local x = x1
	local y = y1
	local eps = 0 			-- eps为累加误差

	dx = math_abs(dx)
	dy = math_abs(dy)
	if dx > dy then
		while x ~= x2 do
			-- table.insert(points, {x=x,y=y})
			if func(x, y, ...) == false then
				return false
			end
			eps = eps + dy
			if eps * 2 >= dx then
				y = y + uy
				eps = eps - dx
			end

			x = x + ux
		end
	else
		while y ~= y2 do
			-- table.insert(points, {x=x,y=y})
			if func(x, y, ...) == false then
				return false
			end
			eps = eps + dx
			if eps*2 >= dy then
				x = x + ux
				eps = eps - dy
			end

			y = y + uy
		end
	end

	-- table.insert(points, {x=x2, y=y2})
	-- return points
	if func(x2, y2, ...) == false then
		return false
	end
	return true
end

-- 遍历直线sx,sy->ex,ey经过的网格
function mod.WalkGrid(sx, sy, ex, ey, w, h, func, ...)
	-- local li = {}
	local dx = ex-sx
	local dy = ey-sy
	if dx == 0 then -- 垂直于x轴,k为无穷大
		local c = math_floor(sx/w)
		local r1 = math_floor(sy/h)
		local r2 = math_floor(ey/h)
		local add = r1>r2 and -1 or 1
		for r=r1,r2,add do
			-- table_insert(li, {c, r})
			if func(c, r, ...) == false then
				return false
			end
		end
	elseif dy == 0 then -- 水平
		local r = math_floor(sy/h)
		local c1 = math.floor(sx/w)
		local c2 = math.floor(ex/w)
		local add = c1>c2 and -1 or 1
		for c=c1,c2,add do
			-- table_insert(li, {c, r})
			if func(c, r, ...) == false then
				return false
			end
		end
	else
		-- y = kx+b
		local k = (ey-sy)/dx
		local b = (ex*sy-sx*ey)/dx
		local c = math_floor(sx/w)
		local r1 = math_floor(sy/h)
		local q -- 在哪个象限
		if ex >= sx then
			q = ey >= sy and 1 or 4
		else
			q = ey >= sy and 2 or 3
		end
		local x, eq, add, ax
		if q == 1 then
			x = c*w+w
			eq = 1 -- y > ey
			add = 1
			ax = 1
		elseif q == 2 then
			x = c*w
			eq = 1 -- y > ey
			add = 1
			ax = -1
		elseif q == 3 then
			x = c*w
			eq = -1 -- y < ey
			add = -1
			ax = -1
		elseif q == 4 then
			x = c*w+w
			eq = -1 -- y < ey
			add = -1
			ax = 1
		end
		local cnt = 0
		local isend = false
		while true do
			cnt = cnt+1
			if cnt > 1000 then
				error(string.format("WalkGrid loop too big!! %s,%s,%s,%s,%s,%s", 
					sx, sy, ex, ey, w, h))
			end
			local y = k*x+b
			if (y-ey)*eq > 0 then
				y = ey
				isend = true
			end
			local r2 = math_floor(y/h)
			for r=r1, r2, add do
				-- table_insert(li, {c, r})
				if func(c, r, ...) == false then
					return false
				end
			end
			if isend then
				break
			else
				c = c+ax
				r1 = r2
				x = x+ax*w
			end
		end
	end
	-- return li
	return true
end


return mod



