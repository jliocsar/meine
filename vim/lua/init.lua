local function doMeineFile(fileName)
  local path = MEINE_VIM_PATH .. '/' .. fileName .. '.lua'
  dofile(path)
end

-- 'plugins' need to be at first
local modules = {'plugins', 'options', 'theme'}

for moduleCount = 1, #modules do
  doMeineFile(modules[moduleCount])
end
