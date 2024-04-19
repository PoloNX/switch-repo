package("libnx")
    set_base("switch-pkg")
    set_kind("library")

    on_load(function(package)
        package:data_set("pkgname", "libnx")
    
        package:base():script("load")(package)
    end)
    
    on_install(function(package)
        package:base():script("install")(package)
    end)

    on_test(function(package)
        assert(package:has_cfuncs("setsysInitialize", {includes = "switch.h"}))
    end)

