module GameOfLife exposing (Cell(..), Coord, Grid, coordToString, evolve, initGrid, randomGrid, toCoord, toggleCell)

import Array exposing (..)
import Random exposing (..)


type Cell
    = Alive
    | Dead


type alias Grid =
    List (List Cell)


type alias Coord =
    ( Int, Int )


type alias SiblingGrid =
    List (List ( Int, Cell ))


initGrid : Coord -> Grid
initGrid ( width, height ) =
    let
        row =
            List.repeat width Dead
    in
    List.repeat height row


randomGrid : Coord -> Int -> Grid
randomGrid size seed =
    Tuple.first (Random.step (randomGridGenerator size) (initialSeed seed))


randomGridGenerator : Coord -> Generator Grid
randomGridGenerator ( width, height ) =
    Random.list height (Random.list width (Random.map intAsCell (Random.int 1 10)))


intAsCell : Int -> Cell
intAsCell int =
    if modBy int 2 == 0 then
        Alive

    else
        Dead


toggleCell : Coord -> Grid -> Grid
toggleCell =
    updateAt negateCell


updateAt : (Cell -> Cell) -> Coord -> Grid -> Grid
updateAt func coord =
    let
        update ( currentCoord, cell ) =
            if sameCoord currentCoord coord then
                func cell

            else
                cell
    in
    map update


map : (( Coord, Cell ) -> Cell) -> Grid -> Grid
map func =
    let
        inCell y x cell =
            func ( ( x, y ), cell )

        inRow index row =
            List.indexedMap (inCell index) row
    in
    List.indexedMap inRow


sameCoord : Coord -> Coord -> Bool
sameCoord ( firstX, firstY ) ( secondX, secondY ) =
    firstX == secondX && firstY == secondY


negateCell : Cell -> Cell
negateCell cell =
    if cell == Alive then
        Dead

    else
        Alive


toCoord : Int -> Int -> Coord
toCoord x y =
    ( x, y )


coordToString : Coord -> String
coordToString ( x, y ) =
    "(" ++ String.fromInt x ++ ", " ++ String.fromInt y ++ ")"


sizeOf : Grid -> Coord
sizeOf grid =
    ( List.length (head grid), List.length grid )


head : Grid -> List Cell
head grid =
    case List.head grid of
        Just list ->
            list

        Nothing ->
            []


siblings : List Coord
siblings =
    [ ( -1, -1 )
    , ( -1, 0 )
    , ( -1, 1 )
    , ( 0, -1 )
    , ( 0, 1 )
    , ( 1, 0 )
    , ( 1, -1 )
    , ( 1, 1 )
    ]


countSiblings : Coord -> Grid -> Cell -> Int
countSiblings ( x, y ) grid val =
    let
        qualifiedSiblings =
            siblingCoordinates ( x, y )
    in
    List.foldl (siblingsQuantifier grid) 0 qualifiedSiblings


siblingsQuantifier : Grid -> Coord -> Int -> Int
siblingsQuantifier grid sibling acc =
    if getInGrid sibling grid == Alive then
        acc + 1

    else
        acc


getInGrid : Coord -> Grid -> Cell
getInGrid ( x, y ) grid =
    case get y (fromList grid) of
        Just row ->
            case get x (fromList row) of
                Just cell ->
                    cell

                Nothing ->
                    Dead

        Nothing ->
            Dead


siblingCoordinates : Coord -> List Coord
siblingCoordinates coord =
    List.map (addCoord coord) siblings


addCoord : Coord -> Coord -> Coord
addCoord ( centerX, centerY ) ( x, y ) =
    ( centerX + x, centerY + y )


evolveCell : Grid -> ( Coord, Cell ) -> Cell
evolveCell grid ( coord, cell ) =
    case countSiblings coord grid cell of
        2 ->
            cell

        3 ->
            Alive

        _ ->
            Dead


evolve : Grid -> Grid
evolve grid =
    map (evolveCell grid) grid
