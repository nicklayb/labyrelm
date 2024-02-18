module Utils exposing (toInt)


toInt : String -> Int
toInt str =
    case String.toInt str of
        Just int ->
            int

        Nothing ->
            0
