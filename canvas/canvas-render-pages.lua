local csv = require("csv")
local dump = require("pl.pretty").dump
local canvas  = require("canvas-lms"):new("canvas-config.lua")

canvas:get_files()
canvas:get_pages()

-- Replace {{key}} in template
local function render_template(template, values, modtopcon)
  local template = template
  values.canvas_topic_page_name = values.T .. ". " .. values.Topic
  if canvas.pages[values.canvas_topic_page_name] == nil then
    values.canvas_topic_page_name = values.Module .. " — " .. values.Topic
  end
  values.canvas_topic_page_url = canvas.url .. canvas.course_prefix .. "pages/" .. canvas.pages[values.canvas_topic_page_name].url
  values.canvas_topic_page_api = canvas.url_api .. canvas.course_prefix .. "pages/" .. canvas.pages[values.canvas_topic_page_name].url
  values.canvas_concept_page_name = values.T .. "." .. values.C .. " " .. values.Concept
  values.canvas_concept_page_url = canvas.url_api .. canvas.course_prefix .. "pages/" .. canvas.pages[values.canvas_concept_page_name].url
  
  if tonumber(values.C) > 1 then
    values.canvas_concept_cont = " [continued]"
  else
    values.canvas_concept_cont = ""
  end
  local Cnext = string.format("%i",values.C+1)
  local Cprev = string.format("%i",values.C-1)
  if modtopcon[values.M][values.T][Cnext] == nil then
    values.canvas_next_concept_page_name = ""
    values.canvas_next_concept_page_url = ""
    values.canvas_next_concept_page_api = ""
  else
    values.canvas_next_concept_page_name = (values.T) .. "." .. Cnext .. " " .. modtopcon[values.M][values.T][Cnext].Concept
    values.canvas_next_concept_page_api = canvas.url_api .. canvas.course_prefix .. "pages/" .. canvas.pages[values.canvas_next_concept_page_name].url
    values.canvas_next_concept_page_url = canvas.url .. canvas.course_prefix .. "pages/" .. canvas.pages[values.canvas_next_concept_page_name].url
  end
  if modtopcon[values.M][values.T][Cprev] == nil then
    values.canvas_prev_concept_page_name = ""
    values.canvas_prev_concept_page_url = ""
    values.canvas_prev_concept_page_api = ""
  else
    values.canvas_prev_concept_page_name = (values.T) .. "." .. Cprev .. " " .. modtopcon[values.M][values.T][Cprev].Concept
    values.canvas_prev_concept_page_api = canvas.url_api .. canvas.course_prefix .. "pages/" .. canvas.pages[values.canvas_prev_concept_page_name].url
    values.canvas_prev_concept_page_url = canvas.url .. canvas.course_prefix .. "pages/" .. canvas.pages[values.canvas_prev_concept_page_name].url
  end

  dump(values)
  template = template:gsub("{{%s*FileUrl%((.-)%)%s*}}",
    function(key)
      local cfile = canvas.files[values[key]] or {}
      return cfile.url or "MISSING"
    end
  )
  template = template:gsub("{{%s*FileUrlBase%((.-)%)%s*}}",
    function(key)
      local cfile = canvas.files[values[key]] or {}
      return canvas.url_api .. canvas.course_prefix .. "files/" .. cfile.id 
    end
  )
  template = template:gsub("{{%s*(.-)%s*}}",
    function(key)
      return values[key] or "MISSING"
    end
  )
  template = template:gsub(
    '<p>%s*<a%s+[^>]-title=""%s+href=""[^>]->.-</a>%s*</p>',
    '<p>&nbsp;</p>'
  )
  return template
end

-- MAIN

local template_file = io.open("template-concept.html", "r")
local template_text = template_file:read("*a")
template_file:close()

local f = csv.open("template-concept-pages.csv")
local cc = 0
local modtopcon = {}
local rowtbl = {}
local hdr = {}

for row in f:lines() do
  cc = cc+1
  if cc == 1 then
    for i,v in ipairs(row) do
      hdr[i] = v
    end
  else
    for i,v in ipairs(row) do
      rowtbl[hdr[i]] = v
    end
    modtopcon[rowtbl.M] = modtopcon[rowtbl.M] or {}
    modtopcon[rowtbl.M][rowtbl.T] = modtopcon[rowtbl.M][rowtbl.T] or {}
    modtopcon[rowtbl.M][rowtbl.T][rowtbl.C] = {}
    modtopcon[rowtbl.M][rowtbl.T][rowtbl.C].Module = rowtbl.Module
    modtopcon[rowtbl.M][rowtbl.T][rowtbl.C].Topic = rowtbl.Topic
    modtopcon[rowtbl.M][rowtbl.T][rowtbl.C].Concept = rowtbl.Concept
  end
end

local f = csv.open("template-concept-pages.csv")
local cc = 0
for row in f:lines() do
  cc = cc+1
  if cc > 1 then
    for i,v in ipairs(row) do
      rowtbl[hdr[i]] = v
    end
    local rendered = render_template(template_text, rowtbl, modtopcon)
    local filename = row[2] .. "-dot-" .. row[3] .. "-" .. row[7]
    local out = io.open("upload/" .. filename .. ".html", "w")
    out:write(rendered)
    out:close()
  end
end

