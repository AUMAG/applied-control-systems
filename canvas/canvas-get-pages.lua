#!/usr/local/bin/lua

local canvas  = require("canvas-lms"):new("canvas-config.lua")
local dump = require "pl.pretty".dump

canvas:get_pages{download=true}

-- Function to escape values (basic CSV escaping)
local function escape_csv(val)
    val = tostring(val)
    if val:find("[,\"]") then
        val = '"' .. val:gsub('"', '""') .. '"'
    end
    return val
end

keys = {"id","published","title","url","updated_at","html_url"}

-- Function to convert table to CSV string
local function table_to_csv(tbl)
    local lines = {}
    for _, row in pairs(tbl) do
        local line = {}
        for _,key in ipairs(keys) do
            table.insert(line, escape_csv(row[key]))
        end
        table.insert(lines, table.concat(line, ","))
    end
    return table.concat(lines, "\n")
end

-- Write to file
local csv_string = table_to_csv(canvas.pages)
local file = io.open("get/avc-pages-output.csv", "w")
file:write(csv_string)
file:close()


for title,page in pairs(canvas.pages) do
  local xx = canvas:get_page_by_title(title)
  local file = io.open("pages/"..page.url..".html", "w")
  if xx.body then
    print("Writing: ".."pages/"..page.url..".html")
    file:write(xx.body)
  else
    print("\n\nNo BODY in following page:\n")
    dump(xx)
  end
  file:close()
end
