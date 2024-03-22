interface NumTools
    exposes [
        exp,
        # log,
        # log2,
        # log10,
        # nthroot,
        square,
    ]
    imports

square : Num a -> Num a
square = \n -> n * n

exp : Frac a -> Frac a
exp = \p -> Num.pow Num.e p

# TODO: Comment out when corresponding compiler bugs fixed.
# log : Frac * -> Frac *
# log = \a, b -> Num.log b |> Num.div Num.log a
#
# log2 : Frac * -> Frac *
# log2 = \b -> log 2 b
#
# log10 : Frac * -> Frac *
# log10 = \b -> log 10 b
#
# nthRoot = f = \n, p -> Num.pow Num.e (Num.log n |> Num.div p)
