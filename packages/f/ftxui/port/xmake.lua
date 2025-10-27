add_rules("mode.debug", "mode.release")

add_requires("libnx")

target("ftxui")
    set_kind("$(kind)")
    add_files("src/ftxui/**.cpp")
    add_includedirs("include/ftxui")
    add_packages("libnx")