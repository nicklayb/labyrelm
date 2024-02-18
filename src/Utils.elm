module Utils exposing (boolMaybe, listIf, listMaybe, stringIf, stringMaybe, toInt, updateIf, updateMaybe)


toInt : String -> Int
toInt str =
    Maybe.withDefault 0 (String.toInt str)


boolMaybe : Maybe a -> Bool
boolMaybe maybe =
    case maybe of
        Just _ ->
            True

        Nothing ->
            False


stringMaybe : (a -> String) -> Maybe a -> String
stringMaybe func string =
    case string of
        Just str ->
            func str

        Nothing ->
            ""


stringIf : String -> Bool -> String
stringIf out condition =
    if condition then
        out

    else
        ""


listIf : List a -> Bool -> List a
listIf out condition =
    if condition then
        out

    else
        []


listMaybe : (a -> List b) -> Maybe a -> List b
listMaybe func list =
    case list of
        Just str ->
            func str

        Nothing ->
            []


updateIf : (a -> a) -> a -> Bool -> a
updateIf func original condition =
    if condition then
        func original

    else
        original


updateMaybe : (a -> a) -> a -> Maybe b -> a
updateMaybe func original maybe =
    case maybe of
        Just _ ->
            func original

        Nothing ->
            original
