##
## autodownload.kak by lenormf
## Download a remote file when a URL is used as a buffer name
##

decl -docstring "when enabled, the buffer containing the download logs will not be removed" \
    bool autodownload_keep_log no

## Format of the download string that will be used to fetch the file
## Defaults to autodownload_format_wget
decl -docstring %{formatted shell command used to download a file
The following mustache variables are expanded:
  - {progress}: path to the named pipe to which the download progress is written
  - {output}: path to the output file
  - {url}: address of the file to download
Defaults to the `autodownload_format_wget` format} \
    str autodownload_format

## Pre-defined formats for different popular download tools
decl -docstring "default formatted command for the `wget` utility" \
    str autodownload_format_wget "wget -o '{progress}' -O '{output}' '{url}'"
decl -docstring "default formatted command for the `aria2c` utility" \
    str autodownload_format_aria2 "aria2c -o $(basename '{output}') -d $(dirname '{output}') '{url}' > '{progress}'"
decl -docstring "default formatted command for the `curl` utility" \
    str autodownload_format_curl "curl -o '{output}' '{url}' 2> '{progress}'"

## Set the default downloader to be wget
set global autodownload_format %opt{autodownload_format_wget}

hook global BufNewFile .* %{
    %sh{ {
        readonly netproto_url="${kak_bufname}"
        readonly netproto_ext="${netproto_url##*.}"
        readonly netproto_proto="${netproto_url%:*}"

        ## Check that the downloader used is reachable from this shell
        command -v "${kak_opt_autodownload_format%% *}" >/dev/null || exit

        ## Check that a url was passed to kakoune
        if ! expr "${netproto_url}" : '[a-zA-Z][a-zA-Z]*://.' >/dev/null; then
            exit
        fi

        ## Create a temporary directory in which we will download the file
        readonly path_dir_tmp=$(mktemp -d -t kak-proto.XXXXXXXX)
        if [ -z "${path_dir_tmp}" ]; then
            echo "echo -debug Unable to create temporary directory" | kak -p "${kak_session}"
            exit 2
        fi

        readonly netproto_buffer="${path_dir_tmp}/buffer"
        readonly netproto_fifo="${path_dir_tmp}/fifo"

        ## Create a named pipe that will print the download status
        if ! mkfifo "${netproto_fifo}"; then
            rm -rf "${path_dir_tmp}"
            echo "echo -debug Unable to create named pipe" | kak -p "${kak_session}"
            exit 2
        fi

        readonly buffer_basename="${netproto_url##*/}"

        ## Start downloading the file to a temporary directory
        {
            download_str=$(printf %s "${kak_opt_autodownload_format}" | \
                               sed -e "s/{url}/${netproto_url//\//\\\/}/g" \
                                   -e "s/{progress}/${netproto_fifo//\//\\\/}/g" \
                                   -e "s/{output}/${netproto_buffer//\//\\\/}/g")
            eval "${download_str}"
        } 2>&1 >/dev/null </dev/null &

        ## Open a new buffer who will read and print the download's progress
        ## Remove the original buffer that was named after the URL of the file to fetch
        ## When the file has been downloaded, create its own buffer and remove temporary files
        ## If the user doesn't want to have the download progress kept in its own buffer after
        ## the download has finished, we remove that buffer
        printf %s "
            eval -buffer '${netproto_url}' %{
                edit! -fifo '${netproto_fifo}' -scroll 'download:${netproto_url}'
                delete-buffer! '${netproto_url}'
                hook -group fifo 'buffer=download:${netproto_url}' BufCloseFifo .* %{
                    nop %sh{
                        if command -v atool >/dev/null; then
                            case \"${netproto_ext}\" in
                                zip|rar|lha|lzh|7z|alz|ace|arj|arc|gz|bz|bz2|Z|lzma|lzo|lz|xz|rz|lrz|7z|cpio)
                                    readonly path_tmp_file=\$(mktemp kak-extract.XXXXXXXX)
                                    atool -F \"${netproto_ext}\" -X \"\${path_tmp_file}\" \"${netproto_buffer}\" 2>/dev/null
                                    mv \"\${path_tmp_file}\" \"${netproto_buffer}\"
                                ;;
                            esac
                        fi
                    }
                    edit '${buffer_basename}'
                    exec -no-hooks '%d!cat \"${netproto_buffer}\"<ret>d'

                    %sh{
                        rm -rf '${path_dir_tmp}'
                        if [ '${kak_opt_autodownload_keep_log,,}' != true ]; then
                            printf %s '
                                delete-buffer! 'download:${netproto_url}'
                                buffer '${buffer_basename}'
                            '
                        fi
                    }
                    rmhooks buffer fifo
                }
            }
        " | kak -p "${kak_session}"
    } 2>&1 >/dev/null </dev/null &
    }
}
