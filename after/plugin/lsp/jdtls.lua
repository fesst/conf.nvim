local ssh_utils = require("motleyfesst.utils.ssh")

if not ssh_utils.IS_LOCAL() then
    return
end

local lsp_utils = require("motleyfesst.utils.lsp")
local jdtls_group = vim.api.nvim_create_augroup("JdtlsAutostart", { clear = true })

local function find_up(markers, start_path)
    local found = vim.fs.find(markers, {
        upward = true,
        path = start_path,
        limit = 1,
    })[1]

    if not found then
        return nil
    end

    return vim.fs.dirname(found)
end

local function resolve_root_dir(bufname)
    local start_path = bufname ~= "" and vim.fs.dirname(bufname) or vim.fn.getcwd()
    local bazel_root = find_up({ "MODULE.bazel", "WORKSPACE.bazel", "WORKSPACE" }, start_path)
    if bazel_root then
        return bazel_root
    end

    local build_root = find_up({
        "settings.gradle.kts",
        "settings.gradle",
        "build.gradle.kts",
        "build.gradle",
        "pom.xml",
        "mvnw",
        "gradlew",
    }, start_path)
    if build_root then
        return build_root
    end

    return find_up({ ".git" }, start_path) or vim.fn.getcwd()
end

local function workspace_name(root_dir)
    return root_dir:gsub("[/\\:]", "_")
end

