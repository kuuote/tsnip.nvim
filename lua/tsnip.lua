local M = {}

local plugin_name = 'tsnip'
local Input = require('nui.input')
local event = require('nui.utils.autocmd').event

local function remove_word()
  vim.cmd('call feedkeys("\\<Esc>bcw", "n")')
end

function M.input(opt)
  local name = opt.name
  local label = opt.label

  local input = Input({
    relative = 'cursor',
    position = {
      row = 1,
      col = 0,
    },
    size = 40,
    border = {
      style = 'rounded',
      text = {
        top = label,
        top_align = 'left',
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    on_change = function(value)
      vim.call('denops#request', plugin_name, 'changed', { name, value })
    end,
    on_submit = function(value)
      vim.call('denops#request', plugin_name, 'submit', { name, value })
    end,
    on_close = function()
      vim.call('denops#request', plugin_name, 'close', {})
    end,
  })
  input:mount()
  input:map('n', '<Esc>', input.input_props.on_close, { noremap = true })
  input:map('i', '<C-w>', remove_word, { noremap = true })

  input:on(event.BufLeave, function()
    vim.call('denops#request', plugin_name, 'close', {})
    input:unmount()
  end)
end

return M
