-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

local wibox = require("wibox")
local beautiful = require("beautiful")

local naughty = require("naughty")
local menubar = require("menubar")

-- path
config_dir = awful.util.getdir("config")
package.path = package.path .. ";" .. config_dir .. "/lib/?/init.lua;" .. config_dir .. "/lib/?.lua"

-- Load applications for menu and default variables
require('applications')

-- Load lib/tools.lua, a few helper and functions this config needs to work
require('lib/tools')

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Separators
spacer    = wibox.widget.textbox(" ")
dspacer   = wibox.widget.textbox("  ")
separator = wibox.widget.textbox("|")
space     = " "
-- }}}

-- {{{ config stuff 

-- Don't change config values here!!! These are just default values!!!
-- Create ~/.config/awesome/myconfig.lua and overwrite config there!
-- Possible config settings are well documented in ~/.config/awesome/myconfig.lua-example

config = {}
config['modkey'] = "Mod4"
config['altkey'] = "Mod1"

widgets = {}
autostart_config = {}
application_config = {}

if exists(config_dir .. "/myconfig.lua") then
    require("myconfig")
end

modkey = config['modkey']
altkey = config['altkey']

if not config['main_screen'] or config['main_screen'] > screen.count() then
    config['main_screen'] = 1    
end

-- }}}

-- {{{ Set Theme
if not config['theme'] then
    config['theme'] = "default"
end
theme = config_dir .. '/themes/' .. config['theme'] .. '/theme.lua'

if not exists(theme) then
    theme = "/usr/share/awesome/themes/default/theme.lua" 
end

beautiful.init(theme)
-- }}}

-- {{{ Layouts 
-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
   for s = 1, screen.count() do
       gears.wallpaper.maximized(beautiful.wallpaper, s, true)
   end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    if config['tag_style'] == 'fancy' then
        tagnames = {"⌂","⚡","✇","☭","★","⍜","⌘","☼","♫"}
    elseif config['tag_style'] == 'greek' then
        tagnames = {"λ","Ω","Δ","ε","ϰ","Ϭ","Ψ","Φ","ϖ"}
    elseif config['tag_style'] == 'braille' then
        tagnames = {"⠁","⠃","⠉","⠙","⠑","⠋","⠛","⠓","⠊"}
    else
        tagnames = {"1","2","3","4","5","6","7","8","9"}
    end
    
    if not config['tag_count'] then
        if config['small_screen'] then
            config['tag_count'] = 4 
        else
            config['tag_count'] = 7 
        end
    end
    
    for i = 1, 9 - config['tag_count'] do
        table.remove(tagnames)
    end
    tags[s] = awful.tag(tagnames, s, layouts[1])
end
-- }}}

-- {{{ Menu
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = get_mainmenu(awful) })
-- }}}

-- {{{ Separators
spacer    = wibox.widget.textbox(" ")
dspacer   = wibox.widget.textbox("  ")
separator = wibox.widget.textbox("|")
space     = " "
-- }}}

-- {{{ Menubar
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Plain Widgets 
if config['kbdcfg'] then
    kbdcfg = {}
    kbdcfg.cmd = "setxkbmap"
    if not config['kbdcfg_languages'] then
        kbdcfg.layout = {{ "de", "" },{ "us", ""},{ "ru", "winkeys"}}
    else
        kbdcfg.layout = config['kbdcfg_languages'] 
    end
    kbdcfg.current = 1
    kbdcfg.widget = wibox.widget.textbox()
    kbdcfg.widget:set_text(space .. string.upper(kbdcfg.layout[kbdcfg.current][1]) .. space)
        
    kbdcfg.switch = function ()
        kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
        local t = kbdcfg.layout[kbdcfg.current]
        kbdcfg.widget:set_text(space .. string.upper(t[1]) .. space)
        awful.util.spawn(kbdcfg.cmd .. " " .. t[1] .. " " .. t[2])
    end
    
    kbdcfg.widget:buttons(awful.util.table.join(
        awful.button({ }, 1, function () kbdcfg.switch() end)
    ))
    
    local t = kbdcfg.layout[kbdcfg.current]
    awful.util.spawn(kbdcfg.cmd .. " " .. t[1] .. " " .. t[2])

    table.insert(widgets,kbdcfg.widget) 
    table.insert(widgets,spacer) 
end
-- }}}

-- {{{ Obvious 
if config['obvious_clock'] then
    require('obvious.clock')
    obvious.clock.set_editor(xeditor)
    obvious.clock.set_shorttimer(1)
    obvious.clock.set_shortformat(function () return " <b>%X</b>" end)
    obvious.clock.set_longformat(function () return " <b>%a %b %d, %T </b> " end)
end

if config['obvious_exec'] then
    require('obvious.popup_run_prompt')
    -- obvious.popup_run_prompt.set_opacity(0.7)
    -- obvious.popup_run_prompt.set_slide(true)
end

if config['obvious_ssh'] then
    require('popup_ssh_prompt')
end

-- }}}

