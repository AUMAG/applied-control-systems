#!/usr/local/bin/lua

local canvas  = require("canvas-lms"):new("canvas-config.lua")
local dump = require "pl.pretty".dump

local dir = require("pl.dir")
local path = require("pl.path")

-- Check for the CLI argument (file to upload)
local file_to_upload = arg[1]  -- arg[1] is the first command-line argument
if not file_to_upload then
    print("Error: No file specified. Please provide a file to upload.")
    os.exit(1)  -- Exit if no file is provided
end

print("Uploading file:", file_to_upload)

local folder = "./"  
local files = dir.getfiles(folder)

if files == nil then
  error("No files in upload folder: "..folder)
end

do
    file = file_to_upload
    print(file)
    local prac = file:match(".*prac.*")
    local work = file:match(".*workshop.*")
    local extra = file:match(".*extra/.*")
    
    if prac then
        print("Uploading practical PDF:", file)
        xx = canvas:file_upload({filename = file, folder = "Practicals"})
    elseif work then
        print("Uploading workshop PDF:", file)
        xx = canvas:file_upload({filename = file, folder = "Workshops"})
    elseif extra then
        print("Uploading workshop PDF:", file)
        xx = canvas:file_upload({filename = file, folder = "Extra"})
    else
        print("Uploading slides PDF:", file)
        xx = canvas:file_upload({filename = file, folder = "Slides"})
    end
    dump(xx)
end
