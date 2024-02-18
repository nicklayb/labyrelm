module Labyrinth.Selectable exposing (Selectable, deselect, init, select)


type alias Selectable a =
    { selected : Bool
    , value : a
    }


select : Selectable a -> Selectable a
select selectable =
    { selectable | selected = True }


deselect : Selectable a -> Selectable a
deselect selectable =
    { selectable | selected = False }


init : a -> Selectable a
init value =
    { selected = False
    , value = value
    }
