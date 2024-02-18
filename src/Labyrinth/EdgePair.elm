module Labyrinth.EdgePair exposing (Edge(..), EdgePair, gridGenerator, init, select)

import Labyrinth.Coord as Coord exposing (Coord)
import Labyrinth.Selectable as Selectable exposing (..)
import Random exposing (..)


type alias EdgePair =
    { south : Selectable Int
    , east : Selectable Int
    , index : Int
    }


type Edge
    = East
    | South


getEdge : Edge -> EdgePair -> Selectable Int
getEdge edge pair =
    case edge of
        East ->
            pair.east

        South ->
            pair.south


setEdge : (Selectable Int -> Selectable Int) -> Edge -> EdgePair -> EdgePair
setEdge func edge pair =
    case edge of
        East ->
            { pair | east = func pair.east }

        South ->
            { pair | south = func pair.south }


deselect : Edge -> EdgePair -> EdgePair
deselect =
    setEdge Selectable.deselect


select : Edge -> EdgePair -> EdgePair
select =
    setEdge Selectable.select


gridGenerator : Coord -> Generator (List EdgePair)
gridGenerator ( width, height ) =
    Random.list (width * height) (Random.map init pairGenerator)


pairGenerator : Generator ( Int, Int )
pairGenerator =
    Random.pair (Random.int 1 10) (Random.int 1 10)


init : ( Int, Int ) -> EdgePair
init ( east, south ) =
    { south = Selectable.init south
    , east = Selectable.init east
    , index = 0
    }
