package.preload['resession.extensions.colorscheme'] = function()
  return {
    on_save = function()
      return vim.g.colors_name
    end,

    on_post_load = function(data)
      vim.api.nvim_create_autocmd("UIEnter", {
        callback = function()
          vim.cmd('colorscheme ' .. data)
          vim.api.nvim_exec_autocmds("Colorscheme",{})
        end,
        desc = "Load colorscheme from last session"
      })
    end
  }
end

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Load last session",
  callback = function()
    local delele_empty_buffer = function()
      for _, buf_id in pairs(vim.api.nvim_list_bufs()) do
        local bufinfo = vim.fn.getbufinfo(buf_id)
          if bufinfo[1].name == "" then
            vim.api.nvim_buf_delete(buf_id, { force = true })
          end
      end
    end

    require("resession").load("Last Session", { reset = false, silence_errors = true })
    delele_empty_buffer()
  end,
})

return {
  "stevearc/resession.nvim",
  lazy = true,
  opts = { extensions = { colorscheme = { enable_in_tab = true } } },
}
