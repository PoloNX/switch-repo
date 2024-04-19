package("zlib")
    set_base("switch-pkg")
    set_kind("library")

    on_load(function(package)
        package:data_set("pkgname", "switch-zlib")
    
        package:base():script("load")(package)
    end)
    
    on_install(function(package)
        package:base():script("install")(package)
    end)
    
    on_test(function(package)
        assert(package:has_cfuncs("inflate", {includes = "zlib.h"}))
    end)
    