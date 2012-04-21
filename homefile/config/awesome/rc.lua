-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")

-- Eminent is a small lua library with effortless and quick wmii-style dynamic tagging.
require("eminent")

-- Notification library
require("naughty")

require("vicious")
require("revelation")
require("util")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "start-tmux"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local altkey = "Mod1"
modkey = "Mod4"


-- custome naughty
naughty.config.default_preset.timeout          = 8
naughty.config.default_preset.screen           = 1
naughty.config.default_preset.position         = "bottom_right"
naughty.config.default_preset.margin           = 4
naughty.config.default_preset.gap              = 1
naughty.config.default_preset.ontop            = true
-- naughty.config.default_preset.icon             = nil
-- naughty.config.default_preset.font             = beautiful.font or "Verdana 12"
-- naughty.config.default_preset.fg               = beautiful.fg_focus or '#ffffff'
-- naughty.config.default_preset.bg               = beautiful.bg_focus or '#535d6c'
-- naughty.config.presets.normal.border_color     = beautiful.border_focus or '#535d6c'
naughty.config.default_preset.hover_timeout    = nil

naughty.config.default_preset.height           = 180
naughty.config.default_preset.width            = 900
naughty.config.default_preset.font             = "Verdana 12"
naughty.config.default_preset.fg               = '#ffffff'
naughty.config.default_preset.bg               = '#535d6c'
naughty.config.presets.normal.border_color     = '#535d6c'
naughty.config.default_preset.border_width     = 1
naughty.config.default_preset.icon_size       = 64

-- Urgency level specification
-- low
naughty.config.presets.low.timeout          = naughty.config.default_preset.timeout
naughty.config.presets.low.height           = naughty.config.default_preset.height
naughty.config.presets.low.width            = naughty.config.default_preset.width
naughty.config.presets.low.position         = naughty.config.default_preset.position
naughty.config.presets.low.font             = naughty.config.default_preset.font
naughty.config.presets.critical.fg          = naughty.config.default_preset.fg
naughty.config.presets.critical.bg          = naughty.config.default_preset.bg
naughty.config.default_preset.border_width  = naughty.config.default_preset.border_width
naughty.config.default_preset.hover_timeout = naughty.config.default_preset.hover_timeout
-- critical
naughty.config.presets.critical.timeout     = 0
naughty.config.presets.critical.height      = naughty.config.default_preset.height
naughty.config.presets.critical.width       = naughty.config.default_preset.width
naughty.config.presets.critical.position    = naughty.config.default_preset.position
naughty.config.presets.critical.font        = naughty.config.default_preset.font
naughty.config.presets.critical.fg          = '#eeeeee'
naughty.config.presets.critical.bg          = '#ff0000'
naughty.config.default_preset.border_width  = naughty.config.default_preset.border_width
naughty.config.default_preset.hover_timeout = nil

secound_screen = 1
if screen.count() > 1 then
   secound_screen = 2
end

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.floating,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9, "W", "F", "IM", "E", "T" }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

space       = widget({ type = 'textbox' })
separator   = widget({ type = 'textbox' })
space.text = ' '
separator.text = '⋮'

-- Network usage widget
--netwidget = widget({ type = 'textbox' })
--vicious.register(netwidget, vicious.widgets.net, '<span color="#CC9393">${eth0 down_kb}</span> <span color="#7F9F7F">${eth0 up_kb}</span>', 3)

-- CPU usage widget (textbox)
-- cpuwidget = widget({ type = 'textbox' })
-- vicious.register(cpuwidget, vicious.widgets.cpu, '$1%')

-- CPU usage widget (graph)
cpuwidget = awful.widget.graph()
cpuwidget:set_width(50)
cpuwidget:set_height(30)
cpuwidget:set_background_color('#494B4F')
cpuwidget:set_color('#FF5656')
cpuwidget:set_gradient_colors({ '#FF5656', '#88A175', '#AECF96' })
vicious.register(cpuwidget, vicious.widgets.cpu, '$1')

