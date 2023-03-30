local status, mini = pcall(require, "mini.indentscope")
if not status then
	return
end

mini.setup()
