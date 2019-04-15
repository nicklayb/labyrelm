module Labyrinth.PrimAlgorithm exposing (init)

import Labyrinth.Coord as Coord exposing (Coord, length)
import Labyrinth.EdgePair as EdgePair exposing (..)
import Labyrinth.Grid as Grid exposing (Grid, east, init, north, south, west)
import Random exposing (..)


type alias Prim =
    { grid : Grid
    , visitedEdge : List Int
    }


type alias Axis =
    { visiting : Int
    , nodeWithEdge : Int
    , edge : Edge
    , value : Int
    }


length : Grid -> Int
length { size } =
    Coord.length size


initLabyrinth : Int -> Grid -> Grid
initLabyrinth seed ({ size } as grid) =
    grid


axisOf : EdgePair -> Prim -> List (Maybe Axis)
axisOf ({ index } as currentNode) prim =
    let
        grid =
            prim.grid

        getNorth =
            case north index grid of
                Nothing ->
                    Nothing

                Just edge ->
                    if edge.south.selected || isVisited edge.index prim then
                        Nothing

                    else
                        Just
                            { visiting = edge.index
                            , nodeWithEdge = edge.index
                            , edge = South
                            , value = edge.south.value
                            }

        getEast =
            case east index grid of
                Nothing ->
                    Nothing

                Just edge ->
                    if currentNode.east.selected || isVisited edge.index prim then
                        Nothing

                    else
                        Just
                            { visiting = edge.index
                            , nodeWithEdge = index
                            , edge = East
                            , value = currentNode.east.value
                            }

        getSouth =
            case south index grid of
                Nothing ->
                    Nothing

                Just edge ->
                    if currentNode.south.selected || isVisited edge.index prim then
                        Nothing

                    else
                        Just
                            { visiting = edge.index
                            , nodeWithEdge = index
                            , edge = South
                            , value = currentNode.south.value
                            }

        getWest =
            case west index grid of
                Nothing ->
                    Nothing

                Just edge ->
                    if edge.east.selected || isVisited edge.index prim then
                        Nothing

                    else
                        Just
                            { visiting = edge.index
                            , nodeWithEdge = edge.index
                            , edge = East
                            , value = edge.east.value
                            }
    in
    [ getNorth
    , getEast
    , getSouth
    , getWest
    ]


isVisited : Int -> Prim -> Bool
isVisited index prim =
    List.member index prim.visitedEdge


initPrim : Int -> Grid -> Prim
initPrim seed grid =
    let
        newPrim =
            { grid = grid
            , visitedEdge = []
            }

        putEdge prim =
            visit 0 prim
    in
    newPrim |> putEdge


maybeBestOf : Maybe Axis -> Maybe Axis -> Maybe Axis
maybeBestOf first second =
    case first of
        Nothing ->
            second

        Just fAxis ->
            case second of
                Nothing ->
                    Just fAxis

                Just sAxis ->
                    Just (bestOf fAxis sAxis)


bestOf : Axis -> Axis -> Axis
bestOf first second =
    if second.value < first.value then
        second

    else
        first


getNextEdge : Prim -> Maybe Axis
getNextEdge prim =
    List.foldl
        (\visitedIndex currentAxis ->
            let
                node =
                    Grid.get visitedIndex prim.grid.edgePairs

                nodeAxis edgePair =
                    axisOf edgePair prim
            in
            case node of
                Nothing ->
                    currentAxis

                Just n ->
                    List.foldl maybeBestOf currentAxis (nodeAxis n)
        )
        Nothing
        prim.visitedEdge


generate : Prim -> Prim
generate prim =
    if isDone prim then
        prim

    else
        prim
            |> getNextEdge
            |> select prim
            |> generate


select : Prim -> Maybe Axis -> Prim
select prim maybeAxis =
    case maybeAxis of
        Nothing ->
            prim

        Just axis ->
            prim
                |> visit axis.visiting
                |> selectInGrid axis


selectInGrid : Axis -> Prim -> Prim
selectInGrid axis prim =
    let
        putInGrid grid =
            Grid.select axis.nodeWithEdge axis.edge grid
    in
    { prim | grid = putInGrid prim.grid }


visit : Int -> Prim -> Prim
visit index prim =
    { prim | visitedEdge = List.append [ index ] prim.visitedEdge }


isDone : Prim -> Bool
isDone { visitedEdge, grid } =
    List.length visitedEdge == length grid


init : Int -> Coord -> Grid
init seed size =
    let
        generatePrim =
            Grid.init seed size
                |> initPrim seed
                |> generate
    in
    generatePrim.grid
