module Kub.Merge exposing (fallDown, remove, siblingsOf)

import Array exposing (..)
import Debug exposing (..)
import Kub.Direction exposing (..)
import Kub.Grid exposing (..)
import Utils


siblingsOf : Coord -> Grid -> List Coord
siblingsOf coord grid =
    Tuple.first (walkDown [] coord grid)


padRow : Int -> List (Maybe Cell) -> List (Maybe Cell)
padRow length cells =
    let
        pad =
            List.repeat (length - List.length cells) Nothing
    in
    List.append pad cells


fallColumn : List (Maybe Cell) -> List (Maybe Cell)
fallColumn row =
    row
        |> List.filter Utils.boolMaybe
        |> padRow (List.length row)


fallDown : Grid -> Grid
fallDown grid =
    List.map fallColumn grid
        |> glueColumns


padColumn : Int -> Grid -> Grid
padColumn length grid =
    let
        emptyCols =
            List.repeat (length - List.length grid) (padRow (widthOf grid) [])
    in
    emptyCols ++ grid


glueColumns : Grid -> Grid
glueColumns grid =
    let
        glueColumn column acc =
            if List.any Utils.boolMaybe column then
                acc ++ [ column ]

            else
                acc
    in
    List.foldl glueColumn [] grid
        |> padColumn (List.length grid)


walkDown : List Coord -> Coord -> Grid -> ( List Coord, List Coord )
walkDown visited coord grid =
    case getAt coord grid of
        Nothing ->
            ( [], coord :: visited )

        Just cell ->
            let
                all direction ( acc, visited_ ) =
                    let
                        directionCoord =
                            coordFrom direction coord
                    in
                    if not (List.member directionCoord visited_) then
                        case getAt directionCoord grid of
                            Nothing ->
                                ( acc, directionCoord :: visited_ )

                            Just checkCell ->
                                if isSame cell checkCell then
                                    let
                                        return ( a, visited__ ) =
                                            ( List.append acc a, List.append visited__ visited_ )
                                    in
                                    return (walkDown visited_ directionCoord grid)

                                else
                                    ( acc, directionCoord :: visited_ )

                    else
                        ( acc, visited_ )

                fold =
                    List.foldl all ( [ coord ], coord :: visited ) directions
            in
            fold


remove : List Coord -> Grid -> Grid
remove =
    setAllAt Nothing
