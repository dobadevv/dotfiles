return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  lazy = false,
  keys = {
    { "zR", function() require("ufo").openAllFolds() end },
    { "zM", function() require("ufo").closeAllFolds() end },
  },
  config = function()
    require("ufo").setup({
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    })
  end,
}
