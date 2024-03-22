interface NumTools
    exposes [
        sq
    ]
    imports

sq : Num a -> Num a
sq = \n -> n * n
