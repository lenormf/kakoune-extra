##
## dub-sdl.kak by lenormf
##

# https://code.dlang.org/package-format?lang=sdl
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*/?dub\.sdl %{
    set-option buffer filetype dub-sdl
}

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/dub-sdl regions
add-highlighter shared/dub-sdl/code default-region group
add-highlighter shared/dub-sdl/double_string region %{(?<!\\)(\\\\)*\K"} %{(?<!\\)(\\\\)*"} fill string

# Global settings
add-highlighter shared/dub-sdl/code/ regex \b(?:name|description|homepage|authors|copyright|license|subPackage|configuration|buildType|x:ddoxFilterArgs)\b 0:keyword

# Build settings
add-highlighter shared/dub-sdl/code/ regex \b(?:dependency|systemDependencies|targetType|targetName|targetPath|workingDirectory|subConfiguration|buildRequirements|buildOptions|libs|sourceFiles|sourcePaths|excludedSourceFiles|mainSourceFile|copyFiles|versions|debugVersions|importPaths|stringImportPaths|preGenerateCommands|postGenerateCommands|preBuildCommands|postBuildCommands|dflags|lflags)\b 0:keyword

# Environment variables
add-highlighter shared/dub-sdl/code/ regex \$(?:PACKAGE_DIR|ROOT_PACKAGE_DIR|[\w_-]+_PACKAGE_DIR|DUB_PACKAGE|DUB_ROOT_PACKAGE|DFLAGS|LFLAGS|VERSIONS|LIBS|IMPORT_PATHS|STRING_IMPORT_PATHS|DC|DC_BASE|D_FRONTEND_VER|DUB_PLATFORM|DUB_ARCH|DUB_TARGET_TYPE|DUB_TARGET_PATH|DUB_TARGET_NAME|DUB_WORKING_DIRECTORY|DUB_MAIN_SOURCE_FILE|DUB_CONFIG|DUB_BUILD_TYPE|DUB_BUILD_MODE|DUB_COMBINED|DUB_RUN|DUB_FORCE|DUB_RDMD|DUB_TEMP_BUILD|DUB_PARALLEL_BUILD|DUB_RUN_ARGS)\b 0:value

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=dub-sdl %{
    add-highlighter window/dub-sdl ref dub-sdl
}
hook global WinSetOption filetype=(?!dub-sdl).* %{
    remove-highlighter window/dub-sdl
}
