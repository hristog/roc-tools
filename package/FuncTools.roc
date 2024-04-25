interface FuncTools
    exposes [
        compose,
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

compose = \f, g -> \a -> g a |> f

expect
    add5 = \n -> n + 5
    mul3 = \n -> n * 3
    mul3add5 = compose add5 mul3
    expected = 35
    actual = mul3add5 10
    actual == expected

compose2With2 = \f, g ->
    \a, b -> g a b |> f

expect
    sum = \a, b -> a + b
    mul3 = \n -> n * 3
    sumMul3 = compose2With2 mul3 sum
    expected = 99
    actual = sumMul3 3 30
    actual == expected

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
    \a, b, c, d -> h a b c d |> g |> f

compose3With5 = \f, g, h ->
    \a, b, c, d, e -> h a b c d e |> g |> f

flip2 : (a, b -> c), b, a -> c
flip2 = \f, b, a -> f a b

expect
    expected = 33
    actual = flip2 Num.divTrunc 3 99
    actual == expected

flip3 : (a, b, c -> d), c, b, a -> d
flip3 = \f, c, b, a -> f a b c

flip4 : (a, b, c, d -> e), d, c, b, a -> e
flip4 = \f, d, c, b, a -> f a b c d

flip5 : (a, b, c, d, e -> f), e, d, c, b, a -> f
flip5 = \fn, e, d, c, b, a -> fn a b c d e

identity = \a -> a

expect
    expected = {}
    actual = identity {}
    actual == expected

expect
    expected = 8
    actual = identity 8
    actual == expected

partial2Takes1 : (a, b -> c), a -> (b -> c)
partial2Takes1 = \f, a -> \b -> f a b

expect
    divTrunc100 = partial2Takes1 Num.divTrunc 100
    expected = 5
    actual = divTrunc100 20
    actual == expected

partial2Takes1Backwards : (a, b -> c), b -> (a -> c)
partial2Takes1Backwards = \f, b -> \a -> f a b

expect
    divTruncBy10 = partial2Takes1Backwards Num.divTrunc 10
    expected = 25
    actual = divTruncBy10 250
    actual == expected

partial3Takes1 : (a, b, c -> d), a -> (b, c -> d)
partial3Takes1 = \f, a -> \b, c -> f a b c

expect
    sum3 = \a, b, c -> a + b + c
    add10 = partial3Takes1 sum3 10
    expected = 45
    actual = add10 15 20
    actual == expected

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

expect
    divBy = curry3 flip2 Num.divTrunc
    divBy3 = divBy 3
    expected = 11
    actual = divBy3 33
    actual == expected

curry3Backwards : (a, b, c -> d), c -> (b -> (a -> d))
curry3Backwards = \f, c -> \b -> \a -> f a b c

expect
    addMul = \a, b, c -> (a + b) * c
    addMul10 = curry3Backwards addMul 10
    add5Mul10 = addMul10 5
    expected = 80
    actual = add5Mul10 3
    actual == expected

curry4 : (a, b, c, d -> e), a -> (b -> (c -> (d -> e)))
curry4 = \f, a -> \b -> \c -> \d -> f a b c d

curry4Backwards : (a, b, c, d -> e), d -> (c -> (b -> (a -> e)))
curry4Backwards = \f, d -> \c -> \b -> \a -> f a b c d

curry5 : (a, b, c, d, e -> f), a -> (b -> (c -> (d -> (e -> f))))
curry5 = \f, a -> \b -> \c -> \d -> \e -> f a b c d e

curry5Backwards : (a, b, c, d, e -> f), e -> (d -> (c -> (b -> (a -> f))))
curry5Backwards = \f, e -> \d -> \c -> \b -> \a -> f a b c d e
