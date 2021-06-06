

local track = require("track")
local gemo = require("gemo")
local vec = require("vec")

local BlockW = 10
local BlockH = 10
local MaxCol = math.floor(display.width/BlockW) + 1
local MaxRow = math.floor(display.width/BlockH) + 1
local MaxX = MaxCol*BlockW
local MaxY = MaxRow*BlockH
local ViewR = 20

local HalfW = BlockW/2
local HalfH = BlockH/2

-- CR->XY
local function CalXYByCR(c, r)
	local cw, ch, hw, hh = BlockW, BlockH, BlockW/2, BlockH/2
	local x = (c-1)*cw+hw -- 取中点
	local y = (r-1)*ch+hh
	return x,y
end

-- XY->CR
local function CalCRByXY(x, y)
	local cw, ch = BlockW, BlockH
	local c = math.floor(x/cw)+1
	local r = math.floor(y/ch)+1
	return c,r
end

-- Pos->CR
local function CalPosByCR(c, r)
	return c*10000+r
end

-- CR->Pos
local function CalCRByPos(pos)
	return math.floor(pos/10000), pos%10000
end


local ViewCRList = {}
local function InitViewCRList()
  local c, r = 0, 0 
  local x, y = CalXYByCR(c, r)
  local hc = math.floor(ViewR/HalfW)
  local hr = math.floor(ViewR/HalfH)
  local left, bottom = c-hc, r-hr
  local right, top = c+hc, r+hr
  local r_sq = ViewR^2
  for cc=left, right do
    for rr=bottom, top do
      local xx, yy = CalXYByCR(cc, rr)
      if (xx-x)^2 + (yy-y)^2 <= r_sq then
        table.insert(ViewCRList, {cc, rr})
      end
    end
  end
end
InitViewCRList()
local ViewPosList = {}
local function GetViewPosList(c, r)
  ViewPosList[1] = nil
  for i, d in ipairs(ViewCRList) do
    ViewPosList[i] = CalPosByCR(d[1]+c, d[2]+r)
  end
  ViewPosList[#ViewPosList+1] = nil
  return ViewPosList
end

---@class Block
local Block = class("Block")
function Block:ctor(pos)
  self.pos = pos
end

---@class PathPoint
local PathPoint = class("PathPoint")
function PathPoint:ctor(pos)
  self.pos = pos
end

---@class MiniMap
local MiniMap = class("MiniMap", function ()
  return display.newNode()
end)
function MiniMap:ctor(parent)
  self:addTo(parent)
  self:setContentSize(display.size)
	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.OnTouch))
  self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.OnTick))
	self:scheduleUpdate()
	self:setKeypadEnabled(true)
	self:addNodeEventListener(cc.KEYPAD_EVENT, handler(self, self.OnKey))
  ---@type table<number, Block>
  self.blocks = {}
  ---@type table<number, PathPoint[]>
  self.paths = {}
  self:InitBlocks()
  self.Col = 0
  self.Row = 0
  self.view_blocks = {}
  self.walk_blocks = {}
  self:GMDrawLines()
  self.pos_node = track.point(self, {x=0, y=0}, "")
  local size = self.pos_node:getContentSize()
  self.pos_node.view_node = track.circle(self.pos_node, {x=size.width/2, y=size.height/2}, ViewR)
  self.need_draw = false
end

function MiniMap:InitBlocks()
  for c=1, MaxCol do
    for r=1, MaxRow do
      local pos = CalPosByCR(c, r)
      local block = Block.new(pos)
      self.blocks[pos] = block
    end
  end
end

function MiniMap:Start()
  -- self:TransTo(MaxX/2, MaxY/2)
  -- local c, r = 15, 15
  -- local x, y = CalXYByCR(c, r)
  -- self:TransTo(x, y)

end

function MiniMap:Save()
end

function MiniMap:Load()
end

function MiniMap:TransTo(x, y)
  self.LastPath = nil
  self:MoveTo(x, y)
end

