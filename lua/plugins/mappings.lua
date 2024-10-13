return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = {
          ["<Leader>rr"] = { ':TermExec cmd="ruby %"<cr>', desc = "Run ruby in terminal" },
          ["<Leader>z"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer", },
          ["<Leader>x"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer", },
          ["Q"] = { ":q<cr>", desc = "Quit buffer" },
        },
      },
    },
  },
}
