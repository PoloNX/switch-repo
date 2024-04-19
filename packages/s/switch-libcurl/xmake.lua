package("switch-libcurl")
    set_base("switch-pkg")
    set_kind("library")

    on_load(function(package)
        package:add("deps", "switch-zlib", "libnx")
        package:data_set("pkgname", "switch-curl")
    
        package:base():script("load")(package)
    end)
    
    on_install(function(package)
        package:base():script("install")(package)
    end)

    on_test(function(package)
    local cxflags
    assert(package:check_cxxsnippets({test = [[
        int main(int argc, char** argv) {
            CURL* curl = curl_easy_init();
            if (curl) {
                curl_easy_cleanup(curl);
                return 0;
            }
            return 1;
        }
    ]] }, {configs = {cxflags = cxflags}, includes = {"curl/curl.h"}}))
    end)
