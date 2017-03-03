httptail
========

Yet another command line utility to "tail" files over network.

#### Features:
 - Partial downloads (selecting start and/or end offset or byte count)
 - Follow mode, allowing to continuously stream one or more remote files
 - Downloading same file from multiple servers (e.g. log files from clusterized app)
 - Preset values can be stored in configuration file, to easily access often viewed files

#### Usage:
  ./httptail [OPTIONS] [URL ...]

#### Options:
    -c|--config FILE      read defaults and options from FILE,
                          defaults to $HOME/.httptailrc
    -p|--preset STRING    selects named preset from configuration file
    -n|--count NUM        output last NUM bytes, defaults to 4096
    -f|--follow           append data to the output as the file grows
    -i|--interval NUM     check for updates every NUM seconds, defaults to 1,
                          only makes sense with --follow
    -s|--start NUM        output starts at byte NUM, defaults to 0,
                          this option is mutually exclusive with --count
    -e|--end NUM          output ends at byte NUM, defaults to end of file,
                          this option is mutually exclusive with --count
    -P|--prepend          prefix each line with file url
    -x|--debug            debug mode
    -h|--help             print help (this text)

#### Examples:
  Print last 10kb:

    ./httptail -c 10240 "http://example.com/path/file.log"

  Print everything from byte 1024 to 2048:

    ./httptail -s 1024 -e 2048 "http://example.com/path/file.log"

  Print what was appended to the file on the server every 0.5s:

    ./httptail -f -i 0.5 "http://example.com/path/file.log"

  Print stream a log from 4 servers simultaneously:

    ./httptail -f "http://server{1..4}.example.com/path/file.log"

#### Configuration:
  Configuration file format is described in the [sample config file](https://github.com/dolik-rce/httptail/blob/master/httptailrc).