-- {{{ Vicious 
if config['vicious_cpu'] or config['vicious_mem'] or config['vicious_bat'] or config['vicious_net'] or config['vicious_wifi'] then
    vicious = require('lib/vicious')
    beautiful.fg_widget        = "#AECF96"
    beautiful.fg_center_widget = "#88A175"
    beautiful.fg_end_widget    = "#FF5656"
    beautiful.fg_off_widget    = "#494B4F"
    beautiful.fg_netup_widget  = "#7F9F7F"
    beautiful.fg_netdn_widget  = beautiful.fg_urgent
    beautiful.bg_widget        = beautiful.bg_normal
    beautiful.border_widget    = beautiful.bg_normal
    
end   

if config['vicious_bat'] then
    baticon = wibox.widget.imagebox()
    baticon:set_image(beautiful.widget_bat)
    batwidget = wibox.widget.textbox()
    
    vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT0")
    table.insert(widgets, dspacer)
    table.insert(widgets, baticon)
    table.insert(widgets, batwidget)
end

if config['vicious_mem'] then
    memicon = wibox.widget.imagebox()
    memicon:set_image(beautiful.widget_mem)
    memwidget = awful.widget.progressbar()
    memwidget:set_width(8)
    memwidget:set_height(18)
    memwidget:set_vertical(true)
    memwidget:set_background_color('#494B4F')
    memwidget:set_color('#FF5656')
    -- memwidget:set_gradient_colors({ '#FF5656', '#88A175', '#AECF96' }) -- TODO
    -- vicious.enable_caching(vicious.widgets.mem)
    
    vicious.register(memwidget, vicious.widgets.mem, "$1", 13)
    table.insert(widgets, dspacer)
    table.insert(widgets, memicon)
    table.insert(widgets, memwidget)
end

if config['vicious_cpu'] then
    cpuicon = wibox.widget.imagebox()
    cpuicon:set_image(beautiful.widget_cpu)
    cpuwidget = awful.widget.graph()
    if config['small_screen'] then
        cpuwidget:set_width(50)
    else
        cpuwidget:set_width(100)
    end
    cpuwidget:set_height(18)
    cpuwidget:set_background_color("#494B4F")
    cpuwidget:set_color("#FF5656")
    -- cpuwidget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" }) -- TODO
    -- cpuwidget:set_max_value(200)
    
    vicious.register(cpuwidget, vicious.widgets.cpu, '$1', 3)
    table.insert(widgets, dspacer)
    table.insert(widgets, cpuicon)
    table.insert(widgets, cpuwidget)
end
    
if config['vicious_wifi'] then
    if not config['device_wireless'] then
        config['device_wireless'] = 'wlan0'
    end 
     
    wifiicon = wibox.widget.imagebox()
    wifiicon:set_image(beautiful.widget_wifi)
    neticon = wibox.widget.imagebox()
    neticon:set_image(beautiful.widget_net)
    neticonup = wibox.widget.imagebox()
    neticonup:set_image(beautiful.widget_netup)
    netfiwidget = wibox.widget.textbox()
    --vicious.enable_caching(vicious.widgets.net)
    
    vicious.register(netfiwidget, vicious.widgets.net, '<span color="'
        .. beautiful.fg_netdn_widget ..'">${'.. config['device_wireless'] ..' down_kb}</span> <span color="'
        .. beautiful.fg_netup_widget ..'">${'.. config['device_wireless'] ..' up_kb}</span>', 3)
    table.insert(widgets, dspacer) 
    table.insert(widgets, wifiicon) 
    table.insert(widgets, neticon) 
    table.insert(widgets, netfiwidget) 
    table.insert(widgets, neticonup) 
end
    
        
if config['vicious_net'] then
    if not config['device_wired'] then
        config['device_wired'] = 'eth0'
    end 
    
    ethericon = wibox.widget.imagebox()
    ethericon:set_image(beautiful.widget_rss)
    neticon = wibox.widget.imagebox()
    neticon:set_image(beautiful.widget_net)
    neticonup = wibox.widget.imagebox()
    neticonup:set_image(beautiful.widget_netup)
    netwidget = wibox.widget.textbox()
    --vicious.enable_caching(vicious.widgets.net)
    
    vicious.register(netwidget, vicious.widgets.net, '<span color="'
        .. beautiful.fg_netdn_widget ..'">${'.. config['device_wired'] ..' down_kb}</span> <span color="'
        .. beautiful.fg_netup_widget ..'">${'.. config['device_wired'] ..' up_kb}</span>', 3)
    table.insert(widgets,dspacer) 
    table.insert(widgets,ethericon) 
    table.insert(widgets,neticon) 
    table.insert(widgets,netwidget) 
    table.insert(widgets,neticonup) 
end
-- }}}

-- {{{ Bashets 
if config['bashets'] then
    --    require('lib/bashets')
end
-- }}}

