module Route exposing (Route(..), fromUrl, href, parser, routeToString)

import Html exposing (Attribute)
import Html.Attributes as Attr exposing (..)
import Url exposing (..)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s)


type Route
    = Home
    | Grid Int Int


parser : Parser (Route -> a) a
parser =
    s "gelm-of-life"
        </> oneOf
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
                    [ "home" ]

                Grid width height ->
                    [ "grid", String.fromInt width, String.fromInt height ]
    in
    String.join "/" ("/gelm-of-life" :: pieces)


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)
