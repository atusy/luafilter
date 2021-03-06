--[[
math-github - Render math based on render.githubusercontent.com

Math expression is URL-encoded by R.
Specify the path of R via "r-path" metadata.

# MIT License

Copyright (c) 2020 Atsushi Yasumoto

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

https://github.com/atusy/lua-filters/blob/master/lua/math-github.lua
]]
local base_url = "https://render.githubusercontent.com/render/math?math="
local args = {
  "--vanilla", "-q", "-s", "-e",
  "cat(URLencode(paste(readLines('stdin', warn = FALSE), collapse = '')))"
}

local function Meta(elem)
  R = elem["r-path"] and pandoc.utils.stringify(elem["r-path"]) or "R"
end

local function Math(elem)
  return pandoc.utils.blocks_to_inlines(pandoc.read(string.format(
    "![`%s`](%s%s&mode=%s){.%s}",
    elem.text,
    base_url, pandoc.pipe(R, args, elem.text),
    (elem.mathtype == "DisplayMath") and "display" or "inline",
    elem.mathtype
  ), "markdown").blocks)
end

return {{Meta = Meta}, {Math = Math}}
