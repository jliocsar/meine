-- Modules to be imported by Lua, needs to start with `'plugins'`
local modules = { 'plugins', 'options', 'theme', 'keymaps' }

for moduleCount = 1, #modules do
  import(modules[moduleCount])
end
