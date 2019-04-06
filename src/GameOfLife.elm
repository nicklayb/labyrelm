module GameOfLife exposing (Coord, Grid, coordToString, evolve, initGrid, negate, randomGrid, toCoord, toggleCell)

import Array exposing (..)
import Random exposing (..)


type alias Grid =
    List (List Bool)


type alias Coord =
    ( Int, Int )


type alias SiblingGrid =
    List (List ( Int, Bool ))


initGrid : Coord -> Grid
initGrid ( width, height ) =
    let
        row =
            List.repeat width False
    in
    List.repeat height row


randomGrid : Int -> Grid -> Grid
randomGrid seed grid =
    let
        inCell y x val =
            randomBool ((length (fromList grid) * y + x) * seed)

        inRow index row =
            List.indexedMap (inCell index) row
    in
    List.indexedMap inRow grid


randomBool : Int -> Bool
randomBool seedValue =
    modBy (randomInt seedValue) 2 == 0


randomInt : Int -> Int
randomInt seedValue =
    Tuple.first (step (int 1 10) (initialSeed seedValue))


toggleCell : Grid -> Coord -> Grid
toggleCell grid ( newX, newY ) =
    let
        inCell y x val =
            if newX == x && newY == y then
                negate val

            else
                val

        inRow index row =
            List.indexedMap (inCell index) row
    in
    List.indexedMap inRow grid


negate : Bool -> Bool
negate val =
    if val == True then
        False

    else
        True


toCoord : Int -> Int -> Coord
toCoord x y =
    ( x, y )


coordToString : Coord -> String
coordToString ( x, y ) =
    "(" ++ String.fromInt x ++ ", " ++ String.fromInt y ++ ")"


sizeOf : Grid -> Coord
sizeOf grid =
    ( List.length (head grid), List.length grid )


head : Grid -> List Bool
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


countSiblingsOf : Coord -> Grid -> Bool -> ( Int, Bool )
countSiblingsOf ( x, y ) grid val =
    let
        qualifiedSiblings =
            siblingCoordinates ( x, y )

        fold =
            List.foldl (siblingsQuantifier grid) 0 qualifiedSiblings
    in
    ( fold, val )


siblingsQuantifier : Grid -> Coord -> Int -> Int
siblingsQuantifier grid sibling acc =
    if getInGrid sibling grid then
        acc + 1

    else
        acc


getInGrid : ( Int, Int ) -> Grid -> Bool
getInGrid ( x, y ) grid =
    case get y (fromList grid) of
        Just row ->
            case get x (fromList row) of
                Just cell ->
                    cell

                Nothing ->
                    False

        Nothing ->
            False


siblingCoordinates : Coord -> List Coord
siblingCoordinates coord =
    let
        sibling ( centerX, centerY ) ( x, y ) =
            ( centerX + x, centerY + y )
    in
    List.map (sibling coord) siblings


evolveCell : ( Int, Bool ) -> Bool
evolveCell ( count, currentState ) =
    case count of
        2 ->
            currentState

        3 ->
            True

        _ ->
            False


evolve : Grid -> Grid
evolve grid =
    let
        inCell y x val =
            evolveCell (countSiblingsOf ( x, y ) grid val)

        inRow index row =
            List.indexedMap (inCell index) row
    in
    List.indexedMap inRow grid
