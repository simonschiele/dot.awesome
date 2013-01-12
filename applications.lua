-- Applications
terminal = "gnome-terminal.wrapper --disable-factory"
terminal_exec = terminal .. " -e "

editor = "vim"
xeditor = terminal_exec .. editor
editor_cmd = terminal_exec .. editor

su = "sudo"
xsu = "gksudo"

ssh_cmd = "ssh -v" 

screen_lock = "xscreensaver-command --lock"
browser = "iceweasel" 
mailer = "icedove"
filer = "thunar"
sysconfig = "gnome-control-center"
mixer = "pavucontrol"


-- Menu
function get_mainmenu(awful)
    
    awesomemenu = {
        { "lock screen", screen_lock },
        { "restart", awesome.restart },
        { "quit", awesome.quit },
    }

    internetmenu = {
        { "browser", browser },
        { "chrome", "google-chrome" },
        { "mailer", mailer },
        { "irc", "irc" },
        { "pidgin", "pidgin" },
    }

    multimediamenu = {
        { "mixer", mixer },
        { "gmpc", "gmpc" },
        { "webcam", "guvcview" },
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
        { "sauerbraten", "sauerbraten" },
        { "warsow", "warsow" },
        { "wormux", "wormux" },
        { "singularity", "singularity" },
        { "warzone2100", "warzone2100" },
        { "dwarf fortress", "/usr/local/games/df_linux/df" },
        { "Titans Revenge", "/opt/revengeofthetitans/revenge.sh" },
        { "World of Goo", "/usr/local/games/WorldOfGoo/WorldOfGoo" },
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

