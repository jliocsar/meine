local filetype = vim.filetype

filetype.add({
	pattern = {
		['.*%.script'] = 'lua',
	},
})