-- {{{ Flaw
if config['flaw'] then
    --    require('lib/flaw')
end
-- }}}

-- {{{ Wibox
-- Create a textclock widget
if config['obvious_clock'] then
    textclock = obvious.clock()
else
    textclock = awful.widget.textclock()
end

-- Create a wibox for each screen and add it
mywibox = {}
debugbox = widget({ type = "textbox", name = "debugbox" })
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )

-- Create Tasklist
if config['taskbar'] == 'bottom' then
    mytaskbox = {}
end
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
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
    mypromptbox[s] = awful.widget.prompt()
    
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    
    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
   
    if s == config['main_screen'] then
        if config['debug'] == true then right_layout:add(debugbox) end
        table.insert(widgets, spacer)
        table.foreach(widgets, function(k,v) right_layout:add(v) end)
        if not config['systray_align'] or config['systray_align'] == 'left' then right_layout:add(wibox.widget.systray()) end
        if config['systray_align'] == 'right' then
            clockicon = wibox.widget.imagebox()
            clockicon:set_image(beautiful.widget_date)
            right_layout:add(spacer) 
            right_layout:add(clockicon) 
        end
        right_layout:add(textclock) 
        if config['systray_align'] == 'right' then 
            right_layout:add(wibox.widget.systray()) 
        end
    end 
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    if config['taskbar'] ~= 'bottom' and config['taskbar'] ~= 'off' then
        layout:set_middle(mytasklist[s])
    else
        layout:set_middle(spacer)
    end
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
    
    if config['taskbar'] == 'bottom' then
        mytaskbox[s] = awful.wibox({ position = "bottom", screen = s })
        mytaskbox[s]:set_widget(mytasklist[s])
    end
end
-- }}}

-- {{{ Key bindings
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
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey,           }, "a", function () awful.screen.focus_relative( 1) end),
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
    awful.key({ altkey,           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    
    -- Quit/Restart/Redraw Awesome
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Control" }, "q", awesome.quit),
    awful.key({ modkey, "Shift"   }, "r", function (c) c:redraw() end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey }, "r", config['obvious_exec'] and obvious.popup_run_prompt.run_prompt or function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "e", config['obvious_exec'] and obvious.popup_run_prompt.run_prompt or function () mypromptbox[mouse.screen]:run() end),
    
    awful.key({ modkey }, "s", config['obvious_ssh'] == true and obvious.popup_ssh_prompt.run_prompt or  
            function ()
                awful.prompt.run({ prompt = "SSH: " },
                mypromptbox[mouse.screen].widget,
                function (s)
                    awful.util.spawn(terminal_exec .. ssh_cmd .. space .. s)
                end)
            end), 
        
    awful.key({ modkey, "Shift" }, "s",
            function ()
                awful.prompt.run({ prompt = "SSH -X: " },
                mypromptbox[mouse.screen].widget,
                function (s)
                    awful.util.spawn(terminal_exec .. ssh_cmd .. " -X " .. s)
                end)
            end), 
    
    -- screen lock
    awful.key({ modkey }, "F11", function () awful.util.spawn(screen_lock) end),
    awful.key({ modkey }, "F12", function () awful.util.spawn(screen_lock) end),
    
    -- kbdcfg
    awful.key({ modkey }, "F9", config['kbdcfg'] and function () kbdcfg.switch() end),

    awful.key({ modkey, "Shift" }, "e",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "f",      function (c) multifullscreen(awful,c) end),
    awful.key({ modkey,           }, "x",      function (c) c:kill() end),
    awful.key({ modkey, "Shift"   }, "x",      function () awful.util.spawn('xkill') end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
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
   keynumber = math.min(9, math.max(#tags[s], keynumber))
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
    awful.button({ altkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize),
    awful.button({ altkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Rules

if not awful.rules.rules then
    awful.rules.rules = {}
end

joinTables(awful.rules.rules,{
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
})

-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    
    if c.pid == 0 then
        -- local fpid = io.popen("pgrep -u " .. os.getenv("USER") .. " -n " .. c.instance)
        local fpid = io.popen("pgrep -n " .. c.instance)
        local instance_pid = fpid:read("*n")
        fpid:close()
        if instance_pid then
            pid = tonumber(instance_pid)
        else
            pid = 0
        end
    else
        pid = c.pid
    end

    if application_config[pid] ~= nil then
        
        if application_config[pid]['screen'] ~= nil and application_config[pid]['screen'] <= screen.count() then
            c.screen = application_config[pid]['screen']
        end
        
        if application_config[pid]['tag'] ~= nil then
            c:tags({ screen[c.screen]:tags()[application_config[pid]['tag']] })
        end
    
    end
    
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
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

    if config['titlebar'] then
        local titlebars_enabled = true
    else
        local titlebars_enabled = false
    end
    
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
    
    c.size_hints_honor = false
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Autostart
if next(autostart_config) ~= nil then
    autostart(awful, autostart_config)
end
-- }}}

