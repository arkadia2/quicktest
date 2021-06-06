
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
-- @module uiloader

--[[--

初始化 cc.uiloader,并提供对外统一接口

cc.uiloader 可以将CCS导出的json文件用quick的纯lua控件构建出UI布局

]]

local UILoaderUtilitys = import(".UILoaderUtilitys")
local uiloader = class("uiloader")
local CCSUILoader = import(".CCSUILoader")
local CCSSceneLoader = import(".CCSSceneLoader")

-- start --

--------------------------------
-- 初始化 cc.uiloader,并提供对外统一接口
-- @function [parent=#uiloader] new

-- end --

-- 在h方向设一个可变偏移值
local Z_ORDER = 1
local jsonData = {}  -- json的缓存文件
function uiloader:ctor(parent)
	print("加载界面 --> ",self.uiname)
	if self.uiname ~= nil then
		self:load(self.uiname)
	end
	self.m_Zorder = 0
	self.m_MainPanel = self:GetObject("mainpanel")
	if self.m_MainPanel == nil then
		return
	else
		parent = parent or GlobalVars.UIPanel
		parent:add(self.m_UiNode)
	end
	
	-- 适应不同分辨率
	self:ChgPosByMainPanel()
	self:CreateImgTitle()
	self:CreateImgBgLayer()
	self:TopMost()
	self:CheckTitlePanel()

	-- 计算ui区域
	self:SetViewRect(self.m_MainPanel)
	-- 设置动画参数
	self:SetAniArgs()
	self:PlayOpenAni()
end

function uiloader:GetMaxScale()
	return self.m_MaxScaleWhenOpen or 1.1  -- 默认是1.1, 一般来说由其他界面返回时则为1
end

function uiloader:TopMost()
	Z_ORDER = Z_ORDER + 1
	self.m_Zorder = Z_ORDER + 1
	self.m_UiNode:setLocalZOrder(Z_ORDER)
end

function uiloader:ChgPosByMainPanel()
	-- 适应不同分辨率
	if display.width == 960 and display.height == 640 then
		return end
	local mainpanel = self.m_MainPanel or self:GetObject("mainpanel")
	if not mainpanel then
		return end
	local oldx,oldy = mainpanel:getPosition()
	local newx = display.width/960*oldx
	local newy = display.height/640*oldy
	local dx,dy = newx-oldx,newy-oldy
	local x,y = self.m_UiNode:getPosition()
	self.m_UiNode:setPosition(x+dx,y+dy)
end

function uiloader:CreateImgTitle()
	local parent = self.m_UiNode
	local bgtitle = display.newSprite("#frame_top_back.png"):addTo(parent)
	local bgsize = bgtitle:getContentSize()
	bgtitle:setScaleX(display.width/bgsize.width)
	local wp = cc.p(display.cx,display.height-bgsize.height/2)
	local lp = parent:convertToNodeSpace(wp)
	bgtitle:setPosition(lp.x, lp.y)
	bgtitle:setLocalZOrder(-9998)
	self.m_BackTitle = bgtitle

	local parent = self.m_MainPanel or self.m_UiNode
	local title = display.newSprite("#frame_top_front.png"):addTo(parent)
	local size = title:getContentSize()
	local wp = cc.p(display.cx,display.height-size.height/2)
	local lp = parent:convertToNodeSpace(wp)
	title:setPosition(lp.x, lp.y)
	title:setLocalZOrder(-9997)
	self.m_FrontTitle = title
end

function uiloader:CreateImgBgLayer()
	local parent = self.m_UiNode -- 加到UiNode里,关闭界面自己释放
	local layer = display.newScreenSprite("background/frame_floor_full.png"):addTo(parent)
	local wp = cc.p(display.cx,display.cy)
	local lp = parent:convertToNodeSpace(wp)
	layer:setPosition(lp.x, lp.y)
	layer:setLocalZOrder(-9999)
	layer:setTouchEnabled(true)
	layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self,self.OnTouchBgLayer))
	layer.m_EdAlpha = 255
	self.m_Layer = layer

