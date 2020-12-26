module Card exposing (..)

import Api exposing (Workout)
import Html exposing (Html, div, h3, text)
import Html.Attributes exposing (class)


card : Workout -> Html msg
card workout =
    div [ class "card" ]
        [ h3 [] [ text workout.name ]
        ]