-- Memory usage widget (textbox)
-- memwidget = widget({ type = 'textbox' })
-- vicious.register(memwidget, vicious.widgets.mem, '$1% ($2MB/$3MB)', 13)

-- Memory usage widget (graph)
memwidget = awful.widget.progressbar()
memwidget:set_width(60)
memwidget:set_height(30)
memwidget:set_background_color('#494B4F')
memwidget:set_border_color(nil)
memwidget:set_color('#AECF96')
memwidget:set_gradient_colors({ '#AECF96', '#88A175', '#FF5656' })
vicious.register(memwidget, vicious.widgets.mem, "$1", 13)

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        -- separator,
        -- netwidget,
        s == 1 and mysystray or nil,
        separator,
        memwidget.widget,
        separator,
        cpuwidget.widget,
        separator,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
--- Spawns cmd if no client can be found matching properties
-- If such a client can be found, pop to first tag where it is visible, and give it focus
-- @param cmd the command to execute
-- @param properties a table of properties to match against clients.  Possible entries: any properties of the client object
function run_or_raise(cmd, properties)
   local clients = client.get()
   local focused = awful.client.next(0)
   local findex = 0
   local matched_clients = {}
   local n = 0
   for i, c in pairs(clients) do
      --make an array of matched clients
      if match(properties, c) then
         n = n + 1
         matched_clients[n] = c
         if c == focused then
            findex = n
         end
      end
   end
   if n > 0 then
      local c = matched_clients[1]
      -- if the focused window matched switch focus to next in list
      if 0 < findex and findex < n then
         c = matched_clients[findex+1]
      end
      local ctags = c:tags()
      if table.getn(ctags) == 0 then
         -- ctags is empty, show client on current tag
         local curtag = awful.tag.selected()
         awful.client.movetotag(curtag, c)
      else
         -- Otherwise, pop to first tag client is visible on
         awful.tag.viewonly(ctags[1])
      end
      -- And then focus the client
      client.focus = c
      c:raise()
      return
   end
   awful.util.spawn(cmd)
end
-- Returns true if all pairs in table1 are present in table2
function match(table1, table2)
   for k, v in pairs(table1) do
      if table2[k] ~= v and not table2[k]:find(v) then
         return false
      end
   end
   return true
end

