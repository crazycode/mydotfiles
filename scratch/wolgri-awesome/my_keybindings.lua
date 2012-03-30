-- {{{ Key bindings
globalkeys = awful.util.table.join(
--    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
--    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "Left",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "Right",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
--    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation--{{{
    awful.key({ modkey, "Shift"   }, "Left", function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift"   }, "Right", function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey, "Control" }, "Left", function () awful.screen.focus( 1)       end),
    awful.key({ modkey, "Control" }, "Right", function () awful.screen.focus(-1)       end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
--}}}
    -- Standard program--{{{
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "Down",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "Up",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "Up",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "Down",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "Up",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "Down",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
--}}}
    -- Prompt--{{{
    awful.key({ modkey },            "F1",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "F2",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)
--}}}
-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them--{{{
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,   }, "w",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey }, "t", awful.client.togglemarked),
    awful.key({ modkey,}, "F5",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)
--}}}
--{{{ Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    table.foreach(awful.key({ modkey }, i,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end), function(_, k) table.insert(globalkeys, k) end)
    table.foreach(awful.key({ modkey, "Control" }, i,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          tags[screen][i].selected = not tags[screen][i].selected
                      end
                  end), function(_, k) table.insert(globalkeys, k) end)
    table.foreach(awful.key({ modkey, "Shift" }, i,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end), function(_, k) table.insert(globalkeys, k) end)
    table.foreach(awful.key({ modkey, "Control", "Shift" }, i,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end), function(_, k) table.insert(globalkeys, k) end)
    table.foreach(awful.key({ modkey, "Shift" }, "F" .. i,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          for k, c in pairs(awful.client.getmarked()) do
                              awful.client.movetotag(tags[screen][i], c)
                          end
                      end
                   end), function(_, k) table.insert(globalkeys, k) end)
end
--}}}
-- Set keys
root.keys(globalkeys)
-- }}}
--{{{ Fn keys  
table.insert(globalkeys, key({ }, "XF86AudioRaiseVolume", function () volume("up", pb_volume) end))
table.insert(globalkeys, key({ }, "XF86AudioLowerVolume", function () volume("down", pb_volume) end))
table.insert(globalkeys, key({ }, "XF86AudioMute", function () volume("mute", pb_volume) end))
table.insert(globalkeys, key({none}, "XF86AudioPlay", function () awful.util.spawn("mpc --no-status toggle") end))
table.insert(globalkeys, key({none}, "XF86AudioNext", function () awful.util.spawn("mpc --no-status next") end))
table.insert(globalkeys, key({none}, "XF86AudioStop", function () awful.util.spawn("mpc --no-status stop ") end))
table.insert(globalkeys, key({none}, "XF86AudioPrev", function () awful.util.spawn("mpc --no-status prev ") end))
table.insert(globalkeys, key({none}, "XF86Sleep", function () awful.util.spawn("sudo pm-suspend --quirk-dpms-on --quirk-vbestate-restore --quirk-vbemode-restore") end))
table.insert(globalkeys, key({none}, "XF86Start", function () awful.util.spawn("sudo cpufreq-set -g ondemand") end))
table.insert(globalkeys, key({none}, "XF86Battery", function () awful.util.spawn("sudo cpufreq-set -g powersave") end))
table.insert(globalkeys, key({none}, "XF86WWW", function () awful.util.spawn(wwwbrowser) end))
table.insert(globalkeys, key({none}, "XF86Mail", function () awful.util.spawn(emailclient) end))
table.insert(globalkeys, key({none}, "XF86Launch1", function () mymainmenu:show(true) end))
--}}}
--{{{ rotate clients and focus master...
table.insert(globalkeys, key({ modkey }, "Tab", function ()
    local allclients = awful.client.visible(client.focus.screen)
  
    for i,v in ipairs(allclients) do
      if allclients[i+1] then
        allclients[i+1]:swap(v)
      end
    end
    awful.client.focus.byidx(-1)
  end))

-- ... the other way 'round!
table.insert(globalkeys, key({ modkey, "Shift" }, "Tab", function ()
    local allclients = awful.client.visible(client.focus.screen)
    local toswap

    for i,v in ipairs(allclients) do
      if toswap then
        toswap:swap(v)
        toswap = v
      else
        toswap = v
      end
    end
    awful.client.focus.byidx(-1)
  end))
--}}}
-- Show some client infos in a naughy box--{{{
-- Collect client infos
function get_fixed_client_infos(c)
    local txt = ""
    if c.name then txt = txt .."Name:".. c.name .. "\n" end
    if c.pid then txt = txt .."PID:".. c.pid .. "\n" end
    if c.class then txt = txt .."Class:".. c.class .. "\n" end
    if c.instance then txt = txt .."Instance:".. c.instance .. "\n" end
    if c.role then txt = txt .."Role:".. c.role .. "\n" end
    if c.type then txt = txt .."Type:".. c.type .. "\n" end
    return txt
end

function get_dyn_client_infos(c)
    local txt = ""
    if c.screen then txt = txt .."Screen: ".. c.screen .. "\n" end
    if awful.client.floating.get(c) then txt = txt .."Floating\n" end
    if c.ontop then txt = txt .."On top\n" end
    if c.fullscreen then txt = txt .."Fullscreen\n" end
    if c.titlebar then txt = txt .."Titlebar\n" end
    if c.opacity then txt = txt .. "Opacity: " .. c.opacity .. "\n" end
    if c.icon_path then txt = txt .."Icon_path: ".. c.icon_path .. "\n" end
    return txt
end


function show_client_infos(c)
    local c
    if _c then
        c = _c
    else
        c = client.focus
    end
    txt = get_fixed_client_infos(c)
    txt = txt .. "\n" .. get_dyn_client_infos(c)
    naughty.notify({ title = "Client info", text = txt, timeout = 6 })
end
table.insert(globalkeys, key({ modkey, "Control" }, "i", show_client_infos))

--}}}
-- {{{ Toggle ontop
table.insert(clientkeys, key({ modkey }, "a", function (c) if c.ontop then c.ontop = false else c.ontop = true end end))
-- }}}

table.insert(clientkeys, key({ modkey, "Shift" }, "t", function (c) if c.titlebar then awful.titlebar.remove(c) else awful.titlebar.add(c, { modkey = "Mod1" }) end end))

root.keys(globalkeys)
