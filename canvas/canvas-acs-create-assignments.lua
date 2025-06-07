#!/usr/local/bin/lua

local lms  = require("canvas-lms")
canvas = lms:new()

canvas:get_rubrics{download=true}
canvas:get_assignments{download=true}

print("Create/update workbooks? 'y' to do so, anything else to skip")
if io.read() == "y" then

  local function create_lab_workbook(arg)

  local lab_workbook_descr = [[
  Please submit your Practical Workbook here. Only one person needs to upload per group, but please put the names and IDs of all group members in the table at the top of the workbook.
  ]]

  canvas:create_assignment {
                        assign_group = "Workbooks" ,
                                name = "Practical workbook "..arg.N ,
                                due = {
                                week = arg.week ,
                                 day = "fri-next" ,
                                      },
                           open_days = 14 ,
                           late_days = 3 ,
                         description = lab_workbook_descr,
                              rubric = "ACS Practical Workbook" ,
  }

  end

  create_lab_workbook{N=1,week=2}
  create_lab_workbook{N=2,week=4}
  create_lab_workbook{N=3,week=6}

end



local assignname
local wk;
local dueday
local duehr    = "24"
local lockhr   = "24"
local unlockhr = "08"

local availdays = 14
local latedays  = 3

print("Create/update assignments? 'y' to do so, anything else to skip")
if io.read() == "y" then

  local assign_mobius_descr = [[
  Each assignment is automatically assessed using Mobius and must be accompanied by your
  individual Matlab code used for completing the assignment. This MyUni assignment is to
  access and answer the Mobius questions; you must navigate to the "Workbook" submission
  for the corresponding assignment to upload your code.

  Missing or non-compliant workbooks may incur a penalty on the assignment grade.
  ]]

  local assign_workbook_descr = [[
  Each assignment is automatically assessed using Mobius and must be accompanied by your
  individual Matlab code used for completing the assignment. Using Matlab's "Live Scripts"
  or m-file "Publish" feature to create a "pretty" version of your code and results/output,
  save that to PDF, and upload here.

  Workbook submissions MUST contain metadata such as title, student name, and student ID.
  Missing or non-compliant workbooks may incur a penalty on the assignment grade.
  ]]

  local assign = {}
  assign[1] = { due_week =  3 , points = "38" }
  assign[2] = { due_week =  6 , points = "48" }
  assign[3] = { due_week =  9 , points = "62" }

  for ii = 1,3 do
    assignname = "Assignment "..ii
    dueday   = "fri"
    wk = assign[ii].due_week
    canvas:create_assignment {
                          assign_group = assignname ,
                                  name = assignname ,
                                  week = wk ,
                                   day = dueday ,
                                 duehr = duehr ,
                                lockhr = lockhr ,
                              unlockhr = unlockhr ,
                             open_days = availdays ,
                             late_days = latedays ,
                                points = assign[ii].points,
                                mobius = true ,
                           description = assign_mobius_descr,
    }
    canvas:create_assignment {
                          assign_group = assignname ,
                                  name = assignname.." workbook" ,
                                  week = wk ,
                                   day = dueday ,
                                 duehr = duehr ,
                                lockhr = lockhr ,
                              unlockhr = unlockhr ,
                             open_days = availdays ,
                             late_days = latedays ,
                                points = "1" ,
                 omit_from_final_grade = true ,
                           description = assign_workbook_descr,
                                rubric = "ACS Practical Workbook" ,
    }
  end

end

print("Create/update exam? 'y' to do so, anything else to skip")
if io.read() == "y" then

    assignname = "Mock exam"
    dueday   = "fri"
    canvas:create_assignment {
                          assign_group = assignname ,
                                  name = assignname ,
                                  week = 13 ,
                                   day = dueday ,
                                 duehr = duehr ,
                                lockhr = lockhr ,
                              unlockhr = unlockhr ,
                             open_days = availdays ,
                             late_days = latedays ,
                                points = 0,
                                mobius = true ,
                           description = [[
As a mock exam, it is intended to replicate most of the experience you'll have when you take the online exam. It can only be attempted once and has a 6 hour time limit — you can start it whenever you like, but the clock will start ticking as soon as you enter it in the Mobius site. The material is not intended to take 6 hours, I just want you to see how the interface works.
]],
    }


    assignname = "Computer exam"
    dueday   = "fri"
    canvas:create_assignment {
                          assign_group = assignname ,
                                  name = assignname ,
                                  week = 15 ,
                                   day = dueday ,
                                 duehr = duehr ,
                                lockhr = lockhr ,
                              unlockhr = unlockhr ,
                             open_days = 0 ,
                             late_days = 0 ,
                                points = 100 ,
                                mobius = true ,
                           description = [[
This is a placeholder for the final computer exam.
]],
    }

end


print("Create/update prac project? 'y' to do so, anything else to skip")
if io.read() == "y" then

  canvas:create_assignment {
                         assign_group = "Project" ,
                                 name = "Practical project report" ,
                                 week = 11 ,
                                  day = "fri" ,
                                duehr = duehr ,
                               lockhr = lockhr ,
                             unlockhr = unlockhr ,
                            open_days = 21 ,
                            late_days = 10 ,
                               points = "100",
                               rubric = "ACS Practical Project" ,
  }
  canvas:create_assignment {
                        assign_group = "Project" ,
                                name = "Practical project group evaluation" ,
                                week = 11 ,
                                 day = "mon-next" ,
                               duehr = duehr ,
                              lockhr = lockhr ,
                            unlockhr = unlockhr ,
                           open_days =  7 ,
                           late_days =  7 ,
                              points = "0",
                         assign_type = "external_tool" ,
  }

end




print("Create/update quizzes? 'y' to do so, anything else to skip")
if io.read() == "y" then

  local quiz_points = {8,4,10,7,6,6,4,7,5,10,4}
  for ii = 1,11 do
    canvas:create_assignment {
                          assign_group = "Quizzes" ,
                                  name = "Lecture quiz week "..ii ,
                                   due = {
                                           week = ii ,
                                            day = "mon-next" ,
                                         },
                                 duehr = duehr ,
                                lockhr = lockhr ,
                              unlockhr = unlockhr ,
                             late_days =  1 ,
                                points = quiz_points[ii],
                                mobius = true ,
    }
  end

end
