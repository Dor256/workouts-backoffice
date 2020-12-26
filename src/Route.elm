module Route exposing (..)

import Browser.Navigation as Nav
import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = NotFound
    | Login
    | Home


parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Login top
        , map Home (s "home")
        ]


pushUrl : Route -> Nav.Key -> Cmd msg
pushUrl route navKey =
    Nav.pushUrl navKey (routeToString route)


routeToString : Route -> String
routeToString route =
    case route of
        NotFound ->
            "/not-found"

        Login ->
            "/"

        Home ->
            "/home"
