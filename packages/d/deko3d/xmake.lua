package("deko3d")
    set_base("switch-pkg")
    set_kind("library")

    on_load(function(package)
        package:add("deps", "libnx")
        package:data_set("pkgname", "deko3d")
    
        package:base():script("load")(package)
    end)
    
    on_install(function(package)
        package:base():script("install")(package)
    end)
