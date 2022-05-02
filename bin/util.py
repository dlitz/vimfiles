#!python3
# dlitz 2022

from argparse import Action
from contextlib import contextmanager
from enum import Enum, auto
import gzip
import io

class ByteCountingFileWrapper:
    def __init__(self, fileobj, initial_pos=0, at_close=False):
        self.__fileobj = fileobj
        self.__pos = initial_pos
        self.__count = initial_pos
        self.__final_byte_count = None
        self.__chunk_size = 128 * 1024
        self.__depth = 0
        self.__at_close = at_close
        if isinstance(fileobj, gzip.GzipFile):
            self.__seekable = False
        else:
            self.__seekable = fileobj.seekable()

    def __getattr__(self, name):
        return getattr(self.__fileobj, name)

    @contextmanager
    def call_wrapper(self):
        try:
            self.__depth += 1
            yield
        finally:
            self.__depth -= 1

    def __increment_count(self, n):
        if self.__depth > 0:
            return
        #print(f"__increment_count({n!r})")
        #print(f"__increment_count: before: __pos={self.__pos!r}, __count={self.__count!r}")
        self.__pos += n
        if n > 0:
            self.__count = max(self.__count, self.__pos)
        #print(f"__increment_count: after: __pos={self.__pos!r}, __count={self.__count!r}")

    def read1(self, size=-1):
        #print(f"read1({size!r}) -> ...")
        with self.call_wrapper():
            data = self.__fileobj.read1(size)
        self.__increment_count(len(data))
        #print(f"read1({size!r}) -> {len(data)}")
        return data

    def read(self, size=-1):
        #print(f"read({size!r})")
        with self.call_wrapper():
            data = self.__fileobj.read(size)
        self.__increment_count(len(data))
        #print(f"read({size!r}) -> {len(data)}")
        return data

    def readinto1(self, b, /):
        #print(f"readinto1(...) ...")
        with self.call_wrapper():
            n = self.__fileobj.readinto1(b)
        self.__increment_count(n)
        #print(f"readinto1(...) -> {n!r}")
        return n

    def readinto(self, b, /):
        #print(f"readinto(...) ...")
        with self.call_wrapper():
            n = self.__fileobj.readinto(b)
        self.__increment_count(n)
        #print(f"readinto(...) -> {n!r}")
        return n

    def write(self, b, /):
        #print("write")
        with self.call_wrapper():
            n = self.__fileobj.write(b)
        self.__increment_count(n)
        return n

    def seek(self, pos, whence=0):
        n = self.__pos = self.__fileobj.seek(pos, whence)
        return n

    def truncate(self, size=None):
        new_file_size = self.__fileobj.truncate(size)
        self.__count = new_file_size
        return new_file_size

    def get_file_size(self):
        #print("get_file_size() ...")
        fileobj = self.__fileobj
        if self.__final_byte_count is not None:
            count = self.__final_byte_count
        elif self.__seekable:
            pos = fileobj.tell()
            try:
                fileobj.seek(0, 2)
                count = self.__final_byte_count = fileobj.tell()
            except io.UnsupportedOperation:
                self.__seekable = False
                # we'll fall through to the non-seekable implementation below
            finally:
                if self.__seekable:
                    fileobj.seek(pos)
        if not self.__seekable:
            try:
                with self.call_wrapper():  # disable counting
                    chunk = self.read(self.__chunk_size)
                    while chunk:
                        self.__count += len(chunk)
                        chunk = self.read(self.__chunk_size)
            except io.UnsupportedOperation:     # e.g. file open for writing only
                pass
            count = self.__final_byte_count = self.__count
        #print(f"get_file_size() -> {count!r}")
        return count

    def __enter__(self):
        return self

    def __exit__(self, *args):
        return

    def close(self):
        fileobj = self.__fileobj
        if self.__at_close:
            if hasattr(fileobj, 'flush'):
                fileobj.flush()
            self.get_file_size()
            self.__at_close = False
        fileobj.close()


class HandlerDict(dict):
    def __call__(self, command_name):
        def decorate(func):
            assert command_name not in self, command_name
            self[command_name] = func
            return func
        return decorate


class ImmediateAction(type):
    def __new__(cls, action_callback, /, *args, **keywords):
        clsname = type(cls).__qualname__
        name = f'{clsname}({action_callback!r})'
        bases = (cls.ImmediateActionBase,)
        obj_dict = {
            'action_callback': staticmethod(action_callback),
            'action_args': args,
            'action_kw': keywords,
        }
        return type(name, bases, obj_dict)

    class Arg(Enum):
        """Sentinel values used to specify arguments passed to __call__"""
        action = auto()
        parser = auto()
        namespace = auto()
        values = auto()
        option_string = auto()

    class ImmediateActionBase(Action):
        def __init__(self, **kw):
            super().__init__(nargs=0, **kw)

        def __call__(self, parser, namespace, values, option_string=None):
            def replace_sentinel(arg):
                if arg is ImmediateAction.Arg.action:
                    arg = self
                elif arg is ImmediateAction.Arg.parser:
                    arg = parser
                elif arg is ImmediateAction.Arg.namespace:
                    arg = namespace
                elif arg is ImmediateAction.Arg.values:
                    arg = values
                elif arg is ImmediateAction.Arg.option_string:
                    arg = option_string
                return arg
            args = [replace_sentinel(arg) for arg in self.action_args]
            kw = {n: replace_sentinel(arg) for n, a in self.action_kw.items()}
            return self.action_callback(*args, **kw)
