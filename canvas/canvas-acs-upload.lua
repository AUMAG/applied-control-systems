#!/usr/local/bin/lua

local canvas  = require("canvas-lms"):new("canvas-config.lua")
local dump = require "pl.pretty".dump

local dir = require("pl.dir")
local path = require("pl.path")

local folder = "../Slides/_upload/"  
local files = dir.getfiles(folder)

print("Upload practicals? Type 'y' for yes.")
pracbool = io.read() == "y"
if not(pracbool) then print("Skipping practicals") else print("Uploading practicals") end
print("Upload workshops? Type 'y' for yes.")
workbool = io.read() == "y"
if not(pracbool) then print("Skipping workshops") else print("Uploading workshops") end
print("Upload slides? Type 'y' for yes.")
slidbool = io.read() == "y"
if not(pracbool) then print("Skipping slides") else print("Uploading slides") end

-- Loop through each file and check for .pdf extension
for _, file in ipairs(files) do
    if path.extension(file):lower() == ".pdf" then
        local prac = file:match(".*prac.*")
        local work = file:match(".*workshop.*")
        if pracbool and prac then
            print("Uploading practical PDF:", file)
            canvas:file_upload({filename = file,folder = "Practicals"})
        elseif workbool and work then
            print("Uploading workshop PDF:", file)
            canvas:file_upload({filename = file,folder = "Workshops"})
        elseif slidbool then
            print("Uploading slides PDF:", file)
            canvas:file_upload({filename = file,folder = "Slides"})
        end
    end
end

