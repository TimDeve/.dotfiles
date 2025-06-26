local buf_command = require("utils.vim").buf_command

buf_command(0, "NeorgExport", require("plugins-config.norg").export_to_clipboard, { nargs='?' })
