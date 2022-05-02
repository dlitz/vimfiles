#!/usr/bin/env python3
# dlitz 2022
# gzip replacement for my vim stuff that allows any file extension
from argparse import ArgumentParser, SUPPRESS
from contextlib import ExitStack
from shutil import copyfileobj
from pathlib import Path
from tempfile import NamedTemporaryFile
import enum
import gzip
import io
import os
import sys

from util import ByteCountingFileWrapper, HandlerDict, ImmediateAction

program_name = Path(__file__).stem
__version__ = '0.0.1'
program_version_string = f'{program_name} {__version__}'
verbose = False
command_handlers = HandlerDict()

def print(*args, **kw):
    kw.setdefault('file', sys.stderr)
    return __builtins__.print(*args, **kw)

def verbose_print(*args, **kw):
    if verbose:
        print(*args, **kw)

def show_license():
    sys.stdout.write(program_version_string + "\n")
    sys.stdout.write("\n")
    sys.stdout.write("License: TODO\n")  # TODO
    sys.exit(0)

def show_version():
    sys.stdout.write(program_version_string + "\n")
    sys.exit(0)

def open_path(path, mode='r', *args, **kw):
    if str(path) == '-':
        if 'r' in mode:
            fd = sys.stdin.fileno()
        elif 'w' in mode or 'x' in mode or 'a' in mode:
            fd = sys.stdout.fileno()
        else:
            fd = -1
        return open(fd, mode, *args, closefd=False, **kw)
    else:
        return open(path, mode, *args, **kw)

@command_handlers('list')
def cmd_list(args, parser):
    fmt = "%19s%20s%7s %s"
    header_line = fmt % ("compressed", "uncompressed", "ratio", "uncompressed_name")
    sys.stdout.write(header_line + "\n")
    for path in args.files:
        with ByteCountingFileWrapper(open_path(path, 'rb')) as file, \
                ByteCountingFileWrapper(gzip.open(file, 'rb')) as gz:
            compressed = gz.get_file_size()
            uncompressed = file.get_file_size()
            # ratio should omit the length of the header, but GzipFile
            # doesn't tell us what that is.
            #ratio = (uncompressed - (compressed-header_length)) / uncompressed
            ratio = (uncompressed - compressed) / uncompressed
            if path.name.endswith('.gz'):
                uncompressed_name = path.stem
            else:
                uncompressed_name = path.name
            sys.stdout.write(fmt % (compressed, uncompressed, f'{ratio * 100.0:.1f}%', uncompressed_name) + "\n")

@command_handlers('test')
def cmd_test(args, parser):
    for path in args.files:
        with open_path(path, 'rb') as file, \
                gzip.open(file, 'rb') as gz:
            chunk = gz.read(128*1024)
            while chunk:
                chunk = gz.read(128*1024)
        if str(path) != '-':
            verbose_print(f'{path}:\t', end='')
        verbose_print(' OK')

def _compress_decompress(args, parser, decompress=True):
    for inpath, outpath in zip(args.files, args.output_files):
        delete_tempfile = False
        try:
            with ExitStack() as stack:
                # Open the files
                infile0 = stack.enter_context(
                        ByteCountingFileWrapper(open_path(inpath, 'rb'), at_close=True))
                if decompress:
                    infile = stack.enter_context(gzip.open(infile0, 'rb'))
                else:
                    infile = infile0

                if str(inpath) == '-' or args.stdout:
                    stdout_mode = True
                    output_tempfile = None
                    outfile0 = stack.enter_context(
                            ByteCountingFileWrapper(
                                open_path(Path('-'), 'wb'), at_close=True))
                else:
                    stdout_mode = False
                    output_tempfile = NamedTemporaryFile(
                        dir=inpath.resolve().parent,
                        prefix='.' + inpath.name + '.',
                        suffix='.gziptmp',
                        delete=False)
                    delete_tempfile = True
                    outfile0 = stack.enter_context(
                        ByteCountingFileWrapper(output_tempfile, at_close=True))

                if decompress:
                    outfile = outfile0
                else:
                    if str(inpath) == '-':
                        orig_filename = ''
                    else:
                        orig_filename = inpath.name
                    outfile = stack.enter_context(
                        ByteCountingFileWrapper(
                            gzip.GzipFile(
                                filename=orig_filename,
                                mode='wb',
                                fileobj=outfile0,
                                compresslevel=args.compresslevel)))

                # compress/decompress data
                copyfileobj(infile, outfile)
                infile.close()
                outfile.close()

                if decompress:
                    compressed_size = infile0.get_file_size()
                    uncompressed_size = outfile0.get_file_size()
                else:
                    compressed_size = outfile0.get_file_size()
                    uncompressed_size = infile0.get_file_size()

                if uncompressed_size == 0:
                    ratio = 0
                else:
                    ratio = (uncompressed_size - compressed_size) / uncompressed_size

                infile.close()
                outfile.close()

                # Update the file
                if not stdout_mode:
                    # Move the tempfile to the destination path
                    Path(output_tempfile.name).rename(outpath)
                    delete_tempfile = False
                    if not args.same_filename:
                        # Remove the source file
                        if inpath.resolve() != outpath.resolve():
                            inpath.unlink()
                    verbose_print(f"{inpath}:\t {ratio*100:2.1f}% -- replaced with {outpath}")
        finally:
            if delete_tempfile:
                Path(output_tempfile.name).unlink()

