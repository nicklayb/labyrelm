module Page.Grid exposing (Model, Msg(..), init, toSession, update, view)

import GameOfLife exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page exposing (PageDefinition, link)
import Route
import Session exposing (Session(..))
import Time exposing (..)
import Utils exposing (..)


type alias Model =
    { session : Session
    , size : Coord
    , grid : Grid
    , generation : Int
    , autoMode : Bool
    , seed : Int
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
        , button [ onClick Randomize ] [ text "Random" ]
        , input [ value (String.fromInt model.seed), onInput UpdateSeed ] []
        ]


viewGrid : Grid -> Html Msg
viewGrid grid =
    let
        viewRow index row =
            div [ class "row" ] (List.indexedMap (viewCell index) row)
    in
    div [ class "grid" ] (List.indexedMap viewRow grid)


viewCell : Int -> Int -> Cell -> Html Msg
viewCell y x cell =
    div [ class (cellClass cell), onMouseDown (ToggleCell ( x, y )) ] []


cellClass : Cell -> String
cellClass cell =
    case cell of
        Alive ->
            "cell active"

        Dead ->
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
      , seed = 1
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleCell coord ->
            ( { model | grid = toggleCell coord model.grid }, Cmd.none )

        Evolve ->
            ( { model
                | grid = evolve model.grid
                , generation = model.generation + 1
              }
            , Cmd.none
            )

        UpdateSeed str ->
            ( { model | seed = Utils.toInt str }, Cmd.none )

        ToggleAuto ->
            ( { model | autoMode = negate model.autoMode }, Cmd.none )

        Randomize ->
            ( { model | grid = randomGrid model.size model.seed }, Cmd.none )

        Tick ->
            if model.autoMode then
                update Evolve model

            else
                ( model, Cmd.none )


negate : Bool -> Bool
negate val =
    if val == True then
        False

    else
        True


toSession : Model -> Session
toSession model =
    model.session


type Msg
    = ToggleCell Coord
    | ToggleAuto
    | UpdateSeed String
    | Evolve
    | Randomize
    | Tick
