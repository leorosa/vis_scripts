
local module = {}

local XDG_CACHE_HOME = os.getenv('XDG_CACHE_HOME')
if XDG_CACHE_HOME then 
	module.path =  XDG_CACHE_HOME .. '/visreg'
else
	module.path = os.getenv('HOME') .. '/.visreg'
end
module.registers = '"abcdefghijklmnopqrstuvwxyz'

function read_reg(reg)
	local f = io.open(module.path..reg)
	if f == nil then return end
	val = f:read "*a"
	f:close()
	vis.registers[reg] = { val }
end

function read_regs()
	for reg in module.registers:gmatch(".") do
		read_reg(reg)
	end
end

function write_reg(reg)
	if string.len(vis.registers[reg][1])>0 then
		local f = io.open(module.path..reg, 'w+')
		if f == nil then return end
		f:write(vis.registers[reg][1])
	f:close()
	end
end

function write_regs()
	for reg in module.registers:gmatch(".") do
		write_reg(reg)
	end
end

vis.events.subscribe(vis.events.START, read_regs)
vis.events.subscribe(vis.events.WIN_CLOSE, write_regs)

return module

