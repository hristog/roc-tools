interface ListTools
    exposes [
        cartesianProduct2
    ]
    imports []


# TODO: Fix resulting ordering via List.append and List.concatenate.
cartesianProduct : List (List a) -> List (List a)
cartesianProduct = \list ->
    update = \state, sublist ->
        when state is
            [] -> List.chunksOf sublist 1
            _ ->
                List.map sublist (\elem -> List.map state (\head -> List.append head elem))
                    |> List.join

    List.walk list [] update

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