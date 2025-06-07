#!/usr/local/bin/lua

local canvas  = require("canvas-lms"):new("canvas-config.lua")
local dump = require "pl.pretty".dump

xx = canvas:get(canvas.course_prefix,{include = "syllabus_body"})
dump(xx)

--
--canvas:get_assignments()
--
--dump(canvas.assignments)
--
--local duehr    = "24"
--local lockhr   = "24"
--local unlockhr = "08"
--
--for ii = 3,3 do
--  canvas:create_assignment {
--                        assign_group = "Quizzes" ,
--                                name = "Lecture quiz week "..ii ,
--                                 due = {
--                                         week = ii ,
--                                          day = "fri-next" ,
--                                       },
--                               duehr = duehr ,
--                              lockhr = lockhr ,
--                            unlockhr = unlockhr ,
--                           late_days =  1 ,
--                              points = "10",
--                              mobius = true,
--  }
--end
--
