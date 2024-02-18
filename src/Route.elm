module Route exposing (Route(..), fromUrl, href, parser, routeToString)

import Html exposing (Attribute)
import Html.Attributes as Attr exposing (..)
import Url exposing (..)
import Url.Parser as Parser exposing ((</>), Parser, int, oneOf, s, string)


type Route
    = Home
    | Game Int Int Int


parser : Parser (Route -> a) a
parser =
    s "labyrelm"
        </> oneOf
                [ Parser.map Home Parser.top
                , Parser.map Home (s "home")
                , Parser.map Game (s "game" </> Parser.int </> Parser.int </> Parser.int)
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

                Game seed width height ->
                    [ "game", String.fromInt seed, String.fromInt width, String.fromInt height ]
    in
    String.join "/" ("/labyrelm" :: pieces)


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)
