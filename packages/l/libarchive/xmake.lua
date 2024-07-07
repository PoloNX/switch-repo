package("libarchive")
    set_base("switch-pkg")
    set_kind("library")

    on_load(function(package)
        package:data_set("deps", "bzip2", "zlib", "liblzma", "lz4", "libexpat", "libzstd")
        package:data_set("pkgname", "switch-libarchive")
    
        package:base():script("load")(package)
    end)
    
    on_install(function(package)
        package:base():script("install")(package)
    end)

