interface ListTools
    exposes [
        cartesianProduct,
        cartesianProduct2,
        combinations2,
        count,
        enumerate,
        enumerateStartAt,
        headTail,
        map5,
        max,
        maxIndex,
        maxIndexWithDefault,
        maxWithDefault,
        maxWithKey,
        mode,
        slice,
        splitAt,
        zip,
        zip2,
        zip3,
        zip4,
        zip5,
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
    list = []
    expected = []
    actual = combinations2 list
    actual == expected

expect
    list = [1, 2, 3, 4, 5]
    expected = [[1, 2], [1, 3], [1, 4], [1, 5], [2, 3], [2, 4], [2, 5], [3, 4], [3, 5], [4, 5]]
    actual = combinations2 list
    actual == expected

count : List a -> Dict a U64 where a implements Eq & Hash
count = \xs ->
    updateCount = \c ->
        when c is
            Missing -> Present 1
            Present curr -> Present (curr + 1)

    List.walk xs (Dict.empty {}) \counts, x -> Dict.update counts x updateCount

expect
    expected = Dict.empty {}
    emptyList : List Str
    emptyList = []
    actual = count emptyList
    actual == expected

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

enumerate : List a -> List (U64, a)
enumerate = \list ->
    List.mapWithIndex list (\elem, i -> (i, elem))

expect
    expected = [(0, "ABC"), (1, "DEF"), (2, "GHI")]
    actual = enumerate ["ABC", "DEF", "GHI"]
    actual == expected

enumerateStartAt : List a, I64 -> List (I64, a)
enumerateStartAt = \list, j ->
    List.mapWithIndex list (\elem, i -> ((Num.toI64 i) + j, elem))

expect
    expected = [(6, "ABC"), (7, "DEF"), (8, "GHI")]
    actual = enumerateStartAt ["ABC", "DEF", "GHI"] 6
    actual == expected

headTail : List a -> Result (a, List a) [ListWasEmpty]
headTail = \list ->
    split = List.split list 1
    when split.before |> List.first is
        Ok head -> Ok (head, split.others)
        Err ListWasEmpty -> Err ListWasEmpty

expect
    list = []
    when headTail list is
        Err ListWasEmpty -> Bool.true
        Ok _ -> Bool.false

expect
    list = ["A"]
    expected = ("A", [])
    when headTail list is
        Err ListWasEmpty -> Bool.false
        Ok actual -> actual == expected

expect
    list = ["A", "B", "C", "D"]
    expected = ("A", ["B", "C", "D"])
    when headTail list is
        Err ListWasEmpty -> Bool.false
        Ok actual -> actual == expected

## Run a transformation function on the first element of each list,
## and use that as the first element in the returned list.
## Repeat until a list runs out of elements.
## ```roc
## fn = \a, _, _, _, _ -> a
## expect map5 [1, 2, 3, 4] ["A", "B", "C"] [5, 5, 5] ['A', 'B', 'C', 'D', 'E'] [10.0, 15.0, 20.0, 25.0] == [1, 2, 3]
## ```
map5 : List a, List b, List c, List d, List e, (a, b, c, d, e -> f) -> List f
map5 = \a, b, c, d, e, fn ->
    List.walkWithIndexUntil a [] \result, ai, i ->
        when List.get b i is
            Err OutOfBounds -> Break result
            Ok bi ->
                when List.get c i is
                    Err OutOfBounds -> Break result
                    Ok ci ->
                        when List.get d i is
                            Err OutOfBounds -> Break result
                            Ok di ->
                                when List.get e i is
                                    Err OutOfBounds -> Break result
                                    Ok ei ->
                                        List.append result (fn ai bi ci di ei) |> Continue

expect
    fn = \_, _, _, _, _ -> 0
    expected = []
    actual = map5 [] [] [] [] [] fn
    actual == expected

expect
    fn = \_, _, c, _, _ -> c
    expected = ['A', 'B', 'C']
    actual = map5 [1, 2, 8] ["A", "B", "C", "D"] ['A', 'B', 'C'] [3.141529, 1.618033, 2.71828] [Bool.true, Bool.false, Bool.false, Bool.true] fn
    actual == expected

# TODO: Update to comparable/sortable, once supported in the standard library.
max : List (Num a) -> Result (Num a) [ListWasEmpty]
max = \list ->
    when List.first list is
        Ok first ->
            List.walk list first \currMax, elem ->
                if elem > currMax then elem else currMax
            |> Ok
        Err ListWasEmpty -> Err ListWasEmpty

expect
    list = []
    when max list is
        Err ListWasEmpty -> Bool.true
        Ok _ -> Bool.false

expect
    list = [1, 1, 2, 3, 3, 5, 5, 5]
    expected = Ok 5
    actual = max list
    actual == expected

maxIndex : List (Num a) -> Result (U64, Num a) [ListWasEmpty]
maxIndex = \list ->
    when List.first list is
        Ok first ->
            List.walkWithIndex list (0, first) \(currMaxIdx, currMax), elem, idx ->
                if elem > currMax then (idx, elem) else (currMaxIdx, currMax)
            |> Ok
        Err ListWasEmpty -> Err ListWasEmpty

maxWithDefault : List (Num a), Num a -> Num a
maxWithDefault = \list, default ->
    List.max list |> Result.withDefault default

maxIndexWithDefault : List (Num a), U64, Num a -> (U64, Num a)
maxIndexWithDefault = \list, defaultIdx, default ->
    when maxIndex list is
        Ok (idx, v) -> (idx, v)
        Err ListWasEmpty -> (defaultIdx, default)

maxWithKey : List (Num a), (Num a -> Num *) -> Result (Num a) [ListWasEmpty]
maxWithKey = \list, key ->
    when List.map list key |> maxIndex is
        Ok (idx, _) ->
            when List.get list idx is
                Ok maxElem -> Ok maxElem
                Err OutOfBounds -> crash "Error: The input list length has changed unexpectedly!"
        Err ListWasEmpty -> Err ListWasEmpty

# TODO: maxIndexWithKey
# TODO: maxIndexWithDefaultAndKey

expect
    list = [1, 2, 3, 4, 5]
    expected = 3
    when maxWithKey list \n -> if n < 4 then n * n else n + 2 is
        Err ListWasEmpty -> Bool.false
        Ok actual -> actual == expected

mode : List a -> Result a [ListWasEmpty] where a implements Eq & Hash
mode = \list ->
    when List.get list 0 is
        Err OutOfBounds -> Err ListWasEmpty
        Ok first ->
            Dict.walk (count list) (first, 0) \(kMode, vMode), k, v ->
                if v > vMode then (k, v) else (kMode, vMode)
            |> .0
            |> Ok

expect
    list = []
    when mode list is
        Err ListWasEmpty -> Bool.true
        Ok _ -> Bool.false

expect
    list = [1]
    expected = 1
    when mode list is
        Err ListWasEmpty -> Bool.false
        Ok actual -> actual == expected
expect
    list = [1, 5]
    expected = 1
    when mode list is
        Err ListWasEmpty -> Bool.false
        Ok actual -> actual == expected

expect
    list = [1, 1, 1, 5, 5, 5]
    expected = 1
    when mode list is
        Err ListWasEmpty -> Bool.false
        Ok actual -> actual == expected

expect
    list = [1, 1, 1, 3, 3, 3, 5, 5, 5]
    expected = 1
    when mode list is
        Err ListWasEmpty -> Bool.false
        Ok actual -> actual == expected

expect
    list = [1, 1, 1, 3, 3, 3, 5, 5, 5, 5]
    expected = 5
    when mode list is
        Err ListWasEmpty -> Bool.false
        Ok actual -> actual == expected

slice : List elem, U64, U64 -> List elem
slice = \list, fromInclusive, untilExclusive ->
    List.sublist list { start : fromInclusive, len : untilExclusive - fromInclusive }

expect
    list = []
    expected = []
    actual = slice list 0 0
    actual == expected

expect
    list = []
    expected = []
    actual = slice list 5 10
    actual == expected

expect
    list = List.range { start: At 0, end: At 9 }
    expected = []
    actual = slice list 0 0
    actual == expected

expect
    list = List.range { start: At 0, end: At 9 }
    expected = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    actual = slice list 0 10
    actual == expected

expect
    list = List.range { start: At 0, end: At 9 }
    expected = [5]
    actual = slice list 5 6
    actual == expected

expect
    list = List.range { start: At 0, end: At 9 }
    expected = [5, 6, 7]
    actual = slice list 5 8
    actual == expected

expect
    list = List.range { start: At 0, end: At 9 }
    expected = [5, 6, 7, 8, 9]
    actual = slice list 5 20
    actual == expected

splitAt : List a, U64 -> (List a, List a)
splitAt = \list, idx ->
    split = List.split list idx
    (split.before, split.others)

expect
    expected = ([], [])
    actual = splitAt [] 1
    actual == expected

expect
    expected = ([], [1])
    actual = splitAt [1] 0
    actual == expected

expect
    expected = ([1], [])
    actual = splitAt [1] 1
    actual == expected

expect
    expected = ([1], [2, 3, 4])
    actual = splitAt [1, 2, 3, 4] 1
    actual == expected

zip : List (List a) -> List (List a)
zip = \llist ->
    when llist is
        [[]] -> [[]]
        _ ->
            isListEmpty = \list ->
                when list is
                    Ok _ -> Bool.false
                    Err ListWasEmpty -> Bool.true

            headsTails = List.map llist headTail

            if List.any headsTails isListEmpty then
                []
            else
                hts = List.map headsTails \ht ->
                    when ht is
                        Ok htOk -> htOk
                        _ -> crash "Error: All lists are supposed to be non-empty at this point, but it seems at least one of them isn't"

                heads = [List.map hts .0]
                tails = List.map hts .1
                List.concat heads (zip tails)

expect
    list = [[]]
    expected = [[]]
    actual = zip list
    actual == expected

expect
    list = [[1, 4], [2, 5], [3, 6]]
    expected = [[1, 2, 3], [4, 5, 6]]
    actual = zip list
    actual == expected

expect
    list = [[1, 4], [2, 5, 16, 17], [3, 6, 18, 19, 20]]
    expected = [[1, 2, 3], [4, 5, 6]]
    actual = zip list
    actual == expected

zip2 : List a, List b -> List (a, b)
zip2 = \u, v -> List.map2 u v \a, b -> (a, b)

zip3 : List a, List b, List c -> List (a, b, c)
zip3 = \u, v, w -> List.map3 u v w \a, b, c -> (a, b, c)

zip4 : List a, List b, List c, List d -> List (a, b, c, d)
zip4 = \u, v, w, x -> List.map4 u v w x \a, b, c, d -> (a, b, c, d)

zip5 : List a, List b, List c, List d, List e -> List (a, b, c, d, e)
zip5 = \u, v, w, x, y -> map5 u v w x y \a, b, c, d, e -> (a, b, c, d, e)
