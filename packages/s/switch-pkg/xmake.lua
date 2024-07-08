package("switch-pkg")
    set_kind("template")
    set_description("Switch package template")

    on_load(function (package)
        -- package:add("deps", "switch-pacman")
    end)

    on_fetch(function (package)
        local pkgname = assert(package:data("pkgname"), "this package must not be used directly")

        local DEVKITPRO = os.getenv("DEVKITPRO")

        local result = {includedirs = {}, links = {}, linkdirs = {}}
        linkdirs = {}
        lib_files = {}
        includedirs = {}
        pkgconfig_files = {}

        if os.isexec("dkp-pacman") then
            list = os.iorunv("dkp-pacman" .. " -Ql " .. pkgname)
        elseif os.isexec("pacman") then
            list = os.iorunv("pacman" .. " -Ql " .. pkgname)
        else
            list = os.iorunv("pacman", {"-Ql", pkgname})
            cprint("${bright red}Pacman not found: ${reset}%s", pkgname)
        end

        list = list:gsub("/opt/devkitpro", DEVKITPRO)
        
        vprint("list :\n %s", list)

        if not list then
            cprint("${bright red}Package not found: ${reset}%s", pkgname)
        end

        for _, line in ipairs(list:split('\n', {plain = true})) do
            line = line:trim():split('%s+')[2]
            if line:find("/pkgconfig/", 1, true) and line:endswith(".pc") then
                vprint("insert .pc : %s", line)
                table.insert(pkgconfig_files, line)
            end
            if line:endswith(".so") or line:endswith(".a") or line:endswith(".lib") then
                table.insert(linkdirs, path.directory(line))
                if line:endswith(".a") then
                    local basename = path.basename(line)
                    if basename:startswith("lib") then
                        basename = basename:sub(4)  -- Remove "lib" prefix
                    end
                    table.insert(lib_files, basename)
                    table.insert(linkdirs, path.directory(line))
                end
            end
            if line:endswith("/include/") then 
                table.insert(includedirs, line)
            end 
        end
        linkdirs = table.unique(linkdirs)

        import("package.manager.pkgconfig.find_package", {alias = "find_package_from_pkgconfig"})

        if pkgconfig_files then
            for i, pkgconfig_file in ipairs(pkgconfig_files) do
                pkgconfig_files[i] = pkgconfig_file:gsub(DEVKITPRO, "/opt/devkitpro")
            end
        end
        
        local foundpc = false
        local pcresult = {includedirs = {}, links = {}, linkdirs = {}}
        for _, pkgconfig_file in ipairs(pkgconfig_files) do 
            local pkgconfig_dir = path.directory(pkgconfig_file)
            local pkgconfig_name = path.basename(pkgconfig_file)
            vprint("pkgconfig_dir : %s and pkgconfig_name %s", pkgconfig_dir, pkgconfig_name)
            local pcinfo = find_package_from_pkgconfig(pkgconfig_name, {configdirs = pkgconfig_dir, linkdirs = linkdirs})
        
            if pcinfo then
                for _, includedir in ipairs(pcinfo.includedirs) do
                    table.insert(pcresult.includedirs, includedir)
                end
                for _, linkdir in ipairs(pcinfo.linkdirs) do
                    table.insert(pcresult.linkdirs, linkdir)
                end
                for _, link in ipairs(pcinfo.links) do
                    table.insert(pcresult.links, link)
                end

                pcresult.version = pcinfo.version
                foundpc = true
            end

        end

        if foundpc == true then
            pcresult.includedirs = table.unique(pcresult.includedirs)
            pcresult.linkdirs = table.unique(pcresult.linkdirs)
            pcresult.links = table.reverse_unique(pcresult.links)
            result = pcresult
        else
            result.includedirs = includedirs
            result.linkdirs = linkdirs
            result.links = lib_files
        end

       vprint("${bright yellow}pkgconfig %s found: ${reset}%s", pkgname, foundpc and "yes" or "no")

        if #result.includedirs > 0 then
            vprint("${bright green}Includedirs:${reset}")
            for _, includedir in ipairs(result.includedirs) do
                vprint("  %s", includedir)
            end
        end

        if #result.linkdirs > 0 then
            vprint("${bright green}Linkdirs:${reset}")
            for _, linkdir in ipairs(result.linkdirs) do
                vprint("  %s", linkdir)
            end
        end

        if #result.links > 0 then
            vprint("${bright green}Links:${reset}")
            for _, link in ipairs(result.links) do
                vprint("  %s", link)
            end
        end

        if result.version then
            vprint("${bright green}Version:${reset} %s", result.version)
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