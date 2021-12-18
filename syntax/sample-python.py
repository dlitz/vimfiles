# vim:set ft=python spell:

import math
import decimal

print(f"""
testa

{
    range(
        int(10))

}

test

""")

test = 0
d = {test: 44}

x = (d[test])

num = decimal.Decimal("0.0")

def doctest_test():
    """
    This is a test

        >>> print("Hello world")
        >>> {rangex}
        rangex

    rangex
    """

#X @= Y
#
#X@Y
#
#@Y
#
#All

class X:
    class Y:
        pass
    def hello(self):
        pass

ranger = range
rangex = range

foo = [ range, ranger, rangex ]

items = [
    "\"asdf",
    r"\"asdf",
    "1\x20{list({x} for x in range(5))}",
    u"2\x20{list({x} for x in range(5))}",
    r"3\x20{list({x} for x in range(5))}",
    br"4a\x20{list({x} for x in range(5))}",
    Br"4b\x20{list({x} for x in range(5))}",
    bR"4c\x20{list({x} for x in range(5))}",
    BR"4d\x20{list({x} for x in range(5))}",
    #ur"5\x20{list({x} for x in range(5))}",   # bad in python 3; ok in python 2
    br"6\x20{list({x} for x in range(5))}",
    rb"7\x20{list({x} for x in range(5))}",
    #urf"8\x20{list({x} for x in range(5))}",  # bad
    #brf"9\x20{list({x} for x in range(5))}",  # bad
    #uf"10\x20{list({x} for x in range(5))}",  # bad
    #bf"11\x20{list({x} for x in range(5))}",  # bad
    f"12\"\x20{list({x} for x in range(5))}",

    fr"13a\x20{list({x} for x in range(5))}",
    fR"13b\x20{list({x} for x in range(5))}",
    FR"13c\x20{list({x} for x in range(5))}",
    Fr"13d\x20{list({x} for x in range(5))}",
    rf"14a\x20{list({x} for x in range(5))}",
    Rf"14b\x20{list({x} for x in [1,2,3,4,tuple({1:2}.items()),5])}",
    RF"14c\x20{list({str(x) + '}'} for x in ranger(5))}",
    rF"14d\x20{list({x, x} for x in rangex(5))}",
    f"The value of pi is approximately {math.pi:.3f}",
    f"more formatting {num!r}",
    f"more formatting {num!a}",
    f"more formatting {num!s}",
    f"more formatting {num!s:10s}",
    f"more formatting {num!s:10s}",
    #f"more formatting {num!Test!r}",
    f"more formatting {'Hello!x:test'=!r:20s}|",
    f"foo{x}",
    f"foo{('(', '[', '}')}", d, 5,
]
for item in items:
    print(item)

{
    "foo" : [ "bar", "baz" ]
}

# ranger
# rangex
ranger
rangex
