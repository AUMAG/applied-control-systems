#!/usr/local/bin/lua

local lms  = require("canvas-lms")
canvas = lms:new()

local pretty  = require("pl.pretty")

print("# RUBRICS")

canvas:get_rubrics{download=true}

pretty.dump(canvas.rubrics)

--canvas:delete_all_rubrics()

--canvas:setup_csv_rubrics{ csv = {"rubric-project","rubric-prac-workbook"} }
