
local UIProcessBar = class("UIProcessBar", function(params)
	local progress = cc.ProgressTimer:create(display.newSprite(params.image))
    progress:setType(display.PROGRESS_TIMER_BAR)
    return progress
end)

UIProcessBar.DIRECTION_LEFT_TO_RIGHT = 0
UIProcessBar.DIRECTION_RIGHT_TO_LEFT = 1

function UIProcessBar:ctor(params)
	self.args_ = {params}

	self:setDirction(params.direction or UIProcessBar.DIRECTION_LEFT_TO_RIGHT)
	self:setPercentage(params.percent)
end

function UIProcessBar:setContentSize(w,h)
	local size = self:getContentSize()
	self:setScaleX(w/size.width)
	self:setScaleY(h/size.height)
end

-- 血条根据血量设置进度条资源的接口
function UIProcessBar:SetHPBarPercentage(iPercentage, iHpFrameType)
	local frameName = resget.GetHpFrame(iPercentage, iHpFrameType)
	if self.m_SpriteframeName == nil or self.m_SpriteframeName ~= frameName then
		self:getSprite():setSpriteFrame(frameName)
		self.m_SpriteframeName = frameName
	end

	self:setPercentage(iPercentage)
end

function UIProcessBar:SetSpriteFrame(frameName)
    if frameName then 
        self:getSprite():setSpriteFrame(frameName)
    end 
end

function UIProcessBar:setDirction(dir)
	self.direction_ = dir
	if dir == UIProcessBar.DIRECTION_LEFT_TO_RIGHT then
		self:setMidpoint(cc.p(0,0))
		self:setBarChangeRate(cc.p(1.0, 0))
	else
		self:setMidpoint(cc.p(1,0))
		self:setBarChangeRate(cc.p(0, 0))
	end
end

function UIProcessBar:createCloneInstance_()
    return UIProcessBar.new(unpack(self.args_))
end

function UIProcessBar:copyProperties_(node)
	self:setVisible(node:isVisible())
    self:setTouchEnabled(node:isTouchEnabled())
    self:setLocalZOrder(node:getLocalZOrder())
    self:setTag(node:getTag())
    self:setName(node:getName())
    self:setContentSize(node:getContentSize().width, node:getContentSize().height)
    self:setPosition(node:getPosition())
    self:setAnchorPoint(node:getAnchorPoint())
    self:setScaleX(node:getScaleX())
    self:setScaleY(node:getScaleY())
    self:setRotation(node:getRotation())
    self:setRotationSkewX(node:getRotationSkewX())
    self:setRotationSkewY(node:getRotationSkewY())
    if self.isFlippedX and node.isFlippedX then
        self:setFlippedX(node:isFlippedX())
        self:setFlippedY(node:isFlippedY())
    end
    self:setColor(node:getColor())
    self:setOpacity(node:getOpacity())
    self:setDirction(node.direction_)
    
    self:copySpecialProperties_(node)
end

return UIProcessBar