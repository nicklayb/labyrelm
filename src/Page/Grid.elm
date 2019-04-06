module Page.Grid exposing (Model, Msg(..), init, toSession, update, view)

import GameOfLife exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page exposing (PageDefinition, link)
import Route
import Session exposing (Session(..))
import Time exposing (..)


type alias Model =
    { session : Session
    , size : Coord
    , grid : Grid
    , generation : Int
    , autoMode : Bool
    }


view : Model -> PageDefinition Msg
view model =
    { title = "Grid"
    , content =
        div [ class "grid-wrapper" ]
            [ topBar model
            , viewGrid model.grid
            ]
    }


autoModeText : Model -> String
autoModeText { autoMode } =
    if autoMode then
        "Stop"

    else
        "Start"


topBar : Model -> Html Msg
topBar model =
    div [ class "grid-bar" ]
        [ button [ onClick Evolve ] [ text ("Evolve to " ++ String.fromInt (model.generation + 1)) ]
        , button [ onClick ToggleAuto ] [ text (autoModeText model) ]
        ]


viewGrid : Grid -> Html Msg
viewGrid grid =
    let
        viewRow index row =
            div [ class "row" ] (List.indexedMap (viewCell index) row)
    in
    div [ class "grid" ] (List.indexedMap viewRow grid)


viewCell : Int -> Int -> Bool -> Html Msg
viewCell y x cell =
    div [ class (cellClass cell), onMouseDown (ToggleCell ( x, y )) ] []


cellClass : Bool -> String
cellClass cell =
    case cell of
        True ->
            "cell active"

        False ->
            "cell"


cellCoord : Int -> Int -> String
cellCoord x y =
    x |> toCoord y |> coordToString


init : Session -> Coord -> ( Model, Cmd Msg )
init session size =
    ( { session = session
      , size = size
      , grid = initGrid size
      , generation = 0
      , autoMode = False
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleCell coord ->
            ( { model | grid = toggleCell model.grid coord }, Cmd.none )

        Evolve ->
            ( { model
                | grid = evolve model.grid
                , generation = model.generation + 1
              }
            , Cmd.none
            )

        ToggleAuto ->
            ( { model | autoMode = GameOfLife.negate model.autoMode }, Cmd.none )

        Tick ->
            if model.autoMode then
                update Evolve model

            else
                ( model, Cmd.none )


toSession : Model -> Session
toSession model =
    model.session


type Msg
    = ToggleCell Coord
    | ToggleAuto
    | Evolve
    | Tick
