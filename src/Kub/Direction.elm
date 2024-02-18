module Kub.Direction exposing (Direction(..), coordFrom, directions, getAtFrom)

import Array exposing (..)
import Kub.Grid as Grid exposing (..)


type Direction
    = Left
    | Up
    | Right
    | Down


directions : List Direction
directions =
    [ Left
    , Up
    , Right
    , Down
    ]


getAtFrom : Direction -> Coord -> Grid -> Maybe Cell
getAtFrom direction coord =
    Grid.getAt (coordFrom direction coord)


coordFrom : Direction -> Coord -> Coord
coordFrom direction ( rowIndex, columnIndex ) =
    case direction of
        Left ->
            ( rowIndex, columnIndex + 1 )

        Up ->
            ( rowIndex + 1, columnIndex )

        Right ->
            ( rowIndex, columnIndex - 1 )

        Down ->
            ( rowIndex - 1, columnIndex )

