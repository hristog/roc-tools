interface NumTools
    exposes [
        exp,
        divMod,
        # log,
        # log2,
        # log10,
        nthRoot,
        square,
    ]
    imports []

divMod : Int a, Int a -> (Int a, Int a)
divMod = \a, b ->
    (
        Num.divTrunc a b,
        Num.rem a b,
    )

expect
    expected = (0, 0)
    actual = divMod 0 10
    actual == expected

expect
    expected = (100, 0)
    actual = divMod 100 1
    actual == expected

expect
    expected = (3, 1)
    actual = divMod 31 10
    actual == expected

square : Num a -> Num a
square = \n -> n * n

expect
    expected = 625
    actual = square 25
    actual == expected

expect
    expected = 256.0
    actual = square 16.0
    actual == expected

exp : Frac a -> Frac a
exp = \p -> Num.pow Num.e p

expect
    expected = 1.0
    actual = exp 0
    actual == expected

nthRoot = \x, n -> Num.pow x (1 / n)

# TODO: This results in a Segmentation fault (core dumped).
# Annotating the function doesn't seem to help either:
# nthRoot : Frac a, Frac a -> Frac a
# expect
#     expected = 5.0
#     actual = nthRoot 125 3
#     actual == expected

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
