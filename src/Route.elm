module Route exposing (Route(..), fromUrl, href, parser, routeToString)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Url exposing (..)
import Url.Parser as Parser exposing ((</>), Parser, int, oneOf, s, string)


type Route
    = Home
    | Grid Int Int


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Home (s "home")
        , Parser.map Grid (s "grid" </> Parser.int </> Parser.int)
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
                    [ "/home" ]

                Grid width height ->
                    [ "/grid", String.fromInt width, String.fromInt height ]
    in
    String.join "/" pieces


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)
