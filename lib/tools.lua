
function autostart(autostart_config)
    if not autostart_config then
        do return nil end
    end
    
    for appname,appdata in pairs(autostart_config) do
        print("> starting " .. appname)
        if autostart_config[appname].shell == nil or autostart_config[appname].shell == false then
            application_config[awful.util.spawn(autostart_config[appname].cmd)] = appdata
        else
            awful.util.spawn_with_shell(autostart_config[appname].cmd)
        end
        print("> finished starting " .. appname)
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

function print_r ( t ) 
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

