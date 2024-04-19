package("harfbuzz")
    set_base("switch-pkg")
    set_kind("library")

    on_load(function(package)
        package:add("deps", "freetype")
        package:data_set("pkgname", "switch-harfbuzz")
    
        package:base():script("load")(package)
    end)
    
    on_install(function(package)
        package:base():script("install")(package)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("hb_buffer_add_utf8", {includes = "hb.h"}))
    end)
