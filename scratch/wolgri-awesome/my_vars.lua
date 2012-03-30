terminal = "xterm"
wwwbrowser = "wwwfox"
emailclient = "urxvt -e mutt"
screensaver= "xscreensaver-command -lock"
home_dir = os.getenv("HOME")
usetags="mytags"
usemode="laptop"
use_titlebar_floatapp=true
--{{{ Beutiful
theme_path = awful.util.getdir("config") .. "/themes/wolgri/theme.lua"
beautiful.init(theme_path)
--}}}
--{{{ Windows
floatapps = {}
floatapps =
{
    -- by class
    ["MPlayer"] = true,
    ["pinentry"] = true,
    ["gimp"] = true,
    ["wicd-client.py"] = true,
    ["gajim.py"] = true,
    ["pidgin"] = true,


    -- by instance
    ["mocp"] = true
}

-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags = {}
apptags =
{
     ["Swiftfox"] = { screen = 1, tag = 2 },
     ["Navigator"] = { screen = 1, tag = 2 },
     ["lilyterm"] = { screen = 1, tag = 1 },
     ["vmware"] = { screen = 1, tag = 5 },
     ["VirtualBox"] = { screen = 1, tag = 5 },
     ["gajim.py"] = { screen = 1, tag = 7 },
     ["pidgin"] = { screen = 1, tag = 7 },



}
--}}}
--{{{ layout
layouts ={}
layouts =
{
    awful.layout.suit.tile,
--    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
--}}}
--{{{ applications menu
-- http://wiki.github.com/terceiro/awesome-freedesktop
  require('freedesktop.utils')
  freedesktop.utils.terminal = terminal  -- default: "xterm"
  freedesktop.utils.icon_theme = 'gnome' -- look inside /usr/share/icons/, default: nil (don't use icon theme)
  require('freedesktop.menu')
  require("debian.menu")

  menu_items = freedesktop.menu.applications_menu
  myawesomemenu = {
     { "manual", terminal .. " -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help' }) },
     { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua", freedesktop.utils.lookup_icon({
     icon = 'package_settings' }) },
     { "restart", awesome.restart, freedesktop.utils.lookup_icon({ icon = 'gtk-refresh' }) },
     { "quit", awesome.quit, freedesktop.utils.lookup_icon({ icon = 'gtk-quit' }) }
  }
  table.insert(menu_items, { "awesome", myawesomemenu, beautiful.awesome_icon })
  table.insert(menu_items, { "open terminal", terminal, freedesktop.utils.lookup_icon({icon = 'terminal'}) })
  table.insert(menu_items, { "Debian", debian.menu.Debian_menu.Debian, freedesktop.utils.lookup_icon({ icon =
  'debian-logo' }) })

  mymainmenu = awful.menu.new({ items = menu_items})

  mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
  -- desktop icons
--  require('freedesktop.desktop')
--  for s = 1, screen.count() do
--     freedesktop.desktop.add_desktop_icons({screen = s, showlabels = true})
--  end
--}}}
