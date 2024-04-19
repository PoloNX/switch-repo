package("libsdl_mixer")
    set_base("switch-pkg")
    set_kind("library")

    on_load(function(package)
        -- package:add("deps", "libsdl", "freetype", "harfbuzz")
        package:data_set("pkgname", "switch-sdl2_mixer")
    
        package:base():script("load")(package)
    end)
    
    on_install(function(package)
        package:base():script("install")(package)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <SDL2/SDL.h>
            #include <SDL2/SDL_mixer.h>
            int main(int argc, char** argv) {
                Mix_Init(MIX_INIT_OGG);
                Mix_Quit();
                return 0;
            }
        ]]}, {configs = {defines = "SDL_MAIN_HANDLED"}}));
    end)