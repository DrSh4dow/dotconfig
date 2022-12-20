local inlay_status, inlay = pcall(require, "lsp-inlayhints")
if not inlay_status then
	return
end

inlay.setup({
	inlay_hints = {
		parameter_hints = {
			show = false,
		},
		-- highlight group
		highlight = "Comment",
	},
})
