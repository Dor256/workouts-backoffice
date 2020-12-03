module Main exposing (..)

import Api exposing (Workout, getWorkouts)
import Browser exposing (element)
import Html exposing (Html, button, div, h1, input, li, main_, text, ul)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events exposing (onClick, onInput)
import Http exposing (..)


main : Program () Model Action
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { title : String
    , search : String
    , workouts : List Workout
    }


init : () -> ( Model, Cmd Action )
init _ =
    ( { title = "Elm"
      , search = ""
      , workouts = []
      }
    , Cmd.none
    )


type Action
    = Press
    | OnChange String
    | GotWorkouts (Result Http.Error (List Workout))


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        Press ->
            ( { model
                | title =
                    if model.title == "Elm" then
                        "Workouts"

                    else
                        "Elm"
              }
            , if List.length model.workouts == 0 then
                getWorkouts GotWorkouts

              else
                Cmd.none
            )

        OnChange text ->
            ( { model
                | search = text
              }
            , Cmd.none
            )

        GotWorkouts (Ok res) ->
            ( { model
                | workouts = res
              }
            , Cmd.none
            )

        GotWorkouts (Err res) ->
            ( { model
                | workouts = []
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none


view : Model -> Html Action
view model =
    main_
        [ class "container" ]
        [ h1 [] [ text model.title ]
        , div
            []
            [ input
                [ type_ "text"
                , onInput OnChange
                , class "searchbar"
                , placeholder "Enter workout..."
                , value model.search
                ]
                []
            , button
                [ onClick Press, class "button" ]
                [ text "Press me" ]
            , ul [] <|
                List.map (\workout -> li [] [ text workout.name ]) model.workouts
            ]
        ]
