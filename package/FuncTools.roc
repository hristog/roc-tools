interface FuncTools
    exposes [
        compose2With2,
        compose2With3,
        compose2With4,
        compose2With5,
        compose3With2,
        compose3With3,
        compose3With4,
        compose3With5,
        curry2,
        curry2Backwards,
        curry3,
        curry3Backwards,
        curry4,
        curry4Backwards,
        curry5,
        curry5Backwards,
        flip2,
        flip3,
        flip4,
        flip5,
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

compose2With2 = \f, g ->
    \a, b -> g a b |> f

compose2With3 = \f, g ->
    \a, b, c -> g a b c |> f

compose2With4 = \f, g ->
    \a, b, c, d -> g a b c d |> f

compose2With5 = \f, g ->
    \a, b, c, d, e -> g a b c d e |> f

compose3With2 = \f, g, h ->
    \a, b -> h a b |> g |> f

compose3With3 = \f, g, h ->
    \a, b, c -> h a b c |> g |> f

compose3With4 = \f, g, h ->
    \a, b, c, d -> g a b c d |> g |> f

compose3With5 = \f, g, h ->
    \a, b, c, d, e -> h a b c d e |> g |> f

flip2 : (a, b -> c), b, a -> c
flip2 = \f, b, a -> f a b

flip3 : (a, b, c -> d), c, b, a -> d
flip3 = \f, c, b, a -> f a b c

flip4 : (a, b, c, d -> e), d, c, b, a -> e
flip4 = \f, d, c, b, a -> f a b c d

flip5 : (a, b, c, d, e -> f), e, d, c, b, a -> f
flip5 = \fn, e, d, c, b, a -> fn a b c d e

partial2Takes1 : (a, b -> c), a -> (b -> c)
partial2Takes1 = \f, a -> \b -> f a b

expect
    sum = \a, b -> a + b
    add100 = partial2Takes1 sum 100
    expected = 150
    actual = add100 50
    actual == expected

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
curry2Backwards = partial2Takes1Backwards

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
