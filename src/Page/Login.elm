module Page.Login exposing (..)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Route exposing (Route)


type Msg
    = OnLogin Nav.Key


onLogin : Msg -> Cmd Msg
onLogin msg =
    case msg of
        OnLogin navKey ->
            Route.pushUrl Route.Home navKey


view : Nav.Key -> Html Msg
view navKey =
    main_
        []
        [ h1 [] [ text "Welcome to Workouts" ]
        , div
            [ class "container" ]
            [ button
                [ class "button", onClick (OnLogin navKey) ]
                [ text "Login" ]
            ]
        ]
