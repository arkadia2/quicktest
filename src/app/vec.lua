
-- 矢量
local CVec = {}
local mt = {
	__index = CVec, 
	__add = function (v1, v2)
		return CVec.new(v1.x+v2.x, v1.y+v2.y)
	end, 
	__sub = function (v1, v2)
		return CVec.new(v1.x-v2.x, v1.y-v2.y)
	end, 

	__mul = function (v, f)
		return CVec.new(v.x*f, v.y*f)
	end, 

	__div = function (v, f)
		return CVec.new(v.x/f, v.y/f)
	end, 

	__unm = function (v) --相反数
		return CVec.new(-v.x, -v.y)
	end,

	__eq = function (v1, v2)
		return v1.x==v2.x and v1.y==v2.y
	end,

	__tostring = function (v)
		return string.format("<x:%s, y:%s, l:%s>", v.x, v.y, v:Length())
	end, 
}
function CVec.new(x,y)
	local v = setmetatable({x=x, y=y}, mt)
	return v
end

function CVec:Add(v)
	self.x = self.x + v.x
	self.y = self.y + v.y
	return self
end

function CVec:AddXY(x,y)
	self.x = self.x+x
	self.y = self.y+y
	return self
end

function CVec:Sub(v)
	self.x = self.x - v.x
	self.y = self.y - v.y
	return self
end

function CVec:SubXY(x,y)
	self.x = self.x-x
	self.y = self.y-y
	return self
end

function CVec:Mul(f)
	self.x = self.x*f
	self.y = self.y*f
	return self
end

function CVec:Div(f)
	self.x = self.x/f
	self.y = self.y/f
	return self
end

function CVec:Length()
	local x = self.x
	local y = self.y
	return math.sqrt(x*x+y*y)
end

function CVec:LengthSq()
	local x = self.x
	local y = self.y
	return x*x+y*y
end

function CVec:Normalize() -- 归一化
	local dis = self:Length()
	if dis == 0 then
		return self
	end
	self.x = self.x/dis
	self.y = self.y/dis
	return self
end

function CVec:Truncate(max) -- 折断
	local len = self:Length()
	local r = len/max
	if r > 1 then
		self.x = self.x/r
		self.y = self.y/r
	end
	return self
end

function CVec:Dot(v)
	return self.x*v.x + self.y*v.y
end

function CVec:SetAngle(angle) -- 弧度
	local len = self:Length()
	self.x = math.cos(angle)*len
	self.y = math.sin(angle)*len
	return self
end

function CVec:GetAngle()
	return math.atan2(self.y, self.x)
end

function CVec:Distance(v)
	local dx = self.x-v.x
	local dy = self.y-v.y
	return math.sqrt(dx*dx+dy*dy)
end

function CVec:Rotate(angle)
	local x, y = self.x, self.y
	local sina = math.sin(angle)
	local cosa = math.cos(angle)
	-- [x*cosA-y*sinA  x*sinA+y*cosA] 
	self.x = x*cosa-y*sina
	self.y = x*sina+y*cosa
end

function CVec:DistanceSq(v)
	local dx = self.x-v.x
	local dy = self.y-v.y
	return dx*dx+dy*dy
end

function CVec:Perp() -- 返回一个垂直向量
	return CVec.new(-self.y, self.x)
end

function CVec:Clone()
	return CVec.new(self.x, self.y)
end

function CVec:Zero()
	self.x = 0
	self.y = 0
end

function CVec:IsZero()
	return self.x^2 + self.y^2 < 0.00001
end

-- 非成员函数
function CVec.VecNormalize(v)
	local v = v:Clone()
	v:Normalize()
	return v
end

function CVec.VecDistance(v1, v2)
	return math.sqrt((v2.x-v1.x)^2 + (v2.y-v1.y)^2)
end

function CVec.VecDistanceSq(v1, v2)
	return (v2.x-v1.x)^2 + (v2.y-v1.y)^2
end

function CVec.VecRotate(v, angle)
	local v = v:Clone()
	v:Rotate(angle)
	return v
end

return CVec
