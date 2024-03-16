interface ListTools
    exposes [
        cartesianProduct2
    ]
    imports []


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