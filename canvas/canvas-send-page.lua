#!/usr/local/bin/lua

local canvas  = require("canvas-lms"):new("canvas-config.lua")
local dump = require "pl.pretty".dump

canvas:get_pages()

local htmlfile = arg[1]

print("Lua send page: "..htmlfile)

for title,page in pairs(canvas.pages) do
  if page.url..".html" == htmlfile then
    print(title)
    local content
    local file = io.open("pages/"..htmlfile, "r")  -- open in read mode
    if file then
      content = file:read("*a")    -- read entire file
      file:close()
    else
      print("Failed to open file: ", filename)
    end
    xx = canvas:update_page(title,{body=content})
    print("RESPONSE:")
    dump(xx)
  end
end
