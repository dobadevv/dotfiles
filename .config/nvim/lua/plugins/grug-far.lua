return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
  opts = {
    headerMaxWidth = 80,
    transient = true,
  },
  keys = {
    { "<leader>RR", function() require("grug-far").open() end, desc = "Replace (project)" },

    {
      "<leader>Rw",
      function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
      end,
      desc = "Replace word under cursor",
    },
    {
      "<leader>Rw",
      function() require("grug-far").with_visual_selection() end,
      mode = "x",
      desc = "Replace selection",
    },

    {
      "<leader>Rf",
      function()
        require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Replace in current file",
    },
    {
      "<leader>Rf",
      function()
        require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })
      end,
      mode = "x",
      desc = "Replace selection in current file",
    },

    {
      "<leader>Ri",
      function()
        require("grug-far").open({ visualSelectionUsage = "operate-within-range" })
      end,
      mode = { "n", "x" },
      desc = "Replace within range",
    },

    {
      "<leader>R/",
      function()
        local search = vim.fn.getreg("/")
        if search and vim.startswith(search, "\\<") and vim.endswith(search, "\\>") then
          search = "\\b" .. search:sub(3, -3) .. "\\b"
        elseif search and vim.startswith(search, "\\V") then
          search = search:sub(3)
        end
        local inst = require("grug-far").open({ prefills = { search = search } })
        inst:when_ready(function() inst:goto_input("replacement") end)
      end,
      mode = { "n", "x" },
      desc = "Replace using last / search",
    },

    {
      "<leader>Rb",
      function()
        require("grug-far").open({ prefills = { paths = "<buflist-cwd>" } })
      end,
      desc = "Replace in open buffers",
    },

    {
      "<leader>Ra",
      function() require("grug-far").open({ engine = "astgrep" }) end,
      desc = "Replace (ast-grep)",
    },

    {
      "<leader>Rh",
      function()
        local opts = {}
        local entry = require("grug-far").get_last_history_entry()
        if entry ~= nil then
          opts.prefills = entry
          opts.engine = entry.engine
          opts.replacementInterpreter = entry.replacementInterpreter
        end
        require("grug-far").open(opts)
      end,
      desc = "Replace (last history)",
    },
  },
}
