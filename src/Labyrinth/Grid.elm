module Labyrinth.Grid exposing (Grid, east, generateGrid, get, init, north, select, south, west)

import Array exposing (..)
import Labyrinth.Coord exposing (..)
import Labyrinth.EdgePair as EdgePair exposing (..)
import Random exposing (..)


type alias Grid =
    { size : Coord
    , edgePairs : List EdgePair
    }


generateGrid : Int -> Coord -> Grid
generateGrid seed size =
    let
        generate =
            Random.initialSeed seed
                |> Random.step (gridGenerator size)
                |> Tuple.first

        setIndex index edge =
            { edge | index = index }

        withIndex grid =
            grid
                |> List.indexedMap setIndex
    in
    { edgePairs = withIndex generate
    , size = size
    }


updateAt : (EdgePair -> EdgePair) -> Int -> Grid -> Grid
updateAt func index grid =
    let
        scope id val =
            if id == index then
                func val

            else
                val
    in
    { grid | edgePairs = List.indexedMap scope grid.edgePairs }


select : Int -> Edge -> Grid -> Grid
select index edge grid =
    updateAt (EdgePair.select edge) index grid


get : Int -> List EdgePair -> Maybe EdgePair
get index edgePairs =
    Array.get index (fromList edgePairs)


south : Int -> Grid -> Maybe EdgePair
south index { size, edgePairs } =
    get (index + width size) edgePairs


north : Int -> Grid -> Maybe EdgePair
north index { size, edgePairs } =
    get (index - width size) edgePairs


east : Int -> Grid -> Maybe EdgePair
east index { size, edgePairs } =
    let
        nextIndex =
            index + 1

        outOfBounds =
            modBy (width size) nextIndex == 0
    in
    if outOfBounds then
        Nothing

    else
        get nextIndex edgePairs


west : Int -> Grid -> Maybe EdgePair
west index { size, edgePairs } =
    let
        nextIndex =
            index - 1

        outOfBounds =
            modBy (width size) index == 0
    in
    if outOfBounds then
        Nothing

    else
        get nextIndex edgePairs


init : Int -> Coord -> Grid
init =
    generateGrid
