-- 2022-04-19  initial version

local wordcount = {}

function print_stats(range)
	text = vis.win.file:content(range)
	_,lines = text:gsub("\n","")
	_,words = text:gsub("%S+","")
	chars = range.finish - range.start
	pages = math.floor(words/27.5)/10
	vis:info(tostring(lines).." lines, "..tostring(words).." words, "..tostring(vis.win.file.size).." chars (~"..tostring(pages).." pages)")
	return lines, words, chars
end

vis:map(vis.modes.NORMAL, '<F6>', function()
	local range = vis.win.selection.range
	range.start = 0
	range.finish = vis.win.file.size
	print_stats(range)
	return true
end, 'Count the words in the current file')

vis:map(vis.modes.VISUAL, '<F6>', function()
	local range = vis.win.selection.range
	print_stats(range)
	return true
end, 'Count the words in the current selection')

return wordcount