@command_handlers('decompress')
def cmd_decompress(args, parser):
    return _compress_decompress(args, parser, decompress=True)

@command_handlers('compress')
def cmd_compress(args, parser):
    return _compress_decompress(args, parser, decompress=False)

def parse_args():
    parser = ArgumentParser(description="""
        Compress or uncompress FILEs in-place (unless -c is given),
        even if they have no .gz extension.""")
    g_cmd = parser.add_mutually_exclusive_group()
    g_cmd.add_argument('-d', '--decompress', action='store_const',
        dest='cmd', const='decompress', default='compress',
        help='decompress (default: compress)')
    g_cmd.add_argument('-l', '--list', action='store_const',
        dest='cmd', const='list',
        help='list compressed file contents')
    g_cmd.add_argument('-t', '--test', action='store_const',
        dest='cmd', const='test',
        help='test compressed file integrity')
    g_cmd.add_argument('-L', '--license',
        action=ImmediateAction(show_license),
        help='display software license')
    g_cmd.add_argument('-V', '--version',
        action=ImmediateAction(show_version),
        help='display version number')

    parser.add_argument('-c', '--stdout', action='store_true',
        help='write on stdout, keep original files unchanged')
    g_name = parser.add_mutually_exclusive_group()
    g_name.add_argument('-n', '--no-name', action='store_false', dest='name',
        help='do not save or restore the original name and timestamp')
    g_name.add_argument('-N', '--name', action='store_true', dest='name',
        help='save or restore the original name and timestamp')
    parser.add_argument('-v', '--verbose', action='store_true',
        help='verbose mode')
    parser.add_argument('-1', '--fast', action='store_const',
        dest='compresslevel', const=1, default=6, help='compress faster')
    for level in range(2, 9):
        parser.add_argument(f'-{level:d}', action='store_const',
            dest='compresslevel', const=level, help=SUPPRESS)
    parser.add_argument('-9', '--best', action='store_const',
        dest='compresslevel', const=9, help='compress better')
    parser.add_argument('--same-filename', action='store_true',
        help='use the same filename for input as for output')
    parser.add_argument('--always-suffix', action='store_true',
        help='always remove a suffix when decompressing, even when the suffix is not .gz')
    parser.add_argument('files', metavar='FILE', nargs='*', type=Path,
        default=[Path('-')],
        help="file to read, or when file is -, read standard input.")

    args = parser.parse_args()

    if args.cmd in ('compress', 'decompress'):
        args.output_files = []
        for path in args.files:
            if args.stdout or str(path) == '-':
                output_file = Path('-')
            elif args.same_filename:
                output_file = path
            elif args.cmd == 'decompress':
                if path.name.endswith(".gz") or args.always_suffix:
                    output_file = path.with_name(path.stem)
                else:
                    output_file = path
            else:   # compress
                docpath = os.environ.get('VIM_GZIP_NAME_HACK')
                if docpath:
                    docpath = Path(docpath)
                    output_file = path.with_name(docpath.name)
                else:
                    output_file = path.with_name(path.name + ".gz")
            args.output_files.append(output_file)
        assert len(args.files) == len(args.output_files)

    return args, parser

def main():
    global verbose
    args, parser = parse_args()
    if args.verbose:
        verbose = True
    sys.stdout.reconfigure(line_buffering=True)
    sys.stderr.reconfigure(line_buffering=True)
    command_handlers[args.cmd](args, parser)

if __name__ == '__main__':
    main()
