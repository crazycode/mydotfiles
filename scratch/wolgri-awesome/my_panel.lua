
--{{{ Tools
--{{{splitbywhitespace stolen from wicked.lua
function splitbywhitespace(str) 
     values = {}
     start = 1
     splitstart, splitend = string.find(str, ' ', start)

     while splitstart do
            m = string.sub(str, start, splitstart-1)
            if m:gsub(' ','') ~= '' then
                 table.insert(values, m)
            end

            start = splitend+1
            splitstart, splitend = string.find(str, ' ', start)
     end

     m = string.sub(str, start)
     if m:gsub(' ','') ~= '' then
            table.insert(values, m)
     end

     return values
end
--}}}

 -- Set foreground color
 function fg(color, text)
   return '<span color="' .. color .. '">' .. text .. '</span>'
 end

 -- Boldify text
 function bold(text)
   return '<b>' .. text .. '</b>'
 end

 -- Widget value
 function widget_value(content, next_value)
   local value
   if content and content ~= nil then
     value = content
     if next_value and next_value ~= "" then
       value = value .. fg(hilight, " / ") .. next_value
     end
   else
     value = next_value
   end
   return value
 end
--}}}

--{{{Widgets
--{{{ Spacer
local bg_color = beautiful.bg_normal
tb_space= widget({ type = 'textbox', name = 'tb_space'})
tb_space.width = "4"
tb_space.text = ""

tb_spacer= widget({ type = 'textbox', name = 'tb_spacer',align = 'right' })
tb_spacer.width = "6"
tb_spacer.text = tb_space.text

--}}}

--{{{ Batt
pb_bat = widget({ type = 'progressbar', name = 'pb_bat' })
pb_bat.width = 60
pb_bat.height = 0.6
pb_bat.gap = 1
pb_bat.border_padding = 0
pb_bat.border_width = 1
pb_bat.ticks_count = 10
pb_bat.ticks_gap = 1
pb_bat.vertical = false
pb_bat:bar_properties_set('bat', {

bg = beautiful.fg_urgent,
fg = beautiful.bat_fg,
fg_off = beautiful.color_red,
reverse = false,
min_value = 0,
max_value = 100
})

--}}}
tb_bat = widget({ type = 'textbox', name = 'tb_bat' , align = 'left'})
--{{{ batt function
local function get_bat()
   local a = io.open("/sys/class/power_supply/BAT1/charge_full")
    for line in a:lines() do
            full = line
       end 
    a:close()
 local b = io.open("/sys/class/power_supply/BAT1/charge_now")
    for line in b:lines() do
            now = line
       end 
    b:close()
batt=math.floor(now*100/full)

            if tonumber(batt) <= 10 
            then
                naughty.notify({ title      = "Battery Warning"
                               , text       = "Battery low! "..batt.."% left!"
                               , timeout    = 30
                               , position   = "top_right"
                               , fg         = beautiful.color_red
                               , bg         = beautiful.fg_focus
                               })
            end
            batt = batt

pb_bat:bar_data_add("bat",batt )
tb_bat.text ="<span font_desc='sans bold 8'>"..batt.."% </span>"
end
--}}}

--{{{ temp
tb_temp = widget({ type = 'textbox', name = 'tb_fq' , align = 'left' })
--}}}
--{{{ temp function
function get_temp()
    local m = io.popen("echo \"scale=0 ;`cat /sys/bus/pci/drivers/k8temp/*/temp1_input`/1000 \"| bc -l")
      for line in m:lines() do
            temp = line
      end    

    m:close()
tb_temp.text =""..temp.."°"
end 
--}}} 

--{{{ Cpu freq
tb_fq = widget({ type = 'textbox', name = 'tb_fq' , align = 'left'})
--}}}
--{{{ Cpu freq function
function get_cfreq()
    local m = io.popen("cpufreq-info -fm")
      for line in m:lines() do
            cfreq = line
      end    

    m:close()
tb_fq.text ="<span font_desc='sans bold 8'>"..cfreq.."</span>"
end 
--}}} 

--{{{ Cpu

gr_cpu0 = widget({ type = 'graph', name = 'gr_cpu0', align = 'left' }) 
gr_cpu0.height = 0.8
gr_cpu0.width = 60
gr_cpu0.bg = beautiful.bg_focus
gr_cpu0.border_color = beautiful.fg_urgent
gr_cpu0.grow = 'left'

gr_cpu0:plot_properties_set('cpu', { 
style ='line',
fg = beautiful.border_marked,
fg_center = beautiful.color_green, 
fg_end = beautiful.color_cyan, 
vertical_gradient = true 
})
gr_cpu1 = widget({ type = 'graph', name = 'gr_cpu1', align = 'left' }) 
gr_cpu1.height = 0.8
gr_cpu1.width = 60
gr_cpu1.bg = beautiful.bg_focus
gr_cpu1.border_color = beautiful.fg_urgent
gr_cpu1.grow = 'left'

gr_cpu1:plot_properties_set('cpu', { 
style ="line",
fg = beautiful.border_marked,
fg_center = beautiful.color_green, 
fg_end = beautiful.color_cyan, 
vertical_gradient = true 
})
--}}}
--{{{cpu function
cpu0_total = 0
cpu0_active = 0
cpu1_total = 0
cpu1_active = 0

function get_cpu()
    -- Return CPU usage percentage
    ---- Get /proc/stat
    local f = io.open('/proc/stat')
    for l in f:lines() do
    cpu_usage = splitbywhitespace(l)
    if cpu_usage[1] == "cpu0" then
            ---- Calculate totals
            total_new = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]+cpu_usage[5]
            active_new = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]
            
            ---- Calculate percentage
            diff_total = total_new-cpu0_total
            diff_active = active_new-cpu0_active
            usage_percent = math.floor(diff_active/diff_total*100)

            ---- Store totals
            cpu0_total = total_new
            cpu0_active = active_new
            
            gr_cpu0:plot_data_add("cpu",usage_percent)
     elseif cpu_usage[1] == "cpu1" then
            ---- Calculate totals
            total_new = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]+cpu_usage[5]
            active_new = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]
            
            ---- Calculate percentage
            diff_total = total_new-cpu1_total
            diff_active = active_new-cpu1_active
            usage_percent = math.floor(diff_active/diff_total*100)

            ---- Store totals
            cpu1_total = total_new
            cpu1_active = active_new

            gr_cpu1:plot_data_add("cpu",usage_percent)
        
    end

end
f:close()
end
--}}} 

