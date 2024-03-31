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
    ( Num.divTrunc a b
    , Num.rem a b
    )

square : Num a -> Num a
square = \n -> n * n

exp : Frac a -> Frac a
exp = \p -> Num.pow Num.e p

nthRoot = \x, n -> Num.pow x (1 / n)

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
