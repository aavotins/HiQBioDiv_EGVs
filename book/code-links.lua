-- code-links.lua
local function escape_latex(s)
  -- escape { } \ in the visible link text
  s = s:gsub("\\", "\\\\")
  s = s:gsub("{", "\\{")
  s = s:gsub("}", "\\}")
  return s
end

function Link(el)
  if #el.content == 1 and el.content[1].t == "Code" then
    local txt = escape_latex(el.content[1].text)
    local url = el.target
    return pandoc.RawInline("latex", "\\linkcode{" .. txt .. "}{" .. url .. "}")
  end
end
