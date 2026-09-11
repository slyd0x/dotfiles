vim.lsp.config("clangd", {
  cmd = { "clangd" },
  filetype = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
  root_markers = { ".git", "compile_commands.json", "CMakeLists.txt" },
})

vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "py", "python" },
  root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
})

vim.lsp.config("rust-analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
})


vim.lsp.enable({ "clangd", "pyright", "rust-analyzer" })

vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspCompletion", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})


local bracket_pairs = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ['"'] = '"',
  ["'"] = "'",
}

for open, close in pairs(bracket_pairs) do
  vim.keymap.set("i", open, open .. close .. "<LEFT>", { noremap = true })
end