--{{{MeM 
pb_mem = widget({ type = 'progressbar', name = 'pb_mem', align = 'left' })

pb_mem.width = 40
pb_mem.height = 0.8
pb_mem.gap = 1
pb_mem.border_padding = 0
pb_mem.border_width = 1
pb_mem.ticks_count = 10
pb_mem.ticks_gap = 1
pb_mem.vertical = false
pb_mem.grow = "left"
pb_mem:bar_properties_set('mem',
{
    ["bg"] = beautiful.fg_urgent ,
    ["fg_off"] = beautiful.bg_focus ,
    ["fg"] = beautiful.color_green ,
    ["reverse"] = false,
    ["min_value"] = 0,
    ["max_value"] = 100
})

--}}}
tb_mem = widget({ type = 'textbox', name = 'tb_mem' , align = 'left'})
--{{{ mem function
function get_mem()
  local mem_free, mem_total, mem_c, mem_b
  local mem_percent, swap_percent, line, fh, count
  count = 0

  fh = io.open("/proc/meminfo")

  line = fh:read()
  while line and count < 4 do
    if line:match("MemFree:") then
      mem_free = string.match(line, "%d+")
      count = count + 1;
    elseif line:match("MemTotal:") then
      mem_total = string.match(line, "%d+")
      count = count + 1;
    elseif line:match("Cached:") then
      mem_c = string.match(line, "%d+")
      count = count + 1;
    elseif line:match("Buffers:") then
      mem_b = string.match(line, "%d+")
      count = count + 1;
    end
    line = fh:read()
  end
  io.close(fh)

  mem_percent = 100 * (mem_total - mem_free - mem_b - mem_c ) / mem_total;
 pb_mem:bar_data_add("mem",mem_percent)
 tb_mem.text ="<span font_desc='sans bold 8'>"..mem_percent.."</span>"

end
--}}}

