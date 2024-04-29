package("simple-ini-parser")
    set_homepage("https://github.com/NicholeMattera/Simple-INI-Parser")
    set_description("A very simple INI parser written in C++.")

    add_urls("https://github.com/NicholeMattera/Simple-INI-Parser/archive/refs/tags/$(version).tar.gz",
             "https://github.com/NicholeMattera/Simple-INI-Parser.git")

    add_versions("v2.1.0", "279cb41700df3820d53b80e2509070481bc8e2551db1ae4ac4eb7c5832fb5f7f")

    on_load(function (package)
        package:add("deps", "libnx")
    end)

    on_install(function (package)
        local configs = {}
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            target("simple-ini-parser")
                set_kind("$(kind)")
                add_files("source/SimpleIniParser/*.cpp")
                add_headerfiles("include/**.hpp")
                add_includedirs("include/SimpleIniParser")
        ]])
        if package:config("shared") then
            configs.kind = "shared"
        end
        import("package.tools.xmake").install(package, configs)
    end)