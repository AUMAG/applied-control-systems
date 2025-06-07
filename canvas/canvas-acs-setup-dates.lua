#!/usr/local/bin/lua

local lms  = require("canvas-lms")
canvas = lms:new()

local pretty  = require("pl.pretty")

print("Update file dates? 'y' to do so, anything else to skip")
if io.read() == "y" then

  canvas:get_files{ download = false }

  local function wk(week)
    _,wkdate = canvas:datetime{
      week = week , day  = "mon-next"  , hour = 9 ,
    }
    return wkdate
  end

  for ii = 1,12 do
    local notes = "pid-tute-week"..ii.."-notes.pdf"
    if not(canvas.files[notes] == nil) then
      canvas:update_file(notes,{unlock_at=wk(ii)})
    end
  end

end


print("Update module dates? 'y' to do so, anything else to skip")
if io.read() == "y" then

  canvas:get_modules{ download = false }

  local function wk(week)
    _,wkdate = canvas:datetime{
      week = week , day  = "mon-2wk"  , hour = 9 ,
    }
    return wkdate
  end

  for ii = 1,12 do

    wkstr = "Week "..string.format("%02i",ii)
    print("Updating module '"..wkstr.."'")
    canvas:update_module(wkstr,{unlock_at=wk(ii)})

  end

end