--{{{Date
  tb_date = widget({type = 'textbox',name = 'tb_date',align = "right"  })
--}}}
--{{{ date function 
function hook_timer ()
    os.setlocale(os.getenv("LC_ALL"))
    tb_date.text ="<span font_desc='terminus 7'>"..os.date(' %a%d%b').."</span><span font_desc='sans bold 8'>"..os.date(' %H:%M').."</span>"

end
-- }}}

--{{{ Volume
 pb_volume =  widget({ type = "progressbar", name = "pb_volume", align = "right" })
 pb_volume.width = 40
 pb_volume.height = 0.80
 pb_volume.border_padding = 1
 pb_volume.ticks_count = 10
 pb_volume.vertical = false
 
 pb_volume:bar_properties_set("vol", 
 { 
   ["bg"] = "#000000",
   ["fg"] = "#6666cc",
   ["fg_off"] = "#000000",
   ["border_color"] = "#999933"
 })
pb_volume:buttons({
     button({ }, 4, function () volume("up", pb_volume) end),
     button({ }, 5, function () volume("down", pb_volume) end),
     button({ }, 1, function () volume("mute", pb_volume) end)
 })

--}}}
--{{{ Volume function 
cardid  = 0
channel = "Master"

 function volume (mode, widget)
    if mode == "update" then
        local status = io.popen("amixer -c " .. cardid .. " -- sget " .. channel):read("*all")
        
        local volume = string.match(status, "(%d?%d?%d)%%")
        status = string.match(status, "%[(o[^%]]*)%]")
        if string.find(status, "on", 1, true) then
            widget:bar_properties_set("vol", {["bg"] = "#000000"})
        else
            widget:bar_properties_set("vol", {["bg"] = "#cc3333"})
        end
        widget:bar_data_add("vol", volume)
    elseif mode == "up" then
        awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%+")
        volume("update", widget)
    elseif mode == "down" then
        awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%-")
        volume("update", widget)
    else
        awful.util.spawn("amixer -c " .. cardid .. " sset " .. channel .. " toggle")
        volume("update", widget)
    end
 end
volume("update", pb_volume);

--}}}
--}}}

-- {{{My panel
-- Create a botbox for each screen and add it
botbox = {}
botbox[1] = wibox({ position = "bottom", name = "botbox" .. 1 , height = "14", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
-- Add widgets to the wibox - order matters
if usemode=="laptop" then 
	botbox[1].widgets = {
	tb_temp,tb_space,
	tb_fq,tb_space,
	gr_cpu0,tb_space,
	gr_cpu1,tb_space,
	pb_mem,tb_space,
	pb_bat,tb_space,tb_bat,
	pb_volume,
	tb_date
	   }
   else	   
	botbox[1].widgets = {
	gr_cpu0,tb_space,
	gr_cpu1,tb_space,
	pb_mem,tb_space,
	pb_volume,
	tb_date
	   }
   end
botbox[1].screen = 1

--}}}

--{{{Timers
awful.hooks.timer.register(1, hook_timer)
awful.hooks.timer.register(1, get_mem)
awful.hooks.timer.register(1, get_cpu)
if usemode=="laptop" then
	awful.hooks.timer.register(1, get_cfreq)
	awful.hooks.timer.register(3, get_bat)
	awful.hooks.timer.register(3, get_temp)
end
--}}}

