interface StrTools
    exposes [
        cmpU8Based,
        formatFWithTrailingZerosMaybeTrim,
    ]
    imports []

cmpU8Based : Str, Str -> [LT, EQ, GT]
cmpU8Based = \s1, s2 ->
    cmpU8BasedHelp (Str.toUtf8 s1) (Str.toUtf8 s2)

cmpU8BasedHelp : List U8, List U8 -> [LT, EQ, GT]
cmpU8BasedHelp = \s1, s2 ->
    when s1 is
        [] ->
            when s2 is 
                [] -> EQ
                _ -> LT
        [c1, ..] ->
            when s2 is
                [] -> GT
                [c2, ..] ->
                    when Num.compare c1 c2 is
                        EQ ->
                            cmpU8BasedHelp (List.dropFirst s1 1) (List.dropFirst s2 1)
                        cmp -> cmp

expect cmpU8Based "" "" == EQ
expect cmpU8Based "abc" "abc" == EQ
expect cmpU8Based "Qrs" "Qrs" == EQ
expect cmpU8Based "mnO" "mnO" == EQ
expect cmpU8Based "" "q" == LT
expect cmpU8Based "q" "" == GT
expect cmpU8Based "Abcd" "Abcde" == LT
expect cmpU8Based "Abcde" "Abcd" == GT
expect cmpU8Based "q" "Q" == GT
expect cmpU8Based "Q" "q" == LT

formatFWithTrailingZerosMaybeTrim : Num (FloatingPoint *), U64 -> Str
formatFWithTrailingZerosMaybeTrim = \v, numZeros ->
    vStr = Num.toStr v
    vListUtf8 = Str.toUtf8 vStr

    after = List.splitFirst vListUtf8 46
        |> Result.withDefault {before: [], after: []}
        |> .after

    lenAfter = List.len after

    when Num.compare numZeros lenAfter is
        EQ ->
            vStr
        LT ->
            List.dropLast vListUtf8 (lenAfter - numZeros)
                |> Str.fromUtf8
                |> Result.withDefault ""
        GT ->
            maybeDecimalPoint =
                when lenAfter is
                    0 -> "."
                    _ -> ""

            Str.concat (Str.concat vStr maybeDecimalPoint) (Str.repeat "0" (numZeros - lenAfter))

fmtFWithTrailingZerosMaybeTrim : Num (FloatingPoint *), U64 -> Str
fmtFWithTrailingZerosMaybeTrim = \v, numZeros ->
    vStr = Num.toStr v
    vListUtf8 = Str.toUtf8 vStr

    dropOnlyElemIfZero = \list ->
        when list is
            [elem] ->
                when elem is
                    48 -> ([], Bool.true)
                    _ -> (list, Bool.false)
            _ -> (list, Bool.false)

    (afterPoint, shouldDropFromStr) = List.splitFirst vListUtf8 46
        |> Result.withDefault {before: [], after: []}
        |> .after
        |> dropOnlyElemIfZero

    lenAfterPoint = List.len afterPoint

    prefix =
        if shouldDropFromStr then
            List.dropLast vListUtf8 2
                |> Str.fromUtf8
                |> Result.withDefault ""
        else
            vStr

    when Num.compare numZeros lenAfterPoint is
        EQ ->
            prefix
        LT ->
            diff = lenAfterPoint - numZeros
            toDrop =
                if lenAfterPoint > 0 && numZeros == 0 then
                    lenAfterPoint + 1
                else
                    diff

            List.dropLast vListUtf8 toDrop
                |> Str.fromUtf8
                |> Result.withDefault ""
        GT ->
            maybeDecimalPoint =
                when lenAfterPoint is
                    0 -> "."
                    _ -> ""

            Str.concat
                (Str.concat prefix maybeDecimalPoint)
                (Str.repeat "0" (numZeros - lenAfterPoint))

expect
    eightF32 : F32
    eightF32 = 8
    fmtFWithTrailingZerosMaybeTrim eightF32 0 == "8"

expect
    eightF64 : F64
    eightF64 = 8
    fmtFWithTrailingZerosMaybeTrim eightF64 0 == "8"

expect
    fmtFWithTrailingZerosMaybeTrim 8 0 == "8"

expect
    eightF32 : F32
    eightF32 = 8
    fmtFWithTrailingZerosMaybeTrim eightF32 1 == "8.0"

expect
    eightF64 : F64
    eightF64 = 8
    fmtFWithTrailingZerosMaybeTrim eightF64 1 == "8.0"

expect
    fmtFWithTrailingZerosMaybeTrim 8 1 == "8.0"


expect
    eightF32 : F32
    eightF32 = 8
    fmtFWithTrailingZerosMaybeTrim eightF32 10 == "8.0000000000"

expect
    eightF64 : F64
    eightF64 = 8
    fmtFWithTrailingZerosMaybeTrim eightF64 10 == "8.0000000000"

expect
    fmtFWithTrailingZerosMaybeTrim 8 10 == "8.0000000000"

expect
    # Please, note that this is getting trimmed down to 3.1415927 due
    # to its being an F32.
    piF32 : F32
    piF32 = 3.14159265358979
    fmtFWithTrailingZerosMaybeTrim piF32 0 == "3"

expect
    piF64 : F64
    piF64 = 3.14159265358979
    fmtFWithTrailingZerosMaybeTrim piF64 0 == "3"

expect
    fmtFWithTrailingZerosMaybeTrim 3.14159265358979 0 == "3"

expect
    # Please, note that this is getting trimmed down to 3.1415927 due
    # to its being an F32.
    piF32 : F32
    piF32 = 3.14159265358979
    fmtFWithTrailingZerosMaybeTrim piF32 7 == "3.1415927"

expect
    piF64 : F64
    piF64 = 3.14159265358979
    fmtFWithTrailingZerosMaybeTrim piF64 7 == "3.1415926"

expect
    fmtFWithTrailingZerosMaybeTrim 3.14159265358979 7 == "3.1415926"

expect
    piF64 : F64
    piF64 = 3.14159265358979
    fmtFWithTrailingZerosMaybeTrim piF64 10 == "3.1415926535"

expect
    fmtFWithTrailingZerosMaybeTrim 3.14159265358979 10 == "3.1415926535"

expect
    piF64 : F64
    piF64 = 3.14159265358979
    fmtFWithTrailingZerosMaybeTrim piF64 20 == "3.14159265358979000000"

expect
    fmtFWithTrailingZerosMaybeTrim 3.14159265358979 20 == "3.14159265358979000000"
