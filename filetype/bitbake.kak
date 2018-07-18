##
## bitbake.kak by lenormf
##

# http://www.yoctoproject.org/docs/1.8/bitbake-user-manual/bitbake-user-manual.html
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .+\.bb(class|append)? %{
    set-option buffer filetype bitbake
}

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/bitbake regions
add-highlighter shared/bitbake/code default-region group
add-highlighter shared/bitbake/double_string region  %{(?<!\\)(\\\\)*\K"} %{(?<!\\)(\\\\)*"} ref sh/double_string
add-highlighter shared/bitbake/single_string region %{(?<!\\)(\\\\)*\K'} %{'} ref sh/single_string
add-highlighter shared/bitbake/comment region '(?<!\$)#' '$' ref sh/comment
add-highlighter shared/bitbake/python_inline region '\$\{@' \} ref python
add-highlighter shared/bitbake/python_bb region '^\h*python(\h+\w+)?\h*\(\h*\)\h*\{' \} group
add-highlighter shared/bitbake/python_native region '^def\h+\w+\([^)]*\)\h*:' '^(?=[^\h])' ref python
add-highlighter shared/bitbake/shell_bb region -recurse \{ '^\h*[\w${}]+\h*\([^)]*\)\h\{' \} ref sh

add-highlighter shared/bitbake/python_bb/ ref python
add-highlighter shared/bitbake/python_bb/ regex '^\h*(python)(\h+\w+)?\h*\(\h*\)\h*\{' 1:green+b

add-highlighter shared/bitbake/code/ regex \$\{?(ASSUME_PROVIDED|B|BB_ALLOWED_NETWORKS|BBCLASSEXTEND|BB_CONSOLELOG|BB_CURRENTTASK|BB_DANGLINGAPPENDS_WARNONLY|BBDEBUG|BB_DEFAULT_TASK|BB_DISKMON_DIRS|BB_DISKMON_WARNINTERVAL|BB_ENV_EXTRAWHITE|BB_ENV_WHITELIST|BB_FETCH_PREMIRRORONLY|BBFILE_COLLECTIONS|BB_FILENAME|BBFILE_PATTERN|BBFILE_PRIORITY|BBFILES|BB_GENERATE_MIRROR_TARBALLS)\}? 0:value
add-highlighter shared/bitbake/code/ regex \$\{?(BB_HASHBASE_WHITELIST|BB_HASHCHECK_FUNCTION|BB_HASHCONFIG_WHITELIST|BBINCLUDED|BBINCLUDELOGS|BBINCLUDELOGS_LINES|BB_INVALIDCONF|BBLAYERS|BBLAYERS_FETCH_DIR|BB_LOGFMT|BBMASK|BB_NICE_LEVEL|BB_NO_NETWORK|BB_NUMBER_PARSE_THREADS|BB_NUMBER_THREADS|BB_ORIGENV|BBPATH|BB_PRESERVE_ENV|BB_RUNFMT|BB_RUNTASK)\}? 0:value
add-highlighter shared/bitbake/code/ regex \$\{?(BB_SCHEDULER|BB_SCHEDULERS|BBSERVER|BB_SETSCENE_DEPVALID|BB_SETSCENE_VERIFY_FUNCTION|BB_SIGNATURE_EXCLUDE_FLAGS|BB_SIGNATURE_HANDLER|BB_SRCREV_POLICY|BB_STAMP_POLICY|BB_STAMP_WHITELIST|BB_STRICT_CHECKSUM|BB_TASKHASH|BB_TASK_NICE_LEVEL|BB_VERBOSE_LOGS|BBVERSIONS|BB_WORKERCONTEXT|BITBAKE_UI|BUILDNAME|BZRDIR|C)\}? 0:value
add-highlighter shared/bitbake/code/ regex \$\{?(CACHE|CVSDIR|D|DEFAULT_PREFERENCE|DEPENDS|DESCRIPTION|DL_DIR|E|EXCLUDE_FROM_WORLD|F|FAKEROOT|FAKEROOTBASEENV|FAKEROOTCMD|FAKEROOTDIRS|FAKEROOTENV|FAKEROOTNOENV|FETCHCMD|FILE|FILESDIR|FILESPATH)\}? 0:value
add-highlighter shared/bitbake/code/ regex \$\{?(G|GITDIR|H|HGDIR|HOMEPAGE|I|INHERIT|L|LAYERDEPENDS|LAYERDIR|LAYERVERSION|LICENSE|M|MIRRORS|MULTI_PROVIDER_WHITELIST|O|OVERRIDES|P|PACKAGES|PACKAGES_DYNAMIC|)\}? 0:value
add-highlighter shared/bitbake/code/ regex \$\{?(PE|PERSISTENT_DIR|PF|PN|PR|PREFERRED_PROVIDER|PREFERRED_PROVIDERS|PREFERRED_VERSION|PREMIRRORS|PROVIDES|PRSERV_HOST|PV|R|RDEPENDS|RPROVIDES|RRECOMMENDS|S|SECTION|SRCDATE|SRCREV|)\}? 0:value
add-highlighter shared/bitbake/code/ regex \$\{?(SRCREV_FORMAT|SRC_URI|STAMP|STAMPCLEAN|SUMMARY|SVNDIR|T|TOPDIR)\}? 0:value

add-highlighter shared/bitbake/code/ regex \b(inherit|include|require|addtask|deltask|export|addhandler)\b 0:keyword

# Commands
# ‾‾‾‾‾‾‾‾

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=bitbake %{
    add-highlighter window/bitbake ref bitbake
}
hook global WinSetOption filetype=(?!bitbake).* %{
    remove-highlighter window/bitbake
}