end

function uiloader:CreateColorBgLayer()
	local alpha = 200
	local parent = self.m_UiNode -- 加到UiNode里,关闭界面自己释放
	local layer = cc.LayerColor:create(cc.c4b(30,30,30,alpha),display.width,display.height):addTo(parent)
	layer:ignoreAnchorPointForPosition(false)
	local wp = cc.p(display.cx,display.cy)
	local lp = parent:convertToNodeSpace(wp)
	layer:setPosition(lp.x, lp.y)
	layer:setLocalZOrder(-9999)
	layer.m_EdAlpha = alpha
	self.m_Layer = layer

	local node = display.newNode():addTo(layer) -- colorlayer不能响应事件
	node:setContentSize(layer:getContentSize())
	node:setTouchEnabled(true)
	node:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self,self.OnTouchBgLayer))
end

function uiloader:CheckTitlePanel()
	local titlepanel = self:GetObject("Panel_title")
	if titlepanel then
		local closebtn = self:GetObject("closebtn", titlepanel)
		if closebtn then
			local parent = closebtn:getParent()
			local size = closebtn:getContentSize()
			local wp = cc.p(display.width-size.width/2,display.height-size.height/2)
			local lp = parent:convertToNodeSpace(wp)
			closebtn:setPosition(lp.x,lp.y)
		end
		local returnbtn = self:GetObject("return",titlepanel)
		if returnbtn then
			local parent = returnbtn:getParent()
			local size = returnbtn:getContentSize()
			local wp = cc.p(size.width/2,display.height-size.height/2)
			local lp = parent:convertToNodeSpace(wp)
			returnbtn:setPosition(lp.x,lp.y)
		end
		local titleimg = self:GetObject("Image_title",titlepanel)
		if titleimg then
			local parent = titleimg:getParent()
			local size = titleimg:getContentSize()
			local wp = cc.p(display.cx,display.height-size.height/2-5)
			local lp = parent:convertToNodeSpace(wp)
			titleimg:setPosition(lp.x,lp.y)
		end
	end
end

function uiloader:SetViewRect(obj)
	self.m_ViewRect = obj:getContentSize()
	local px,py = obj:getPosition()
	local ap = obj:getAnchorPointInPoints()
	local wp = obj:getParent():convertToWorldSpace(cc.p(px-ap.x,py-ap.y))
	self.m_ViewRect.x = wp.x
	self.m_ViewRect.y = wp.y
end

function uiloader:SetAniArgs()
	self.m_AddScaleTime = 0.1    -- 增大的时间
	self.m_DelScaleTime = 0.03   -- 返回原大小的时间
	self.m_LayerFadeTime = 0.15  -- layer渐变的时间
	self.m_MinScale = 0.6

	self.m_DelScaleTimeClose = 0.08
	-- self.m_MaxScaleClose = 1.0
	self.m_MinScaleClose = 0.8  -- 关闭时的缩放到的最小比例
end

function uiloader:PlayOpenAni()
	self.m_MainPanel:setScale(self.m_MinScale)
	local sequence = cc.Sequence:create(
		cc.ScaleTo:create(self.m_AddScaleTime, self:GetMaxScale()),
		cc.ScaleTo:create(self.m_DelScaleTime, 1.0),
		cc.CallFunc:create(handler(self,self.EndOpenAni))
		)
	self.m_MainPanel:runAction(sequence)

	if self.m_Layer then
		self.m_Layer:setOpacity(0)
		self.m_Layer:runAction(cc.FadeTo:create(self.m_LayerFadeTime, self.m_Layer.m_EdAlpha))
	end
end

function uiloader:EndOpenAni()
	local guide = require("guide")
	guide.Triger("DlgOpen",{Dlg=self})
end

function uiloader:SetCapture(bCapture)
	self.m_Capture = bCapture
end

