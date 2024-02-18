module Page.Home exposing (Model, Msg, init, toSession, update, view)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onInput)
import Page exposing (PageDefinition)
import Route exposing (href)
import Session exposing (..)
import Utils exposing (..)


type alias Model =
    { session : Session
    , seed : Int
    }


type Msg
    = UpdateSeed String


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , seed = 0
      }
    , Cmd.none
    )


view : Model -> PageDefinition Msg
view { seed } =
    { title = "Home"
    , content =
        div [ class "flex jc-center ai-center" ]
            [ div [] [ a [ href (Route.Game seed), class "start" ] [ text "start" ] ]
            , div [] [ input [ placeholder "Seed", onInput UpdateSeed, value (String.fromInt seed) ] [] ]
            ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateSeed seed ->
            ( { model | seed = Utils.toInt seed }, Cmd.none )


toSession : Model -> Session
toSession model =
    model.session
