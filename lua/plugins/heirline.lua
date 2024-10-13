return {
  "rebelot/heirline.nvim",
  opts = function (_, opts)
    local status = require("astroui.status")
    return vim.tbl_extend('force', opts, {
      statusline = {
        hl = { fg = "fg", bg = "bg" },
        status.component.mode(),
        status.component.git_branch(),
        status.component.separated_path({
          path_func = status.provider.filename({ modify = ":~:h" }),
          separator = "  ",
          max_depth = 6,
          condition = function()
            return (vim.bo.filetype ~= 'toggleterm' and true or false)
          end
        }),
        status.component.file_info({
          filename = { padding = { left = 0 } },
          filetype = false,
          condition = function()
            return (vim.bo.filetype ~= 'toggleterm' and true or false)
          end
        }),
        status.component.git_diff(),
        status.component.diagnostics(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        status.component.lsp(),
        status.component.virtual_env(),
        status.component.treesitter(),
        status.component.nav(),
        status.component.mode { surround = { separator = "right" } },
      }})
  end,
}
