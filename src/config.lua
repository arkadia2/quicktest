
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1

-- 是否是内部版本
VERSION_INNER_CLIENT = true  --(客户端标志)

-- display FPS stats on screen
DEBUG_FPS = true
if VERSION_INNER_CLIENT == false then
	DEBUG_FPS = false
end

-- dump memory info every 10 seconds
DEBUG_MEM = false

-- load deprecated API
LOAD_DEPRECATED_API = false

-- load shortcodes API
LOAD_SHORTCODES_API = true

-- screen orientation
CONFIG_SCREEN_ORIENTATION = "landscape"

-- design resolution
CONFIG_SCREEN_WIDTH  = 1280
CONFIG_SCREEN_HEIGHT = 720

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FILL_ALL"
CONFIG_SCREEN_AUTOSCALE_CALLBACK = function(pixelW,pixelH,mode)
	local sx = CONFIG_SCREEN_WIDTH / pixelW
	local sy = CONFIG_SCREEN_HEIGHT / pixelH
	local realx
	local realy
	local s
	if sx <= sy then
		CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"
		s = sy
		realy = CONFIG_SCREEN_HEIGHT
		realx = pixelH * realy / pixelW
	else
		CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"
		s = sx
		realx = CONFIG_SCREEN_WIDTH
		realy = pixelW * realx / pixelH
	end
	return pixelW / realx,pixelH / realy
end