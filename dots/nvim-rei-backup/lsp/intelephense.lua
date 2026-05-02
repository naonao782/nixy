local function get_license()
  local home = os.getenv("HOME")
  if not home or home == "" then
    return nil
  end

  local file = io.open(home .. "/intelephense/license.txt", "rb")
  if not file then
    return nil
  end

  local content = file:read("*a")
  file:close()

  if not content or content == "" then
    return nil
  end

  return string.gsub(content, "%s+", "")
end

local license = get_license()
local init_options = {}

if license and license ~= "" then
  init_options.licenceKey = license
end

return {
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php", "blade" },
  root_markers = { "composer.json", ".git" },
  init_options = init_options,
}
