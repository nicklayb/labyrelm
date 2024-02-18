module Route exposing (Route(..), fromUrl, href, parser, routeToString)

import Html exposing (Attribute)
import Html.Attributes as Attr exposing (..)
import Url exposing (..)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s)


type Route
    = Home
    | Game Int


parser : Parser (Route -> a) a
parser =
    s "kub"
        </> oneOf
                [ Parser.map Home Parser.top
                , Parser.map Home (s "home")
                , Parser.map Game (s "game" </> Parser.int)
                ]


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    [ "home" ]

                Game seed ->
                    [ "game", String.fromInt seed ]
    in
    String.join "/" ("kub" :: pieces)


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)
