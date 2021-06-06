
-- 此模块暂时还无法使用，需完善
local UIScaleButton = class("UIScaleButton", function()
	return display.newNode() end)

function UIScaleButton:ctor(image, msgid)
	self.m_sprite_ = interface.CButton.new(image,self,msgid)
end

function UIScaleButton:SetMessageId(msgid)
	self.m_sprite_:SetMessageId(msgid)
end

function UIScaleButton:setButtonLabel(label)
	if label == nil then
		return
	end

	self.m_sprite_:add(label,1)
	local size = self.m_sprite_:getContentSize()
	local w = label:getContentSize().width
	label:setPosition((size.width-w)/2,size.height/2)
end

function UIScaleButton:setButtonSize()

end

return UIScaleButton