
local module = {}

local print_digraphs = function()
	vis:command("!vis-digraph | cut -d' ' -f1-2 | paste - - - - - - - - - - - - - - | more")
	io.read(1)
end

-- initialize commands
vis:command_register('dig', print_digraphs, 'print digraphs')

return module
