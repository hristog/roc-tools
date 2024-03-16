interface FuncTools
    exposes [
        curry2,
        curry3,
        curry3Backwards,
        curry4,
        curry4Backwards,
        curry5,
        curry5Backwards,
        flipArgs2,
        flipArgs3,
        partial2Takes1,
        partial2Takes1Backwards,
        partial3Takes1,
        partial3Takes1Backwards,
        partial3Takes2,
        partial3Takes2Backwards,
        partial4Takes1,
        partial4Takes2,
        partial4Takes3,
        partial5Takes3,
        partial5Takes1,
        partial5Takes2,
        partial5Takes3,
        partial5Takes4,
    ]
    imports []

flipArgs2 : (a, b -> c), b, a -> c
flipArgs2 = \f, b, a -> f a b

flipArgs3 : (a, b, c -> d), c, b, a -> d
flipArgs3 = \f, c, b, a -> f a b c

partial2Takes1 : (a, b -> c), a -> (b -> c)
partial2Takes1 = \f, a -> \b -> f a b

partial2Takes1Backwards : (a, b -> c), b -> (a -> c)
partial2Takes1Backwards = \f, b -> \a -> f a b

partial3Takes1 : (a, b, c -> d), a -> (b, c -> d)
partial3Takes1 = \f, a -> \b, c -> f a b c

partial3Takes1Backwards : (a, b, c -> d), c -> (a, b -> d)
partial3Takes1Backwards = \f, c -> \a, b -> f a b c

partial3Takes2 : (a, b, c -> d), a, b -> (c -> d)
partial3Takes2 = \f, a, b -> \c -> f a b c

partial3Takes2Backwards : (a, b, c -> d), b, c -> (a -> d)
partial3Takes2Backwards = \f, b, c -> \a -> f a b c

partial4Takes1 : (a, b, c, d -> e), a -> (b, c, d -> e)
partial4Takes1 = \f, a -> \b, c, d -> f a b c d

partial4Takes2 : (a, b, c, d -> e), a, b -> (c, d -> e)
partial4Takes2 = \f, a, b -> \c, d -> f a b c d

partial4Takes3 : (a, b, c, d -> e), a, b, c -> (d -> e)
partial4Takes3 = \f, a, b, c -> \d -> f a b c d

partial5Takes1 : (a, b, c, d, e -> f), a -> (b, c, d, e -> f)
partial5Takes1 = \f, a -> \b, c, d, e -> f a b c d e

partial5Takes2 : (a, b, c, d, e -> f), a, b -> (c, d, e -> f)
partial5Takes2 = \f, a, b -> \c, d, e -> f a b c d e

partial5Takes3 : (a, b, c, d, e -> f), a, b, c -> (d, e -> f)
partial5Takes3 = \f, a, b, c -> \d, e -> f a b c d e

partial5Takes4 : (a, b, c, d, e -> f), a, b, c, d -> (e -> f)
partial5Takes4 = \f, a, b, c, d -> \e -> f a b c d e

curry2 = partial2Takes1

curry3 : (a, b, c -> d), a -> (b -> (c -> d))
curry3 = \f, a -> \b -> \c -> f a b c

curry3Backwards : (a, b, c -> d), c -> (b -> (a -> d))
curry3Backwards = \f, c -> \b -> \a -> f a b c

curry4 : (a, b, c, d -> e), a -> (b -> (c -> (d -> e)))
curry4 = \f, a -> \b -> \c -> \d -> f a b c d

curry4Backwards : (a, b, c, d -> e), d -> (c -> (b -> (a -> e)))
curry4Backwards = \f, d -> \c -> \b -> \a -> f a b c d

curry5 : (a, b, c, d, e -> f), a -> (b -> (c -> (d -> (e -> f))))
curry5 = \f, a -> \b -> \c -> \d -> \e -> f a b c d e

curry5Backwards : (a, b, c, d, e -> f), e -> (d -> (c -> (b -> (a -> f))))
curry5Backwards = \f, e -> \d -> \c -> \b -> \a -> f a b c d e

expect
    sum = \a, b -> a + b
    add100 = partial2Takes1 sum 100
    expected = 150
    actual = add100 50
    actual == expected
