module Session exposing (Session(..), init, navKey)

import Browser.Navigation as Nav


type Session
    = Guest Nav.Key


navKey : Session -> Nav.Key
navKey session =
    case session of
        Guest key ->
            key


init : Nav.Key -> Session
init key =
    Guest key