function uiloader:OnTouchBgLayer(event)
	if self.m_Capture then
		return false end
	if event.name == "began" and not cc.rectContainsPoint(self.m_ViewRect,event) then
		if self:IsHideDlg() == true then
			self:HideDlg()
		else
			self:CloseDlg()
		end
		return true
	end
	return false
end

function uiloader:ReturnDlg()
	if self.m_OnReturnFunc ~= nil then
		self.m_OnReturnFunc()
	end
	if self:IsHideDlg() == true then
		self:HideDlg()
	else
		self:CloseDlg()
	end
end

function uiloader:HideDlg(bShowAni)
	-- self:DelMost()
	if self.m_MainPanel == nil or bShowAni == false then 
		self:HideDlgOver()
	else
		local sequence = cc.Sequence:create(
	   		-- cc.ScaleTo:create(self.m_DelScaleTime, self.m_MaxScaleClose),
	   		cc.ScaleTo:create(self.m_DelScaleTimeClose, self.m_MinScaleClose),
	   		cc.CallFunc:create(handler(self, self.HideDlgOver))
	   		)
		self.m_MainPanel:runAction(sequence)

		if self.m_FrontTitle then
			self.m_FrontTitle:setVisible(false)
		end
		if self.m_Layer then
			self.m_Layer:runAction(cc.FadeTo:create(self.m_LayerFadeTime, 0))
		end
	end
end

function uiloader:HideDlgOver()
	local guide = require("guide")
	guide.Triger("DlgClose",{Dlg=self})
	if self.m_UiNode ~= nil then
		self.m_UiNode:setVisible(false)
	end
end

function uiloader:ShowDlg(bShowAni)
	self:TopMost()

	if self.m_MainPanel == nil or bShowAni == false then 
		self:ShowDlgOverWithNoAni()
	else
		self.m_MainPanel:setScale(self.m_MinScale)
		local sequence = cc.Sequence:create(
			cc.CallFunc:create(handler(self, self.ShowDlgOver)),
			cc.ScaleTo:create(self.m_AddScaleTime, self:GetMaxScale()),
			cc.ScaleTo:create(self.m_DelScaleTime, 1.0),
			cc.CallFunc:create(handler(self,self.EndOpenAni))
			)
		self.m_MainPanel:runAction(sequence)

		if self.m_FrontTitle then
			self.m_FrontTitle:setVisible(true)
		end
		if self.m_Layer then
			self.m_Layer:runAction(cc.FadeTo:create(self.m_LayerFadeTime, self.m_Layer.m_EdAlpha))
		end
	end
end

function uiloader:ShowDlgOverWithNoAni()
	self.m_MainPanel:setScale(1.0)
	if self.m_FrontTitle then
		self.m_FrontTitle:setVisible(true)
	end
	if self.m_Layer then
		self.m_Layer:setOpacity(255)
	end
	if self.m_UiNode ~= nil then
		self.m_UiNode:setVisible(true)
	end
	self:EndOpenAni()
end

function uiloader:ShowDlgOver()
	if self.m_UiNode ~= nil then
		self.m_UiNode:setVisible(true)
	end
end

function uiloader:CloseDlg(bShowAni)
	-- self:DelMost()
	if self.m_UiNode then -- 关闭时，对话框不再响应消息
		self.m_UiNode:setTouchEnabled(true)
		self.m_UiNode:addNodeEventListener(cc.NODE_TOUCH_CAPTURE_EVENT, function (event)
				return false
			end)
	end
	if self.m_MainPanel == nil or bShowAni == false then 
		self:Release()
	else
		local sequence = cc.Sequence:create(
	   		-- cc.ScaleTo:create(self.m_DelScaleTime, self.m_MaxScaleClose),
	   		cc.ScaleTo:create(self.m_DelScaleTimeClose, self.m_MinScaleClose),
	   		cc.CallFunc:create(handler(self, self.Release))
	   		)
		self.m_MainPanel:runAction(sequence)

		if self.m_FrontTitle then
			self.m_FrontTitle:setVisible(false)
		end
		if self.m_Layer then
			self.m_Layer:runAction(cc.FadeTo:create(self.m_LayerFadeTime, 0))
		end
	end
