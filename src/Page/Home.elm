module Page.Home exposing (Model, Msg, init, toSession, update, view)

import Html exposing (..)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)
import Page exposing (PageDefinition)
import Route exposing (href)
import Session exposing (..)
import Utils exposing (..)


type alias Model =
    { session : Session
    , width : Int
    , height : Int
    , seed : Int
    }


type Msg
    = UpdateWidth String
    | UpdateHeight String
    | UpdateSeed String


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , width = 0
      , height = 0
      , seed = 0
      }
    , Cmd.none
    )


view : Model -> PageDefinition Msg
view { width, height, seed } =
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
                , div []
                    [ label [] [ text "Seed" ]
                    , input [ value (String.fromInt seed), onInput UpdateSeed ] []
                    ]
                , a [ Route.href (Route.Game seed width height) ] [ text (buttonText width height) ]
                ]
            ]
    }


buttonText : Int -> Int -> String
buttonText width height =
    "Create a " ++ String.fromInt width ++ " by " ++ String.fromInt height ++ " labyrinth"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateWidth width ->
            ( { model | width = Utils.toInt width }, Cmd.none )

        UpdateHeight height ->
            ( { model | height = Utils.toInt height }, Cmd.none )

        UpdateSeed seed ->
            ( { model | seed = Utils.toInt seed }, Cmd.none )


toSession : Model -> Session
toSession model =
    model.session