vim.api.nvim_create_autocmd("FileType", {
    group = jdtls_group,
    pattern = "java",
    callback = function()
        local jdtls = require("jdtls")

        local root_dir = resolve_root_dir(vim.api.nvim_buf_get_name(0))
        if not root_dir or root_dir == "" or vim.fn.isdirectory(root_dir) == 0 then
            vim.notify("jdtls: invalid project root: " .. vim.inspect(root_dir), vim.log.levels.WARN)
            return
        end
        local project_name = workspace_name(root_dir)

        local function get_bazel_exec_root()
            local exec_root = root_dir .. "/bazel-" .. vim.fn.fnamemodify(root_dir, ":t")
            if vim.fn.isdirectory(exec_root) == 1 then
                return exec_root
            end

            if vim.fn.executable("bazel") == 0 or not vim.system then
                return nil
            end

            local result = vim.system({ "bazel", "info", "execution_root" }, {
                cwd = root_dir,
                text = true,
            }):wait()

            if result.code ~= 0 then
                return nil
            end

            local detected_exec_root = vim.trim(result.stdout or "")
            if detected_exec_root == "" or vim.fn.isdirectory(detected_exec_root) == 0 then
                return nil
            end

            return detected_exec_root
        end

        -- Collect Maven jars from Bazel's external repository so jdtls can resolve
        -- external dependencies for go-to-definition, hover, and completion.
        -- rules_jvm_external (bzlmod) stores jars under:
        --   <exec_root>/external/rules_jvm_external++maven+<artifact>/file/v1/<path>/<artifact>.jar
        local function collect_bazel_referenced_libraries()
            local exec_root = get_bazel_exec_root()
            if not exec_root then
                return { include = {}, sources = {} }
            end

            local external_dir = exec_root .. "/external"
            if vim.fn.isdirectory(external_dir) == 0 then
                return { include = {}, sources = {} }
            end

            -- Try bzlmod layout first (rules_jvm_external++maven+*), fall back to legacy (maven/)
            local all_jars = vim.fn.glob(external_dir .. "/rules_jvm_external++maven+*/**/*.jar", false, true)
            if vim.tbl_isempty(all_jars) then
                all_jars = vim.fn.glob(external_dir .. "/maven/**/*.jar", false, true)
            end
            table.sort(all_jars)

            local libraries = { include = {}, sources = {} }
            for _, jar in ipairs(all_jars) do
                local name = vim.fn.fnamemodify(jar, ":t")
                if not name:match("%-javadoc%.jar$") and not name:match("%-sources%.jar$") then
                    table.insert(libraries.include, jar)

                    local source_jar = jar:gsub("%.jar$", "-sources.jar")
                    if source_jar ~= jar and vim.fn.filereadable(source_jar) == 1 then
                        libraries.sources[jar] = source_jar
                    end
                end
            end

            return libraries
        end

        local home = os.getenv("HOME")
        local mason_dir = home .. "/.local/share/nvim/mason" -- ===<MASON_DIR>===
        local jdtls_dir = mason_dir .. "/packages/jdtls" -- ===<JDTLS_DIR>===
        local workspace_dir = home .. "/.local/share/nvim/jdtls-workspace/" .. project_name -- ===<JDTLS_WORKSPACE_DIR>===
        local bazel_libraries = collect_bazel_referenced_libraries()

        local java_bin = "java" -- ===<JAVA_BIN>===
        -- lombok.jar: prefer ~/apps/lombok.jar, fall back to bundled one inside jdtls package
        local lombok_jar = home .. "/apps/lombok.jar" -- ===<LOMBOK_JAR>===
        local java_debug_dir = mason_dir .. "/packages/java-debug-adapter/extension/server" -- ===<JAVA_DEBUG_SERVER_DIR>===
        local java_test_dir = mason_dir .. "/packages/java-test/extension/server" -- ===<JAVA_TEST_SERVER_DIR>===
        local java_dependency_dir = mason_dir .. "/packages/vscode-java-dependency/extension/server" -- ===<JAVA_DEPENDENCY_SERVER_DIR>===
        local java_decompiler_dir = mason_dir .. "/packages/vscode-java-decompiler/server" -- ===<JAVA_DECOMPILER_SERVER_DIR>===
        local spring_boot_dir = mason_dir .. "/packages/vscode-spring-boot-tools/extension/jars" -- ===<SPRING_BOOT_EXT_DIR>===
        if vim.fn.filereadable(lombok_jar) == 0 then
            lombok_jar = jdtls_dir .. "/lombok.jar"
        end
        local launcher_jar = vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar")

        local os_uname = vim.loop.os_uname()
        local sysname = os_uname.sysname or ""
        local machine = (os_uname.machine or ""):lower()
        local is_arm = machine:match("aarch64") ~= nil or machine:match("arm") ~= nil

        local config_dir
        if sysname == "Darwin" then
            config_dir = jdtls_dir .. (is_arm and "/config_mac_arm" or "/config_mac")
        elseif sysname == "Linux" then
            config_dir = jdtls_dir .. (is_arm and "/config_linux_arm" or "/config_linux")
        else
            config_dir = jdtls_dir .. "/config_win"
        end

        local bundles = {}
        local java_debug = vim.fn.glob(java_debug_dir .. "/com.microsoft.java.debug.plugin-*.jar", true, true)
        -- Use specific glob: runner-jar-with-dependencies.jar and jacocoagent.jar are not
        -- valid OSGi bundles and cause "Failed to get bundleInfo" errors in jdtls.
        local java_test = vim.fn.glob(java_test_dir .. "/com.microsoft.java.test.plugin-*.jar", true, true)
        local java_dependency_ext = vim.fn.glob(java_dependency_dir .. "/*.jar", true, true)
        local java_decompiler_ext = vim.fn.glob(java_decompiler_dir .. "/*.jar", true, true)
        -- Filter spring-boot jars: commons-lsp-extensions.jar and xml-ls-extension.jar
        -- are not valid OSGi bundles for this jdtls version and cause bundle load errors.
        local spring_boot_all = vim.fn.glob(spring_boot_dir .. "/*.jar", true, true)
        local spring_boot_ext = {}
        local spring_boot_exclude = { ["commons-lsp-extensions.jar"] = true, ["xml-ls-extension.jar"] = true }
        for _, jar in ipairs(spring_boot_all) do
            if not spring_boot_exclude[vim.fn.fnamemodify(jar, ":t")] then
                table.insert(spring_boot_ext, jar)
            end
        end
        vim.list_extend(bundles, java_debug)
        vim.list_extend(bundles, java_test)
        vim.list_extend(bundles, java_dependency_ext)
        vim.list_extend(bundles, java_decompiler_ext)
        vim.list_extend(bundles, spring_boot_ext)

        local capabilities = lsp_utils.make_capabilities()

        local on_attach = lsp_utils.extend_on_attach(function(_, bufnr)

            pcall(function()
                jdtls.setup_dap({ hotcodereplace = "auto" })
                jdtls.dap.setup_dap_main_class_configs()
            end)

            -- :JavaBazelSync — force jdtls to re-read project config (Bazel/Maven/Gradle).
            -- Run this after a BUILD.bazel change or when go-to-definition stops working.
            vim.api.nvim_buf_create_user_command(bufnr, "JavaBazelSync", function()
                vim.lsp.buf.execute_command({ command = "java.projectConfiguration.update", arguments = { vim.uri_from_bufnr(bufnr) } })
                vim.notify("jdtls: project configuration update requested", vim.log.levels.INFO)
            end, { desc = "Re-sync jdtls project config (Bazel/Maven/Gradle)" })

            -- :JavaResetWorkspace — delete cached workspace and restart jdtls.
            -- Use when go-to-definition / classpath is broken (InvisibleProjectImporter was
            -- used instead of Maven/Gradle importer on a previous session).
            vim.api.nvim_buf_create_user_command(bufnr, "JavaResetWorkspace", function()
                local ws = workspace_dir
                vim.lsp.stop_client(vim.lsp.get_clients({ name = "jdtls" }), true)
                vim.fn.delete(ws, "rf")
                vim.notify("jdtls: workspace deleted (" .. ws .. "). Reopen the file to restart.", vim.log.levels.INFO)
            end, { desc = "Delete jdtls workspace cache and stop server (reopen file to restart)" })

            -- Format-on-save is handled globally by conform.nvim.
            -- Keep manual formatting on <leader>f via lsp_utils.default_on_attach().
        end)

        local config = {
            cmd = {
                java_bin,
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xmx2g",
                "--add-modules=ALL-SYSTEM",
                "--add-opens",
                "java.base/java.util=ALL-UNNAMED",
                "--add-opens",
                "java.base/java.lang=ALL-UNNAMED",
                "-javaagent:" .. lombok_jar,
                "-Xbootclasspath/a:" .. lombok_jar,
                "-jar",
                launcher_jar,
                "-configuration",
                config_dir,
                "-data",
                workspace_dir,
            },
            root_dir = root_dir,
            capabilities = capabilities,
            on_attach = on_attach,
            init_options = {
                bundles = bundles,
            },
            settings = {
                java = {
                    eclipse = {
                        downloadSources = true,
                    },
                    contentProvider = {
                        preferred = "fernflower",
                    },
                    maven = {
                        downloadSources = true,
                    },
                    import = {
                        maven = {
                            enabled = true,
                        },
                        gradle = {
                            enabled = true,
                            wrapper = {
                                enabled = true,
                            },
                        },
                        bazel = {
                            enabled = true,
                        },
                    },
                    -- Classpath: lombok + Maven jars from Bazel's external repo.
                    -- This keeps unmanaged Bazel Java workspaces navigable in jdtls.
                    project = {
                        referencedLibraries = {
                            include = vim.list_extend({ lombok_jar }, bazel_libraries.include),
                            sources = bazel_libraries.sources,
                        },
                    },
                    -- Keep jdtls index in sync with source changes
                    autobuild = {
                        enabled = true,
                    },
                    -- Better completion (helps Spring/Lombok method stubs appear)
                    completion = {
                        enabled = true,
                        guessMethodArguments = true,
                    },
                    configuration = {
                        updateBuildConfiguration = "automatic",
                    },
                    saveActions = {
                        organizeImports = false,
                    },
                    implementationsCodeLens = {
                        enabled = true,
                    },
                    references = {
                        includeAccessors = true,
                        includeDeclarations = true,
                        includeDecompiledSources = true,
                    },
                    referencesCodeLens = {
                        enabled = true,
                    },
                    search = {
                        scope = "all",
                    },
                    symbols = {
                        includeGeneratedCode = true,
                        includeSourceMethodDeclarations = true,
                    },
                },
            },
        }

        if launcher_jar == nil or launcher_jar == "" then
            vim.notify("jdtls launcher jar not found under: " .. jdtls_dir, vim.log.levels.ERROR)
            return
        end
        if vim.fn.isdirectory(config_dir) == 0 then
            vim.notify("jdtls config dir not found: " .. config_dir, vim.log.levels.ERROR)
            return
        end

        jdtls.start_or_attach(config)
    end,
})
