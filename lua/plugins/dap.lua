return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    -- dependencies = { "suketa/nvim-dap-ruby", config = true },

    config = function(plugin, opts)
      local dap = require('dap')
      dap.adapters.ruby = function(callback, config)
        callback {
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = {
            command = "rdbg",
            args = { "--open", "--port", "${port}",
              "-c", config.command, config.script,
            --[[ command = "bundle",
            args = { "exec", "rdbg", "-n", "--open", "--port", "${port}",
              "-c", "--", "bundle", "exec", config.command, config.script, ]]
            },
          },
        }
      end

      dap.configurations.ruby = {
        {
          type = "ruby",
          name = "debug current file",
          request = "attach",
          localfs = true,
          command = "ruby",
          script = "${file}",
        },
        {
          type = "ruby",
          name = "run current spec file",
          request = "attach",
          localfs = true,
          command = "rspec",
          script = "${file}",
        },
      }
    end
  },

  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = {
          ["<F5>"] = { function() require('dap').toggle_breakpoint() end, desc = "Debugger Breakpoint" },
          ["<F6>"] = { function()
              -- vim.fn.setenv("RUBYOPT", "-rdebug/open_non_stop")
              require('dap').continue()
            end, desc = "Debugger Continue" },
          ["<F7>"] = { function() require('dap').step_into() end, desc = "Debugger step into" },
          ["<F8>"] = { function() require('dap').step_out() end, desc = "Debugger step out" },
          ["<F9>"] = { function() require('dap').step_over() end, desc = "Debugger step over" },
          ["<F10>"] = { function() require("dap").terminate() end, desc = "Debugger: Stop" }
          --[[
          "<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
          "<Leader>dr', function() require('dap').repl.open() end)
          "<Leader>dl', function() require('dap').run_last() end)
          ""'v'}, '<Leader>dh', function()
            require('dap.ui.widgets').hover()
          end)
          vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
            require('dap.ui.widgets').preview()
          end)
          vim.keymap.set('n', '<Leader>df', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.frames)
          end)
          vim.keymap.set('n', '<Leader>ds', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.scopes)
          end) ]]
        },
      },
    },
  },
}
