package("libsdl_image")
    set_base("switch-pkg")
    set_kind("library")

    on_load(function(package)
        package:add("deps", "libsdl", "libpng", "libjpeg-turbo", "libwebp")
        package:data_set("pkgname", "switch-sdl2_image")
    
        package:base():script("load")(package)
    end)
    
    on_install(function(package)
        package:base():script("install")(package)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <SDL2/SDL.h>
            #include <SDL2/SDL_image.h>
            int main(int argc, char** argv) {
                IMG_Init(IMG_INIT_PNG);
                IMG_Quit();
                return 0;
            }
        ]]}, {configs = {defines = "SDL_MAIN_HANDLED"}}));
    end)