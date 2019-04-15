module Labyrinth.Path exposing (Cell(..), Path, get, init)

import Array exposing (..)
import Labyrinth.Coord exposing (..)
import Labyrinth.Grid exposing (..)
import Labyrinth.PrimAlgorithm exposing (..)


type Cell
    = Path
    | Wall


type alias Path =
    List (List Cell)


emptyGrid : Coord -> Path
emptyGrid ( width, height ) =
    let
        dimension size =
            (size * 2) - 1

        row =
            List.repeat (dimension width) Wall
    in
    List.repeat (dimension height) row


apply : Grid -> Path -> Path
apply { edgePairs, size } path =
    let
        centerBound { index } =
            setPath (indexToCoord size index)

        southBound { south, index } acc =
            if south.selected then
                setPath (southCoord size index) acc

            else
                acc

        eastBound { east, index } acc =
            if east.selected then
                setPath (eastCoord size index) acc

            else
                acc

        applyAt edge acc =
            acc
                |> centerBound edge
                |> southBound edge
                |> eastBound edge
    in
    List.foldl applyAt path edgePairs


updateAt : (Cell -> Cell) -> Coord -> Path -> Path
updateAt func coord =
    let
        update ( currentCoord, cell ) =
            if sameCoord currentCoord coord then
                func cell

            else
                cell
    in
    map update


map : (( Coord, Cell ) -> Cell) -> Path -> Path
map func =
    let
        inCell y x cell =
            func ( ( x, y ), cell )

        inRow index row =
            List.indexedMap (inCell index) row
    in
    List.indexedMap inRow


set : Cell -> Coord -> Path -> Path
set cell =
    updateAt (\_ -> cell)


get : Coord -> Path -> Cell
get ( x, y ) path =
    case Array.get y (fromList path) of
        Nothing ->
            Wall

        Just row ->
            case Array.get x (fromList row) of
                Nothing ->
                    Wall

                Just cell ->
                    cell


setPath : Coord -> Path -> Path
setPath =
    set Path


init : Grid -> Path
init grid =
    emptyGrid grid.size
        |> apply grid


isWalkable : Cell -> Bool
isWalkable cell =
    cell == Path
