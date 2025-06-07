#!/usr/local/bin/lua

local canvas  = require("canvas-lms"):new("canvas-config.lua")
local dump = require "pl.pretty".dump

canvas:get_files()

-- Function to escape values (basic CSV escaping)
local function escape_csv(val)
    val = tostring(val)
    if val:find("[,\"]") then
        val = '"' .. val:gsub('"', '""') .. '"'
    end
    return val
end

keys = {"filename","id","url"}

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
local csv_string = table_to_csv(canvas.files)
local file = io.open("get/acs-canvas-files.csv", "w")
file:write(csv_string)
file:close()
