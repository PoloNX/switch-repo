package("borealis")
    set_homepage("https://github.com/PoloNX/borealis")
    set_description("Hardware accelerated, Nintendo Switch inspired UI library for PC, Android, iOS, PSV, PS4 and Nintendo Switch")
    set_license("Apache-2.0")

    add_urls("https://github.com/PoloNX/borealis.git")
    add_versions("2024.04.18", "8a9064af864cfeaac0bd0ae306052e68b5302b3a")

    add_deps("cmake")

    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DPLATFORM_SWITCH=ON")
        os.cd("library")
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("brls::Application::init", {includes = "borealis.hpp"}))
    end)
