module Labyrinth.Coord exposing (Coord, eastCoord, height, indexToCoord, length, sameCoord, southCoord, width)


type alias Coord =
    ( Int, Int )


width : Coord -> Int
width coord =
    Tuple.first coord


height : Coord -> Int
height coord =
    Tuple.second coord


length : Coord -> Int
length ( w, h ) =
    w * h


sameCoord : Coord -> Coord -> Bool
sameCoord ( firstX, firstY ) ( secondX, secondY ) =
    firstX == secondX && firstY == secondY


southCoord : Coord -> Int -> Coord
southCoord coord index =
    let
        toCoord ( x, y ) =
            ( x, y + 1 )
    in
    toCoord (indexToCoord coord index)


eastCoord : Coord -> Int -> Coord
eastCoord coord index =
    let
        toCoord ( x, y ) =
            ( x + 1, y )
    in
    toCoord (indexToCoord coord index)


indexToCoord : Coord -> Int -> Coord
indexToCoord ( w, _ ) index =
    let
        y =
            floor (toFloat index / toFloat w)

        x =
            modBy w index
    in
    ( x * 2, y * 2 )
