module Main exposing (Model, Msg(..), init, main, update, view)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode
import Page exposing (..)
import Page.Grid as Grid
import Page.Home as Home exposing (..)
import Route exposing (Route)
import Session exposing (..)
import Time exposing (..)
import Url



-- ---------------------------
-- MODEL
-- ---------------------------


type Model
    = NotFound Session
    | Redirect Session
    | Home Home.Model
    | Grid Grid.Model


init : Int -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    changeRouteTo (Route.fromUrl url) (Redirect (Session.init key))



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = Ignored
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotHomeMsg Home.Msg
    | GotGridMsg Grid.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url)
                    )

                Browser.External url ->
                    ( model, Nav.load url )

        ( UrlChanged url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( GotGridMsg subMsg, Grid grid ) ->
            Grid.update subMsg grid
                |> updateWith Grid GotGridMsg model

        ( GotHomeMsg subMsg, Home home ) ->
            Home.update subMsg home
                |> updateWith Home GotHomeMsg model

        ( _, _ ) ->
            ( model, Cmd.none )


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        session =
            toSession model
    in
    case maybeRoute of
        Nothing ->
            ( NotFound session, Cmd.none )

        Just Route.Home ->
            Home.init session
                |> updateWith Home GotHomeMsg model

        Just (Route.Grid width height) ->
            Grid.init session ( width, height )
                |> updateWith Grid GotGridMsg model


toSession : Model -> Session
toSession page =
    case page of
        NotFound session ->
            session

        Redirect session ->
            session

        Home home ->
            Home.toSession home

        Grid grid ->
            Grid.toSession grid


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Document Msg
view model =
    let
        render page toMsg config =
            let
                { title, body } =
                    Page.view page config
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        Redirect _ ->
            render Page.Other (\_ -> Ignored) viewNotFound

        NotFound _ ->
            render Page.Other (\_ -> Ignored) viewNotFound

        Home home ->
            render Page.Home GotHomeMsg (Home.view home)

        Grid grid ->
            render Page.Grid GotGridMsg (Grid.view grid)


subscriptions : Model -> Sub Msg
subscriptions model =
    every 200 sendTick


sendTick : Time.Posix -> Msg
sendTick _ =
    GotGridMsg Grid.Tick



-- ---------------------------
-- MAIN
-- ---------------------------


main : Program Int Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }
