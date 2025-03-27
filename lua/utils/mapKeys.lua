local M = {}

local function isArray(tbl)
  if type(tbl) ~= "table" then return false end
  local i = 1
  for _ in pairs(tbl) do
    if tbl[i] == nil then return false end
    i = i + 1
  end
  return true
end

local function parseKeymap(kb, seq, result, mode)
  seq = seq or ""
  mode = mode or "n"
  result = result or {}
  for k, v in pairs(kb) do
    if type(v) == "table" then
      if isArray(v) ~= true then
        if string.match( k, "[nvit]") and seq == "" then --string.match( k, "[nvit]") and 
          mode = k
          parseKeymap(v, "", result, mode)
        else
          parseKeymap(v, seq..k, result, mode)
        end
      elseif isArray(v) == true then
        table.insert(result, {
          seq = (seq..k) or "",
          cmd = v[1] or v.cmd or "nocmd",
          desc =  v[2] or v.desc or "nodesc",
          mode = mode or "n",
        })
      end
    end
  end
  return result
end

function M.lze(kb)
  local result = parseKeymap(kb)
  local result1 = {}
  for _, v in ipairs(result) do
    table.insert (result1, {
      v.seq,
      v.cmd,
      mode = {v.mode},
      desc = v.desc
    })
  end
  return result1
end

function M.wk(kb)
  local result = parseKeymap(kb)
  local wk = require("which-key")
  for _, v in ipairs(result) do
    wk.add(v.seq, v.cmd, { mode = v.mode }, {desc = v.desc})
  end
end

function M.vim(kb)
  local result = parseKeymap(kb)
  for _, v in ipairs(result) do
    vim.keymap.set(v.mode, v.seq , v.cmd, { desc = v.desc })
  end
end

function M.lzeSeqAndDesc(kb)
  local result = parseKeymap(kb)
  local result1 = {}
  for _, v in ipairs(result) do
    table.insert (result1, {
      v.seq,
      {desc = v.desc or "cannot find"}
    })
  end
  return result1
end

return M
