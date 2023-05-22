local function doMeineFile(fileName)
  local path = MEINE_VIM_PATH .. '/' .. fileName .. '.lua'
  return dofile(path)
end

-- 'plugins' need to be at first
local modules = {'plugins', 'options', 'theme', 'keymaps'}

for moduleCount = 1, #modules do
  doMeineFile(modules[moduleCount])
end
