module Page.Home exposing (Model, Msg, init, toSession, update, view)

import Html exposing (..)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)
import Page exposing (PageDefinition)
import Route exposing (href)
import Session exposing (..)


type alias Model =
    { session : Session
    , width : Int
    , height : Int
    }


type Msg
    = UpdateWidth String
    | UpdateHeight String


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , width = 0
      , height = 0
      }
    , Cmd.none
    )


view : Model -> PageDefinition Msg
view { width, height } =
    { title = "Home"
    , content =
        div []
            [ Html.form []
                [ div []
                    [ label [] [ text "Width" ]
                    , input [ value (String.fromInt width), onInput UpdateWidth ] []
                    ]
                , div []
                    [ label [] [ text "Height" ]
                    , input [ value (String.fromInt height), onInput UpdateHeight ] []
                    ]
                , a [ Route.href (Route.Grid width height) ] [ text (buttonText width height) ]
                ]
            ]
    }


buttonText : Int -> Int -> String
buttonText width height =
    "Create a " ++ String.fromInt width ++ " by " ++ String.fromInt height ++ " game of life grid"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateWidth width ->
            ( { model | width = toInt width }, Cmd.none )

        UpdateHeight height ->
            ( { model | height = toInt height }, Cmd.none )


toInt : String -> Int
toInt str =
    case String.toInt str of
        Just int ->
            int

        Nothing ->
            0


toSession : Model -> Session
toSession model =
    model.session
