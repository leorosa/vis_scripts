
local module = {}
local anum = 1
local alist = {}

function autocomplete_set(arg)
	alist = arg
end

function autocomplete_add(text)
	table.insert(alist, text)
end

function autocomplete(incr)
	if #alist == 0 then return end
	fold = anum
	local pos = vis.win.selection.pos
	local lin = vis.win.selection.line
	local col = vis.win.selection.col
	local range = vis.win.file:text_object_longword(pos-1);
	pre = vis.win.file:content(range.start, pos-range.start)
	completion = ''
	while true do
		anum = anum + incr
		if anum > #alist then anum = 1 end
		if anum < 1 then anum = #alist end
		l = pre:len()
		if alist[anum] then
			if pre == alist[anum]:sub(1,l) then
				completion = alist[anum]
				break
			end
		end
		if anum == fold then break end
	end
	if completion == '' then return end
	local range = vis.win.file:text_object_longword(pos-1);
	vis.win.file:delete(range)
	vis.win.file:insert(range.start, completion)
	vis.win.selection:to(lin,col)
end

vis:map(vis.modes.INSERT, "<S-Tab>", function(keys) autocomplete( 1) end)
vis:map(vis.modes.INSERT, "<M-Tab>", function(keys) autocomplete(-1) end)

---- you need to feed a list of words in your visrc file to use this plugin; e.g.:
--
--local auto = {}
--local p = io.popen('find ~/Documents/* -maxdepth 1 -type f')
--for path in p:lines() do
--	local l = path:len()
--	i, j = string.find(path, 'Documents/')
--	--autocomplete_add(string.sub(path, j+1, l-4))
--	table.insert(auto, string.sub(path, j+1, l-4))
--end
--autocomplete_set(auto)

return module
