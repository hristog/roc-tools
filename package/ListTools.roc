interface ListTools
    exposes [
        cartesianProduct,
        cartesianProduct2,
        combinations2,
        count,
        maxWithDefault,
    ]
    imports [
        FuncTools.{ partial2Takes1Backwards },
    ]

# TODO: Fix resulting ordering via List.append and List.concatenate.
cartesianProduct : List (List a) -> List (List a)
cartesianProduct = \list ->
    appendProducts = \state, sublist ->
        when state is
            [] -> List.chunksOf sublist 1
            _ ->
                List.joinMap sublist (\elem -> List.map state (partial2Takes1Backwards List.append elem))

    List.walk list [] appendProducts

expect
    ab = [[]]
    actual = cartesianProduct ab
    expected = []
    actual == expected

expect
    ab = [[], []]
    actual = cartesianProduct ab
    expected = []
    actual == expected

expect
    ab = [[1], []]
    actual = cartesianProduct ab
    expected = []
    actual == expected

expect
    abcde = [[], [], [1], [], []]
    actual = cartesianProduct abcde
    expected = []
    actual == expected

expect
    ab = [[], [], []]
    actual = cartesianProduct ab
    expected = []
    actual == expected

expect
    fruitsVegetables = [["apple", "orange"], ["carrot", "spinach"]]
    actual = cartesianProduct fruitsVegetables
    expected = [["apple", "carrot"], ["orange", "carrot"], ["apple", "spinach"], ["orange", "spinach"]]
    actual == expected

expect
    abc = [[1, 2, 3], [4, 5, 6]]
    actual = cartesianProduct abc
    expected = [[1, 4], [2, 4], [3, 4], [1, 5], [2, 5], [3, 5], [1, 6], [2, 6], [3, 6]]
    actual == expected

expect
    abc = [[1, 2], [3, 4], [5, 6]]
    actual = cartesianProduct abc
    expected = [[1, 3, 5], [2, 3, 5], [1, 4, 5], [2, 4, 5], [1, 3, 6], [2, 3, 6], [1, 4, 6], [2, 4, 6]]
    actual == expected

cartesianProduct2 : List a, List b -> List (a, b)
cartesianProduct2 = \u, v ->
    when u is
        [] -> []
        _ ->
            when v is
                [] -> []
                _ ->
                    uProd : a -> List (a, b)
                    uProd = \elemU ->
                        List.map v (\elemV -> (elemU, elemV))

                    List.map u uProd |> List.join

expect
    a = []
    b = []
    cartesianProduct2 a b == []

expect
    a = []
    b = ['A', 'B', 'C']
    cartesianProduct2 a b == []

expect
    a = [10]
    b = []
    cartesianProduct2 a b == []

expect
    a = [10]
    b = ['A']
    cartesianProduct2 a b == [(10, 'A')]

expect
    a = [10, 20]
    b = ['A', 'B']
    cartesianProduct2 a b == [(10, 'A'), (10, 'B'), (20, 'A'), (20, 'B')]

expect
    a = [10, 20]
    b = ['A', 'B', 'C']
    cartesianProduct2 a b == [(10, 'A'), (10, 'B'), (10, 'C'), (20, 'A'), (20, 'B'), (20, 'C')]

# TODO: Make this generic, in terms of the number of elements in each combination.
combinations2 : List a -> List (List a)
combinations2 = \list ->
    updateCombinations = \state, u, idx ->
        List.concat state (List.map (List.dropFirst list (idx + 1)) (\v -> [u, v]))
    List.walkWithIndex list [] updateCombinations

expect
    list = [1, 2, 3, 4, 5]
    expected = [[1, 2], [1, 3], [1, 4], [1, 5], [2, 3], [2, 4], [2, 5], [3, 4], [3, 5], [4, 5]]
    actual = combinations2 list
    actual == expected

count : List a -> Dict a U64
count = \xs ->
    updateCount = \c ->
        when c is
            Missing -> Present 1
            Present curr -> Present (curr + 1)

    List.walk xs (Dict.empty {}) \counts, x -> Dict.update counts x updateCount

expect
    list = [1, 1, 5, 5, 5, 8, 10, 11, 88, 88, 88, 88, 88]
    expected =
        Dict.empty {}
        |> Dict.insert 1 2
        |> Dict.insert 5 3
        |> Dict.insert 8 1
        |> Dict.insert 10 1
        |> Dict.insert 11 1
        |> Dict.insert 88 5

    actual = count list
    actual == expected

maxWithDefault : List (Num a), Num a -> Num a
maxWithDefault = \list, default ->
    List.max list |> Result.withDefault default

