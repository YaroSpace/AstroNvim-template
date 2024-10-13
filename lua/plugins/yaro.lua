local eval_lua = function(chunk)
  if select(2, chunk:gsub("\n", "")) < 1 then
    chunk = "return " .. chunk
  end

  local code, error = load(chunk)
  if error then return error end

  local status, result = xpcall(code, debug.traceback)
  if not status then return (result..debug.traceback()) end

  result = type(result) == 'function' and debug.getinfo(result) or result
  return vim.inspect(result)
end

vim.o.scrolloff = 999

vim.api.nvim_create_autocmd("Filetype", {
  pattern = "help",
  command = "wincmd L",
  desc = "Open help in vertical split",
})

-- vim.api.nvim_create_user_command("Pp", function(opts)
--
--   -- local command = "return vim.inspect(" .. opts.args .. ")"
--   -- if not assert(loadstring(command)) then return end
--
--   vim.cmd("pu=execute('lua=" .. opts.args .. "')")
-- end, { nargs = "*", desc = "Pretty print Lua expression and paste into current buffer" })

vim.api.nvim_create_user_command("Pm", function(opts)
  local message = require("messages.api").open_float
  message(opts.args == "" and "" or eval_lua(opts.args))
end, { nargs = "*", desc = "Pretty print Lua expression and output in Message window" })

vim.api.nvim_set_keymap("n", "`", ":Pm<cr>", { desc = "Open Messages window" })

return {
  {
    "nacro90/numb.nvim",
    lazy = false,
    opts = {},
    desc = "Peeks lines of the buffer",
  },
  {
    "tpope/vim-scriptease",
    enabled = false,
    lazy = false,
    desc = "Vim scripting tools",
  },
  {
    "ggandor/leap.nvim",
    enabled = false,
    lazy = false,
    init = function() require("leap").create_default_mappings() end,
  },
  {
    "AckslD/messages.nvim",
    enabled = true,
    lazy = true,
    cmd = "Messages",
    opts = {
      prepare_buffer = function(opts)
        local bufnr = vim.fn.bufnr('messages')
        local winnr = nil

        if bufnr ~= -1 then
          for _, nr in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(nr) == bufnr  then
              winnr = nr; break
            end
          end

          winnr = winnr or vim.api.nvim_open_win(bufnr, true, vim.tbl_extend('force', opts, { height = 20 }))
          vim.api.nvim_set_current_win(winnr)

          return winnr
        end

        bufnr = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_name(bufnr, "messages")
        vim.api.nvim_set_option_value("filetype", "lua", { buf = bufnr })

        vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-Up>", ":resize +5<cr>", { desc = "Resize window" })
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-Down>", ":resize -5<cr>", { desc = "Resize window" })

        vim.keymap.set({"n", "v"}, "<C-J>", "", { -- <C-J> is to catch <C-Enter>
          buffer = bufnr,
          desc = "Eval lua code in current line",
          callback = function()
            local bufnr = vim.fn.bufnr()
            local linenr = vim.fn.line('.')
            local chunk = vim.api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)[1]

            if vim.api.nvim_get_mode().mode == "V" then
              vim.api.nvim_input("<Esc>")

              local v_start, v_end = vim.fn.line('.'), vim.fn.line('v')
              if v_start > v_end then
                v_start, v_end = v_end, v_start
              end

              chunk = vim.api.nvim_buf_get_lines(bufnr, v_start - 1, v_end, false)
              chunk = table.concat(chunk, "\n")
            end

            local result = eval_lua(chunk)
            vim.api.nvim_buf_set_lines(bufnr, linenr, linenr, false, vim.split(result, "\n"))
          end,
        })

        vim.api.nvim_buf_set_keymap(bufnr, "n", "gf", "", {
          desc = "Open file in vertical split",
          callback = function()
            local file = vim.fn.expand "<cfile>"
            vim.api.nvim_win_close(0, false)
            vim.cmd("vs " .. file)
          end,
        })

        winnr = vim.api.nvim_open_win(bufnr, true, vim.tbl_extend('force', opts, { height = 20 }))
        return winnr
      end
    }
  },
  {
    "rafcamlet/nvim-luapad",
    enabled = false,
    cmd = "Luapad",
    opts = {
      preview = true,
      wipe = false,
    },
    lazy = true,
  },
  {
    "bfredl/nvim-luadev",
    enabled = false,
    cmd = "Luadev",
    lazy = true,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {},
  }
}
