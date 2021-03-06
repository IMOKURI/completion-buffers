local completion = require("completion")
local buffers = require("completion_buffers.source")
local cmd = vim.api.nvim_command
local function add_sources()
  completion.addCompletionSource("buffers", {item = buffers.get_buffers_completion_items})
  completion.addCompletionSource("buffer", {item = buffers.get_buffer_completion_items})
  cmd("augroup RefreshBufferWords")
  cmd("autocmd! *")
  cmd("autocmd BufEnter * lua require'completion_buffers'.refresh_buffers_word()")
  cmd("autocmd BufUnload * call luaeval('require\"completion_buffers\".unload_buffer_words(_A)', expand('<abuf>'))")
  return cmd("augroup END")
end
local function refresh_buffers_word()
  return buffers.caching_buffer_words()
end
local function unload_buffer_words(bufnr)
  return buffers.unload_buffer_words(bufnr)
end
return {add_sources = add_sources, refresh_buffers_word = refresh_buffers_word, unload_buffer_words = unload_buffer_words}