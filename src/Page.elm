module Page exposing (Page(..), PageDefinition, link, view, viewNotFound)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes exposing (..)
import Route exposing (Route(..))


type Page
    = Home
    | Game
    | Other


type alias PageDefinition msg =
    { title : String
    , content : Html msg
    }


view : Page -> PageDefinition msg -> Document msg
view _ { title, content } =
    { title = title
    , body = [ viewBody content ]
    }



viewBody : Html msg -> Html msg
viewBody content =
    Html.main_ [] [ content ]


viewNotFound : PageDefinition msg
viewNotFound =
    { title = "Not found"
    , content = div [] [ text "Not found" ]
    }


link : Route -> String -> Html msg
link route title =
    li [] [ a [ Route.href route ] [ text title ] ]
