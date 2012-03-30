if usetags=="mytags" then

   tags = {}
   for s = 2, screen.count() do
       tags[s] = {}
       for tagnumber = 1, 9 do
          tags[s][tagnumber] = tag(tagnumber)
          tags[s][tagnumber].screen = s
          awful.layout.set(awful.layout.suit.floating, tags[s][tagnumber])
       end
       tags[s][1].selected = true
   end

   tags[1] = {}

   tags[1][1] = tag("main")
   tags[1][1].screen = 1
   awful.layout.set(layouts[1], tags[1][1])
   tags[1][1].selected = true

   tags[1][2] = tag("web")
   tags[1][2].screen = 1
   awful.layout.set(layouts[1], tags[1][2])

   tags[1][3] = tag("stuff")
   tags[1][3].screen = 1
   awful.layout.set(awful.layout.suit.floating, tags[1][3])

   tags[1][4] = tag("work")
   tags[1][4].screen = 1
   awful.layout.set(layouts[1], tags[1][4])

   tags[1][5] = tag("virt")
   tags[1][5].screen = 1
   awful.layout.set(awful.layout.suit.tile.max, tags[1][5])

   tags[1][6] = tag("etc")
   tags[1][6].screen = 1
   awful.layout.set(layouts[1], tags[1][6])

   tags[1][7] = tag("im")
   tags[1][7].screen = 1
   awful.layout.set(layouts[1], tags[1][7])

   tags[1][1].selected = true
end
