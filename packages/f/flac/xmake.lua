package("flac")
    set_base("switch-pkg")
    set_kind("library")

    on_load(function(package)
        package:add("deps", "libogg")
        package:data_set("pkgname", "switch-flac")
    
        package:base():script("load")(package)
    end)
    
    on_install(function(package)
        package:base():script("install")(package)
    end)
