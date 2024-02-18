module Page.Game exposing (Model, Msg(..), init, toSession, update, view)

import Debug exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Labyrinth.Coord as Coord exposing (Coord, sameCoord)
import Labyrinth.Path as Path exposing (..)
import Labyrinth.PrimAlgorithm as PrimAlgorithm exposing (..)
import Page exposing (PageDefinition, link)
import Random exposing (..)
import Route
import Session exposing (Session(..))
import Time exposing (..)
import Utils exposing (..)


type alias Model =
    { session : Session
    , size : Coord
    , path : Path
    , entry : Coord
    , current : Coord
    , end : Coord
    , moveCount : Int
    }


view : Model -> PageDefinition Msg
view model =
    { title = "Grid"
    , content =
        div [ class "grid-wrapper" ]
            [ topBar model
            , viewport model
            ]
    }


topBar : Model -> Html Msg
topBar model =
    div [ class "grid-bar" ]
        [ text ("Moves: " ++ String.fromInt model.moveCount)
        ]


viewport : Model -> Html Msg
viewport model =
    let
        viewGrid =
            getViewport model

        cellClass =
            pathClass model

        inCell rowIndex colIndex ( coord, cell ) =
            let
                coordToMove =
                    ( colIndex - 1, rowIndex - 1 )

                relativeCoord =
                    ( rowIndex, colIndex )
            in
            case cell of
                Wall ->
                    div [ class "cell wall" ] []

                Path ->
                    if clickable coordToMove then
                        div [ class (cellClass coord relativeCoord), onClick (Move coordToMove) ] []

                    else
                        div [ class (cellClass coord relativeCoord) ] []

        inRow index row =
            div [ class "row" ] (List.indexedMap (inCell index) row)
    in
    div [ class "grid" ] (List.indexedMap inRow viewGrid)


pathClass : Model -> Coord -> Coord -> String
pathClass { current, entry, end } coord relativeCoord =
    let
        currentStr =
            if sameCoord current coord then
                "current"

            else
                ""

        with str =
            String.join " " [ "cell", "path", getArrow relativeCoord, str, currentStr ]
    in
    if sameCoord entry coord then
        with "entry"

    else if sameCoord end coord then
        with "exit"

    else
        with ""


getArrow : Coord -> String
getArrow coord =
    let
        arrow =
            case coord of
                ( 0, 1 ) ->
                    "up"

                ( 1, 0 ) ->
                    "left"

                ( 1, 2 ) ->
                    "right"

                ( 2, 1 ) ->
                    "down"

                _ ->
                    ""
    in
    " arrow " ++ arrow


success : Model -> Bool
success { current, end } =
    sameCoord current end


clickable : Coord -> Bool
clickable ( x, y ) =
    modBy 2 (x + y) /= 0


getViewport : Model -> List (List ( Coord, Cell ))
getViewport model =
    let
        getCell coord =
            ( coord, Path.get coord model.path )

        inRow row =
            List.map getCell row
    in
    List.map inRow (siblingCoordinates model.current)


siblings : List (List Coord)
siblings =
    [ [ ( -1, -1 )
      , ( 0, -1 )
      , ( 1, -1 )
      ]
    , [ ( -1, 0 )
      , ( 0, 0 )
      , ( 1, 0 )
      ]
    , [ ( -1, 1 )
      , ( 0, 1 )
      , ( 1, 1 )
      ]
    ]


siblingCoordinates : Coord -> List (List Coord)
siblingCoordinates coord =
    let
        inRow row =
            List.map (addCoord coord) row
    in
    List.map inRow siblings


addCoord : Coord -> Coord -> Coord
addCoord ( centerX, centerY ) ( x, y ) =
    ( centerX + x, centerY + y )


init : Session -> Coord -> Int -> ( Model, Cmd Msg )
init session size seed =
    ( { session = session
      , size = size
      , path = Path.init (PrimAlgorithm.init seed size)
      , entry = entryFrom seed size
      , current = entryFrom seed size
      , end = exitFrom seed size
      , moveCount = 0
      }
    , Cmd.none
    )


randomHorizon : Int -> Coord -> Int
randomHorizon seed ( width, height ) =
    Random.initialSeed seed
        |> Random.step (Random.int 0 (width - 1))
        |> Tuple.first
        |> (*) 2


entryFrom : Int -> Coord -> Coord
entryFrom seed coord =
    ( randomHorizon seed coord, 0 )


exitFrom : Int -> Coord -> Coord
exitFrom seed coord =
    ( randomHorizon seed coord, (Tuple.second coord - 1) * 2 )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Move state ->
            ( { model
                | current = addCoord model.current state
                , moveCount = model.moveCount + 1
              }
            , Cmd.none
            )


toSession : Model -> Session
toSession model =
    model.session


type Msg
    = Move Coord
