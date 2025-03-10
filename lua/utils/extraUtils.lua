local M = {}

M.addPacks = function(name, plugins)
  local result = { name }
  if plugins then
    for _, v in ipairs(plugins) do
      table.insert(result, v)
    end
  end
  for _, v in ipairs(result) do
    vim.cmd.packadd(v)
  end
end

return M
