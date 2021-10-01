
require('vis')

local module = {
	tab_width = 4,
}

local function nbackspace(sel)
	vis.win.file:delete(sel.pos-1, 1)
	return
end

local function ebackspace(sel)
	if not sel.pos then return end
	local bkpos = sel.pos-1
	if vis.win.file:content(bkpos, 1) ~= ' ' then
		vis.win.file:delete(bkpos, 1)
		vis.win.selection.pos = bkpos
		return
	end
	while vis.win.file:content(bkpos, 1) == ' ' do
		vis.win.file:delete(bkpos, 1)
		bkpos = bkpos-1
		if ((sel.col-1) % module.tab_width) == 0 then break end
		if not sel.pos then break end
	end
	vis.win.selection.pos = bkpos+1
end

local function ebackspaces()
	local selections = {}
	local length = 0
	for selection in vis.win:selections_iterator() do
		if selection.pos ~= nil and selection.pos ~= 0 then
			table.insert(selections, selection)
			length = length+1
		end
	end
-- if multiple selection, do a simple backspace
	if length > 1 then
		for _, selection in ipairs(selections) do
			nbackspace(selection)
		end
	else
		ebackspace(vis.win.selection)
	end
	vis:insert('')
end

vis.events.subscribe(vis.events.INIT, function()
	vis:map(vis.modes.INSERT, '<Backspace>', ebackspaces)
end)

return module
