-- -- This file is automatically loaded by lazyvim.config.init
-- 
-- -- DO NOT USE `LazyVim.safe_keymap_set` IN YOUR OWN CONFIG!!
-- -- use `vim.keymap.set` instead
-- -- local map = LazyVim.safe_keymap_set
local map = vim.keymap.set
-- 
-- -- better up/down
-- map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
-- map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
-- map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
-- map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
-- 
-- move to window using the <ctrl> hjkl keys
map("n", "<c-h>", "<c-w>h", { desc = "go to left window", remap = true })
map("n", "<c-j>", "<c-w>j", { desc = "go to lower window", remap = true })
map("n", "<c-k>", "<c-w>k", { desc = "go to upper window", remap = true })
map("n", "<c-l>", "<c-w>l", { desc = "go to right window", remap = true })

-- resize window using <ctrl> arrow keys
map("n", "<c-up>", "<cmd>resize +2<cr>", { desc = "increase window height" })
map("n", "<c-down>", "<cmd>resize -2<cr>", { desc = "decrease window height" })
map("n", "<c-left>", "<cmd>vertical resize -2<cr>", { desc = "decrease window width" })
map("n", "<c-right>", "<cmd>vertical resize +2<cr>", { desc = "increase window width" })
 
-- move lines
map("n", "<a-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "move down" })
map("n", "<a-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "move up" })
map("i", "<a-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "move down" })
map("i", "<a-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "move up" })
map("v", "<a-j>", ":<c-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "move down" })
map("v", "<a-k>", ":<c-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "move up" })
 
-- buffers
map("n", "<s-h>", "<cmd>bprevious<cr>", { desc = "prev buffer" })
map("n", "<s-l>", "<cmd>bnext<cr>", { desc = "next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "switch to other buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "switch to other buffer" })
map("n", "<leader>bd", function()
  snacks.bufdelete()
end, { desc = "delete buffer" })
map("n", "<leader>bo", function()
  snacks.bufdelete.other()
end, { desc = "delete other buffers" })
map("n", "<leader>bd", "<cmd>:bd<cr>", { desc = "delete buffer and window" })

-- -- clear search and stop snippet on escape
-- map({ "i", "n", "s" }, "<esc>", function()
--   vim.cmd("noh")
--   lazyvim.cmp.actions.snippet_stop()
--   return "<esc>"
-- end, { expr = true, desc = "escape and clear hlsearch" })
 
-- -- clear search, diff update and redraw
-- -- taken from runtime/lua/_editor.lua
-- map(
--   "n",
--   "<leader>ur",
--   "<cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>",
--   { desc = "redraw / clear hlsearch / diff update" }
-- )
-- 
-- -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- map("n", "n", "'nn'[v:searchforward].'zv'", { expr = true, desc = "next search result" })
-- map("x", "n", "'nn'[v:searchforward]", { expr = true, desc = "next search result" })
-- map("o", "n", "'nn'[v:searchforward]", { expr = true, desc = "next search result" })
-- map("n", "n", "'nn'[v:searchforward].'zv'", { expr = true, desc = "prev search result" })
-- map("x", "n", "'nn'[v:searchforward]", { expr = true, desc = "prev search result" })
-- map("o", "n", "'nn'[v:searchforward]", { expr = true, desc = "prev search result" })
-- 
-- -- add undo break-points
-- map("i", ",", ",<c-g>u")
-- map("i", ".", ".<c-g>u")
-- map("i", ";", ";<c-g>u")
-- 
-- save file
map({ "i", "x", "n", "s" }, "<c-s>", "<cmd>w<cr><esc>", { desc = "save file" })
-- 
-- --keywordprg
-- map("n", "<leader>k", "<cmd>norm! k<cr>", { desc = "keywordprg" })
-- 
-- -- better indenting
-- map("x", "<", "<gv")
-- map("x", ">", ">gv")
-- 
-- -- commenting
map("n", "gco", "o<esc>vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "add comment below" })
map("n", "gco", "o<esc>vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "add comment above" })
-- 
-- -- lazy
-- map("n", "<leader>l", "<cmd>lazy<cr>", { desc = "lazy" })
-- 
-- -- new file
-- map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "new file" })
-- 
-- -- location list
-- map("n", "<leader>xl", function()
--   local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
--   if not success and err then
--     vim.notify(err, vim.log.levels.error)
--   end
-- end, { desc = "location list" })
-- 
-- -- quickfix list
-- map("n", "<leader>xq", function()
--   local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
--   if not success and err then
--     vim.notify(err, vim.log.levels.error)
--   end
-- end, { desc = "quickfix list" })
-- 
-- map("n", "[q", vim.cmd.cprev, { desc = "previous quickfix" })
-- map("n", "]q", vim.cmd.cnext, { desc = "next quickfix" })
-- 
-- -- formatting
-- map({ "n", "x" }, "<leader>cf", function()
--   lazyvim.format({ force = true })
-- end, { desc = "format" })
-- 
-- -- diagnostic
-- local diagnostic_goto = function(next, severity)
--   return function()
--     vim.diagnostic.jump({
--       count = (next and 1 or -1) * vim.v.count1,
--       severity = severity and vim.diagnostic.severity[severity] or nil,
--       float = true,
--     })
--   end
-- end
-- map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "line diagnostics" })
-- map("n", "]d", diagnostic_goto(true), { desc = "next diagnostic" })
-- map("n", "[d", diagnostic_goto(false), { desc = "prev diagnostic" })
-- map("n", "]e", diagnostic_goto(true, "error"), { desc = "next error" })
-- map("n", "[e", diagnostic_goto(false, "error"), { desc = "prev error" })
-- map("n", "]w", diagnostic_goto(true, "warn"), { desc = "next warning" })
-- map("n", "[w", diagnostic_goto(false, "warn"), { desc = "prev warning" })
-- 
-- -- stylua: ignore start
-- 
-- -- toggle options
-- lazyvim.format.snacks_toggle():map("<leader>uf")
-- lazyvim.format.snacks_toggle(true):map("<leader>uf")
-- snacks.toggle.option("spell", { name = "spelling" }):map("<leader>us")
-- snacks.toggle.option("wrap", { name = "wrap" }):map("<leader>uw")
-- snacks.toggle.option("relativenumber", { name = "relative number" }):map("<leader>ul")
-- snacks.toggle.diagnostics():map("<leader>ud")
-- snacks.toggle.line_number():map("<leader>ul")
-- snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "conceal level" }):map("<leader>uc")
-- snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "tabline" }):map("<leader>ua")
-- snacks.toggle.treesitter():map("<leader>ut")
-- snacks.toggle.option("background", { off = "light", on = "dark" , name = "dark background" }):map("<leader>ub")
-- snacks.toggle.dim():map("<leader>ud")
-- snacks.toggle.animate():map("<leader>ua")
-- snacks.toggle.indent():map("<leader>ug")
-- snacks.toggle.scroll():map("<leader>us")
-- snacks.toggle.profiler():map("<leader>dpp")
-- snacks.toggle.profiler_highlights():map("<leader>dph")
-- 
-- if vim.lsp.inlay_hint then
--   snacks.toggle.inlay_hints():map("<leader>uh")
-- end
-- 
-- -- lazygit
-- if vim.fn.executable("lazygit") == 1 then
--   map("n", "<leader>gg", function() snacks.lazygit( { cwd = lazyvim.root.git() }) end, { desc = "lazygit (root dir)" })
--   map("n", "<leader>gg", function() snacks.lazygit() end, { desc = "lazygit (cwd)" })
-- end
-- 
-- map("n", "<leader>gl", function() snacks.picker.git_log() end, { desc = "git log (cwd)" })
-- map("n", "<leader>gb", function() snacks.picker.git_log_line() end, { desc = "git blame line" })
-- map("n", "<leader>gf", function() snacks.picker.git_log_file() end, { desc = "git current file history" })
-- map("n", "<leader>gl", function() snacks.picker.git_log({ cwd = lazyvim.root.git() }) end, { desc = "git log" })
-- map({ "n", "x" }, "<leader>gb", function() snacks.gitbrowse() end, { desc = "git browse (open)" })
-- map({"n", "x" }, "<leader>gy", function()
--   snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
-- end, { desc = "git browse (copy)" })
-- 
-- -- quit
-- map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "quit all" })
-- 
-- -- highlights under cursor
-- map("n", "<leader>ui", vim.show_pos, { desc = "inspect pos" })
-- map("n", "<leader>ui", function() vim.treesitter.inspect_tree() vim.api.nvim_input("i") end, { desc = "inspect tree" })
-- 
-- -- lazyvim changelog
-- map("n", "<leader>l", function() lazyvim.news.changelog() end, { desc = "lazyvim changelog" })
-- 
-- -- floating terminal
-- map("n", "<leader>ft", function() snacks.terminal() end, { desc = "terminal (cwd)" })
-- map("n", "<leader>ft", function() snacks.terminal(nil, { cwd = lazyvim.root() }) end, { desc = "terminal (root dir)" })
-- map({"n","t"}, "<c-/>",function() snacks.terminal(nil, { cwd = lazyvim.root() }) end, { desc = "terminal (root dir)" })
-- map({"n","t"}, "<c-_>",function() snacks.terminal(nil, { cwd = lazyvim.root() }) end, { desc = "which_key_ignore" })
-- 
-- -- windows
-- map("n", "<leader>-", "<c-w>s", { desc = "split window below", remap = true })
-- map("n", "<leader>|", "<c-w>v", { desc = "split window right", remap = true })
-- map("n", "<leader>wd", "<c-w>c", { desc = "delete window", remap = true })
-- snacks.toggle.zoom():map("<leader>wm"):map("<leader>uz")
-- snacks.toggle.zen():map("<leader>uz")
-- 
-- -- tabs
-- map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "last tab" })
-- map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "close other tabs" })
-- map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "first tab" })
-- map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "new tab" })
-- map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "next tab" })
-- map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "close tab" })
-- map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "previous tab" })
-- 
-- -- lua
-- map({"n", "x"}, "<localleader>r", function() snacks.debug.run() end, { desc = "run lua", ft = "lua" })
