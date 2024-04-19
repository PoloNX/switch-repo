package("libsdl")
    set_base("switch-pkg")
    set_kind("library")

    on_load(function(package)
        package:add("deps", "mesa", "libnx")
        package:data_set("pkgname", "switch-sdl2")
    
        package:base():script("load")(package)
    end)
    
    on_install(function(package)
        package:base():script("install")(package)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <SDL2/SDL.h>
            int main(int argc, char** argv) {
                SDL_Init(0);
                return 0;
            }
        ]]}, {configs = {defines = "SDL_MAIN_HANDLED"}}));
    end)
