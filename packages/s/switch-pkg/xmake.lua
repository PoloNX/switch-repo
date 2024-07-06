package("switch-pkg")
    set_kind("template")
    set_description("Switch package template")

    on_load(function (package)
        -- package:add("deps", "switch-pacman")
    end)

    on_fetch(function (package)
        local pkgname = assert(package:data("pkgname"), "this package must not be used directly")

        local DEVKITPRO = os.getenv("DEVKITPRO")

        linkdirs = {}
        pkgconfig_files = {}

        if os.isexec("pacman") then
            list = os.execute("pacman" .. " -Ql " .. pkgname)
        elseif os.isexec("dkp-pacman") then
            list = os.execute("dkp-pacman" .. " -Ql " .. pkgname)
        else
            cprint("${bright red}Pacman not found: ${reset}%s", pkgname)
            return
        end

        if not list then
            cprint("${bright red}Package not found: ${reset}%s", pkgname)
            return
        end

        for _, line in ipairs(list:split('\n', {plain = true})) do
            line = line:trim():split('%s+')[2]
            if line:find("/pkgconfig/", 1, true) and line:endswith(".pc") then
                table.insert(pkgconfig_files, line)
            end
            if line:endswith(".so") or line:endswith(".a") or line:endswith(".lib") then
                table.insert(linkdirs, path.directory(line))
            end
        end
        linkdirs = table.unique(linkdirs)

        import("package.manager.pkgconfig.find_package", {alias = "find_package_from_pkgconfig"})

        local foundpc = false
        local result = {includedirs = {}, links = {}, linkdirs = {}}
        for _, pkgconfig_file in ipairs(pkgconfig_files) do 
            local pkgconfig_dir = path.directory(pkgconfig_file)
            local pkgconfig_name = path.basename(pkgconfig_file)
            local pcresult = find_package_from_pkgconfig(pkgconfig_name, {configdirs = pkgconfig_dir, linkdirs = linkdirs})
        
            if pcresult then
                for _, includedir in ipairs(pcresult.includedirs) do
                    table.insert(result.includedirs, includedir)
                end
                for _, linkdir in ipairs(pcresult.linkdirs) do
                    table.insert(result.linkdirs, linkdir)
                end
                for _, link in ipairs(pcresult.links) do
                    table.insert(result.links, link)
                end

                result.version = pcresult.version
                foundpc = true
            end

        end

        if foundpc == true then
            result.includedirs = table.unique(result.includedirs)
            result.linkdirs = table.unique(result.linkdirs)
            result.links = table.unique(result.links)
        end

       cprint("${bright yellow}Package %s found: ${reset}%s", pkgname, foundpc and "yes" or "no")

        if #result.includedirs > 0 then
            cprint("${bright green}Includedirs:${reset}")
            for _, includedir in ipairs(result.includedirs) do
                cprint("  %s", includedir)
            end
        end

        if #result.linkdirs > 0 then
            cprint("${bright green}Linkdirs:${reset}")
            for _, linkdir in ipairs(result.linkdirs) do
                cprint("  %s", linkdir)
            end
        end

        if #result.links > 0 then
            cprint("${bright green}Links:${reset}")
            for _, link in ipairs(result.links) do
                cprint("  %s", link)
            end
        end

        if result.version then
            cprint("${bright green}Version:${reset} %s", result.version)
        end

        return result
    end)

    on_install(function (package)
        local pkgname = assert(package:data("pkgname"), "this package must not be used directly")

        -- Vérifier si un exécutable est disponible
        local function check_executable(exec)
            local handle = io.popen("where " .. exec .. " 2>nul")
            local result = handle:read("*a")
            handle:close()
            return result ~= ""
        end

        -- Debug : Imprimer les variables d'environnement PATH
        cprint("${bright yellow}PATH: ${reset}%s", os.getenv("PATH"))

        -- Debug : Imprimer le chemin absolu de pacman
        if check_executable("pacman") then
            cprint("${bright green}Pacman found in PATH${reset}")
        else
            cprint("${bright red}Pacman not found in PATH${reset}")
        end

        -- Debug : Imprimer le chemin absolu de dkp-pacman
        if check_executable("dkp-pacman") then
            cprint("${bright green}dkp-pacman found in PATH${reset}")
        else
            cprint("${bright red}dkp-pacman not found in PATH${reset}")
        end

        if check_executable("pacman") then
            os.vrunv("pacman", {"-S", pkgname})
        elseif check_executable("dkp-pacman") then
            os.vrunv("dkp-pacman", {"-S", pkgname})
        else
            cprint("${bright red}Pacman not found: ${reset}%s", pkgname)
            return
        end
    end)
