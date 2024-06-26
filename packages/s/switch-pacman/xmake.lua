package("switch-pacman")
    set_kind("binary")

    on_fetch("@windows", function(package, opt)
        if opt.system then
            local pacman = "pacman"
            if os.isexec(pacman) then
                package:addenv("PATH", "C:\\devkitPro\\msys2\\usr\\bin")
            end
        end
    end)

    on_test(function (package)
        if os.isexec("pacman") then
            os.vrun("pacman --version")
        elseif os.isexec("dkp-pacman") then
            os.vrun("dkp-pacman --version")
        else
            raise("pacman not found!")
        end
    end)