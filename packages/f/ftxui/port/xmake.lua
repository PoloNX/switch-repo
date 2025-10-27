add_rules("mode.debug", "mode.release")

add_requires("libnx", "gtest")

target("ftxui")
    set_kind("$(kind)")
    add_files("src/ftxui/**.cpp")
    add_includedirs("include/ftxui")
    add_includedirs("include")
    add_packages("libnx", "gtest")