-- globalkeys define.
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey, "Shift"   }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    -- awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- ================ BEGIN my custom keybindings. (crazycode) ================

    awful.key({ modkey,           }, "Return", function () run_or_raise("start-tmux", { name = "tmux-main" }) end),

    awful.key({ modkey,           }, "f", function () run_or_raise("firefox", { class = "Firefox" }) end),
    awful.key({ modkey,           }, "w", function () run_or_raise("google-chrome", { class = "Google-chrome" }) end),
    awful.key({ modkey,           }, "p", function () run_or_raise("pidgin", { class = "Pidgin" }) end),


    -- CHANGE: 更好的dmenu
    awful.key({modkey }, "o", function() awful.util.spawn( "smart-dmenu" ) end),

    -- CHANGE: 执行或转到Emacs所在的tag
    awful.key({ modkey }, "e", function () run_or_raise("/usr/bin/emc", { class = "Emacs" }) end),

    -- Try IT!
    awful.key({ modkey }, "q",  revelation),

    -- CHANGE: print screen.
    awful.key({ modkey }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'") end),

    -- CHANGE: 锁定屏幕
    awful.key({ modkey }, "F12",
              function ()
                 awful.util.spawn("xlock")
              end),

    -- print info on current client
    awful.key({ modkey },    "i",        function ()
                                      local c = client.focus
                                      if not c then
                                         return
                                      end

                                      local geom = c:geometry()

                                      local t = ""
                                      if c.class then t = t .. "Class: " .. c.class .. "\n" end
                                      if c.instance then t = t .. "Instance: " .. c.instance .. "\n" end
                                      if c.role then t = t .. "Role: " .. c.role .. "\n" end
                                      if c.name then t = t .. "Name: " .. c.name .. "\n" end
                                      if c.type then t = t .. "Type: " .. c.type .. "\n" end
                                      if geom.width and geom.height and geom.x and geom.y then
                                         t = t .. "Dimensions: " .. "x:" .. geom.x .. " y:" .. geom.y .. " w:" .. geom.width .. " h:" .. geom.height
                                      end

                                      naughty.notify({
                                                        text = t,
                                                        timeout = 30,
                                                     })
                                   end),

    -- Prompt
    -- CHANGE: 换掉，支持:打开shell
    awful.key({ modkey,           }, "r",
              function () awful.prompt.run({prompt="Run:"},
                                          mypromptbox[mouse.screen].widget,
                                        check_for_terminal,
                                        clean_for_completion,
                                        awful.util.getdir("cache") .. "/history") end),

    -- ================ END my custom keybindings. (crazycode) ================

    -- Prompt
    -- awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey, "Shift"   }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Shift"   }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- CHANGE: 以下全部分为自定义设置

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    -- Float Application
    { rule = { class = "Cssh" },
      properties = { floating = true } },

    { rule = { name = 'Options' },
      properties = { floating = true } },

    { rule = { name = 'Settings' },
      properties = { floating = true } },

    { rule = { name = 'Preferences' },
      properties = { floating = true } },

    { rule = { class = "Quodlibet" },
      properties = { floating = true, tag = tags[1][2], switchtotag = true } },
    -- "T"
    { rule = { name = "tmux-main" },
      properties = { tag = tags[1][14], switchtotag = true, maximized_vertical = true, maximized_horizontal = true } },
    -- "E"
    { rule = { class = "Emacs" },
      properties = { tag = tags[1][13], switchtotag = true, maximized_vertical = true, maximized_horizontal = true } },
    -- "W"
    { rule = { class = "Google-chrome" },
      properties = { tag = tags[1][10], switchtotag = true, maximized_vertical = true, maximized_horizontal = true } },
    { rule = { class = "Chromium" },
      properties = { tag = tags[secound_screen][2], switchtotag = true, maximized_vertical = true, maximized_horizontal = true } },

    -- "F"
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][11], switchtotag = true, maximized_vertical = true, maximized_horizontal = true } },
    -- "IM"
    { rule = { class = "Pidgin" },
      properties = { tag = tags[1][12], switchtotag = true } },
    { rule = { class = "Remmina" },
      properties = { tag = tags[1][3], switchtotag = true } },
    { rule = { class = "Opera" },
      properties = { tag = tags[secound_screen][9], switchtotag = true, maximized_vertical = true, maximized_horizontal = true } },
    { rule = { class = "VirtualBox" },
      properties = { tag = tags[secound_screen][3], switchtotag = true, floating = true } },
    -- { rule = { class = "VirtualBox", name = "Win2003" },
    --   properties = { tag = tags[secound_screen][4], switchtotag = true, maximized_vertical = true, maximized_horizontal = true } },
    { rule = { class = "Eclipse" },
      properties = { tag = tags[1][1], switchtotag = true } }
}
-- }}}


-- {{{ functions to help launch run commands in a terminal using ":" keyword
function check_for_terminal (command)
   if command:sub(1,1) == ":" then
      command = terminal .. ' -e ' .. command:sub(2)
   end
   awful.util.spawn(command)
end

function clean_for_completion (command, cur_pos, ncomp, shell)
   local term = false
   if command:sub(1,1) == ":" then
      term = true
      command = command:sub(2)
      cur_pos = cur_pos - 1
   end
   command, cur_pos =  awful.completion.shell(command, cur_pos,ncomp,shell)
   if term == true then
      command = ':' .. command
      cur_pos = cur_pos + 1
   end
   return command, cur_pos
end
-- }}}

util.run_once('dropbox', 'dropboxd')
-- util.run_once('nm-applet')
util.run_once('pidgin')
-- util.run_once('gol')

-- run screen-saver when idle 10 minutes.
util.run_once("xautolock -time 10 -locker 'xlock -lockdelay 15'")
