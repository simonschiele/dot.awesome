--
-- DON'T EDIT THIS FILE! Copy it to '~/.config/awesome/myapplications.lua'
-- and edit this copy. This way the config will be update-safe.
--

-- Applications
terminal = "gnome-terminal.wrapper --disable-factory"
terminal_exec = terminal .. " -e "

editor = "vim"
xeditor = terminal_exec .. editor

su = "sudo"
xsu = "gksudo"

ssh_cmd = "ssh -v"

screen_lock = "xscreensaver-command --lock"
browser = "google-chrome"
mailer = "icedove"
filer = "thunar"
sysconfig = "gnome-control-center"
mixer = "pavucontrol"

-- Menu
function get_mainmenu()

    awesomemenu = {
        { "lock screen", screen_lock },
        { "restart", awesome.restart },
        { "quit", awesome.quit },
    }

    internetmenu = {
        { "browser", browser },
        { "mailer", mailer },
        { "irc", "irc" },
        { "pidgin", "pidgin" },
        { "iceweasel", "iceweasel" },
        { "chrome", "google-chrome" },
    }

    multimediamenu = {
        { "mixer", mixer },
        { "gmpc", "gmpc" },
        { "webcam", "guvcview" },
        { "picard", "picard" },
    }

    utilsmenu = {
        { "kodos", "kodos" },
        { "colorpicker", "agave" },
        { "charmap", "gucharmap" },
        { "calculator", "gcalctool" },
        { "pgadmin", "pgadmin3" },
        { "GTK Term", "gtkterm" },
        { "vnc", "vinagre" },
        { "rdesktop", "grdesktop" },
        { "filer", filer },
    }

    gamesmenu = {
        { "dwarf fortress", "/usr/local/games/df_linux/df" },
    }

    graphicsmenu = {
        { "gimp", "gimp" },
        { "inkscape", "inkscape" },
        { "geeqie", "geeqie" },
    }

    officemenu = {
        { "libre writer", "libreoffice -writer"},
        { "libre calc", "libreoffice -calc"},
        { "document viewer", "evince" },
        { "abiword", "abiword" },
        { "gnumeric", "gnumeric" },
    }

    menu = awful.menu({ items =   {
        { "browser", browser },
        { "terminal", terminal },
        { "sysconfig", sysconfig },
        { "nvconfig", xsu .. " nvidia-settings" },
        { " ", "echo -n" },
        { "internet", internetmenu },
        { "office", officemenu },
        { "graphics", graphicsmenu },
        { "multimedia", multimediamenu },
        { "games", gamesmenu },
        { "utils", utilsmenu },
        { " ", "echo -n" },
        { "awesome", awesomemenu },
    }})

    return menu

end

