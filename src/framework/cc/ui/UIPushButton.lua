
--[[

Copyright (c) 2011-2014 chukong-inc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

--------------------------------
-- @module UIPushButton

--[[--

quick 按钮控件

]]

local UIButton = import(".UIButton")
local UIPushButton = class("UIPushButton", UIButton)

UIPushButton.NORMAL   = "normal"
UIPushButton.PRESSED  = "pressed"
UIPushButton.DISABLED = "disabled"
UIPushButton.CHOOSED = "choosed"  -- CHOOSE状态

-- start --

--------------------------------
-- 按钮控件构建函数
-- @function [parent=#UIPushButton] ctor
-- @param table images 各种状态的图片
-- @param table options 参数表 其中scale9为是否缩放

--[[--

按钮控件构建函数

状态值:
-   normal 正常状态
-   pressed 按下状态
-   disabled 无效状态
-   choosed 选中状态

]]
-- end --

function UIPushButton:ctor(images, options)
    UIPushButton.super.ctor(self, {
        {name = "disable", from = {"normal", "pressed"}, to = "disabled"},
        {name = "enable",  from = {"disabled"}, to = "normal"},
        {name = "press",   from = {"normal"},  to = "pressed"},
        {name = "press",   from = {"choosed"},  to = "choosed"},
        {name = "release", from = "pressed", to = "normal"},
        {name = "release", from = "choosed", to = "choosed"},
        {name = "choose", from = {"normal", "pressed", "choosed"}, to = "choosed"},
        {name = "unchoose", from = {"normal", "choosed"}, to = "normal"},
    }, "normal", options)
    if type(images) ~= "table" then images = {normal = images} end
    self:setButtonImage(UIPushButton.NORMAL, images["normal"], true)
    self:setButtonImage(UIPushButton.PRESSED, images["pressed"], true)
    self:setButtonImage(UIPushButton.DISABLED, images["disabled"], true)
    self:setButtonImage(UIPushButton.CHOOSED, images["pressed"], true)
    if options ~= nil and options.tag ~= nil then
        self.m_OnMessage = true
        self.m_MessageId = options.tag
    end
    self.m_HaveChooseStatus = false

    self.args = {images, options}
end

function UIPushButton:setButtonImage(state, image, ignoreEmpty)
    assert(state == UIPushButton.NORMAL
        or state == UIPushButton.PRESSED
        or state == UIPushButton.DISABLED
        or state == UIPushButton.CHOOSED,
        string.format("UIPushButton:setButtonImage() - invalid state %s", tostring(state)))
    UIPushButton.super.setButtonImage(self, state, image, ignoreEmpty)

    if state == UIPushButton.NORMAL then
        if not self.images_[UIPushButton.PRESSED] then
            self.images_[UIPushButton.PRESSED] = image
        end
        if not self.images_[UIPushButton.DISABLED] then
            self.images_[UIPushButton.DISABLED] = image
        end
        if not self.images_[UIPushButton.CHOOSED] then
            self.images_[UIPushButton.CHOOSED] = image
        end
    end

    return self
end

function UIPushButton:OnMessageDispose()
    self.m_OnMessage = false
end

-- 设置选则状态，选中后图片默认为按下状态的图片
function UIPushButton:SetChooseImages(images)
    self.m_HaveChooseStatus = true
    if images ~= nil then
        self:setButtonImage(UIPushButton.CHOOSED, images, true)
    else
        self:setButtonImage(UIPushButton.CHOOSED, self.images_[UIPushButton.PRESSED], true)
    end
end

function UIPushButton:SetUnchooseStatus()
    if self.fsm_:canDoEvent("unchoose") then
        self.fsm_:doEvent("unchoose")
    end
end

function UIPushButton:GetSelected()
    if self.m_Selected == nil then
        return false
    end

    return self.m_Selected
end

function UIPushButton:SetSelect(bSelected)
    self.m_Selected = bSelected

    if bSelected == true then
        if self.fsm_:canDoEvent("choose") then
            self.fsm_:doEvent("choose")
        end
    else
        if self.fsm_:canDoEvent("unchoose") then
            self.fsm_:doEvent("unchoose")
        end
    end
end

function UIPushButton:SetText(sText, font, size, color, align)
    local label = self:getButtonLabel("normal")
    if label then 
        label:setString(sText)
        return         
    end    
    label = display.newTTFLabel({text = sText,
        font = font or display.DEFAULT_TTF_FONT,
        size = size or 18,
        color = color or cc.c3b(255, 255, 255),
        align = align or cc.TEXT_ALIGNMENT_CENTER,
    })
    self:setButtonLabel("normal", label)
end 

function UIPushButton:SetMessageId(msgid)
    self.m_OnMessage = true
    self.m_MessageId = msgid
end

function UIPushButton:onTouch_(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
        self.touchBeganX = x
        self.touchBeganY = y
        if not self:checkTouchInSprite_(x, y) then return false end
        self.fsm_:doEvent("press")
        self:dispatchEvent({name = UIButton.PRESSED_EVENT, x = x, y = y, touchInTarget = true})
        return true
    end

    -- must the begin point and current point in Button Sprite
    local touchInTarget = self:checkTouchInSprite_(self.touchBeganX, self.touchBeganY)
                        and self:checkTouchInSprite_(x, y)
    if name == "moved" then
        if touchInTarget and self.fsm_:canDoEvent("press") then
            self.fsm_:doEvent("press")
            self:dispatchEvent({name = UIButton.PRESSED_EVENT, x = x, y = y, touchInTarget = true})
        elseif not touchInTarget and self.fsm_:canDoEvent("release") then
            self.fsm_:doEvent("release")
            self:dispatchEvent({name = UIButton.RELEASE_EVENT, x = x, y = y, touchInTarget = false})
        end
    else
        if self.m_HaveChooseStatus == true then
            if self.fsm_:canDoEvent("choose") then
                self.fsm_:doEvent("choose")
                self:dispatchEvent({name = UIButton.RELEASE_EVENT, x = x, y = y, touchInTarget = touchInTarget})
            end
        else
            if self.fsm_:canDoEvent("release") then
                self.fsm_:doEvent("release")
                self:dispatchEvent({name = UIButton.RELEASE_EVENT, x = x, y = y, touchInTarget = touchInTarget})
            end
        end
        if name == "ended" and touchInTarget then
            self:dispatchEvent({name = UIButton.CLICKED_EVENT, x = x, y = y, touchInTarget = true})
            if self.m_OnMessage == true then
                local parent = self:getParent()
                while parent ~= nil do
                    if parent.OnMessage ~= nil then
                        parent:OnMessage(self.m_MessageId)
                        return
                    end
                    parent = parent:getParent()
                end
            end
        end
    end
end

function UIPushButton:createCloneInstance_()
    return UIPushButton.new(unpack(self.args_))
end

return UIPushButton