end

function uiloader:IsHideDlg()
	return false
end

function uiloader:Release()
	-- 只释放引擎对象 
	local guide = require("guide")
	guide.Triger("DlgClose",{Dlg=self})
	if self.m_UiNode ~= nil then
		self.m_UiNode.m_Self = nil
		self.m_UiNode:removeSelf()
	end
end

-- start --

--------------------------------
-- 解析json文件
-- @function [parent=#uiloader] load
-- @param string jsonFile 要解析的json文件
-- @param table params 解析参数
-- @return node#node  解析后的布局

-- end --

function uiloader:load(jsonFile, params)
	local jsonTmp = jsonData[jsonFile]
	if not jsonTmp then
		-- if not params or not params.bJsonStruct then
		-- 	local pathInfo = io.pathinfo(jsonFile)
		-- 	if ".csb" == pathInfo.extname then
		-- 		return cc.CSLoader:getInstance():createNodeWithFlatBuffersFile(jsonFile)
		-- 	else
		-- 		json = self:loadFile_(jsonFile)
		-- 	end
		-- else
		-- 	json = jsonFile
		-- end
		jsonTmp = self:loadFile_(jsonFile)
		jsonData[jsonFile] = jsonTmp
	end
	if not jsonTmp then
		print("uiloader - load file fail:" .. jsonFile)
		return
	end
	local json = clone(jsonTmp)
	local node,w,h
	if self:isScene_(json) then
		node, w, h = CCSSceneLoader:load(json, params)
	else
		node, w, h = CCSUILoader:load(json, params)
	end
	node.OnMessage = function(obj,msgid)
		self:OnMessage(msgid)
	end
	self.m_UiNode = node
	self.m_UiNode.m_Self = self -- 循环引用
	self.m_Width = w
	self.m_Height = h

	UILoaderUtilitys.clearPath()

	return node, w, h
end

function uiloader:SearchOptions(root,name)
	if root.options.name == name then
		return root
	else
		for _,val in ipairs(root.children) do
			local options = self:SearchOptions(val,name)
			if options ~= nil then
				return options
			end
		end
	end
end

function uiloader:GetOptions(name)
	local uiname = self.uiname
	if uiname == nil then
		return
	end

	if not self.m_OpRoot then
		self.m_OpRoot = {}
		local fileUtil = cc.FileUtils:getInstance()
		local fullPath = fileUtil:fullPathForFilename(uiname)
		local jsonStr = fileUtil:getStringFromFile(fullPath)
		local jsonVal = json.decode(jsonStr)
		local root = jsonVal.nodeTree
		if not root then
			root = jsonVal.widgetTree
		end
		self.m_OpRoot = root
	end
	return self:SearchOptions(self.m_OpRoot, name)
end



function uiloader:CloneOption(options)
	if options ~= nil then
		return CCSUILoader:generateUINode(clone(options))
	end
end

-- start --

function uiloader:GetObject(name,parent)
	if parent == nil then parent = self.m_UiNode end
	if parent ~= nil then
		return self:seekNodeByName(parent,name)
	end
	return nil
end

function uiloader:GetObjectFromNode(panel, name)
	if panel ~= nil then
		return self:seekNodeByName(panel, name)
	end
	return nil
end

function uiloader:OnMessage(msgid)
	print ("uiloader msgid ->",msgid)
end

--------------------------------
-- 按tag查找布局中的结点
-- @function [parent=#uiloader] seekNodeByTag
-- @param node parent 要查找布局的结点
-- @param number tag 要查找的tag
-- @return node#node 

-- end --

function uiloader:seekNodeByTag(parent, tag)
	if not parent then
		return
	end

	if tag == parent:getTag() then
		return parent
	end

	local findNode
	local children = parent:getChildren()
	local childCount = parent:getChildrenCount()
	if childCount < 1 then
		return
	end
	for i=1, childCount do
		if "table" == type(children) then
			parent = children[i]
		elseif "userdata" == type(children) then
			parent = children:objectAtIndex(i - 1)
		end

		if parent then
			findNode = self:seekNodeByTag(parent, tag)
			if findNode then
				return findNode
			end
		end
	end

	return
end

-- start --

--------------------------------
-- 按name查找布局中的结点
-- @function [parent=#uiloader] seekNodeByName
-- @param node parent 要查找布局的结点
-- @param string name 要查找的name
-- @return node#node 

-- end --

function uiloader:seekNodeByName(parent, name)
	if not parent then
		return
	end

	if name == parent.name then
		return parent
	end

	local findNode
	local children = parent:getChildren()
	local childCount = parent:getChildrenCount()
	if childCount < 1 then
		return
	end
	for i=1, childCount do
		if "table" == type(children) then
			parent = children[i]
		elseif "userdata" == type(children) then
			parent = children:objectAtIndex(i - 1)
		end

		if parent then
			if name == parent.name then
				return parent
			end
		end
	end

	for i=1, childCount do
		if "table" == type(children) then
			parent = children[i]
		elseif "userdata" == type(children) then
			parent = children:objectAtIndex(i - 1)
		end

		if parent then
			findNode = self:seekNodeByName(parent, name)
			if findNode then
				return findNode
			end
		end
	end

	return
end

-- start --

--------------------------------
-- 按name查找布局中的结点
-- 与seekNodeByName不同之处在于它是通过node的下子结点表来查询,效率更快
-- @function [parent=#uiloader] seekNodeByNameFast
-- @param node parent 要查找布局的结点
-- @param string name 要查找的name
-- @return node#node 

-- end --

function uiloader:seekNodeByNameFast(parent, name)
	if not parent then
		return
	end

	if not parent.subChildren then
		return
	end

	if name == parent.name then
		return parent
	end

	local findNode = parent.subChildren[name]
	if findNode then
		-- find
		return findNode
	end

	for i,v in ipairs(parent.subChildren) do
		findNode = self:seekNodeByName(v, name)
		if findNode then
			return findNode
		end
	end

	return
end

-- start --

--------------------------------
-- 根据路径来查找布局中的结点
-- @function [parent=#uiloader] seekNodeByPath
-- @param node parent 要查找布局的结点
-- @param string path 要查找的path
-- @return node#node 

-- end --

function uiloader:seekNodeByPath(parent, path)
	if not parent then
		return
	end

	local names = string.split(path, '/')

	for i,v in ipairs(names) do
		parent = self:seekNodeByNameFast(parent, v)
		if not parent then
			return
		end
	end

	return parent
end

-- start --

--------------------------------
-- 查找布局中的组件结点
-- @function [parent=#uiloader] seekComponents
-- @param node parent 要查找布局的结点
-- @param string nodeName 要查找的name
-- @param number componentIdx 在查找组件在它的直接父结点的位置
-- @return node#node 


--[[--

查找布局中的组件结点

~~~ lua

-- "hero" 是结点名称
-- 1 是 "hero"这个结点下的第一个组件
local hero = cc.uiloader:seekComponents(parentNode, "hero", 1)

~~~

]]
-- end --

function uiloader:seekComponents(parent, nodeName, componentIdx)
	local node = self:seekNodeByName(parent, nodeName)
	if not node then
		return
	end
	node = self:seekNodeByName(node, "Component" .. componentIdx)
	return node
end






-- private
function uiloader:loadFile_(jsonFile)
	local fileUtil = cc.FileUtils:getInstance()
	local fullPath = fileUtil:fullPathForFilename(jsonFile)

	local pathinfo  = io.pathinfo(fullPath)
	UILoaderUtilitys.addSearchPathIf(pathinfo.dirname)

	local jsonStr = fileUtil:getStringFromFile(fullPath)
	local jsonVal = json.decode(jsonStr)

	return jsonVal
end

function uiloader:isScene_(json)
	if json.components then
		return true
	else
		return false
	end
end

return uiloader
