local ssh_utils = require("motleyfesst.ssh_utils")

if not ssh_utils.IS_LOCAL() then
    return
end

local lsp_utils = require("motleyfesst.lsp_utils")
local jdtls_group = vim.api.nvim_create_augroup("JdtlsAutostart", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = jdtls_group,
    pattern = "java",
    callback = function()
        local ok_jdtls, jdtls = pcall(require, "jdtls")
        if not ok_jdtls then
            vim.notify("nvim-jdtls is not available", vim.log.levels.WARN)
            return
        end

        local ok_setup, jdtls_setup = pcall(require, "jdtls.setup")
        if not ok_setup then
            vim.notify("nvim-jdtls setup module is not available", vim.log.levels.WARN)
            return
        end

        local root_markers = {
            ".git",
            "mvnw",
            "gradlew",
            "pom.xml",
            "build.gradle",
            "build.gradle.kts",
            "settings.gradle",
            "settings.gradle.kts",
            "WORKSPACE",
            "WORKSPACE.bazel",
            "MODULE.bazel",
            "BUILD",
            "BUILD.bazel",
        }
        local root_dir = jdtls_setup.find_root(root_markers)
        if root_dir == nil or root_dir == "" then
            root_dir = vim.fn.getcwd()
        end

        local project_name = vim.fn.fnamemodify(root_dir, ":p:t")

        -- Collect Maven jars from Bazel's external repository so jdtls can resolve
        -- external dependencies for go-to-definition, hover, and completion.
        -- rules_jvm_external stores downloaded jars under bazel-{workspace}/external/maven/.
        local function collect_bazel_classpath_jars()
            local exec_root = root_dir .. "/bazel-" .. project_name
            if vim.fn.isdirectory(exec_root) == 0 then
                return {}
            end
            local maven_dir = exec_root .. "/external/maven"
            if vim.fn.isdirectory(maven_dir) == 0 then
                return {}
            end
            local all_jars = vim.fn.glob(maven_dir .. "/**/*.jar", false, true)
            local jars = {}
            for _, jar in ipairs(all_jars) do
                local name = vim.fn.fnamemodify(jar, ":t")
                -- Skip sources and javadoc jars — jdtls fetches those via downloadSources
                if not name:match("%-sources%.jar$") and not name:match("%-javadoc%.jar$") then
                    table.insert(jars, jar)
                end
            end
            return jars
        end

        local home = os.getenv("HOME")
        local mason_dir = home .. "/.local/share/nvim/mason" -- ===<MASON_DIR>===
        local jdtls_dir = mason_dir .. "/packages/jdtls" -- ===<JDTLS_DIR>===
        local workspace_dir = home .. "/.local/share/nvim/jdtls-workspace/" .. project_name -- ===<JDTLS_WORKSPACE_DIR>===

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

        -- Full protocol capabilities (not lsp_utils.make_capabilities() — preserves textDocument)
        -- Old nvim-cmp code in after/discharged/completion/
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local ok_blink, blink_cmp = pcall(require, "blink.cmp")
        if ok_blink then
            capabilities = blink_cmp.get_lsp_capabilities(capabilities)
        end

        local on_attach = function(client, bufnr)
            lsp_utils.attach_default_keymaps(bufnr)
            require("motleyfesst.fold_utils").on_lsp_attach(client, bufnr)

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

            -- Format-on-save: conform.nvim handles this globally (google-java-format).
            -- If conform is unavailable, fall back to jdtls LSP formatting.
            local format_group = vim.api.nvim_create_augroup("JavaFormatOnSave", { clear = false })
            vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = format_group,
                buffer = bufnr,
                callback = function()
                    local ok_conform, conform = pcall(require, "conform")
                    if ok_conform then
                        conform.format({ bufnr = bufnr, timeout_ms = 3000, lsp_format = "fallback" })
                    else
                        vim.lsp.buf.format({
                            bufnr = bufnr,
                            async = false,
                            filter = function(c)
                                return c.name == "jdtls"
                            end,
                        })
                    end
                end,
            })
        end

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
                    -- Classpath: lombok + all Maven jars from Bazel's external repo.
                    -- This is what enables go-to-definition across external dependencies.
                    project = {
                        referencedLibraries = vim.list_extend(
                            { lombok_jar },
                            collect_bazel_classpath_jars()
                        ),
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
                    referencesCodeLens = {
                        enabled = true,
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
