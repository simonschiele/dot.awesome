
function autostart(autostart_config)
    if not autostart_config then
        do return nil end
    end

    for appname,appdata in pairs(autostart_config) do

        local cmd = ""
        if autostart_config[appname]['sudo'] then
            cmd = xsu .. space
        end

        cmd = cmd .. autostart_config[appname]['cmd']

        if autostart_config[appname]['shell'] then
            pid = awful.util.spawn_with_shell(cmd)

            if pid ~= nil and pid ~= 0 then
                application_config[pid] = appdata
            end

            print("> started '" .. appname .. "' via awful.util.spawn_with_shell('" .. cmd .. "') -> " .. pid)
        else
            pid = awful.util.spawn(cmd)

            if pid ~= nil and pid ~= 0 then
                application_config[pid] = appdata
            end

            print("> started '" .. appname .. "' via awful.util.spawn('" .. cmd .. "') -> " .. pid)
        end
    end
end

function exists(filename)
      local file = io.open(filename)
      if file then
        io.close(file)
        return true
      else
        return false
      end
end

function multifullscreen(c)
    awful.client.floating.toggle(c)
    if awful.client.floating.get(c) then
        local clientX = screen[1].workarea.x
        local clientY = screen[1].workarea.y
        local clientWidth = 0
        -- look at http://www.rpm.org/api/4.4.2.2/llimits_8h-source.html
        local clientHeight = 2147483640
        for s = 1, screen.count() do
            clientHeight = math.min(clientHeight, screen[s].workarea.height)
            clientWidth = clientWidth + screen[s].workarea.width
        end
        local t = c:geometry({x = clientX, y = clientY, width = clientWidth, height = clientHeight})
    else
        --apply the rules to this client so he can return to the right tag if there is a rule for that.
        awful.rules.apply(c)
    end
    -- focus our client
    client.focus = c
end

function joinTables(t1, t2)
    for k,v in ipairs(t2)
        do table.insert(t1, v)
    end
    return t1
end

function floats(c)
  if awful.layout.getname(awful.layout.get(c.screen)) == 'floating' or awful.client.floating.get(c) then
    return true
  end
  return false
end

function print_r(t)
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    sub_print_r(t,"  ")
end

