package("glad")
    set_base("switch-pkg")
    set_kind("library")

    on_load(function(package)
        package:add("deps", "mesa")
        package:data_set("pkgname", "switch-glad")
    
        package:base():script("load")(package)
    end)
    
    on_install(function(package)
        package:base():script("install")(package)
    end)