function MiniMap:MoveTo(x, y)
  self.pos_node:setPosition(x, y)
  local c, r = CalCRByXY(x, y)
  if c == self.Col and r == self.Row then
    return
  end
  local sx, sy = CalXYByCR(self.Col, self.Row)
  local sc, sr = self.Col, self.Row
  self.Col, self.Row = c, r
  local ex, ey = CalXYByCR(c, r)
  if not self.LastPath then
    self:OnWalk(c, r)
    self.need_draw = true
  else
    gemo.WalkGrid(sx, sy, ex, ey, BlockW, BlockH, function (c, r)
      if c+1 == sc and r+1 == sr then
        return
      end
      self:OnWalk(c+1, r+1)
    end)
    for _, path in ipairs(self.paths) do
      self:MergePath(path)
    end
    self.need_draw = true
  end
end

function MiniMap:OnWalk(c, r)
  self.walk_blocks[CalPosByCR(c, r)] = 1
  local view_list = GetViewPosList(c, r)
  local all_in = true
  for _, pos in ipairs(view_list) do
    if not self.view_blocks[pos] then
      all_in = false
      self.view_blocks[pos] = 1
    end
  end
  if all_in then
    self.LastPath = nil
    return
  end
  local pos = CalPosByCR(c, r)
  local point = PathPoint.new(pos)
  if not self.LastPath then
    self.LastPath = {point}
    table.insert(self.paths, self.LastPath)
  else
    local len = #self.LastPath
    assert(len > 0)
    table.insert(self.LastPath, point)
  end
  -- print(">> move to", c, r, #self.LastPath)
end

function MiniMap:MergePath(path)
  if not path then
    return
  end
  local st = self:GetMargetStart(path)
  print(">> st", st)
  for i=st, 1000000 do
    local p1 = path[i]
    local p2 = path[#path]
    if not p1 or not p2 then
      return
    end
    local c1, r1 = CalCRByPos(p1.pos)
    local c2, r2 = CalCRByPos(p2.pos)
    local sx, sy = CalXYByCR(c1, r1)
    local ex, ey = CalXYByCR(c2, r2)
    local all_in = true
    gemo.WalkGrid(sx, sy, ex, ey, BlockW, BlockH, function (c, r)
      local wp = CalPosByCR(c+1, r+1)
      if not self.walk_blocks[wp] then
        all_in = false
        return false
      end
    end)
    if all_in then
      path[i+1] = p2
      for j=i+2, #path do
        path[j] = nil
      end
      return
    end
  end
end

function MiniMap:GetMargetStart(path)
  local len = #path
  local p1 = path[len-1]
  local p2 = path[len-2]
  if not p1 or not p2 then
    return 1
  end
  local c1, r1 = CalCRByPos(p1.pos)
  local c2, r2 = CalCRByPos(p2.pos)
  local v1 = vec.new(c2-c1, r2-r1)
  local st = len-2
  for i=1, 1000000 do
    local p = path[st-1]
    if not p then
      break
    end
    local c, r = CalCRByPos(p.pos)
    local c2, r2 = CalCRByPos(p2.pos)
    local v2 = vec.new(c-c2, r-r2)
    if v2:Dot(v1) < 0 then
      break
    end
    p2 = p
    st = st-1
  end
  return st
end

function MiniMap:GMDrawLines()
	if self.m_LineNode then
		self.m_LineNode:removeSelf()
	end
	local drawnode = cc.DrawNode:create()
	self:add(drawnode, -99)
	self.m_LineNode = drawnode
	local hw, hh = HalfW, HalfH
	local color = cc.c4f(0.5, 0.5, 0.5, 0.5)
	local color2 = cc.c4f(0, 0.5, 0, 1)
	for c=1, MaxCol do
		local sx, sy = CalXYByCR(c, 1)
		sx, sy = sx-hw, sy-hh
		local ex, ey = CalXYByCR(c, MaxRow)
		ex, ey = ex-hw, ey-hh
		local thec = color
		if (c-1)%10 == 0 then
			thec = color2
		end
		drawnode:drawLine(cc.p(sx, sy), cc.p(ex, ey), thec)
	end
	for r=1, MaxRow do
		local sx, sy = CalXYByCR(1, r)
		sx, sy = sx-hw, sy-hh
		local ex, ey = CalXYByCR(MaxCol, r)
		ex, ey = ex-hw, ey-hh
		local thec = color
		if (r-1)%10 == 0 then
			thec = color2
		end
		drawnode:drawLine(cc.p(sx, sy), cc.p(ex, ey), thec)
	end
end

function MiniMap:GMDraw()
  self:GMDrawBlocks()
  self:GMDrawWalkBlocks()
  self:GMDrawPaths()
end

function MiniMap:GMDrawBlocks()
	local cw, ch = HalfW, HalfH
	local color = cc.c4f(1, 0, 0, 0.4)
	if self.m_BlockNode then
		self.m_BlockNode:removeSelf()
	end
	local drawnode = cc.DrawNode:create()
	drawnode:addTo(self, -98)
	self.m_BlockNode = drawnode
  for pos, _ in pairs(self.view_blocks) do
    local c, r = CalCRByPos(pos)
    local x, y = CalXYByCR(c, r)
    drawnode:drawSolidRect(cc.p(x-cw, y-ch), cc.p(x+cw, y+ch), color)
  end
end

function MiniMap:GMDrawWalkBlocks()
	local cw, ch = HalfW, HalfH
	local color = cc.c4f(0, 1, 1, 0.4)
	if self.m_WalkNode then
		self.m_WalkNode:removeSelf()
	end
	local drawnode = cc.DrawNode:create()
	drawnode:addTo(self, -97)
	self.m_WalkNode = drawnode
  for pos, _ in pairs(self.walk_blocks) do
    local c, r = CalCRByPos(pos)
    local x, y = CalXYByCR(c, r)
    drawnode:drawSolidRect(cc.p(x-cw, y-ch), cc.p(x+cw, y+ch), color)
  end
end

function MiniMap:GMDrawPaths()
  if self.m_PathNode then
    self.m_PathNode:removeSelf()
  end
  local drawnode = cc.DrawNode:create()
	drawnode:addTo(self, -96)
	self.m_PathNode = drawnode
  local color = cc.c4f(1, 1, 1, 1)
  for _, path in ipairs(self.paths) do
    for i, p in ipairs(path) do
      local c, r = CalCRByPos(p.pos)
      local x, y = CalXYByCR(c, r)
      drawnode:drawCircle(cc.p(x, y), 5, 0, 50, true, color)
      local pre_p = path[i-1]
      if pre_p then
        local pc, pr = CalCRByPos(pre_p.pos)
        local px, py = CalXYByCR(pc, pr)
        drawnode:drawLine(cc.p(px,py),cc.p(x,y),color)
      end
    end
  end
end

function MiniMap:OnTouch(event)
	if event.name == "began" then
    self:TransTo(event.x, event.y)
		return true
	elseif event.name == "moved" then
    self:MoveTo(event.x, event.y)
	elseif event.name == "ended" then
		-- self:OnClick(event)
	end
end

function MiniMap:OnClick(wp)
	local x, y = wp.x, wp.y
	local c, r = CalCRByXY(x, y)
	print(string.format(">> x,y(%.2f, %.2f) c,r(%d, %d)", x, y, c, r))
  self:MoveTo(x, y)
  -- self:TransTo(x, y)
end

function MiniMap:OnKey(event)
	local code = event.code
  print(">> onkey", code)
	if code == track.VK_UP or code == track.VK_DOWN then
	-- elseif code == track.VK_LEFT or code == track.VK_RIGHT then
	-- elseif code == track.VK_SPACE then -- 空格暂停，n下一帧
	-- elseif code == track.VK_N then
	-- elseif code == track.VK_W then -- 编辑墙
	-- elseif code == track.VK_B then -- 阻档
	-- elseif code == track.VK_C then
	-- elseif code == track.VK_ESC then
	elseif code == track.VK_R then -- reset
    self.view_blocks = {}
    self.walk_blocks = {}
    self.paths = {}
    self.need_draw = true
    -- local w, h = 1024, 1024
    -- local r = 20
    -- local s = 1024/(2*20)
    -- s = s*s
    -- s = s+s/4
    -- local m = s/1024
    -- print(string.format(">> p:%s size %.2fKB", s, m))
	end
end

function MiniMap:OnTick(dt)
  if not self.need_draw then
    return
  end
  self.need_draw = false
  self:GMDraw()
end


return MiniMap



