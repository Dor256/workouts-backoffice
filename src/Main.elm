module Main exposing (..)

import Api exposing (Workout, addWorkout, getWorkouts)
import Browser exposing (element)
import Card exposing (card)
import Html exposing (Attribute, Html, button, div, h1, input, li, main_, text, ul)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events exposing (keyCode, on, onClick, onInput)
import Http exposing (..)
import Json.Decode as Json
import Loader exposing (loader)


main : Program () Model Action
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { search : String
    , workouts : Maybe (List Workout)
    }


init : () -> ( Model, Cmd Action )
init _ =
    ( { search = ""
      , workouts = Nothing
      }
    , getWorkouts GotWorkouts
    )


type Action
    = OnChange String
    | GotWorkouts (Result Http.Error (List Workout))
    | OnSubmit Int
    | AddWorkout (Result Http.Error ())


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        OnChange text ->
            ( { model
                | search = text
              }
            , Cmd.none
            )

        GotWorkouts (Ok res) ->
            ( { model
                | workouts = Just res
              }
            , Cmd.none
            )

        GotWorkouts (Err res) ->
            ( { model
                | workouts = Nothing
              }
            , Cmd.none
            )

        OnSubmit key ->
            if key == enterKey then
                ( model
                , addWorkout AddWorkout { name = model.search }
                )

            else
                ( model, Cmd.none )

        AddWorkout (Ok res) ->
            case model.workouts of
                Just workouts ->
                    ( { model | workouts = Just (List.append workouts [ { name = model.search } ]), search = "" }
                    , Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )

        AddWorkout (Err res) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none


enterKey : Int
enterKey =
    13


onKeyPress : (Int -> msg) -> Attribute msg
onKeyPress mapper =
    on "keypress" (Json.map mapper keyCode)


view : Model -> Html Action
view model =
    main_
        []
    <|
        case model.workouts of
            Just workouts ->
                [ h1 [] [ text "Workouts" ]
                , div
                    [ class "container" ]
                    [ input
                        [ type_ "text"
                        , onInput OnChange
                        , onKeyPress OnSubmit
                        , class "searchbar"
                        , placeholder "Enter workout..."
                        , value model.search
                        ]
                        []
                    , div [ class "card-container" ] <|
                        List.map (\workout -> card workout) workouts
                    ]
                ]

            Nothing ->
                [ loader ]
