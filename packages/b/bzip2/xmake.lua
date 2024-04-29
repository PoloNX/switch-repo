package("bzip2")
    set_base("switch-pkg")
    set_kind("library")

    on_load(function(package)
        package:data_set("pkgname", "switch-bzip2")
    
        package:base():script("load")(package)
    end)
    
    on_install(function(package)
        package:base():script("install")(package)
    end)

